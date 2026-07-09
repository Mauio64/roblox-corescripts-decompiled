local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local UIBlox = require(AppChatParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local BaseCell = require(AppChat.Components.Cells.BaseCell)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local Foundation = require(AppChatParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local t1 = {
	bodyText = "Placeholder body",
	iconImage = nil,
	iconCellWidth = 30,
	cellHeight = 28,
	iconSize = IconSize.Small,
	onIconActivated = function() -- line: 37
	end
}

local function ConversationTypeCell(t2: {[any]: any}) -- line: 42
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), useTokens (copy), useIsInExperience (copy), React (copy), BaseCell (copy), Foundation (copy), IconButton (copy)
	local v16 = Cryo.Dictionary.join(t1, t2)
	local v17 = useStyle()
	local v18 = v16.style or v17
	local Theme = v18.Theme
	local Size_300 = v18.Tokens.Size.Size_300
	local v21 = useTokens()
	local v22 = useIsInExperience()
	local v23, v24 = React.useBinding(0)
	local v25 = React.useCallback(function(p1) -- line: 51
		-- upvalues: v24 (copy)
		v24(p1.AbsoluteSize.X)
	end, {})

	return React.createElement(BaseCell, {
		Selectable = false,
		isDisabled = true,
		showDivider = false,
		Size = UDim2.new(1, 0, 0, v16.cellHeight),
		BackgroundColor3 = if not v22 then Theme.BackgroundDefault.Color else v21.Color.None.Color3,
		BackgroundTransparency = if not v22 then v18.Theme.BackgroundDefault.Transparency else v21.Color.None.Transparency,
		LayoutOrder = v16.layoutOrder,
		dividerColor3 = Theme.Divider.Color,
		dividerTransparency = Theme.Divider.Transparency
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, Size_300),
			PaddingRight = UDim.new(0, Size_300)
		}),
		Content = React.createElement(Foundation.View, {
			tag = "row size-full align-y-center",
			onAbsoluteSizeChanged = v25
		}, {
			Text = React.createElement(Foundation.Text, {
				LayoutOrder = 1,
				tag = "size-0-full auto-x content-emphasis text-align-x-left text-title-large text-truncate-end",
				Text = v16.bodyText,
				sizeConstraint = {
					MaxSize = v23:map(function(n1: number) -- line: 80
						-- upvalues: v16 (copy)
						local v28 = n1 - v16.iconCellWidth

						return Vector2.new(not (v28 > 0) and 1e999 or v28, 1e999)
					end)
				}
			}),
			InfoIcon = React.createElement(IconButton, {
				backgroundTransparency = 1,
				layoutOrder = 2,
				icon = v16.iconImage,
				iconColor3 = Theme.IconDefault.Color,
				iconSize = v16.iconSize,
				iconTransparency = Theme.IconDefault.Transparency,
				size = UDim2.fromOffset(v16.iconCellWidth, v16.iconCellWidth),
				onActivated = v16.onIconActivated
			})
		})
	})
end

return ConversationTypeCell
