local set = {}

for k in game:DefineFastString("SduiNonGameTopicIds", "300000000, 600000000, 100000010"):gmatch("(%w+)") do
	set[k] = true
end

local function isSduiGameOmniFeedItem(p, p2): boolean
	return p == "sdui" and p2 ~= nil and not set[tostring(p2)]
end

return isSduiGameOmniFeedItem
