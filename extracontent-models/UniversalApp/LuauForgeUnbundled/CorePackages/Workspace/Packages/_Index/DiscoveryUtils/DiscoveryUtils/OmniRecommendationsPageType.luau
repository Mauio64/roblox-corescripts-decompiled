local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryUtils/RobloxAppEnums").AppPage

local v5 = { PAGE_TYPE_HOME = "Home" }

return {
	toAppPage = function(p2)
		if p2 == v5.PAGE_TYPE_HOME then
			return appPage.Home
		end

		return nil
	end,
	fromAppPage = function(p2)
		if p2 == appPage.Home then
			return v5.PAGE_TYPE_HOME
		end

		return nil
	end,
	OmniRecommendationsPageType = v5
}
