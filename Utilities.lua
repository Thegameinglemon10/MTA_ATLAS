local utils = {}

---Writes a message in the terminal and expects that the user provide a number.
---@param text string What you're looking for. Ex: "What's 2+2"
---@param min number? The minimum (inclusive) value. Throws an error message if the number provided is less than this value. Leave blank/nil for uncapped numbers.
---@param max number? The maximum (inclusive) value. Throws an error message if the number provided is greator than this value. Leave blank/nil for uncapped numbers.
---@return number value The number provided by the user.
---@return boolean isValid If the response is <= max and >= min.
function utils.requestNumFromUser(text, min, max)
    write(text); local response = read(); local num = tonumber(response)
    if (not num) then print("\nInvalid response! Expected a number.") return response, false end
    if (min and (response < min)) then print("\nInvalid response! Expected a number greator than or equal to "..tostring(min)); return response, false end
    if (max and (response > max)) then print("\nInvalid response! Expected a number less than than or equal to "..tostring(max)); return response, false end

    return num, true
end;

---Writes a message in the terminal and expects that the user provide a boolean.
---@param text string What you're looking for. Ex: "Is blue your favorite color?"
---@param denyYN boolean If yes/no or y/n are allowed.
---@param denyShort boolean If y/n or t/f are allowed in place of the full word.
---@return boolean bool The boolean provided by the user. This is the converted value (ex: "y" = true). Is false if the response is not true/t, false/f, yes/y, or no/n.
---@return string response The boolean string provided by the user.
---@return boolean isValid If the response is a bool and meets the requirements.
function utils.requestBoolFromUser(text, denyYN, denyShort)
    write(text); local response = read()
    local rLower = string.lower(response)

    --> Check True
    local isLongYes, isShortYes  = (rLower == "yes"), (rLower == "y")
    local isLongTrue, isShortTrue = (rLower == "true"), (rLower == "t")
    local isYes, isTrue = (isShortYes or isLongYes), (isShortTrue or isLongTrue)
    
    --> Check False
    local isLongNo, isShortNo = (rLower == "no"), (rLower == "n")
    local isLongFalse, isShortFalse = (rLower == "false"), (rLower == "f")
    local isNo, isFalse = (isShortNo or isLongNo), (isShortFalse or isLongFalse)
    
    --> Check Type
    local isShortYesNo = (isShortYes or isShortTrue or isShortNo or isShortFalse)
    local isYesNo = (isYes or isNo)
    local bool = (isShortTrue or isLongTrue or isYes)
   
    --> Prevent t/f and y/n from being used.
    if (denyShort and isShortYesNo) then
       print("\nInvalid response! Try typing the full word.")
       return bool, response, false
    end

    --> Prevent yes/no and y/n from being used.
    if (denyYN and isYesNo) then
        print("\nInvalid response! Please provide a true or false response.")
        return bool, response, false
    end

    --> Check for invalid responses.
    if not (isYesNo or isFalse or isTrue) then
       print("\nUnrecognized response! Please provide a true or false response.")
       return bool, response, false
    end

    return bool, response, true
end

return utils