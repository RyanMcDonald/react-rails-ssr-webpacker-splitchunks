const { environment } = require("@rails/webpacker");

environment.config.set(
  "output.globalObject",
  "(typeof self !== 'undefined' ? self : this)"
);

environment.splitChunks();

module.exports = environment;
