local module = require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Rodux/installReducer")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Containers/Chips")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Containers/UserLists")

return {
	RoduxKey = require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Common/Constants").RODUX_KEY,
	installReducer = module,
	Chips = module2,
	UserLists = module3
}
