local Number = require(script.Parent.Parent.Parent.LuauPolyfill).Number
local null = require(script.Parent.null)

local function deepEqual(p1, p2) -- line: 13
	-- upvalues: Number (copy), null (copy), deepEqual (copy)
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

	local t1 = {}

	for k, v in pairs(p1) do
		t1[k] = true

		local v9, v10 = deepEqual(v, p2[k])

		if not v9 then
			return false, (v10:gsub("{1}", ("{1}[%s]"):format((tostring(k)))):gsub("{2}", ("{2}[%s]"):format((tostring(k)))))
		end
	end

	for k, v in pairs(p2) do
		if t1[k] then
			continue
		end

		local v13, v14 = deepEqual(p1[k], v)

		if not v13 then
			return false, (v14:gsub("{1}", ("{1}[%s]"):format((tostring(k)))):gsub("{2}", ("{2}[%s]"):format((tostring(k)))))
		end
	end

	return true
end

return deepEqual
