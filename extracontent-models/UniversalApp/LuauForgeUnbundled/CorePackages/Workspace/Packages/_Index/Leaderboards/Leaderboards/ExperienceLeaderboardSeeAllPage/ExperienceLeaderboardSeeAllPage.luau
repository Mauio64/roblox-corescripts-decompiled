require("@game/CorePackages/Workspace/Packages/_Workspace/Leaderboards/Navigation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Leaderboards/React")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Leaderboards/SduiSharedUtilities")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/Leaderboards/Localization").Hooks.useLocalization

local sduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local sduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local compositionTags = require("@game/CorePackages/Workspace/Packages/_Workspace/Leaderboards/AppComposition").CompositionTags

local fetchExperienceLeaderboardSeeAllPageIfNeeded = require("@game/CorePackages/Workspace/Packages/_Index/Leaderboards/Leaderboards/ExperienceLeaderboardSeeAllPage/fetchExperienceLeaderboardSeeAllPageIfNeeded")

local getExperienceLeaderboardSeeAllPageKey = require("@game/CorePackages/Workspace/Packages/_Index/Leaderboards/Leaderboards/ExperienceLeaderboardSeeAllPage/getExperienceLeaderboardSeeAllPageKey")

local function getFromPropsOrNavigationParams(p2, p3)
	return p2[p3] or p2.navigation and p2.navigation.getParam(p3)
end

local function ExperienceLeaderboardSeeAllPage(props)
	local universeId = props.universeId or props.navigation and props.navigation.getParam("universeId")
	local initialTab = props.initialTab or props.navigation and props.navigation.getParam("initialTab")

	local v5 = getExperienceLeaderboardSeeAllPageKey(universeId)
	usePageScopeRef(v5)
	local v6 = useLocalization({
		pageTitle = "Feature.Leaderboards.Heading.Leaderboard"
	})

	local v7 = React.useMemo(function()
		local v8 = props
		return v8.pageTimer
			or v8.navigation and v8.navigation.getParam("pageTimer")
			or sduiLoadTimer.createLoadTimer("ExperienceLeaderboardSeeAll")
	end, { v5 })

	React.useEffect(function()
		if universeId then
			fetchExperienceLeaderboardSeeAllPageIfNeeded(universeId, initialTab, v7)
		end
	end, { universeId, initialTab, v7 })

	local v8 = React.useCallback(function()
		if universeId then
			local loadTimer = sduiLoadTimer.createLoadTimer("ExperienceLeaderboardSeeAll")
			loadTimer.start("refresh")
			fetchExperienceLeaderboardSeeAllPageIfNeeded(universeId, initialTab, loadTimer, true)
		end
	end, { universeId, initialTab })

	if universeId == nil then
		return nil
	end

	return React.createElement(sduiPageEntryPoint, {
		appPage = "ExperienceLeaderboardSeeAll",
		configKey = v5,
		pageTimer = v7,
		includeNavigationHeaderBar = true,
		pageTitle = v6.pageTitle,
		refresh = v8,
		layoutTag = compositionTags.Layout.Detail,
		contentTag = compositionTags.ContentRegion.Body
	})
end

return React.memo(ExperienceLeaderboardSeeAllPage)
