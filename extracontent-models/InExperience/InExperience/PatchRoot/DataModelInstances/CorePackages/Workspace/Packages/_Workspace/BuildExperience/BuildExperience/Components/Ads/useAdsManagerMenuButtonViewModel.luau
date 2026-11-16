local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

require(parent.DataHydration.AdCampaigns)
require(parent.DataHydration.CampaignStats)
local getAdsManagerUrl = require(script.Parent.getAdsManagerUrl)
require(script.Parent.AdsManagerMenuButtonView)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local useOpenWebViewWithResumeRefresh = require(BuildExperience.utils.useOpenWebViewWithResumeRefresh)
local useRefreshAdsData = require(script.Parent.useRefreshAdsData)

local FFlagBuildAdsManagerUniverseUrl = require(BuildExperience.Flags.FFlagBuildAdsManagerUniverseUrl)

local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local useScaledValue = Foundation.Hooks.useScaledValue

local defineFastInt = game:DefineFastInt("BuildAdsManagerMenuWidth", 162)

local function useAdsManagerMenuButtonViewModel(data)
	local state, setState = React.useState(false)
	local menuWidth = useScaledValue(defineFastInt)
	local adsManager = useLocalization({ adsManager = LocalizationStrings.ADS_STATS_ADS_MANAGER }).adsManager
	local universeId = data.universeId
	local v = useRefreshAdsData(universeId, {
		adCampaignsStore = data.adCampaignsStore,
		campaignStatsStore = data.campaignStatsStore
	})
	local v2

	if FFlagBuildAdsManagerUniverseUrl then
		v2 = useOpenWebViewWithResumeRefresh(
			getAdsManagerUrl.getAdsManagerUrl(universeId),
			adsManager,
			v,
			data.appLifecycleObserverService
		)
	else
		v2 = useOpenWebViewWithResumeRefresh(
			getAdsManagerUrl.getDefaultAdsManagerUrl(),
			adsManager,
			v,
			data.appLifecycleObserverService
		)
	end

	local v3 = React.useCallback(function()
		setState(false)
		v2()
	end, { v2 })

	local onItemActivated = React.useCallback(function(p)
		if p == "ads-manager" then
			v3()
		end
	end, { v3 })

	local onToggleMenu = React.useCallback(function()
		setState(function(p): boolean
			return not p
		end)
	end, {})

	local onCloseMenu = React.useCallback(function()
		setState(false)
	end, {})

	local menuItems = React.useMemo(function()
		return {
			{
				id = "ads-manager",
				text = adsManager,
				trailing = { iconName = IconName.ArrowUpRightFromSquare }
			}
		}
	end, { adsManager })

	return {
		layoutOrder = data.layoutOrder,
		testId = data.testId or "AdsManagerMenuButton",
		buttonSize = InputSize.Large,
		isMenuOpen = state,
		menuSize = InputSize.Large,
		menuWidth = menuWidth,
		menuItems = menuItems,
		onToggleMenu = onToggleMenu,
		onCloseMenu = onCloseMenu,
		onItemActivated = onItemActivated
	}
end

return useAdsManagerMenuButtonViewModel
