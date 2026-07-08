local Parent = script:FindFirstAncestor("DiscoveryUtils").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local t1 = {
	PAGE_TYPE_HOME = "Home"
}

return {
	toAppPage = function(s1: string) -- line: 9
		-- upvalues: t1 (copy), AppPage (copy)
		if s1 == t1.PAGE_TYPE_HOME then
			return AppPage.Home
		end

		return nil
	end,
	fromAppPage = function(s2: string) -- line: 16
		-- upvalues: AppPage (copy), t1 (copy)
		if s2 == AppPage.Home then
			return t1.PAGE_TYPE_HOME
		end

		return nil
	end,
	OmniRecommendationsPageType = t1
}
