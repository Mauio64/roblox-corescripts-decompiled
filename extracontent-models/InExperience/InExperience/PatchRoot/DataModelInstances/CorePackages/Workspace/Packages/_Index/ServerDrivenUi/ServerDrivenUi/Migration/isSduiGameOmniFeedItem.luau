local t1 = {}

for match in game:DefineFastString("SduiNonGameTopicIds", "300000000, 600000000, 100000010"):gmatch("(%w+)") do
	t1[match] = true
end

local function isSduiGameOmniFeedItem(p1, p2) -- line: 11
	-- upvalues: t1 (copy)
	if p1 ~= "sdui" then
		return false
	end

	if p2 == nil then
		return false
	end

	return not t1[tostring(p2)]
end

return isSduiGameOmniFeedItem
