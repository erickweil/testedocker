import mongoose, { Document, Types } from "mongoose";

let connectingPromise = null;

export async function conectarBanco() {
    const bancoUrl = process.env.DB_URL;

    // Descomente a linha abaixo para ver as queries do banco no console
    //mongoose.set("debug", true);

    if (mongoose.connection.readyState === 1) return; // já está conectado

    // Já tentou conectar, aproveita a promise
    if (connectingPromise) {
        process.env.DEBUGLOG === "true" && console.log("Aguardando conexão com banco...");
        await connectingPromise;
        return;
    }

    if (!bancoUrl) {
        throw new Error("Impossível se conectar ao banco de dados. \nÉ necessário configurar a variável de ambiente DB_URL com a string de conexão do banco de dados.");
    }

    try {
        mongoose.set("strictQuery", true);


        process.env.DEBUGLOG === "true" && console.log("Tentando conexão com banco...");

        mongoose.connection
            .on("open", () => {
                process.env.DEBUGLOG === "true" && console.log("Conexão com banco estabelecida com sucesso!");
            })
            .on("error", err => {
                console.log("Erro no banco de dados:", err);
            })
            .on("disconnected", () => {
                process.env.DEBUGLOG === "true" && console.log("Desconectou do banco de dados.");
            });

        // Guarda a promise de conexão para reutilizar
        connectingPromise = mongoose.connect(bancoUrl);
        await connectingPromise;
        connectingPromise = null;
    } catch (error) {
        console.error("Erro ao conectar com banco:", error);
        connectingPromise = null; // <== Importante: reseta a promise para permitir novas tentativas
        throw error; // não iniciar o servidor se não conseguir se conectar com o banco
    }
}

export async function desconetarBanco() {
    process.env.DEBUGLOG === "true" && console.log("Solicitando encerramento da conexão com banco");

    await mongoose.disconnect();
}

export default mongoose.connection;