const express = require('express')
const app = express()

let contador = 0

app.get("/", (req, res) => {
    console.log("Executou");
    contador++;
    res.send("<h1>FUNCIONOU "+contador+" vezes</h1>")
})


// Deixe por último
app.listen(5000)
