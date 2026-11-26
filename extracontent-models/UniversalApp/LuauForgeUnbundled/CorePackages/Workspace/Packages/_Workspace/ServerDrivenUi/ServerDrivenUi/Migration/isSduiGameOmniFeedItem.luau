local set = {}

for k in game:DefineFastString("SduiNonGameTopicIds", "300000000, 600000000, 100000010"):gmatch("(%w+)") do
	set[k] = true
end

local function isSduiGameOmniFeedItem(p2, p3): boolean
	if not (p2 == "sdui" and p3 ~= nil) then
		return false
	end

	return not set[tostring(p3)]
end

return isSduiGameOmniFeedItem
