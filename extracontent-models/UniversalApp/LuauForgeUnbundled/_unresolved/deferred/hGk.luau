local CorePackages = game:GetService("CorePackages")
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Thunks.NavigateDown
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")
local t = require(CorePackages.Packages.t)

local appPage = RobloxAppEnums.AppPage

return function(onClose)
	assert(t.callback(onClose) or t.none(onClose), "")
	return navigateDown({
		name = appPage.Groups,
		extraProps = { onClose = onClose }
	})
end
