;;; modules/local/programming/config.el -*- lexical-binding: t; -*-

(when (modulep! +cmake)
  (load! "languages/cmake"))

(when (modulep! +cuda)
  (load! "languages/cuda"))

(when (modulep! +koka)
  (load! "languages/koka"))

(when (modulep! +markdown)
  (load! "languages/markdown"))

(when (modulep! +protobuf)
  (load! "languages/protobuf"))

(when (modulep! +python)
  (load! "languages/python"))

(when (modulep! +typst)
  (load! "languages/typst"))
