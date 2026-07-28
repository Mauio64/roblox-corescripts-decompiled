local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local v6 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local ParentParent = script.Parent.Parent
local Colors = require(ParentParent.Colors)
local OverlayComponents = require(ParentParent.Components.OverlayComponents)

local function selectOverlayComponent(p1) -- line: 31
	-- upvalues: OverlayComponents (copy)
	return OverlayComponents[p1.overlay.overlay]
end
local function selectOverlayProps(p2) -- line: 35
	return p2.overlay.overlayProps
end
local function Overlay(_) -- line: 39
	-- upvalues: useSelector (copy), selectOverlayComponent (copy), selectOverlayProps (copy), useStyle (copy), React (copy), ReactFocusNavigation (copy), v6 (copy), Provider (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), Colors (copy)
	local v20 = useSelector(selectOverlayComponent)
	local v21 = useSelector(selectOverlayProps)
	local v22 = useStyle()

	return React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
		value = v6
	}, {
		FocusNavigationRegistryProvider = React.createElement(Provider, nil, {
			FocusNavigationCoreScriptsWrapper = React.createElement(FocusRoot, {
				isIsolated = true,
				isAutoFocusRoot = true,
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
			}, {
				OverlayContainer = React.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundTransparency = v22.Tokens.Color.Common.Scrim.Transparency,
					BackgroundColor3 = Colors.Black,
					Size = UDim2.fromScale(1, 1),
					Visible = v20 ~= nil
				}, {
					Overlay = v20 and React.createElement(v20, v21) or nil
				})
			})
		})
	})
end

return Overlay
