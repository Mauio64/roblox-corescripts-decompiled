local Parent = script:FindFirstAncestor("AppStartup").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage

local function navigateWithPlatformAccount(b1: boolean, p1: ((...any) -> ...any)) -- line: 8
	-- upvalues: AppPage (copy)
	if b1 then
		p1(AppPage.SingleSignOnContainer)

		return
	end

	p1(AppPage.Startup)
end

return navigateWithPlatformAccount
