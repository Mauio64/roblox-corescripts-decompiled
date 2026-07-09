local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)

require(CorePackages.Workspace.Packages.Http)

local GetFFlagUADesktopPurchaseWarnings = require(Modules.LuaApp.Flags.GetFFlagUADesktopPurchaseWarnings)

return function(p1, s1: string?, n1: number?, b1: boolean?) -- line: 8
	-- upvalues: GetFFlagUADesktopPurchaseWarnings (copy), UrlBuilder (copy)
	return p1(if not GetFFlagUADesktopPurchaseWarnings() then UrlBuilder.economy.purchaseWarning.getPurchaseWarning(s1) else UrlBuilder.economy.purchaseWarning.getPurchaseWarning(s1, n1, b1 == false), "GET")
end
