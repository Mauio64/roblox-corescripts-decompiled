local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Number = LuauPolyfill.Number
local String = LuauPolyfill.String
local isNaN = Number.isNaN
local fn
local v = nil

local function naturalCompare(list: string, list2: string)
	local v2 = 1
	local v3 = 1

	while v2 <= #list and v3 <= #list2 do
		local v4 = String.charCodeAt(list, v2)
		local v5 = String.charCodeAt(list2, v3)

		if fn(v4) and fn(v5) then
			local v6 = 0

			repeat
				v2 += 1
				v6 = v6 * 10 + v4 - v
				v4 = String.charCodeAt(list, v2)
			until not (fn(v4) and v6 > 0)

			local v7 = 0

			repeat
				v3 += 1
				v7 = v7 * 10 + v5 - v
				v5 = String.charCodeAt(list2, v3)
			until not (fn(v5) and v7 > 0)

			if v6 < v7 then
				return -1
			end

			if v7 < v6 then
				return 1
			end
		else
			if v4 < v5 then
				return -1
			end

			if v5 < v4 then
				return 1
			end

			v2 += 1
			v3 += 1
		end
	end

	return #list - #list2
end

v = 48
local v2 = 57

fn = function(p: number)
	local v3 = not isNaN(p)

	if v3 then
		if v <= p then
			return p <= v2
		end

		return false
	end

	return v3
end

return { naturalCompare = naturalCompare }
