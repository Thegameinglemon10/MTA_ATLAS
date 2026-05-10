--@ // DEPENDENCIES \\ @--
local printer = peripheral.find("printer")
local CCString = require("cc.strings")

--@ // VARIABLES \\ @--
local suffixes = {"st", "nd", "rd"}
local maxCharsPerLine = 25;
local curLine = 1;

--@ // FUNCTION \\ @--
function getNumSuffix(num) return (suffixes[(num % 10)] or "th") end
function writeAndAdvance(text) printer.write(text); curLine = (curLine + 1); printer.setCursorPos(1, curLine) end

function splitAndWriteInput(inp)
    local lines = CCString.wrap(inp, maxCharsPerLine)
    local maxLines = #lines

    for i = 1, 2 do
        local myLine = (lines[i] or "")

        if (#myLine > maxCharsPerLine) then
            myLine = (string.sub(myLine, i, -2) .. "..")
        end

        writeAndAdvance(myLine)
    end

    writeAndAdvance("")
end

function getFormattedDate(unix) -- Ex: "Aug. 20th"
    local monthAbbreviated = os.date("%b. ", unix) -- "Aug. "
    local dayOfTheMonth = tostring(tonumber(os.date("%d", unix))) -- "20", The tostring removes the zero padding ("01" -> "1")
    local daySuffix = getNumSuffix(tonumber(dayOfTheMonth)) -- "th"

    return (monthAbbreviated .. dayOfTheMonth .. daySuffix)
end

--@ // PRINT NOTICE PAGE \\ @--
--> Start Page Write Header
printer.newPage()
printer.setPageTitle("M.T.A IMPOUND NOTICE")
writeAndAdvance("- M.T.A. IMPOUND NOTICE -")

--> Write Owner's Name
writeAndAdvance("Owner's Name:")
write("\n[MTA] What's the owner's name?\n> "); splitAndWriteInput(read())

--> Write Vehicle's Name
writeAndAdvance("Vehicle's Name:")
write("\n[MTA] What's the vehicle's name?\n> "); splitAndWriteInput(read())

--> Write Registrar's Name
writeAndAdvance("Registrar's Name:")
write("\n[MTA] What's your name?\n> "); splitAndWriteInput(read())

--> Write Current Date
writeAndAdvance("Date: " .. getFormattedDate())

--> Write Forfeiture Date
function getDaysUntilForfeiture(failureNotice)
    write("\n" .. "[MTA] " .. (failureNotice or "") .. "How many days does the owner have until forfeiture?\n> ");
    
    local daysUntilForfeiture = tonumber(read())
    if not daysUntilForfeiture then return getDaysUntilForfeiture("Invalid! Must be a number. ") end
    if daysUntilForfeiture < 7 then return getDaysUntilForfeiture("Invalid! Must be at least 7. ") end

    return daysUntilForfeiture
end

local epochSeconds = (os.epoch("utc") / 1000)
local daysUntilForfeiture = getDaysUntilForfeiture()
local forfeitureDateUnix = (epochSeconds + (daysUntilForfeiture * 86400))
writeAndAdvance("Forfeit Date: " .. getFormattedDate(forfeitureDateUnix))

--> Write Footer & Print
writeAndAdvance("")
writeAndAdvance("")
writeAndAdvance("ENFORCED BY THE MERYDIAN")
writeAndAdvance("TRANSIT AUTHORITY UNDER")
writeAndAdvance("THE GRAND ARBITER")
printer.write("-------------------------")
printer.endPage()

--[[ PRINT DECREE PAGE ]]--
printer.newPage()
printer.setPageTitle("M.T.A IMPOUND DECREE")

local decreeLines = {
    "- DECREE OF IMPOUNDMENT -";
    "";
    "I, the Registrar, with";
    "the power invested in";
    "me by the Grand";
    "Arbiter under the";
    "I.K.T.A., hereby impound";
    "this vehicle for";
    "violations of the A.T.C.";
    "";
    "This vehicle is to be";
    "immediately ceded to";
    "the M.T.A. You have the";
    "right to appeal until the";
    "end of the forfeiture";
    "date listed. Contact your";
    "local registry clerk for";
    "appeals, a list of your";
    "violations, or other";
    "inquires.";
    "-------------------------";
}

for lineIndex, myLine in ipairs(decreeLines) do
    printer.write(myLine); printer.setCursorPos(1, lineIndex + 1)
end

printer.endPage()
print("\n[MTA] Impound notice printed. Thank you for your service!")