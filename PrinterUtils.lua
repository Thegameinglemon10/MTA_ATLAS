local printerUtils = {
    PageSize = {Width = 25; Height = 15;}
}


---Checks if there's an attatched printer and it has enough materials to print.
---@param pagesNeeded number How many pages need to be printed.
---@return boolean canPrint True if all checks passed
---@return string? err Provides an error message if canPrint is false.
function printerUtils.canPrint(pagesNeeded)
    local myPrinter = peripheral.find("printer")
    if not myPrinter then return false, "No printer found." end
    
    local paperLevel = myPrinter.getPaperLevel()
    if (paperLevel < pagesNeeded) then return false, ("Low on paper. "..tostring(paperLevel).."/"..tostring(pagesNeeded)) end

    local inkLevel = myPrinter.getInkLevel()
    if (inkLevel < pagesNeeded) then return false, ("Low on ink. "..tostring(inkLevel).."/"..tostring(pagesNeeded)) end

    return true
end

---Prints a page from the provided array. Each value is a seperate line.
---@param lines {number: string}
---@param pageTitle string?
function printerUtils.printFromLineArray(lines, pageTitle)
    local myPrinter = peripheral.find("printer")
    if not myPrinter then error("No printer found.", 2) end

    myPrinter.newPage()

    if pageTitle then myPrinter.setPageTitle(pageTitle) end
    for myLineIndex, myLineText in ipairs(lines) do myPrinter.write(myLineText); myPrinter.setCursorPos(1, (myLineIndex + 1)) end

    myPrinter.endPage()
end

return printerUtils