local Badges = script:FindFirstAncestor("Badges")
local parent = Badges.Parent

require(parent.Navigation)
local React = require(parent.React)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local AppComposition = require(parent.AppComposition)
local CompositionTags = AppComposition.CompositionTags
local SharedFlags = require(parent.SharedFlags)
local FFlagSplitPaneBadgesSeeAllSupportRegion = SharedFlags.FFlagSplitPaneBadgesSeeAllSupportRegion
local paneHostContext

if FFlagSplitPaneBadgesSeeAllSupportRegion then
	local SplitPane = require(parent.SplitPane)
	paneHostContext = SplitPane.PaneHostContext
else
	paneHostContext = nil
end

local fetchBadgesSeeAllPageIfNeeded = require(Badges.BadgesSeeAllPage.fetchBadgesSeeAllPageIfNeeded)
local getBadgesSeeAllPageKey = require(Badges.BadgesSeeAllPage.getBadgesSeeAllPageKey)

local function getFromPropsOrNavigationParams(p, p2: string) -- 2 equivalent calls inferred from this helper
	return p[p2] or p.navigation and p.navigation.getParam(p2)
end

local function BadgesSeeAllPage(p)
	local v = getFromPropsOrNavigationParams(p, "universeId") -- inferred equivalent call
	local badgesSeeAllPageKey = getBadgesSeeAllPageKey(v)
	local v2 = useLocalization({ pageTitle = "CommonUI.Features.Label.Badges" })
	local v3

	if FFlagSplitPaneBadgesSeeAllSupportRegion then
		v3 = React.useContext(paneHostContext)
	end

	local pageTimer = React.useMemo(function()
		return getFromPropsOrNavigationParams(p, "pageTimer") or SduiLoadTimer.createLoadTimer("BadgesSeeAll") -- inferred equivalent call
	end, { badgesSeeAllPageKey })

	React.useEffect(function()
		if v then
			fetchBadgesSeeAllPageIfNeeded(v, pageTimer)
		end
	end, { v, pageTimer })

	local refresh = React.useCallback(function()
		if v then
			local loadTimer = SduiLoadTimer.createLoadTimer("BadgesSeeAll")
			loadTimer.start("refresh")
			fetchBadgesSeeAllPageIfNeeded(v, loadTimer, true)
		end
	end, { v })

	if v == nil then
		return nil
	end

	return React.createElement(SduiPageEntryPoint, {
		appPage = "BadgesSeeAll",
		configKey = badgesSeeAllPageKey,
		pageTimer = pageTimer,
		includeNavigationHeaderBar = true,
		navButtonType = FFlagSplitPaneBadgesSeeAllSupportRegion and v3 ~= nil and v3.isHostCloseVisible and "none" or nil,
		pageTitle = v2.pageTitle,
		refresh = refresh,
		contentTag = CompositionTags.ContentRegion.Body
	})
end

return React.memo(BadgesSeeAllPage)
