local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Modules = CoreGui.RobloxGui.Modules
local Panel3D = UIBlox.Core.VR.Panel3D
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local Object = require(CorePackages.Packages.LuauPolyfill).Object
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local VrCompatibility = require(CorePackages.Workspace.Packages.VrCompatibility)
local VRConstants = VrCompatibility.VRConstants
local VRPanelWidthIXP = VrCompatibility.VRPanelWidthIXP
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local OverlayComponent = require(Modules.LuaApp.Components.CentralOverlayUtils).OverlayComponent
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local VRCentralFoundationOverlayProvider = require(Modules.LuaApp.Components.CrossPlatformCompatibility.VRCentralFoundationOverlayProvider)
local GetFFlagVRPanelWidthIXPEnabled = SharedFlags.GetFFlagVRPanelWidthIXPEnabled
local FFlagLuaAppForceVrAppPanelWidthRollout = SharedFlags.FFlagLuaAppForceVrAppPanelWidthRollout
local GetFFlagEnableVRChartsTab = SharedFlags.GetFFlagEnableVRChartsTab
local v22 = game:DefineFastFlag("EnableCentralFoundationOverlayProvider", false)
local t1 = {
	hideCentralOverlay = false
}

local function v24(p1) -- line: 45
	return p1.CentralOverlay.OverlayType
end
local function v25(p2) -- line: 48
	return p2.CentralOverlay.Arguments
end
local function v26(p3) -- line: 51
	return p3.ScreenSize
end

return function(t2: {[any]: any}) -- line: 55
	-- upvalues: Object (copy), t1 (copy), useSelector (copy), v24 (copy), OverlayComponent (copy), v25 (copy), v26 (copy), useDispatch (copy), React (copy), CloseCentralOverlay (copy), FFlagLuaAppForceVrAppPanelWidthRollout (copy), GetFFlagVRPanelWidthIXPEnabled (copy), IxpUtils (copy), VRPanelWidthIXP (copy), GetFFlagEnableVRChartsTab (copy), Roact (copy), CoreGui (copy), Panel3D (copy), VRConstants (copy), v22 (copy), VRCentralFoundationOverlayProvider (copy)
	local v31 = Object.assign({}, t1, t2)
	local v32 = useSelector(v24)
	local v33 = OverlayComponent[v32]
	local v34 = useSelector(v25)
	local v35 = useSelector(v26)
	local v36 = useDispatch()
	local v37 = React.useCallback(function() -- line: 65
		-- upvalues: v36 (copy), CloseCentralOverlay (copy)
		v36(CloseCentralOverlay())
	end)
	local v38 = if FFlagLuaAppForceVrAppPanelWidthRollout or not GetFFlagVRPanelWidthIXPEnabled() then nil else IxpUtils.useTestVariables(VRPanelWidthIXP.VrAppPanelWidthMultiplier)
	local v39 = if FFlagLuaAppForceVrAppPanelWidthRollout or not GetFFlagVRPanelWidthIXPEnabled() then nil else IxpUtils.useTestVariables(VRPanelWidthIXP.VrAppPanelCurvature)

	React.useEffect(function() -- line: 76
		-- upvalues: v32 (copy), v37 (copy)
		if not v32 then
			v37()
		end
	end, { v32 or false })

	local v40 = if not v34 then nil else v34.openPosition

	if GetFFlagEnableVRChartsTab() and v40 then
		local v41 = v35.X / 2
		local v42 = v41 + (v40.X - v41) / 1.2

		v34 = Object.assign({}, v34, {
			openPosition = Vector2.new(v42, v40.Y)
		})
	end

	local v43 = React.createElement(v33, Object.assign({}, v34, {
		containerWidth = v35.X,
		closeCentralOverlayThunk = CloseCentralOverlay
	}))

	if not v31.hideCentralOverlay and v33 then
		local v44 = (FFlagLuaAppForceVrAppPanelWidthRollout or not v38) and 1.2 or 1.2 * v38

		return React.createElement(Roact.Portal, {
			target = CoreGui
		}, {
			VRCentralOverlay = React.createElement(Panel3D, {
				panelName = "CentralOverlay",
				partSize = Vector2.new(VRConstants.MainScreenSize.X * v44, VRConstants.MainScreenSize.Y),
				offset = if not FFlagLuaAppForceVrAppPanelWidthRollout and (not GetFFlagVRPanelWidthIXPEnabled() or v39 ~= 0) then CFrame.lookAt(VRConstants.CentralOverlayPosition, VRConstants.DefaultCameraPosition) else CFrame.new(VRConstants.CentralOverlayPosition) * CFrame.fromEulerAnglesXYZ(0, -3.141592653589793, 0),
				virtualScreenSize = Vector2.new(v35.X, v35.Y),
				curvature = not FFlagLuaAppForceVrAppPanelWidthRollout and v39 or VRConstants.MainScreenCurvature
			}, {
				TextButtonWrapper = React.createElement("TextButton", {
					BackgroundTransparency = 1,
					Text = "",
					Selectable = false,
					Size = UDim2.new(1, 0, 1, 0)
				}, {
					VRCentralFoundationOverlayProvider = if not v22 then nil else React.createElement(VRCentralFoundationOverlayProvider, nil, {
						OverlayComponent = v43
					}),
					OverlayComponent = if v22 then nil else v43
				})
			})
		})
	end

	return nil
end
