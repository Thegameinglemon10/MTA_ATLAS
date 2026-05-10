local repositoryURL = "https://raw.githubusercontent.com/Thegameinglemon10/MTA_ATLAS/refs/heads/main/%s.lua"
local fileNames = {"Bootstrap"}

for _, myFileName in pairs(fileNames) do
    local myFileURL = string.format(repositoryURL, myFileName)
    shell.run("wget "..myFileURL.." "..myFileName)
end

print("-- WELCOME TO ATLAS: Downloading complete. Restarting system... --")
sleep(2)
shell.exit()