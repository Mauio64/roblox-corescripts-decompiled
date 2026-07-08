local DevStore = script:FindFirstAncestor("DevStore")
local DevStoreParent = DevStore.Parent
local AppPage = require(DevStoreParent.RobloxAppEnums).AppPage
local FFlagLuaAppDevStoreSeeAllForceRefreshOnNavigate = require(DevStoreParent.SharedFlags).FFlagLuaAppDevStoreSeeAllForceRefreshOnNavigate
local SduiLoadTimer = require(DevStoreParent.SduiSharedUtilities).SduiLoadTimer
local fetchDevStoreSeeAllPageIfNeeded = require(DevStore.DevStoreSeeAllPage.fetchDevStoreSeeAllPageIfNeeded)

local function navigateToDevStoreSeeAll(p1, s1: string) -- line: 11
	-- upvalues: SduiLoadTimer (copy), AppPage (copy), FFlagLuaAppDevStoreSeeAllForceRefreshOnNavigate (copy), fetchDevStoreSeeAllPageIfNeeded (copy)
	local v10 = SduiLoadTimer.createLoadTimer(AppPage.DevStoreSeeAll)

	v10.start("navigate")

	local v11 = not not FFlagLuaAppDevStoreSeeAllForceRefreshOnNavigate or nil
	local v12 = fetchDevStoreSeeAllPageIfNeeded(s1, v10, v11)

	p1.navigate(AppPage.DevStoreSeeAll, {
		universeId = s1,
		pageTimer = v10,
		url = v12
	})
end

return navigateToDevStoreSeeAll
