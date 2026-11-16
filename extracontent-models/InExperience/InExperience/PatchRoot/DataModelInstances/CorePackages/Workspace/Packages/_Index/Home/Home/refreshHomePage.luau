local Home = script:FindFirstAncestor("Home")
local parent = Home.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local fetchHomePage = require(Home.fetchHomePage)
local SiteMessageStore = require(parent.SiteMessageStore)
local GetSiteMessageStore = SiteMessageStore.GetSiteMessageStore

local function refreshHomePage(requestIntent: string?, contextualFeatures, flag: boolean?)
	if flag ~= false then
		GetSiteMessageStore(false).refreshSiteAlertInfo()
	end

	local loadTimer = SduiSharedUtilities.SduiLoadTimer.createLoadTimer(AppPage.Home)
	loadTimer.start("refresh")
	local v = fetchHomePage(loadTimer, {
		forceRefresh = true,
		requestIntent = requestIntent,
		contextualFeatures = contextualFeatures
	})

	if v then
		return v:finally(function()
			loadTimer.logRefreshComplete()
		end)
	end

	return nil
end

return refreshHomePage
