import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
  username: {
    type: String,
    required: [true, 'O nome de usuário é obrigatório.'],
    unique: true,
    trim: true
  },
  email: {
    type: String,
    required: [true, 'O email é obrigatório.'],
    unique: true,
    trim: true,
    lowercase: true,
    match: [/^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/, 'Por favor, insira um email válido.']
  },
  password: {
    type: String,
    required: [true, 'A senha é obrigatória.'],
    minlength: [6, 'A senha deve ter no mínimo 6 caracteres.'],
    select: false
  }
}, {
  timestamps: true // Adiciona os campos createdAt e updatedAt automaticamente
});

const User = mongoose.model('User', userSchema);

export default User;