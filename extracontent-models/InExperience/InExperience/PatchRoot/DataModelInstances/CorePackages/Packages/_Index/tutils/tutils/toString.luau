local checkListConsistency = require(script.Parent.checkListConsistency)
local function recursiveToString(item, value)
	local v = value or ""

	if type(item) ~= "table" then
		return (tostring(item))
	end

	local v2 = ""

	if not checkListConsistency(item) then
		v2 ..= "-- WARNING: this table fails the list consistency test\n"
	end

	local v3 = v2 .. "{\n"

	for k, item2 in pairs(item) do
		if type(k) == "string" then
			v3 ..= "  " .. v .. tostring(k) .. " = " .. recursiveToString(item2, "  " .. v) .. ";\n"
		end

		if type(k) == "number" then
			v3 ..= "  " .. v .. recursiveToString(item2, "  " .. v) .. ",\n"
		end
	end

	return v3 .. v .. "}"
end

return recursiveToString
