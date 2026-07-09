local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local VerticalEfficiencyExperimentation = require(CorePackages.Workspace.Packages.DiscoveryUtils).VerticalEfficiencyExperimentation
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v8 = UIBlox.App.ImageSet.Images["icons/logo/letterform"]
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local getIconButtonSize = require(Modules.LuaApp.Components.TopBar.Utils.getIconButtonSize)
local HomeUserInfoWidget = require(Modules.LuaApp.Components.Home.HomeUserInfoWidget)
local FFlagLuaAppMoveProfileIntoTopBarIXP = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppMoveProfileIntoTopBarIXP
local v13 = game:DefineFastFlag("LuaAppEnableLogoHeaderByDefault", false)

return function(t1: {[any]: any}) -- line: 33
	-- upvalues: useStyle (copy), getIconButtonSize (copy), FFlagLuaAppMoveProfileIntoTopBarIXP (copy), VerticalEfficiencyExperimentation (copy), v13 (copy), React (copy), HomeUserInfoWidget (copy), ImageSetLabel (copy), v8 (copy), StyledTextLabel (copy)
	local v15 = useStyle()
	local Theme = v15.Theme
	local Font = v15.Font
	local v18 = getIconButtonSize(t1.formFactor)
	local v19 = FFlagLuaAppMoveProfileIntoTopBarIXP and VerticalEfficiencyExperimentation.getIsRobloxLogoHeaderEnabled() or v13
	local v20 = v18 - v15.Tokens.Size.Size_200

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Size = UDim2.new(0, v18, 1, 0)
	}, {
		HorizontalLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v15.Tokens.Size.Size_300)
		}),
		UserAvatar = React.createElement(HomeUserInfoWidget, {
			sideMargin = 0,
			shouldOnlyDisplayAvatarIcon = true,
			onlyAvatarButtonRef = t1.buttonRef
		}),
		LeftHeader = if not v19 then t1.titleText and React.createElement(StyledTextLabel, {
			fluidSizing = true,
			layoutOrder = 2,
			text = t1.titleText,
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Left,
			fontStyle = Font.Title,
			colorStyle = Theme.TextEmphasis
		}) or nil else React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			ImageTransparency = 0,
			AnchorPoint = Vector2.new(0, 0.5),
			Image = v8,
			ImageColor3 = Theme.TextEmphasis.Color,
			Position = UDim2.fromOffset(24, 24),
			Size = UDim2.fromOffset(v20 * 5.222222222222222, v20)
		})
	})
end
