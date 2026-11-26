require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/Navigation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/React")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/SduiSharedUtilities")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/Localization").Hooks.useLocalization

local sduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local sduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/SharedFlags").FFlagSduiErrorPaths
local compositionTags = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/AppComposition").CompositionTags

local fFlagSplitPaneDevStoreSeeAllSupportRegion = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/SharedFlags").FFlagSplitPaneDevStoreSeeAllSupportRegion
local paneHostContext

if fFlagSplitPaneDevStoreSeeAllSupportRegion then
	paneHostContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/SplitPane").PaneHostContext
else
	paneHostContext = nil
end

local fetchDevStoreSeeAllPageIfNeeded = require("@game/CorePackages/Workspace/Packages/_Index/ExperienceStoreServerDrivenUi/ExperienceStoreServerDrivenUi/Api/fetchDevStoreSeeAllPageIfNeeded")
local getDevStoreSeeAllPageKey = require("@game/CorePackages/Workspace/Packages/_Index/ExperienceStoreServerDrivenUi/ExperienceStoreServerDrivenUi/Utils/getDevStoreSeeAllPageKey")

local function getFromPropsOrNavigationParams(p2, p3)
	return p2[p3] or p2.navigation and p2.navigation.getParam(p3)
end

local function DevStoreSeeAllPage(props)
	local universeId = props.universeId or props.navigation and props.navigation.getParam("universeId")

	local v5 = getDevStoreSeeAllPageKey(universeId)
	local v6 = useLocalization({ pageTitle = "Feature.GameDetails.Label.Store" })
	local v7

	if fFlagSplitPaneDevStoreSeeAllSupportRegion then
		v7 = React.useContext(paneHostContext)
	end

	local pageTimer = props.pageTimer or props.navigation and props.navigation.getParam("pageTimer")

	local v8 = React.useMemo(function()
		return pageTimer or sduiLoadTimer.createLoadTimer("DevStoreSeeAll")
	end, { v5, pageTimer })

	if fFlagSduiErrorPaths then
		React.useMemo(function()
			if not universeId then
				return nil
			end

			local sduiClientPageScope = getSduiClientPageScope(v5)
			sduiClientPageScope.set("devStoreSectionsFired", {})
			return sduiClientPageScope
		end, { v5, v8, universeId })
	end

	React.useEffect(function()
		if universeId then
			fetchDevStoreSeeAllPageIfNeeded(universeId, v8)
		end
	end, { universeId, v8 })

	local v9 = React.useCallback(function()
		if universeId then
			local loadTimer = sduiLoadTimer.createLoadTimer("DevStoreSeeAll")
			loadTimer.start("refresh")
			fetchDevStoreSeeAllPageIfNeeded(universeId, loadTimer, true)
		end
	end, { universeId })

	if universeId == nil then
		return nil
	end

	return React.createElement(sduiPageEntryPoint, {
		appPage = "DevStoreSeeAll",
		configKey = v5,
		pageTimer = v8,
		includeNavigationHeaderBar = true,
		navButtonType = fFlagSplitPaneDevStoreSeeAllSupportRegion and v7 ~= nil and v7.isHostCloseVisible and "none" or nil,
		pageTitle = v6.pageTitle,
		refresh = v9,
		contentTag = compositionTags.ContentRegion.Body,
		layoutTag = compositionTags.Layout.Detail
	})
end

return React.memo(DevStoreSeeAllPage)
