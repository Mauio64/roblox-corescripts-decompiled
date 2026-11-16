local LuauPolyfill = require(script.Parent.Parent.Parent.LuauPolyfill)
local Number = LuauPolyfill.Number
local null = require(script.Parent.null)
local function deepEqual(items, items2)
	if typeof(items) ~= typeof(items2) then
		return false, (("{1}: value of type '%s'\n{2}: value of type '%s'"):format(typeof(items), (typeof(items2))))
	end

	if Number.isNaN(items) and Number.isNaN(items2) or items == items2 then
		return true
	end

	if items == null or items2 == null or typeof(items) ~= "table" then
		return false, string.format("{1} (%s) ~= {2} (%s)", tostring(items), (tostring(items2)))
	end

	local set = {}

	for k, item in pairs(items) do
		set[k] = true

		local v, v2 = deepEqual(item, items2[k])

		if not v then
			return
				false,
				(v2:gsub("{1}", ("{1}[%s]"):format((tostring(k)))):gsub("{2}", ("{2}[%s]"):format((tostring(k)))))
		end
	end

	for k, item in pairs(items2) do
		if set[k] then
			continue
		end

		local v, v2 = deepEqual(items[k], item)

		if not v then
			return
				false,
				(v2:gsub("{1}", ("{1}[%s]"):format((tostring(k)))):gsub("{2}", ("{2}[%s]"):format((tostring(k)))))
		end
	end

	return true
end

return deepEqual
