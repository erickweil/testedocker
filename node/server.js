import "dotenv/config";

import express from "express";

const app = express();

let contagem = 0;
app.use((req, res, next) => {
    res.status(200).send({
        message: "OK - Funcionou!",
        segredo: process.env.SEGREDO,
        contagem: contagem++
    })
});

if(!process.env.PORT) {
    throw new Error("Deve definir a porta no env!");
}

app.listen(process.env.PORT, () => {
    console.log("Servidor iniciado!", process.env.PORT);
});