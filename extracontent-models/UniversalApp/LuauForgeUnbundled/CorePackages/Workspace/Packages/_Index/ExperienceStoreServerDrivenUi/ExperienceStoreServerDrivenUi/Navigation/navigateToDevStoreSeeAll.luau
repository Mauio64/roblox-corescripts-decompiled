local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/RobloxAppEnums").AppPage
local fFlagLuaAppDevStoreSeeAllForceRefreshOnNavigate = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/SharedFlags").FFlagLuaAppDevStoreSeeAllForceRefreshOnNavigate
local sduiLoadTimer = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/SduiSharedUtilities").SduiLoadTimer
local fetchDevStoreSeeAllPageIfNeeded = require("@game/CorePackages/Workspace/Packages/_Index/ExperienceStoreServerDrivenUi/ExperienceStoreServerDrivenUi/Api/fetchDevStoreSeeAllPageIfNeeded")

local function navigateToDevStoreSeeAll(p2, p3)
	local loadTimer = sduiLoadTimer.createLoadTimer(appPage.DevStoreSeeAll)
	loadTimer.start("navigate")

	local v5 = fetchDevStoreSeeAllPageIfNeeded(p3, loadTimer, fFlagLuaAppDevStoreSeeAllForceRefreshOnNavigate and true or nil)

	p2.navigate(appPage.DevStoreSeeAll, {
		universeId = p3,
		pageTimer = loadTimer,
		url = v5
	})
end

return navigateToDevStoreSeeAll
