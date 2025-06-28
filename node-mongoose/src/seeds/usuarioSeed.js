// seed.js
import "dotenv/config";
import { faker } from "@faker-js/faker/locale/pt_BR"; // Usando o locale do Brasil!
import { conectarBanco } from "../config/dbConnect.js"; // Importe sua função de conexão
import User from "../models/usuario.js";

// Quantidade de usuários que você quer criar
const NUMERO_DE_USUARIOS = 10;

await conectarBanco();

await User.deleteMany({});

// 3. Criar uma lista de novos usuários
console.log(`Criando ${NUMERO_DE_USUARIOS} novos usuários...`);
const usuariosParaCriar = [];

for (let i = 0; i < NUMERO_DE_USUARIOS; i++) {
    const username = faker.internet.userName().toLowerCase().replace(/[^a-z0-9_.]/g, '');
    
    const novoUsuario = new User({
    username: username,
    email: faker.internet.email({
        firstName: username,
        provider: 'example.com'
    }),
    password: "password123", 
    });
    usuariosParaCriar.push(novoUsuario);
}

// 4. Inserir todos os novos usuários no banco de uma vez
await User.insertMany(usuariosParaCriar);
console.log("✅ Usuários criados e inseridos com sucesso!");
