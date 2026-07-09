local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local GenericWebPageWrapper = require(Modules.LuaApp.Components.GenericWebPageWrapper)
local GetFStringBlackbirdUrl = require(CorePackages.Workspace.Packages.SharedFlags).GetFStringBlackbirdUrl
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local getSubscriptionPurchaseCloseCallback = require(CorePackages.Workspace.Packages.RobloxSubscriptionPurchaseApp).Utils.getSubscriptionPurchaseCloseCallback

local function BlackbirdPageWrapper(t1: {[any]: any}) -- line: 23
	-- upvalues: React (copy), getSubscriptionPurchaseCloseCallback (copy), GenericWebPageWrapper (copy), UrlBuilder (copy), GetFStringBlackbirdUrl (copy)
	local v10 = React.useMemo(getSubscriptionPurchaseCloseCallback, {})

	return React.createElement(GenericWebPageWrapper, {
		titleKey = "CommonUI.Features.Label.X",
		isVisible = t1.isVisible,
		DisplayOrder = t1.DisplayOrder,
		url = UrlBuilder.fromString(GetFStringBlackbirdUrl())(),
		transitionAnimation = t1.transitionAnimation,
		onClose = v10
	})
end

return BlackbirdPageWrapper
