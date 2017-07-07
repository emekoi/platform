G = {
  author = "emekamonkey",
  version = "0.1.0",
  license = "MIT",
  title = "platform",
  width = 128,
  height = 128,
  scale = 4,
  debug = false,
}

return {
  title = G.title,
  width = G.width * G.scale,
  height = G.height * G.scale,
}
