Adaptado de https://github.com/erickweil/testes-k8s/tree/main/nginx-dns

# Nginx Dns
A ideia é prover uma forma de que acessos a um subdomínio sejam encaminhados a hosts visíveis localmente pelo nginx.

Considerando um espaço dns onde há hosts *.local e um domínio público com dns wildcard *.exemplo.com
O nome batata.exemplo.com iria encaminhar para o host batata.local

Porém, para resolver esse nome de host é necessário utilizar o servidor dns apropriado, isto é feito acessando o arquivo /etc/resolv.conf que contém o nameserver que deve ser utilizado

Exemplo de arquivo em container docker que não faz parte de uma rede bridge
```conf
nameserver 8.8.8.8
search 1.1.1.1
```

Exemplo de arquivo resolv.conf de container docker dentro de uma rede bridge
```conf
search 1.1.1.1
nameserver 172.25.0.1
options edns0 trust-ad ndots:0
```
(Veja https://www.man7.org/linux/man-pages/man5/resolv.conf.5.html)

> É possível extrair o nameserver dele e gerar a linha que deve ir no nginx com um comando awk
> (https://serverfault.com/questions/638822/nginx-resolver-address-from-etc-resolv-conf)
> ```
> echo resolver $(awk 'BEGIN{ORS=" "} $1=="nameserver" {print $2}' /etc/resolv.conf) ";" > /etc/nginx/resolvers.conf
> ```
> Depois basta incluir com  include resolvers.conf;

'nameserver 172.25.0.1' especifica o ip do servidor dns que será capaz de resolver corretamente os nomes dentro da rede bridge.

## Configuração Nginx
(Veja o arquivo default.conf)

Para a configuração do nginx funcionar é necessário:
1. Especificar um resolver com o ip do servidor dns local (Veja http://nginx.org/en/docs/http/ngx_http_core_module.html#resolver)
```conf
	server {
		resolver 172.25.0.1 valid=10s; # Pode aqui
		...
            location / {
                resolver 172.25.0.1 valid=10s; # E aqui também se quiser
			...
			}
		...
	}
```

1. Realizar o regex com base no nome do domínio (Veja https://stackoverflow.com/questions/9578628/redirecting-a-subdomain-with-a-regular-expression-in-nginx)

Veja abaixo o regex:
`server_name ~^(?<subdomain>.+)\.exemplo\.com\.br$;`

Irá 'dar match' em qualquer domínio '*.exemplo.com.br' e armazenar o que está no '*' na variável $subdomain

1. Concatenar o nome do com a porta e montar o encaminhamento

proxy_pass `http://$subdomain:80$request_uri;`

Desta forma o resolver será capaz de encontrar o IP do hostname corretamente.

(Sobre o $request_uri veja: https://stackoverflow.com/questions/48708361/nginx-request-uri-vs-uri)