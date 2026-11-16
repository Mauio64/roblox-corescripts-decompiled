local parent = script.Parent
require(parent.Types)

local function iterable(items)
	local v = 1
	local flag = true
	local v2 = nil

	return function()
		if flag then
			local item = items[v]

			if item == nil then
				flag = false
			else
				local v3 = v
				v += 1
				return v3, item
			end
		end

		repeat
			v2 = next(items, v2)
		until typeof(v2) ~= "number" or not (v2 > 0) or not (v2 < v) or v2 % 1 ~= 0

		if v2 == nil then
			return nil
		end

		return v2, items[v2]
	end
end

return iterable
