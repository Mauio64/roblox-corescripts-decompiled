local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Leaderboards/RobloxAppEnums").AppPage
local sduiLoadTimer = require("@game/CorePackages/Workspace/Packages/_Workspace/Leaderboards/SduiSharedUtilities").SduiLoadTimer

local fetchExperienceLeaderboardSeeAllPageIfNeeded = require("@game/CorePackages/Workspace/Packages/_Index/Leaderboards/Leaderboards/ExperienceLeaderboardSeeAllPage/fetchExperienceLeaderboardSeeAllPageIfNeeded")

local function navigateToExperienceLeaderboardSeeAll(p2, p3, p4)
	local loadTimer = sduiLoadTimer.createLoadTimer(appPage.ExperienceLeaderboardSeeAll)
	loadTimer.start("navigate")

	local v5 = fetchExperienceLeaderboardSeeAllPageIfNeeded(p3, p4, loadTimer)

	p2.navigate(appPage.ExperienceLeaderboardSeeAll, {
		universeId = p3,
		initialTab = p4,
		pageTimer = loadTimer,
		url = v5
	})
end

return navigateToExperienceLeaderboardSeeAll
