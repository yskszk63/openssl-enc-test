const secret = 'Hello, World!'

const password = 'SECRET'
const baseKey = await crypto.subtle.importKey("raw", new TextEncoder().encode(password), 'PBKDF2', false, ['deriveBits']);
const keyIv = await crypto.subtle.deriveBits({
  name: 'PBKDF2',
  hash: 'SHA-256',
  salt: '',
  iterations: 1000,
}, baseKey, 48 * 8);
const key = await crypto.subtle.importKey("raw", keyIv.slice(0, 32), { name: 'AES-CBC' }, false, ['encrypt']);
const iv = keyIv.slice(32);
const result = await crypto.subtle.encrypt({
  name: 'AES-CBC',
  iv,
}, key, new TextEncoder().encode(secret));
console.log(Buffer.from(result).toString('base64'));
