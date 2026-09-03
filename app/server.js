const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send(`
    <h1>🚀 Aplicação rodando na VM Produção!</h1>
    <p>Servidor: ${require('os').hostname()}</p>
    <p>IP: 192.168.56.20</p>
    <p>Porta: ${PORT}</p>
  `);
});

app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`✅ Servidor rodando na porta ${PORT}`);
  console.log(`🌐 Acesse: http://192.168.56.20:${PORT}`);
});
