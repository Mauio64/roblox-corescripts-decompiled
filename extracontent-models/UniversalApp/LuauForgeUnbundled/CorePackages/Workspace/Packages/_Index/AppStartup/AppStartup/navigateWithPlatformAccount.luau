local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/RobloxAppEnums").AppPage

local function navigateWithPlatformAccount(p2, callback)
	if p2 then
		callback(appPage.SingleSignOnContainer)
	else
		callback(appPage.Startup)
	end
end

return navigateWithPlatformAccount
