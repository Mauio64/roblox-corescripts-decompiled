local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/RobloxAppEnums").AppPage
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SduiSharedUtilities")
local fetchHomePage = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/fetchHomePage")
local getSiteMessageStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SiteMessageStore").GetSiteMessageStore

local function refreshHomePage(p2, p3, p4)
	if p4 ~= false then
		getSiteMessageStore(false).refreshSiteAlertInfo()
	end

	local loadTimer = SduiSharedUtilities.SduiLoadTimer.createLoadTimer(appPage.Home)
	loadTimer.start("refresh")
	local v5 = fetchHomePage(loadTimer, {
		forceRefresh = true,
		requestIntent = p2,
		contextualFeatures = p3
	})

	if v5 then
		return v5:finally(function()
			loadTimer.logRefreshComplete()
		end)
	end

	return nil
end

return refreshHomePage
