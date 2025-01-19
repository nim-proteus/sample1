if existsEnv("ASSIMP_LIB_PATH"):
  --dynlibOverride:assimp
  --passL:"$ASSIMP_LIB_PATH"