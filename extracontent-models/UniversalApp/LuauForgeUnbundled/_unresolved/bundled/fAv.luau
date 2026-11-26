local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local verticalEfficiencyExperimentation = require("@luauforge/bundled/egz").VerticalEfficiencyExperimentation

local UIBlox = require(CorePackages.Packages.UIBlox)

local useStyle = UIBlox.Core.Style.useStyle
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images

local vector2 = Vector2.new(114, 30)

local module = require("@luauforge/bundled/fAw")
local module2 = require("@luauforge/bundled/fAx")

local fFlagLuaAppMoveProfileIntoTopBarIXP = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppMoveProfileIntoTopBarIXP
local defineFastFlag = game:DefineFastFlag("LuaAppEnableLogoHeaderByDefault", false)

return function(props)
	local v5 = useStyle()

	local theme = v5.Theme
	local font = v5.Font

	local v6 = module(props.formFactor)

	local v7 = fFlagLuaAppMoveProfileIntoTopBarIXP
		and verticalEfficiencyExperimentation.getIsRobloxLogoHeaderEnabled()
		or defineFastFlag

	local v8 = v6 - v5.Tokens.Size.Size_200
	local v9 = if props.isClassicTheme then vector2 else Vector2.new(v8 * (47 / 9), v8)
	local v10 = props.isClassicTheme and "icons/logo/letterform_classic" or "icons/logo/letterform"

	local createElement = React.createElement
	local v12 = {
		Size = UDim2.new(0, v6, 1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}

	local v13 = {
		HorizontalLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v5.Tokens.Size.Size_300)
		}),
		UserAvatar = React.createElement(module2, {
			sideMargin = 0,
			shouldOnlyDisplayAvatarIcon = true,
			onlyAvatarButtonRef = props.buttonRef
		}),
		LeftHeader = 0
	}
	local v14

	if v7 then
		local createElement2 = React.createElement
		local v16 = {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Image = images[v10],
			ImageColor3 = 0,
			ImageTransparency = 0,
			Position = 0,
			Size = 0
		}
		local v17 = if props.isClassicTheme then Color3.new(1, 1, 1) else theme.TextEmphasis.Color
		v16.ImageColor3 = v17

		v16.Position = UDim2.fromOffset(24, 24)
		v16.Size = UDim2.fromOffset(v9.X, v9.Y)
		v14 = createElement2(imageSetLabel, v16)
	else
		v14 = props.titleText and React.createElement(styledTextLabel, {
			fluidSizing = true,
			text = props.titleText,
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Left,
			fontStyle = font.Title,
			colorStyle = theme.TextEmphasis,
			layoutOrder = 2
		}) or nil
	end

	v13.LeftHeader = v14
	return createElement("Frame", v12, v13)
end
