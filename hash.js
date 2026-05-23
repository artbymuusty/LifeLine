// hash.js
import bcrypt from 'bcrypt';

const pw = 'password1';
bcrypt.hash(pw, 10).then(hash => {
  console.log(hash);
  process.exit(0);
});
