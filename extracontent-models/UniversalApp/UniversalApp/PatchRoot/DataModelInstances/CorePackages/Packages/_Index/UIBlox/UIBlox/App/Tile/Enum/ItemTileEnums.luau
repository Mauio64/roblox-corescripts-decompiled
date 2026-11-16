local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent

local enumerate = require(parent2.enumerate)

local strict = require(parent.Utility.strict)

return strict({
	ItemIconType = enumerate("ItemIconType", { "AnimationBundle", "Bundle", "DynamicHead" }),
	Restriction = enumerate("Restriction", { "Limited", "LimitedUnique", "Collectible" }),
	StatusStyle = enumerate("StatusStyle", { "Alert", "Info", "PendingIcon", "AlertIcon" })
}, script.Name)
