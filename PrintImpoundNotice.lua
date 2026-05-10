--[[
__/\\\\\\\\\\\\\________/\\\\\________/\\\______________/\\\\\\\\\________/\\\\\\\\\______/\\\\\\\\\\\__/\\\\\\\\\\\\\\\__/\\\________/\\\___
__\/\\\/////////\\\____/\\\///\\\_____\/\\\____________/\\\\\\\\\\\\\____/\\\///////\\\___\/////\\\///__\///////\\\/////__\///\\\____/\\\/___
___\/\\\_______\/\\\__/\\\/__\///\\\___\/\\\___________/\\\/////////\\\__\/\\\_____\/\\\_______\/\\\___________\/\\\_________\///\\\/\\\/____
____\/\\\\\\\\\\\\\/__/\\\______\//\\\__\/\\\__________\/\\\_______\/\\\__\/\\\\\\\\\\\/________\/\\\___________\/\\\___________\///\\\/_____
_____\/\\\/////////___\/\\\_______\/\\\__\/\\\__________\/\\\\\\\\\\\\\\\__\/\\\//////\\\________\/\\\___________\/\\\_____________\/\\\_____
______\/\\\____________\//\\\______/\\\___\/\\\__________\/\\\/////////\\\__\/\\\____\//\\\_______\/\\\___________\/\\\_____________\/\\\____
_______\/\\\_____________\///\\\__/\\\_____\/\\\__________\/\\\_______\/\\\__\/\\\_____\//\\\______\/\\\___________\/\\\_____________\/\\\___
________\/\\\_______________\///\\\\\/______\/\\\\\\\\\\\__\/\\\_______\/\\\__\/\\\______\//\\\__/\\\\\\\\\\\_______\/\\\_____________\/\\\__
_________\///__________________\/////________\///////////___\///________\///___\///________\///__\///////////________\///______________\///__
Copyright, Polarity 2026

-- Development Team --
| Founder < Thegameinglemon10 [Thegaminglemon10#0076]

-- FILE INFORMATION --

File Name: 
Written By: Thegameinglemon10
Creation Date: 
Version: 1.0.0

-- Last Edit --
Editor: Thegameinglemon10
Date: 

-- Description --
-- Changelog --

-- END HEADER --
]]--!strict

--@ // TYPE DECLARATIONS \\ @--

--@ // DEPENDENCIES \\ @--
local printerUtils = require("PrinterUtils")
local cc_string = require("cc.strings")

local utilities = require("Utilities")
local getNumberOrdinal = utilities.getNumberOrdinal

--@ // GLOBALS \\ @--

--@ // CONSTANTS \\ @--
local myPrinter = peripheral.find("printer")
local maxCharsPerLine = printerUtils.PageSize.Width;

--@ // VARIABLES \\ @--
local CURRENT_LINE = 1;

--@ // FUNCTIONS \\ @--

---Writes a single line and increments the line pointer.
---@param text string
function WRITE_LINE(text)
    myPrinter.write(text);
    CURRENT_LINE = (CURRENT_LINE + 1);
    myPrinter.setCursorPos(1, CURRENT_LINE)
end

---Splits the provided text across multiple lines.
---@param text string
---@param maxLines number How many lines the text can split across before it's truncated.
---@param writeAllLines boolean If true, it will write "maxLines" number of lines. If the text doesn't require that many lines, it will still write it as blank.
function SPLIT_AND_WRITE(text, maxLines, writeAllLines)
    local myLines = cc_string.wrap(text, maxCharsPerLine)
    local numLinesRequired = #myLines
    local numLinesToBeWritten = (writeAllLines and maxLines or math.min(maxLines, numLinesRequired))
    
    local mustTruncate = (numLinesToBeWritten < numLinesRequired)
    for myLineIndex = 1, numLinesToBeWritten do
        local myLineText = (myLines[myLineIndex] or "")

        if ((myLineIndex == numLinesRequired) and mustTruncate) then
            myLineText = (string.sub(myLineText, 1, -2) .. "..")
        end

        WRITE_LINE(myLineText)
    end
end

function WRITE_USER_RESPONSE(title, question)
    WRITE_LINE(title) --> Write title

    write("\n[MTA] "..question.."\n> "); --> Ask Question

    SPLIT_AND_WRITE(read()); --> Write response

    WRITE_LINE("") --> Leave room for next line
end

function FORMAT_DATE(unixSeconds) -- Ex: "Aug. 20th"
    local monthAbbreviated = os.date("%b. ", unixSeconds) -- "Aug. "
    local dayOfTheMonth = tostring(tonumber(os.date("%d", unixSeconds))) -- "20", The tostring removes the zero padding ("01" -> "1")
    local daySuffix = getNumberOrdinal(tonumber(dayOfTheMonth) or 0) -- "th"

    return (monthAbbreviated .. dayOfTheMonth .. daySuffix)
end

function GET_DAYS_UNTIL_FORFEITURE()
    local response, isValid = utilities.requestNumFromUser("\n[MTA] How many days does the owner have until forfeiture?\n> ", 7)
    if not isValid then return GET_DAYS_UNTIL_FORFEITURE() else return response end
end

--@ // CHECK PRINT CAPABILITY \\ @--
local canPrint, err = printerUtils.canPrint(2)
if not canPrint then print("Unable to print notice: "..err) return end

--@ // PRINT NOTICE PAGE \\ @--
--> Start Page Write Header
myPrinter.newPage()
myPrinter.setPageTitle("M.T.A IMPOUND NOTICE")
WRITE_LINE("- M.T.A. IMPOUND NOTICE -")

--> Write owner, vehicle, and registrar's name
WRITE_USER_RESPONSE("Owner's Name", "What's the owner's name?")
WRITE_USER_RESPONSE("Vehicle's Name", "What's the vehicle's name?")
WRITE_USER_RESPONSE("Registrar's Name", "What's your name?")

--> Write Current Date
WRITE_LINE("Date: " .. FORMAT_DATE())

--> Write Forfeiture Date
local currentUnixSeconds = (os.epoch("utc") / 1000)
local daysUntilForfeiture = GET_DAYS_UNTIL_FORFEITURE()
local forfeitureDateUnixSeconds = (currentUnixSeconds + (daysUntilForfeiture * 86400))
WRITE_LINE("Forfeit Date: " .. FORMAT_DATE(forfeitureDateUnixSeconds))

--> Write Footer & Print
WRITE_LINE("")
WRITE_LINE("")
WRITE_LINE("ENFORCED BY THE MERYDIAN")
WRITE_LINE("TRANSIT AUTHORITY UNDER")
WRITE_LINE("THE GRAND ARBITER")
myPrinter.write("-------------------------")
myPrinter.endPage()

--[[ PRINT DECREE PAGE ]]--
printerUtils.printFromLineArray({
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
}, "M.T.A IMPOUND DECREE")

print("\n[MTA] Finished printing. Thank you for your service!")