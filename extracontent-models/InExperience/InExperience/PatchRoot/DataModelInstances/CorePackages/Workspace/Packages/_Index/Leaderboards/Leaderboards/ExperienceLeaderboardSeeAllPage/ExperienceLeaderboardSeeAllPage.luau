local Leaderboards = script:FindFirstAncestor("Leaderboards")
local parent = Leaderboards.Parent

require(parent.Navigation)
local React = require(parent.React)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local AppComposition = require(parent.AppComposition)
local CompositionTags = AppComposition.CompositionTags

local fetchExperienceLeaderboardSeeAllPageIfNeeded = require(Leaderboards.ExperienceLeaderboardSeeAllPage.fetchExperienceLeaderboardSeeAllPageIfNeeded)

local getExperienceLeaderboardSeeAllPageKey = require(Leaderboards.ExperienceLeaderboardSeeAllPage.getExperienceLeaderboardSeeAllPageKey)

local function getFromPropsOrNavigationParams(p, p2: string) -- 3 equivalent calls inferred from this helper
	return p[p2] or p.navigation and p.navigation.getParam(p2)
end

local function ExperienceLeaderboardSeeAllPage(p)
	local v = getFromPropsOrNavigationParams(p, "universeId") -- inferred equivalent call
	local v2 = getFromPropsOrNavigationParams(p, "initialTab") -- inferred equivalent call
	local experienceLeaderboardSeeAllPageKey = getExperienceLeaderboardSeeAllPageKey(v)
	usePageScopeRef(experienceLeaderboardSeeAllPageKey)
	local v3 = useLocalization({ pageTitle = "Feature.Leaderboards.Heading.Leaderboard" })

	local pageTimer = React.useMemo(function()
		return getFromPropsOrNavigationParams(p, "pageTimer") -- inferred equivalent call
			or SduiLoadTimer.createLoadTimer("ExperienceLeaderboardSeeAll")
	end, { experienceLeaderboardSeeAllPageKey })

	React.useEffect(function()
		if v then
			fetchExperienceLeaderboardSeeAllPageIfNeeded(v, v2, pageTimer)
		end
	end, { v, v2, pageTimer })

	local refresh = React.useCallback(function()
		if v then
			local loadTimer = SduiLoadTimer.createLoadTimer("ExperienceLeaderboardSeeAll")
			loadTimer.start("refresh")
			fetchExperienceLeaderboardSeeAllPageIfNeeded(v, v2, loadTimer, true)
		end
	end, { v, v2 })

	if v == nil then
		return nil
	end

	return React.createElement(SduiPageEntryPoint, {
		appPage = "ExperienceLeaderboardSeeAll",
		configKey = experienceLeaderboardSeeAllPageKey,
		pageTimer = pageTimer,
		includeNavigationHeaderBar = true,
		pageTitle = v3.pageTitle,
		refresh = refresh,
		layoutTag = CompositionTags.Layout.Detail,
		contentTag = CompositionTags.ContentRegion.Body
	})
end

return React.memo(ExperienceLeaderboardSeeAllPage)
