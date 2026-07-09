local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local CloseCentralOverlay = require(Parent.CentralOverlay).Thunks.CloseCentralOverlay
local Responsive = require(Parent.Responsive)
local GetInputModeStore = Responsive.GetInputModeStore
local OpenInfoPeekView = require(Parent.DiscoveryRouting).OpenInfoPeekView
local OpenCloseOnlyInteractiveAlert = require(Parent.DiscoveryRouting).OpenCloseOnlyInteractiveAlert
local SduiResponsiveHelpers = require(Parent.SduiCoreSystem).SduiResponsiveHelpers

return function(p1, _, p3) -- line: 18
	-- upvalues: SduiResponsiveHelpers (copy), GetInputModeStore (copy), Responsive (copy), OpenInfoPeekView (copy), OpenCloseOnlyInteractiveAlert (copy), CloseCentralOverlay (copy)
	local dispatch = p3.dependencies.dispatch
	local v12 = SduiResponsiveHelpers.isPortraitOrientation()
	local v13 = GetInputModeStore(false).getLastInputType(false)
	local v14 = p1 and (not not p1.actionParams and p1.actionParams.tooltipInfoText) or ""
	local v15 = p1 and (not not p1.actionParams and p1.actionParams.tooltipTitle) or ""

	if v13 == Responsive.Input.Touch and v12 then
		dispatch(OpenInfoPeekView(v15, v14))

		return
	end

	dispatch(OpenCloseOnlyInteractiveAlert(v15, v14, function() -- line: 34
		-- upvalues: dispatch (copy), CloseCentralOverlay (copy)
		return dispatch(CloseCentralOverlay())
	end))
end
