local ChromeShared = script:FindFirstAncestor("ChromeShared")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local Service = require(ChromeShared.Service)
require(CorePackages.Workspace.Packages.Chrome)
local useObservableValue = require(ChromeShared.Hooks.useObservableValue)

local function NineDotNotificationBadge(p)
	local clone = table.clone(p.iconHostProps)
	clone.showNineDotActivityIndicator = useObservableValue(Service:nineDotActivityIndicatorVisible()) == true

	return React.createElement(p.NotificationBadge, clone)
end

return NineDotNotificationBadge
