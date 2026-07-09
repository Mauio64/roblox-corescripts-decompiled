local ParentParent = script.Parent.Parent.Parent
local Images = require(ParentParent.UIBlox).App.ImageSet.Images
local v3 = Images["icons/graphic/premium_xlarge"]
local v4 = Images["icons/controls/keys/xboxA"]
local v5 = Images["icons/controls/keys/xboxB"]

return {
	ICONS = {
		PREMIUM_ICON_LARGE = v3,
		A_ICON = v4,
		B_ICON = v5
	}
}
