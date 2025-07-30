const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Azure devops CI\CD pipeline end-to-end');
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
