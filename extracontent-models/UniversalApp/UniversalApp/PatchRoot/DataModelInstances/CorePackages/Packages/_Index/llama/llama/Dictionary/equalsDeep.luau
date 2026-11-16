local equalObjects = require(script.Parent.Parent.equalObjects)
local function equalsDeepOneWay(items, p): boolean
	if type(items) == "table" and type(p) == "table" then
		for k, item in pairs(items) do
			if not equalsDeepOneWay(item, p[k]) then
				return false
			end
		end
	elseif items ~= p then
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
