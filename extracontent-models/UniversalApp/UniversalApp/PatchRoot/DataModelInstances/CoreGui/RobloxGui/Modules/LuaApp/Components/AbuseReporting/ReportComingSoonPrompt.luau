local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local VrCompatibility = require(CorePackages.Workspace.Packages.VrCompatibility)
local VRConstants = VrCompatibility.VRConstants
local VRPanelWidthIXP = VrCompatibility.VRPanelWidthIXP
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local Style = require(CorePackages.Workspace.Packages.Style)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local FullPageModal = UIBlox.App.Dialog.Modal.FullPageModal
local useDesignTokens = Style.useDesignTokens
local mapTypographyVariantToFontEnum = Style.mapTypographyVariantToFontEnum
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagVRPanelWidthIXPEnabled = SharedFlags.GetFFlagVRPanelWidthIXPEnabled
local FFlagLuaAppForceVrAppPanelWidthRollout = SharedFlags.FFlagLuaAppForceVrAppPanelWidthRollout

return function(t1: {[any]: any}) -- line: 26
	-- upvalues: useDesignTokens (copy), ArgCheck (copy), FFlagLuaAppForceVrAppPanelWidthRollout (copy), GetFFlagVRPanelWidthIXPEnabled (copy), IxpUtils (copy), VRPanelWidthIXP (copy), React (copy), FullPageModal (copy), VRConstants (copy), mapTypographyVariantToFontEnum (copy)
	local v17 = useDesignTokens()

	ArgCheck.assert(false, "Report Dialog's title and body text have not been localized. This needs to be addressed before this feature is released.")

	local v18 = if FFlagLuaAppForceVrAppPanelWidthRollout or not GetFFlagVRPanelWidthIXPEnabled() then nil else IxpUtils.useTestVariables(VRPanelWidthIXP.VrAppPanelWidthMultiplier)

	return React.createElement(FullPageModal, {
		title = "Reporting Coming Soon",
		onCloseClicked = t1.onClose,
		screenSize = if FFlagLuaAppForceVrAppPanelWidthRollout or not v18 then VRConstants.MainScreenResolution else Vector2.new(VRConstants.MainScreenResolution.X * v18, VRConstants.MainScreenResolution.Y)
	}, {
		Texts = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 15)
			}),
			PrimaryText = React.createElement("TextLabel", {
				Text = "Reporting is coming soon to this platform.",
				LayoutOrder = 1,
				TextWrapped = true,
				BackgroundTransparency = 1,
				Font = mapTypographyVariantToFontEnum(v17.Typography.TitleLarge),
				TextColor3 = v17.Color.Content.Emphasis.Color3,
				TextTransparency = v17.Color.Content.Emphasis.Transparency,
				TextSize = v17.Typography.TitleLarge.FontSize,
				TextXAlignment = Enum.TextXAlignment.Center,
				Size = UDim2.new(1, 0, 0, v17.Typography.TitleLarge.FontSize)
			})
		})
	})
end
