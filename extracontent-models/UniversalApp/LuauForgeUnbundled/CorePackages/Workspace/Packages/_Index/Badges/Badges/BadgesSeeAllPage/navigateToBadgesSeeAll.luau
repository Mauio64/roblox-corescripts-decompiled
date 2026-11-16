local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/RobloxAppEnums").AppPage
local sduiLoadTimer = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/SduiSharedUtilities").SduiLoadTimer
local fetchBadgesSeeAllPageIfNeeded = require("@game/CorePackages/Workspace/Packages/_Index/Badges/Badges/BadgesSeeAllPage/fetchBadgesSeeAllPageIfNeeded")

local function navigateToBadgesSeeAll(p2, p3)
	local loadTimer = sduiLoadTimer.createLoadTimer(appPage.BadgesSeeAll)
	loadTimer.start("navigate")

	local v5 = fetchBadgesSeeAllPageIfNeeded(p3, loadTimer)

	p2.navigate(appPage.BadgesSeeAll, {
		universeId = p3,
		pageTimer = loadTimer,
		url = v5
	})
end

return navigateToBadgesSeeAll
