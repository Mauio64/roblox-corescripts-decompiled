require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/Navigation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/React")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/SduiSharedUtilities")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/Localization").Hooks.useLocalization

local sduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local sduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local compositionTags = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/AppComposition").CompositionTags
local fFlagSplitPaneBadgesSeeAllSupportRegion = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/SharedFlags").FFlagSplitPaneBadgesSeeAllSupportRegion
local paneHostContext

if fFlagSplitPaneBadgesSeeAllSupportRegion then
	paneHostContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/SplitPane").PaneHostContext
else
	paneHostContext = nil
end

local fetchBadgesSeeAllPageIfNeeded = require("@game/CorePackages/Workspace/Packages/_Index/Badges/Badges/BadgesSeeAllPage/fetchBadgesSeeAllPageIfNeeded")
local getBadgesSeeAllPageKey = require("@game/CorePackages/Workspace/Packages/_Index/Badges/Badges/BadgesSeeAllPage/getBadgesSeeAllPageKey")

local function getFromPropsOrNavigationParams(p2, p3)
	return p2[p3] or p2.navigation and p2.navigation.getParam(p3)
end

local function BadgesSeeAllPage(p2)
	local universeId = p2.universeId or p2.navigation and p2.navigation.getParam("universeId")

	local v5 = getBadgesSeeAllPageKey(universeId)
	local v6 = useLocalization({ pageTitle = "CommonUI.Features.Label.Badges" })
	local v7

	if fFlagSplitPaneBadgesSeeAllSupportRegion then
		v7 = React.useContext(paneHostContext)
	end

	local v8 = React.useMemo(function()
		local v9 = p2
		return v9.pageTimer
			or v9.navigation and v9.navigation.getParam("pageTimer")
			or sduiLoadTimer.createLoadTimer("BadgesSeeAll")
	end, { v5 })

	React.useEffect(function()
		if universeId then
			fetchBadgesSeeAllPageIfNeeded(universeId, v8)
		end
	end, { universeId, v8 })

	local v9 = React.useCallback(function()
		if universeId then
			local loadTimer = sduiLoadTimer.createLoadTimer("BadgesSeeAll")
			loadTimer.start("refresh")
			fetchBadgesSeeAllPageIfNeeded(universeId, loadTimer, true)
		end
	end, { universeId })

	if universeId == nil then
		return nil
	end

	return React.createElement(sduiPageEntryPoint, {
		appPage = "BadgesSeeAll",
		configKey = v5,
		pageTimer = v8,
		includeNavigationHeaderBar = true,
		navButtonType = fFlagSplitPaneBadgesSeeAllSupportRegion and v7 ~= nil and v7.isHostCloseVisible and "none" or nil,
		pageTitle = v6.pageTitle,
		refresh = v9,
		contentTag = compositionTags.ContentRegion.Body
	})
end

return React.memo(BadgesSeeAllPage)
