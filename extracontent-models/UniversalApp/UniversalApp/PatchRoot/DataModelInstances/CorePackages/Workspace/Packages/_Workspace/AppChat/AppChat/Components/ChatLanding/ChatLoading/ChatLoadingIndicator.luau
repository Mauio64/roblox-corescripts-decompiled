local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local withStyle = require(Parent.UIBlox).Style.withStyle
local LoadingAvatar = require(script.Parent.LoadingAvatar)
local TextPlaceholders = require(script.Parent.TextPlaceholders)
local v6 = Roact.PureComponent:extend("ChatLoadingIndicator")

v6.defaultProps = {
	cellHeight = 64,
	avatarCellWidth = 60
}

function v6.init(p1) -- line: 19
	-- upvalues: withStyle (copy), Roact (copy), LoadingAvatar (copy), TextPlaceholders (copy)
	function p1.singleConversationPlaceholder(p2, p3) -- line: 20
		-- upvalues: withStyle (copy), Roact (copy), p1 (copy), LoadingAvatar (copy), TextPlaceholders (copy)
		return withStyle(function(p4) -- line: 21
			-- upvalues: Roact (copy), p2 (copy), p1 (copy), LoadingAvatar (copy), TextPlaceholders (copy), p3 (copy)
			return Roact.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = p2,
				Size = UDim2.new(1, 0, 0, p1.props.cellHeight),
				BackgroundTransparency = p4.Tokens.Color.None.Transparency,
				BackgroundColor3 = p4.Theme.BackgroundDefault.Color
			}, {
				UIList = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 0),
					PaddingTop = UDim.new(0, 4)
				}),
				Content = Roact.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, -1)
				}, {
					UIList = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal
					}),
					avatar = Roact.createElement(LoadingAvatar, {
						LayoutOrder = 1,
						avatarImage = p1.props.avatarImage,
						cellWidth = p1.props.avatarCellWidth,
						cellHeight = p1.props.cellHeight
					}),
					textPlaceholders = Roact.createElement(TextPlaceholders, {
						LayoutOrder = 2,
						avatarCellWidth = p1.props.avatarCellWidth
					})
				}),
				bottomLineContainer = not p3 and Roact.createElement("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					ZIndex = 2,
					ClipsDescendants = true,
					Size = UDim2.new(1, 0, 0, 1)
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, p1.props.avatarCellWidth)
					}),
					bottomLine = Roact.createElement("Frame", {
						BorderSizePixel = 0,
						BackgroundColor3 = p4.Theme.Divider.Color,
						Transparency = p4.Theme.Divider.Transparency,
						Size = UDim2.new(1, 0, 1, 0)
					})
				})
			})
		end)
	end
	function p1.allConversationPlaceholdersList() -- line: 78
		-- upvalues: Roact (copy), p1 (copy)
		local t1 = {
			UIList = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			})
		}

		table.insert(t1, p1.singleConversationPlaceholder(1, false))
		table.insert(t1, p1.singleConversationPlaceholder(2, false))
		table.insert(t1, p1.singleConversationPlaceholder(3, true))

		return t1
	end
end
function v6.render(p5) -- line: 92
	-- upvalues: withStyle (copy), Roact (copy)
	return withStyle(function(p6) -- line: 93
		-- upvalues: Roact (copy), p5 (copy)
		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = p6.Theme.BackgroundDefault.Color,
			BackgroundTransparency = p6.Tokens.Color.None.Transparency
		}, p5.allConversationPlaceholdersList())
	end)
end

return v6
