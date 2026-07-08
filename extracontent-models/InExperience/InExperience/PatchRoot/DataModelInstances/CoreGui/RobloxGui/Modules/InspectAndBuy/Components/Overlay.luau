local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useStyle = UIBlox.Core.Style.useStyle
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local v8 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local ParentParent = script.Parent.Parent
local Colors = require(ParentParent.Colors)
local OverlayComponents = require(ParentParent.Components.OverlayComponents)

local function selectOverlayComponent(p1) -- line: 33
	-- upvalues: OverlayComponents (copy)
	return OverlayComponents[p1.overlay.overlay]
end
local function selectOverlayProps(p2) -- line: 37
	return p2.overlay.overlayProps
end
local function Overlay(_) -- line: 41
	-- upvalues: useSelector (copy), selectOverlayComponent (copy), selectOverlayProps (copy), useStyle (copy), React (copy), ReactFocusNavigation (copy), v8 (copy), Provider (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Colors (copy)
	local v22 = useSelector(selectOverlayComponent)
	local v23 = useSelector(selectOverlayProps)
	local v24 = useStyle()

	return React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
		value = v8
	}, {
		FocusNavigationRegistryProvider = React.createElement(Provider, nil, {
			FocusNavigationCoreScriptsWrapper = React.createElement(FocusRoot, {
				isIsolated = true,
				isAutoFocusRoot = true,
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
			}, {
				OverlayContainer = React.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then v24.Tokens.Semantic.Color.Common.Overlay else v24.Tokens.Color.Common.Scrim)).Transparency,
					BackgroundColor3 = Colors.Black,
					Size = UDim2.fromScale(1, 1),
					Visible = v22 ~= nil
				}, {
					Overlay = v22 and React.createElement(v22, v23) or nil
				})
			})
		})
	})
end

return Overlay
