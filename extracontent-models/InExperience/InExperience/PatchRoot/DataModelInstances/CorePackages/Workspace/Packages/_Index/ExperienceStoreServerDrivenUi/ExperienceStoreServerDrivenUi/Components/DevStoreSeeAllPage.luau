local ExperienceStoreServerDrivenUi = script:FindFirstAncestor("ExperienceStoreServerDrivenUi")
local parent = ExperienceStoreServerDrivenUi.Parent

require(parent.Navigation)
local React = require(parent.React)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths
local AppComposition = require(parent.AppComposition)
local CompositionTags = AppComposition.CompositionTags

local SharedFlags2 = require(parent.SharedFlags)
local FFlagSplitPaneDevStoreSeeAllSupportRegion = SharedFlags2.FFlagSplitPaneDevStoreSeeAllSupportRegion
local paneHostContext

if FFlagSplitPaneDevStoreSeeAllSupportRegion then
	local SplitPane = require(parent.SplitPane)
	paneHostContext = SplitPane.PaneHostContext
else
	paneHostContext = nil
end

local fetchDevStoreSeeAllPageIfNeeded = require(ExperienceStoreServerDrivenUi.Api.fetchDevStoreSeeAllPageIfNeeded)
local getDevStoreSeeAllPageKey = require(ExperienceStoreServerDrivenUi.Utils.getDevStoreSeeAllPageKey)

local function getFromPropsOrNavigationParams(p, p2: string) -- 2 equivalent calls inferred from this helper
	return p[p2] or p.navigation and p.navigation.getParam(p2)
end

local function DevStoreSeeAllPage(p)
	local v = getFromPropsOrNavigationParams(p, "universeId") -- inferred equivalent call
	local devStoreSeeAllPageKey = getDevStoreSeeAllPageKey(v)
	local v2 = useLocalization({ pageTitle = "Feature.GameDetails.Label.Store" })
	local v3

	if FFlagSplitPaneDevStoreSeeAllSupportRegion then
		v3 = React.useContext(paneHostContext)
	end

	local v4 = getFromPropsOrNavigationParams(p, "pageTimer") -- inferred equivalent call
	local pageTimer = React.useMemo(function()
		return v4 or SduiLoadTimer.createLoadTimer("DevStoreSeeAll")
	end, { devStoreSeeAllPageKey, v4 })

	if FFlagSduiErrorPaths then
		React.useMemo(function()
			if not v then
				return nil
			end

			local sduiClientPageScope = getSduiClientPageScope(devStoreSeeAllPageKey)
			sduiClientPageScope.set("devStoreSectionsFired", {})
			return sduiClientPageScope
		end, { devStoreSeeAllPageKey, pageTimer, v })
	end

	React.useEffect(function()
		if v then
			fetchDevStoreSeeAllPageIfNeeded(v, pageTimer)
		end
	end, { v, pageTimer })

	local refresh = React.useCallback(function()
		if v then
			local loadTimer = SduiLoadTimer.createLoadTimer("DevStoreSeeAll")
			loadTimer.start("refresh")
			fetchDevStoreSeeAllPageIfNeeded(v, loadTimer, true)
		end
	end, { v })

	if v == nil then
		return nil
	end

	return React.createElement(SduiPageEntryPoint, {
		appPage = "DevStoreSeeAll",
		configKey = devStoreSeeAllPageKey,
		pageTimer = pageTimer,
		includeNavigationHeaderBar = true,
		navButtonType = FFlagSplitPaneDevStoreSeeAllSupportRegion and v3 ~= nil and v3.isHostCloseVisible and "none" or nil,
		pageTitle = v2.pageTitle,
		refresh = refresh,
		contentTag = CompositionTags.ContentRegion.Body,
		layoutTag = CompositionTags.Layout.Detail
	})
end

return React.memo(DevStoreSeeAllPage)
