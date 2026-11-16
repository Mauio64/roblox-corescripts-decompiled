local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CentralOverlay").Thunks.CloseCentralOverlay
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Responsive")
local getInputModeStore = Responsive.GetInputModeStore
local openInfoPeekView = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryRouting").OpenInfoPeekView
local openCloseOnlyInteractiveAlert = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryRouting").OpenCloseOnlyInteractiveAlert

local sduiResponsiveHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem").SduiResponsiveHelpers

return function(p2, p3, p4)
	local dispatch = p4.dependencies.dispatch

	local portraitOrientation = sduiResponsiveHelpers.isPortraitOrientation()
	local lastInputType = getInputModeStore(false).getLastInputType(false)

	local tooltipInfoText = p2 and p2.actionParams and p2.actionParams.tooltipInfoText or ""

	local tooltipTitle = p2 and p2.actionParams and p2.actionParams.tooltipTitle or ""

	if lastInputType == Responsive.Input.Touch and portraitOrientation then
		dispatch(openInfoPeekView(tooltipTitle, tooltipInfoText))
	else
		dispatch(openCloseOnlyInteractiveAlert(tooltipTitle, tooltipInfoText, function()
			return dispatch(closeCentralOverlay())
		end))
	end
end
