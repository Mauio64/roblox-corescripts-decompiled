local Leaderboards = script:FindFirstAncestor("Leaderboards")
local parent = Leaderboards.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer

local fetchExperienceLeaderboardSeeAllPageIfNeeded = require(Leaderboards.ExperienceLeaderboardSeeAllPage.fetchExperienceLeaderboardSeeAllPageIfNeeded)

local function navigateToExperienceLeaderboardSeeAll(p, universeId: string, initialTab: string?)
	local loadTimer = SduiLoadTimer.createLoadTimer(AppPage.ExperienceLeaderboardSeeAll)
	loadTimer.start("navigate")

	local url = fetchExperienceLeaderboardSeeAllPageIfNeeded(universeId, initialTab, loadTimer)

	p.navigate(AppPage.ExperienceLeaderboardSeeAll, {
		universeId = universeId,
		initialTab = initialTab,
		pageTimer = loadTimer,
		url = url
	})
end

return navigateToExperienceLeaderboardSeeAll
