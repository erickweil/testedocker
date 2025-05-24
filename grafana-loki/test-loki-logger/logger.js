// https://github.com/JaniAnttonen/winston-loki/blob/development/examples/basicAuth.js
import winston from 'winston';
import LokiTransport from 'winston-loki';

const logger = winston.createLogger({
    exitOnError: false
});

// https://github.com/winstonjs/logform?tab=readme-ov-file#understanding-formats
const formatLog = winston.format((info, opts) => {
    const { ip, usuario, method, url, code, ms, message, ...other} = info?.message || {};

    info.message = [
        info.timestamp, ms !== undefined ? ms+"ms" : "", ip || ".", usuario || "?", "\t", method, url, code, message,
        other && Object.keys(other).length > 0 ? JSON.stringify(other, null, 2) : undefined
    ]
    .filter((item) => item ? true : false).join(" ");
    return info;
});

logger.add(new winston.transports.Console({
    level: "debug",
    format: winston.format.combine(
        winston.format.timestamp(),
        formatLog(),
        winston.format.cli({
            colors: {
                info: "blue",
                warn: "yellow",
                error: "red",
                debug: "white"
            }
        })
    )
}));

if(process.env.LOKI_URL) {
    logger.add(new LokiTransport({
        host: process.env.LOKI_URL,
        json: true,
        basicAuth: `${process.env.LOKI_BASICAUTH_USER}:${process.env.LOKI_BASICAUTH_PWD}`,
        labels: { 
            app: process.env.LOKI_LABEL
        },
        level: "debug",
        format: winston.format.combine(
            winston.format.timestamp(),
            winston.format.json()
        )
    }));

    console.log("Logger configurado para enviar mensagens para o Loki");
}

/**
 * Handle errors originating in the logger itself:
 * It is also worth mentioning that the logger also emits an 'error' event if an error occurs within the logger 
 * itself which you should handle or suppress if you don't want unhandled exceptions:
 */
logger.on("error", function (err) { 
    console.error("Erro Wiston Logger: "+err);
});

const wait = (duration) => new Promise(resolve => {
    setTimeout(resolve, duration)
});


const run = async () => {
    let n = 0;
    while (true) {
        logger.debug({
            message: {
                message: `Debug message`,
                n: n,
            },
            labels: {
                origem: "background"
            }
        });
        if (n % 2 === 0) {
            logger.info({
                message: {
                    message: `Info message`,
                    n: n,
                },
                labels: {
                    origem: "background"
                }
            });
        }
        if (n % 10 === 0) {
            logger.error({
                message: {
                    message: `Error message`,
                    n: n,
                },
                labels: {
                    origem: "background"
                }
            });
        }

        await wait(1000)
        n++;
    }
};

run();