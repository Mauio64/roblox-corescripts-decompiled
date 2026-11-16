local Badges = script:FindFirstAncestor("Badges")
local parent = Badges.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local fetchBadgesSeeAllPageIfNeeded = require(Badges.BadgesSeeAllPage.fetchBadgesSeeAllPageIfNeeded)

local function navigateToBadgesSeeAll(p, universeId: string)
	local loadTimer = SduiLoadTimer.createLoadTimer(AppPage.BadgesSeeAll)
	loadTimer.start("navigate")

	local url = fetchBadgesSeeAllPageIfNeeded(universeId, loadTimer)

	p.navigate(AppPage.BadgesSeeAll, { universeId = universeId, pageTimer = loadTimer, url = url })
end

return navigateToBadgesSeeAll
