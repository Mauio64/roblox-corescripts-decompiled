local function isSpaceByte(p: number?): boolean -- 5 equivalent calls inferred from this helper
	if p == 32 then
		return true
	elseif p == nil or not (p >= 9) then
		return false
	else
		return p <= 13
	end
end

local function isBlank(value: string): boolean -- 3 equivalent calls inferred from this helper
	return string.find(value, "%S") == nil
end

local function trim(value: string)
	if not isSpaceByte(string.byte(value, 1)) and not isSpaceByte(string.byte(value, -1)) then -- inferred equivalent call
		return value
	end

	if isBlank(value) then -- inferred equivalent call
		return ""
	end

	return string.match(value, "^%s*(.*%S)") or ""
end

local function joinPhrase(value: string, value2: string)
	if isSpaceByte(string.byte(value2, 1)) then -- inferred equivalent call
		value2 = isBlank(value2) and "" or string.match(value2, "^%s*(.*%S)") or "" -- inferred equivalent call
	elseif isSpaceByte(string.byte(value2, -1)) then -- inferred equivalent call
		value2 = isBlank(value2) and "" or string.match(value2, "^%s*(.*%S)") or "" -- inferred equivalent call
	end

	if value2 == "" then
		return value
	end

	if value ~= "" and not isSpaceByte(string.byte(value, -1)) then -- inferred equivalent call
		return value .. " " .. value2
	end

	return value .. value2
end

return joinPhrase
