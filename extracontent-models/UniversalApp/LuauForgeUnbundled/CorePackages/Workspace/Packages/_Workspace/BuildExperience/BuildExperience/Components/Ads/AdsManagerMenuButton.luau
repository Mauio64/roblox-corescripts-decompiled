local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local AdsManagerMenuButtonView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/AdsManagerMenuButtonView")
local useAdsManagerMenuButtonViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/useAdsManagerMenuButtonViewModel")

local function AdsManagerMenuButton(p2)
	local v5 = useAdsManagerMenuButtonViewModel(p2)
	return React.createElement(AdsManagerMenuButtonView, v5)
end

return AdsManagerMenuButton
