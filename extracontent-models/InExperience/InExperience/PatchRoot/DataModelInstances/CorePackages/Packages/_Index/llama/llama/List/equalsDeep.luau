local equalObjects = require(script.Parent.Parent.equalObjects)
local function equalsDeepOneWay(list, list2): boolean
	if type(list) == "table" and type(list2) == "table" then
		for i = 1, #list do
			if not equalsDeepOneWay(list[i], list2[i]) then
				return false
			end
		end
	elseif list ~= list2 then
		return false
	end

	return true
end

local function equalsDeep(...): boolean
	if equalObjects(...) then
		return true
	end

	local v = select("#", ...)

	for i = 1, v do
		local v2 = select(i, ...)

		for j = 1, v do
			if j ~= i and not equalsDeepOneWay(v2, (select(j, ...))) then
				return false
			end
		end
	end

	return true
end

return equalsDeep
