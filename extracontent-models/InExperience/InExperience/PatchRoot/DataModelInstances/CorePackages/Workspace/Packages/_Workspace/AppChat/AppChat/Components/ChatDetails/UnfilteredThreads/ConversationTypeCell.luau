local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)
local Cryo = require(parent.Cryo)
local React = require(parent.React)

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize

local BaseCell = require(AppChat.Components.Cells.BaseCell)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local v = {
	bodyText = "Placeholder body",
	iconImage = nil,
	iconSize = IconSize.Small,
	iconCellWidth = 30,
	shouldShowIcon = true,
	cellHeight = 28,
	onIconActivated = function() end
}

local function ConversationTypeCell(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useStyle()
	local style = joined.style or v2
	local theme = style.Theme
	local size_300 = style.Tokens.Size.Size_300
	local v3 = useTokens()
	local v4 = useIsInExperience()
	local v5, v6 = React.useBinding(0)
	local onAbsoluteSizeChanged = React.useCallback(function(p2)
		v6(p2.AbsoluteSize.X)
	end, {})

	local createElement = React.createElement
	local v7 = {
		Size = UDim2.new(1, 0, 0, joined.cellHeight),
		BackgroundColor3 = 0,
		BackgroundTransparency = 0,
		LayoutOrder = 0,
		Selectable = false,
		dividerColor3 = 0,
		dividerTransparency = 0,
		isDisabled = true,
		showDivider = false
	}
	local backgroundColor

	if v4 then
		backgroundColor = v3.Color.None.Color3
	else
		backgroundColor = theme.BackgroundDefault.Color
	end

	v7.BackgroundColor3 = backgroundColor
	local backgroundTransparency

	if v4 then
		backgroundTransparency = v3.Color.None.Transparency
	else
		backgroundTransparency = style.Theme.BackgroundDefault.Transparency
	end

	v7.BackgroundTransparency = backgroundTransparency

	v7.LayoutOrder = joined.layoutOrder

	v7.dividerColor3 = theme.Divider.Color
	v7.dividerTransparency = theme.Divider.Transparency

	local v8 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, size_300),
			PaddingRight = UDim.new(0, size_300)
		}),
		Content = 0
	}

	local createElement2 = React.createElement
	local view = Foundation.View

	local v9 = {
		Text = React.createElement(Foundation.Text, {
			LayoutOrder = 1,
			Text = joined.bodyText,
			sizeConstraint = {
				MaxSize = v5:map(function(p2: number)
					local v9 = p2 - (not joined.shouldShowIcon and 0 or joined.iconCellWidth)
					return Vector2.new(not (v9 > 0) and 1e999 or v9, 1e999)
				end)
			},
			tag = "size-0-full auto-x content-emphasis text-align-x-left text-title-large text-truncate-end"
		}),
		InfoIcon = 0
	}
	local infoIcon

	if joined.shouldShowIcon then
		infoIcon = React.createElement(IconButton, {
			backgroundTransparency = 1,
			icon = joined.iconImage,
			iconColor3 = theme.IconDefault.Color,
			iconSize = joined.iconSize,
			iconTransparency = theme.IconDefault.Transparency,
			layoutOrder = 2,
			size = UDim2.fromOffset(joined.iconCellWidth, joined.iconCellWidth),
			onActivated = joined.onIconActivated
		})
	end

	v9.InfoIcon = infoIcon
	v8.Content = createElement2(
		view,
		{ tag = "row size-full align-y-center", onAbsoluteSizeChanged = onAbsoluteSizeChanged },
		v9
	)
	return createElement(BaseCell, v7, v8)
end

return ConversationTypeCell
