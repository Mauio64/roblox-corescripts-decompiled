require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize

local BaseCell = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells/BaseCell")
local useIsInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsInExperience")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local useTokens = Foundation.Hooks.useTokens

local v5 = {
	bodyText = "Placeholder body",
	iconImage = nil,
	iconSize = iconSize.Small,
	iconCellWidth = 30,
	shouldShowIcon = true,
	cellHeight = 28,
	onIconActivated = function() end
}

local function ConversationTypeCell(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useStyle()
	local style = joined.style or v6
	local theme = style.Theme
	local size_300 = style.Tokens.Size.Size_300
	local v7 = useTokens()
	local v8 = useIsInExperience()
	local v9, v10 = React.useBinding(0)
	local v11 = React.useCallback(function(p3)
		v10(p3.AbsoluteSize.X)
	end, {})

	local createElement = React.createElement
	local v13 = {
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
	local v14 = if v8 then v7.Color.None.Color3 else theme.BackgroundDefault.Color
	v13.BackgroundColor3 = v14

	local v15 = if v8 then v7.Color.None.Transparency else style.Theme.BackgroundDefault.Transparency
	v13.BackgroundTransparency = v15

	v13.LayoutOrder = joined.layoutOrder

	v13.dividerColor3 = theme.Divider.Color
	v13.dividerTransparency = theme.Divider.Transparency

	local v16 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, size_300),
			PaddingRight = UDim.new(0, size_300)
		}),
		Content = 0
	}

	local createElement2 = React.createElement
	local view = Foundation.View

	local v18 = {
		Text = React.createElement(Foundation.Text, {
			LayoutOrder = 1,
			Text = joined.bodyText,
			sizeConstraint = {
				MaxSize = v9:map(function(p3)
					local v19 = p3 - (not joined.shouldShowIcon and 0 or joined.iconCellWidth)
					return Vector2.new(not (v19 > 0) and 1e999 or v19, 1e999)
				end)
			},
			tag = "size-0-full auto-x content-emphasis text-align-x-left text-title-large text-truncate-end"
		}),
		InfoIcon = 0
	}

	local v19 = if joined.shouldShowIcon then React.createElement(iconButton, {
		backgroundTransparency = 1,
		icon = joined.iconImage,
		iconColor3 = theme.IconDefault.Color,
		iconSize = joined.iconSize,
		iconTransparency = theme.IconDefault.Transparency,
		layoutOrder = 2,
		size = UDim2.fromOffset(joined.iconCellWidth, joined.iconCellWidth),
		onActivated = joined.onIconActivated
	}) else nil
	v18.InfoIcon = v19
	v16.Content = createElement2(
		view,
		{ tag = "row size-full align-y-center", onAbsoluteSizeChanged = v11 },
		v18
	)
	return createElement(BaseCell, v13, v16)
end

return ConversationTypeCell
