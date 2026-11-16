local ExperienceStoreServerDrivenUi = script:FindFirstAncestor("ExperienceStoreServerDrivenUi")
local parent = ExperienceStoreServerDrivenUi.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDevStoreSeeAllForceRefreshOnNavigate = SharedFlags.FFlagLuaAppDevStoreSeeAllForceRefreshOnNavigate
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local fetchDevStoreSeeAllPageIfNeeded = require(ExperienceStoreServerDrivenUi.Api.fetchDevStoreSeeAllPageIfNeeded)

local function navigateToDevStoreSeeAll(p, universeId: string)
	local loadTimer = SduiLoadTimer.createLoadTimer(AppPage.DevStoreSeeAll)
	loadTimer.start("navigate")

	local url = fetchDevStoreSeeAllPageIfNeeded(
		universeId,
		loadTimer,
		FFlagLuaAppDevStoreSeeAllForceRefreshOnNavigate and true or nil
	)

	p.navigate(AppPage.DevStoreSeeAll, { universeId = universeId, pageTimer = loadTimer, url = url })
end

return navigateToDevStoreSeeAll
