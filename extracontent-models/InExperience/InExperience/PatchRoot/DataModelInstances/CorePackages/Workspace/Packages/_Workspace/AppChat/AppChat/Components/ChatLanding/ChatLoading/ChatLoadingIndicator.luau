local parent = script:FindFirstAncestor("AppChat").Parent

local Roact = require(parent.Roact)

local UIBlox = require(parent.UIBlox)
local withStyle = UIBlox.Style.withStyle

local LoadingAvatar = require(script.Parent.LoadingAvatar)
local TextPlaceholders = require(script.Parent.TextPlaceholders)

local extended = Roact.PureComponent:extend("ChatLoadingIndicator")
extended.defaultProps = { cellHeight = 64, avatarCellWidth = 60 }

function extended:init()
	function self.singleConversationPlaceholder(layoutOrder, p)
		return withStyle(function(p2)
			return Roact.createElement("Frame", {
				LayoutOrder = layoutOrder,
				Size = UDim2.new(1, 0, 0, self.props.cellHeight),
				BackgroundTransparency = p2.Tokens.Color.None.Transparency,
				BackgroundColor3 = p2.Theme.BackgroundDefault.Color,
				BorderSizePixel = 0
			}, {
				UIList = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 0),
					PaddingTop = UDim.new(0, 4)
				}),
				Content = Roact.createElement(
					"Frame",
					{ LayoutOrder = 1, Size = UDim2.new(1, 0, 1, -1), BackgroundTransparency = 1 },
					{
						UIList = Roact.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Horizontal
						}),
						avatar = Roact.createElement(LoadingAvatar, {
							avatarImage = self.props.avatarImage,
							cellWidth = self.props.avatarCellWidth,
							cellHeight = self.props.cellHeight,
							LayoutOrder = 1
						}),
						textPlaceholders = Roact.createElement(TextPlaceholders, {
							avatarCellWidth = self.props.avatarCellWidth,
							LayoutOrder = 2
						})
					}
				),
				bottomLineContainer = not p and Roact.createElement("Frame", {
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundTransparency = 1,
					ZIndex = 2,
					ClipsDescendants = true
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, self.props.avatarCellWidth)
					}),
					bottomLine = Roact.createElement("Frame", {
						BackgroundColor3 = p2.Theme.Divider.Color,
						Transparency = p2.Theme.Divider.Transparency,
						Size = UDim2.new(1, 0, 1, 0),
						BorderSizePixel = 0
					})
				})
			})
		end)
	end

	function self.allConversationPlaceholdersList()
		local v = {
			UIList = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			})
		}

		table.insert(v, self.singleConversationPlaceholder(1, false))
		table.insert(v, self.singleConversationPlaceholder(2, false))
		table.insert(v, self.singleConversationPlaceholder(3, true))

		return v
	end
end

function extended.render(p)
	local pageBackgroundTransparency = p.props.pageBackgroundTransparency
	return withStyle(function(p2)
		local createElement = Roact.createElement
		local v = {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = p2.Theme.BackgroundDefault.Color,
			BackgroundTransparency = 0,
			BorderSizePixel = 0
		}
		local backgroundTransparency

		if pageBackgroundTransparency == nil then
			backgroundTransparency = p2.Tokens.Color.None.Transparency
		else
			backgroundTransparency = pageBackgroundTransparency
		end

		v.BackgroundTransparency = backgroundTransparency
		return createElement("Frame", v, p.allConversationPlaceholdersList())
	end)
end

return extended
