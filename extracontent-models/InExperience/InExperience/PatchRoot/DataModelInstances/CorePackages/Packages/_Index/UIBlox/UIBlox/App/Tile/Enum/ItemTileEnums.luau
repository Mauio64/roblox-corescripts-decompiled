local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local enumerate = require(ParentParentParent.enumerate)
local strict = require(ParentParent.Utility.strict)
local v5 = enumerate("ItemIconType", {
	"AnimationBundle",
	"Bundle",
	"DynamicHead"
})
local v6 = enumerate("Restriction", {
	"Limited",
	"LimitedUnique",
	"Collectible"
})
local v7 = enumerate("StatusStyle", {
	"Alert",
	"Info",
	"PendingIcon",
	"AlertIcon"
})

return strict({
	ItemIconType = v5,
	Restriction = v6,
	StatusStyle = v7
}, script.Name)
