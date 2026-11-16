local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/AdCampaigns")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CampaignStats")
local getAdsManagerUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/getAdsManagerUrl")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/AdsManagerMenuButtonView")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local useOpenWebViewWithResumeRefresh = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useOpenWebViewWithResumeRefresh")
local useRefreshAdsData = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/useRefreshAdsData")

local FFlagBuildAdsManagerUniverseUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdsManagerUniverseUrl")

local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize
local useScaledValue = Foundation.Hooks.useScaledValue

local defineFastInt = game:DefineFastInt("BuildAdsManagerMenuWidth", 162)

local function useAdsManagerMenuButtonViewModel(data)
	local state, setState = React.useState(false)
	local v5 = useScaledValue(defineFastInt)
	local adsManager = useLocalization({ adsManager = LocalizationStrings.ADS_STATS_ADS_MANAGER }).adsManager
	local universeId = data.universeId
	local v6 = useRefreshAdsData(universeId, {
		adCampaignsStore = data.adCampaignsStore,
		campaignStatsStore = data.campaignStatsStore
	})
	local v7

	if FFlagBuildAdsManagerUniverseUrl then
		v7 = useOpenWebViewWithResumeRefresh(getAdsManagerUrl.getAdsManagerUrl(universeId), adsManager, v6, data.appLifecycleObserverService)
	else
		v7 = useOpenWebViewWithResumeRefresh(getAdsManagerUrl.getDefaultAdsManagerUrl(), adsManager, v6, data.appLifecycleObserverService)
	end

	local v8 = React.useCallback(function()
		setState(false)
		v7()
	end, { v7 })

	local v9 = React.useCallback(function(p2)
		if p2 == "ads-manager" then
			v8()
		end
	end, { v8 })

	local v10 = React.useCallback(function()
		setState(function(p2): boolean
			return not p2
		end)
	end, {})

	local v11 = React.useCallback(function()
		setState(false)
	end, {})

	local v12 = React.useMemo(function()
		return {
			{
				id = "ads-manager",
				text = adsManager,
				trailing = { iconName = iconName.ArrowUpRightFromSquare }
			}
		}
	end, { adsManager })

	return {
		layoutOrder = data.layoutOrder,
		testId = data.testId or "AdsManagerMenuButton",
		buttonSize = inputSize.Large,
		isMenuOpen = state,
		menuSize = inputSize.Large,
		menuWidth = v5,
		menuItems = v12,
		onToggleMenu = v10,
		onCloseMenu = v11,
		onItemActivated = v9
	}
end

return useAdsManagerMenuButtonViewModel
