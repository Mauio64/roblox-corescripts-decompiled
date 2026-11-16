local parent = script.Parent.Parent.Parent
local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
return {
	ICONS = {
		PREMIUM_ICON_LARGE = Images["icons/graphic/premium_xlarge"],
		A_ICON = Images["icons/controls/keys/xboxA"],
		B_ICON = Images["icons/controls/keys/xboxB"]
	}
}
