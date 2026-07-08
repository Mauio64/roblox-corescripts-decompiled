local checkListConsistency = require(script.Parent.checkListConsistency)

local function recursiveToString(p1, p2) -- line: 6
	-- upvalues: checkListConsistency (copy), recursiveToString (copy)
	local v5 = p2 or ""

	if type(p1) == "table" then
		local s1 = ""

		if not checkListConsistency(p1) then
			s1 ..= "-- WARNING: this table fails the list consistency test\n"
		end

		local v7 = s1 .. "{\n"

		for k, v in pairs(p1) do
			if type(k) == "string" then
				v7 ..= "  " .. v5 .. tostring(k) .. " = " .. recursiveToString(v, "  " .. v5) .. ";\n"
			end

			if type(k) == "number" then
				v7 ..= "  " .. v5 .. recursiveToString(v, "  " .. v5) .. ",\n"
			end
		end

		return v7 .. v5 .. "}"
	end

	return (tostring(p1))
end

return recursiveToString
