local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local UIBlox = require(CorePackages.Packages.UIBlox)

local useStyle = UIBlox.Core.Style.useStyle

local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

local focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider

local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local parent = script.Parent.Parent
local Colors = require(parent.Colors)
local OverlayComponents = require(parent.Components.OverlayComponents)

local function selectOverlayComponent(p)
	return OverlayComponents[p.overlay.overlay]
end

local function selectOverlayProps(p)
	return p.overlay.overlayProps
end

local function Overlay(_)
	local v = useSelector(selectOverlayComponent)
	local v2 = useSelector(selectOverlayProps)
	local v3 = useStyle()

	return React.createElement(
		ReactFocusNavigation.FocusNavigationContext.Provider,
		{ value = focusNavigationService },
		{
			FocusNavigationRegistryProvider = React.createElement(Provider, nil, {
				FocusNavigationCoreScriptsWrapper = React.createElement(
					FocusRoot,
					{
						surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
						isIsolated = true,
						isAutoFocusRoot = true
					},
					{
						OverlayContainer = React.createElement("Frame", {
							BackgroundTransparency = v3.Tokens.Color.Common.Scrim.Transparency,
							BackgroundColor3 = Colors.Black,
							BorderSizePixel = 0,
							Size = UDim2.fromScale(1, 1),
							Visible = v ~= nil
						}, {
							Overlay = v and React.createElement(v, v2) or nil
						})
					}
				)
			})
		}
	)
end

return Overlay
