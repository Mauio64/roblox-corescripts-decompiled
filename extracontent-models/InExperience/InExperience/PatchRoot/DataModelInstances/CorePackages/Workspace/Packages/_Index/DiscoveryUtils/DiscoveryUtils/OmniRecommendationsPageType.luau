local parent = script:FindFirstAncestor("DiscoveryUtils").Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local omniRecommendationsPageType = { PAGE_TYPE_HOME = "Home" }
local OmniRecommendationsPageType = {}

function OmniRecommendationsPageType.toAppPage(p: string)
	if p == omniRecommendationsPageType.PAGE_TYPE_HOME then
		return AppPage.Home
	end

	return nil
end

function OmniRecommendationsPageType.fromAppPage(p: string)
	if p == AppPage.Home then
		return omniRecommendationsPageType.PAGE_TYPE_HOME
	end

	return nil
end

OmniRecommendationsPageType.OmniRecommendationsPageType = omniRecommendationsPageType
return OmniRecommendationsPageType
