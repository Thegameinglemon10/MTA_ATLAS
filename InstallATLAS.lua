local ATLASRepositoryURL = "https://raw.githubusercontent.com/Thegameinglemon10/MTA_ATLAS/main/"
local internalFileNames = {"startup.lua"}

local externalFileURLs = {}
local externalFileInstallers = {"https://raw.githubusercontent.com/Shlomo1412/PixelUI-v2/main/installer.lua"}

function TRY_DOWNLOAD(filePath, fileURL)
    local result, err = http.get(fileURL)
    if not result then error("Failed to download " .. filePath .. ": " .. err) end

    local myFile = fs.open(filePath, "w")
    myFile.write(result.readAll());
    myFile.close(); result.close()
end

local INSERT = table.insert
local downloadTasks = {}

--> Queue Workers
for i, myFilePath in ipairs(internalFileNames) do downloadTasks[i] = function() TRY_DOWNLOAD(myFilePath, ATLASRepositoryURL..myFilePath) end end
for myFilePath, myFileURL in ipairs(externalFileURLs) do INSERT(downloadTasks, function() TRY_DOWNLOAD(myFilePath, myFileURL) end) end
for _, myInstallerURL in ipairs(externalFileInstallers) do INSERT(downloadTasks, function() shell.run("wget run "..myInstallerURL) end) end

--> Run Workers in Parallel
parallel.waitForAll(table.unpack(downloadTasks))

print("-- WELCOME TO ATLAS: Downloading complete. --")
print(".. Running first-time startup. ..")
sleep(2); shell.run("startup.lua");

if fs.exists("InstallATLAS.lua") then
    fs.delete("InstallATLAS.lua")
end