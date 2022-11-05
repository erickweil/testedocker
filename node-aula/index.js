import express from "express";
import * as dotenv from 'dotenv';
dotenv.config();

const app = express();

app.get("/", (req,res) => {
    res.send("<html><body><h1>"+process.env.TITULO+"</h1></body></html>");
});

app.listen(process.env.PORT);

