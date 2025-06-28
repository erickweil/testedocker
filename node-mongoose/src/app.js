
import "dotenv/config";
import express, { Router } from "express";
import { conectarBanco } from "./config/dbConnect.js";
import User from "./models/usuario.js";
import compression from "compression";

await conectarBanco();

const app = express();

app.use(compression());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
const router = Router();

/**
 * @route   GET /users
 * @desc    Busca todos os usuários
 * @access  Public
 */
router.get("/", async (req, res) => {
    const users = await User.find();
    res.status(200).json(users);
});

/**
 * @route   POST /users
 * @desc    Cria um novo usuário
 * @access  Public
 */
router.post("/", async (req, res) => {
    const { username, email, password } = req.body;

    // Validação simples
    if (!username || !email || !password) {
        return res.status(400).json({ message: "Por favor, preencha todos os campos." });
    }

    // ATENÇÃO: Em um projeto real, você deve criptografar a senha aqui antes de salvar!
    // ex: const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = await User.create({
        username,
        email,
        password, // Em produção, use a senha criptografada: hashedPassword
    });

    // Retorna o usuário criado sem a senha
    newUser.password = undefined;

    res.status(201).json(newUser);
});

app.use("/users", router);

export default app;
