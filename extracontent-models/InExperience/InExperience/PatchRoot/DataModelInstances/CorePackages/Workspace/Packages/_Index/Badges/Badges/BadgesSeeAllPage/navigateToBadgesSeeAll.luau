local Badges = script:FindFirstAncestor("Badges")
local BadgesParent = Badges.Parent
local AppPage = require(BadgesParent.RobloxAppEnums).AppPage
local SduiLoadTimer = require(BadgesParent.SduiSharedUtilities).SduiLoadTimer
local fetchBadgesSeeAllPageIfNeeded = require(Badges.BadgesSeeAllPage.fetchBadgesSeeAllPageIfNeeded)

local function navigateToBadgesSeeAll(p1, s1: string) -- line: 9
	-- upvalues: SduiLoadTimer (copy), AppPage (copy), fetchBadgesSeeAllPageIfNeeded (copy)
	local v9 = SduiLoadTimer.createLoadTimer(AppPage.BadgesSeeAll)

	v9.start("navigate")

	local v10 = fetchBadgesSeeAllPageIfNeeded(s1, v9)

	p1.navigate(AppPage.BadgesSeeAll, {
		universeId = s1,
		pageTimer = v9,
		url = v10
	})
end

return navigateToBadgesSeeAll
