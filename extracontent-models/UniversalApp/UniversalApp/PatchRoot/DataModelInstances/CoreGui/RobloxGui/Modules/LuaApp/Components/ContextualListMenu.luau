local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local LuaApp = Modules.LuaApp
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local Constants = require(Modules.LuaApp.Constants)
local VrCompatibility = require(CorePackages.Workspace.Packages.VrCompatibility)
local VRReadyWrapper = VrCompatibility.VRReadyWrapper
local VRConstants = VrCompatibility.VRConstants
local VRPanelWidthIXP = VrCompatibility.VRPanelWidthIXP
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local FitChildren = require(LuaApp.FitChildren)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize
local FramePopOut = require(LuaApp.Components.FramePopOut)
local FramePopup = require(LuaApp.Components.FramePopup)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FFlagEnableFlyoutSidePanel = require(Modules.LuaApp.Flags.FFlagEnableFlyoutSidePanel)
local v25 = if not FFlagEnableFlyoutSidePanel then nil else require(CorePackages.Workspace.Packages.FlyoutSidePanel).FlyoutScrollAwayControl
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagVRPanelWidthIXPEnabled = SharedFlags.GetFFlagVRPanelWidthIXPEnabled
local FFlagLuaAppForceVrAppPanelWidthRollout = SharedFlags.FFlagLuaAppForceVrAppPanelWidthRollout
local v29 = Roact.PureComponent:extend("ContextualListMenu")

v29.defaultProps = {
	menuWidth = Constants.DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH
}

function v29.init(p1) -- line: 57
	-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	p1.focusEventHandlers = {
		[FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(p2) -- line: 60
				-- upvalues: p1 (copy)
				local callbackCancel = p1.props.callbackCancel

				if callbackCancel ~= nil then
					callbackCancel()
					p2:cancel()
				end
			end)
		}
	}
end
function v29.render(p3) -- line: 71
	-- upvalues: Roact (copy), FormFactor (copy), FitChildren (copy), FramePopOut (copy), FramePopup (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), getSafeAreaSize (copy), withStyle (copy), CoreGui (copy), VRReadyWrapper (copy), Constants (copy), FFlagLuaAppForceVrAppPanelWidthRollout (copy), VRConstants (copy), GetFFlagVRPanelWidthIXPEnabled (copy)
	local v33 = p3.props[Roact.Children] or {}
	local callbackCancel = p3.props.callbackCancel
	local formFactor = p3.props.formFactor
	local screenSize = p3.props.screenSize
	local globalContextMenuInset = p3.props.globalContextMenuInset
	local menuWidth = p3.props.menuWidth
	local screenShape = p3.props.screenShape
	local v40 = formFactor == FormFactor.WIDE

	if screenSize.X <= 0 or screenSize.Y <= 0 then
		return nil
	end

	v33.Layout = Roact.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	local v41 = Roact.createElement(FitChildren.FitFrame, {
		BackgroundTransparency = 1,
		fitAxis = FitChildren.FitAxis.Height,
		Size = UDim2.new(1, 0, 0, 0)
	}, v33)
	local v42 = if not v40 then Roact.createElement(FramePopup, {
		onCancel = callbackCancel
	}, {
		Content = v41
	}) else Roact.createElement(FramePopOut, {
		itemWidth = menuWidth,
		onCancel = callbackCancel,
		parentShape = screenShape
	}, {
		Content = v41
	})
	local u43 = Roact.createElement(FocusNavigableSurfaceWrapper, {
		isIsolated = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
		customEventHandlers = p3.focusEventHandlers
	}, {
		MenuContents = v42
	})
	local v44 = getSafeAreaSize(screenSize, globalContextMenuInset)

	return withStyle(function(p4) -- line: 124
		-- upvalues: Roact (copy), CoreGui (copy), VRReadyWrapper (copy), Constants (copy), FFlagLuaAppForceVrAppPanelWidthRollout (copy), p3 (copy), VRConstants (copy), GetFFlagVRPanelWidthIXPEnabled (copy), globalContextMenuInset (copy), screenSize (copy), v44 (copy), u43 (ref)
		return Roact.createElement(Roact.Portal, {
			target = CoreGui
		}, {
			PortalUI = Roact.createElement(VRReadyWrapper, {
				component = "ScreenGui",
				props = {
					ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
					DisplayOrder = Constants.DisplayOrder.ContextualListMenu
				},
				vrProps = {
					panelName = "ContextualListMenu",
					partSize = if FFlagLuaAppForceVrAppPanelWidthRollout or not p3.props.vrPanelWidthMultiplier then VRConstants.MainScreenSize else Vector2.new(VRConstants.MainScreenSize.X * p3.props.vrPanelWidthMultiplier, VRConstants.MainScreenSize.Y),
					offset = if not FFlagLuaAppForceVrAppPanelWidthRollout and (not GetFFlagVRPanelWidthIXPEnabled() or p3.props.vrPanelCurvature ~= 0) then CFrame.lookAt(VRConstants.MainScreenPosition, VRConstants.DefaultCameraPosition) else CFrame.new(VRConstants.MainScreenPosition) * CFrame.fromEulerAnglesXYZ(0, -3.141592653589793, 0),
					virtualScreenSize = if FFlagLuaAppForceVrAppPanelWidthRollout or not p3.props.vrPanelWidthMultiplier then VRConstants.MainScreenResolution else Vector2.new(VRConstants.MainScreenResolution.X * p3.props.vrPanelWidthMultiplier, VRConstants.MainScreenResolution.Y),
					curvature = if FFlagLuaAppForceVrAppPanelWidthRollout or not p3.props.vrPanelCurvature then VRConstants.MainScreenCurvature else p3.props.vrPanelCurvature
				}
			}, {
				Content = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Active = true,
					Position = UDim2.new(0, -globalContextMenuInset.left, 0, -globalContextMenuInset.top),
					Size = UDim2.new(0, screenSize.X, 0, screenSize.Y),
					BackgroundColor3 = p4.Theme.Overlay.Color,
					BackgroundTransparency = p4.Theme.Overlay.Transparency
				}, {
					SafeAreaFrame = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						ClipsDescendants = true,
						Position = UDim2.new(0, globalContextMenuInset.left, 0, globalContextMenuInset.top),
						Size = v44
					}, {
						Content = u43
					})
				})
			})
		})
	end)
end

if FFlagEnableFlyoutSidePanel then
	function v29.didMount(_) -- line: 186
		-- upvalues: v25 (copy)
		v25.setContextualMenuVisible(true)
	end
	function v29.willUnmount(_) -- line: 190
		-- upvalues: v25 (copy)
		v25.setContextualMenuVisible(false)
	end
end

local v30 = RoactRodux.connect(function(p7, _) -- line: 195
	return {
		formFactor = p7.FormFactor,
		screenSize = p7.ScreenSize,
		globalGuiInset = p7.GlobalGuiInset,
		globalContextMenuInset = p7.GlobalContextMenuInset
	}
end)(v29)

if not FFlagLuaAppForceVrAppPanelWidthRollout and GetFFlagVRPanelWidthIXPEnabled() then
	v30 = IxpUtils.connectTestVariables({
		vrPanelWidthMultiplier = VRPanelWidthIXP.VrAppPanelWidthMultiplier,
		vrPanelCurvature = VRPanelWidthIXP.VrAppPanelCurvature
	})(v30)
end

return v30
