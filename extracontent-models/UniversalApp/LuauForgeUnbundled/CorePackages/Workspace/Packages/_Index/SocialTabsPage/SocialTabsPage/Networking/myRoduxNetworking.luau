local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/RoduxNetworking")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Networking/networkImpl")
local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Common/Constants").RODUX_KEY

return RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = module2
})
