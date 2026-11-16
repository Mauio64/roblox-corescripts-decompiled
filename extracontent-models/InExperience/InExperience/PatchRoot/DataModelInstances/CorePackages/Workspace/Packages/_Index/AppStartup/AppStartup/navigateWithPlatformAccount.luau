local parent = script:FindFirstAncestor("AppStartup").Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local function navigateWithPlatformAccount(flag: boolean, callback)
	if flag then
		callback(AppPage.SingleSignOnContainer)
	else
		callback(AppPage.Startup)
	end
end

return navigateWithPlatformAccount
