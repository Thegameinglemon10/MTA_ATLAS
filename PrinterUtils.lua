local printerUtils = {
    PageSize = {Width = 25; Height = 15;}
}


---Checks if there's an attatched printer and it has enough materials to print.
---@param pagesNeeded number How many pages need to be printed.
---@return boolean canPrint True if all checks passed
---@return string? err Provides an error message if canPrint is false.
function printerUtils.canPrint(pagesNeeded)
    local printer = peripheral.find("printer")
    if not printer then return false, "No printer found." end
    
    local paperLevel = printer.getPaperLevel()
    if (paperLevel < pagesNeeded) then return false, ("Low on paper. "..tostring(paperLevel).."/"..tostring(pagesNeeded)) end

    local inkLevel = printer.getInkLevel()
    if (inkLevel < pagesNeeded) then return false, ("Low on ink. "..tostring(inkLevel).."/"..tostring(pagesNeeded)) end

    return true
end

return printerUtils