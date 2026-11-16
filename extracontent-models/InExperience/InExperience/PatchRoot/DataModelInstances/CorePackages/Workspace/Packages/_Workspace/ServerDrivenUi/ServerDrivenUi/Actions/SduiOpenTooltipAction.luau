local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local CentralOverlay = require(parent.CentralOverlay)
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local Responsive = require(parent.Responsive)
local GetInputModeStore = Responsive.GetInputModeStore
local DiscoveryRouting = require(parent.DiscoveryRouting)
local OpenInfoPeekView = DiscoveryRouting.OpenInfoPeekView
local DiscoveryRouting2 = require(parent.DiscoveryRouting)
local OpenCloseOnlyInteractiveAlert = DiscoveryRouting2.OpenCloseOnlyInteractiveAlert

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiResponsiveHelpers = SduiCoreSystem.SduiResponsiveHelpers

return function(p, _, p2)
	local dispatch = p2.dependencies.dispatch

	local portraitOrientation = SduiResponsiveHelpers.isPortraitOrientation()
	local lastInputType = GetInputModeStore(false).getLastInputType(false)

	local tooltipInfoText = p and p.actionParams and p.actionParams.tooltipInfoText or ""

	local tooltipTitle = p and p.actionParams and p.actionParams.tooltipTitle or ""

	if lastInputType == Responsive.Input.Touch and portraitOrientation then
		dispatch(OpenInfoPeekView(tooltipTitle, tooltipInfoText))
	else
		dispatch(OpenCloseOnlyInteractiveAlert(tooltipTitle, tooltipInfoText, function()
			return dispatch(CloseCentralOverlay())
		end))
	end
end
