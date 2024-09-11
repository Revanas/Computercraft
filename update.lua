local runURL = ""
local startupURL = "https://raw.githubusercontent.com/Revanas/Computercraft/main/inv.lua"
local lib, startup
local libFile, startupFile

lib = http.get(runURL)
libFile = lib.readAll()

fs.delete("run")
local file1 = fs.open("run", "w")
file1.write(libFile)
file1.close()

startup = http.get(startupURL)
startupFile = startup.readAll()

fs.delete("inv")
local file2 = fs.open("inv", "w")
file2.write(startupFile)
file2.close()
