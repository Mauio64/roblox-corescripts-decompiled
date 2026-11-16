local LuauPolyfill = require(script.Parent.Parent.Parent.LuauPolyfill)
local Number = LuauPolyfill.Number
local null = require(script.Parent.null)
local function deepContains(p, item)
	if typeof(p) ~= typeof(item) then
		return false, (("{1}: value of type '%s'\n{2}: value of type '%s'"):format(typeof(p), (typeof(item))))
	end

	if Number.isNaN(p) and Number.isNaN(item) or p == item then
		return true
	end

	if p == null or item == null or typeof(p) ~= "table" then
		return false, string.format("{1} (%s) ~= {2} (%s)", tostring(p), (tostring(item)))
	end

	for k, item2 in pairs(item) do
		local v, v2 = deepContains(p[k], item2)

		if not v then
			return
				false,
				(v2:gsub("{1}", ("{1}[%s]"):format((tostring(k)))):gsub("{2}", ("{2}[%s]"):format((tostring(k)))))
		end
	end

	return true
end

return deepContains
