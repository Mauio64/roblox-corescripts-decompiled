local Number = require(script.Parent.Parent.Parent.LuauPolyfill).Number
local null = require(script.Parent.null)

local function deepContains(p1, p2) -- line: 4
	-- upvalues: Number (copy), null (copy), deepContains (copy)
	if typeof(p1) ~= typeof(p2) then
		return false, (("{1}: value of type '%s'\n{2}: value of type '%s'"):format(typeof(p1), (typeof(p2))))
	end

	if Number.isNaN(p1) and Number.isNaN(p2) then
		return true
	end

	if p1 == p2 then
		return true
	end

	if p1 == null or p2 == null or typeof(p1) ~= "table" then
		return false, string.format("{1} (%s) ~= {2} (%s)", tostring(p1), (tostring(p2)))
	end

	for k, v in pairs(p2) do
		local v8, v9 = deepContains(p1[k], v)

		if not v8 then
			return false, (v9:gsub("{1}", ("{1}[%s]"):format((tostring(k)))):gsub("{2}", ("{2}[%s]"):format((tostring(k)))))
		end
	end

	return true
end

return deepContains
