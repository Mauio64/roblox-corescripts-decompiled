local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")

local withStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Style.withStyle

local LoadingAvatar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLoading/LoadingAvatar")
local TextPlaceholders = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLoading/TextPlaceholders")

local extended = Roact.PureComponent:extend("ChatLoadingIndicator")
extended.defaultProps = { cellHeight = 64, avatarCellWidth = 60 }

function extended:init()
	function self.singleConversationPlaceholder(p2, p3)
		return withStyle(function(p4)
			return Roact.createElement("Frame", {
				LayoutOrder = p2,
				Size = UDim2.new(1, 0, 0, self.props.cellHeight),
				BackgroundTransparency = p4.Tokens.Color.None.Transparency,
				BackgroundColor3 = p4.Theme.BackgroundDefault.Color,
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
					{
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 1, -1),
						BackgroundTransparency = 1
					},
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
				bottomLineContainer = not p3 and Roact.createElement("Frame", {
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
						BackgroundColor3 = p4.Theme.Divider.Color,
						Transparency = p4.Theme.Divider.Transparency,
						Size = UDim2.new(1, 0, 1, 0),
						BorderSizePixel = 0
					})
				})
			})
		end)
	end

	function self.allConversationPlaceholdersList()
		local v5 = {
			UIList = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			})
		}

		table.insert(v5, self.singleConversationPlaceholder(1, false))
		table.insert(v5, self.singleConversationPlaceholder(2, false))
		table.insert(v5, self.singleConversationPlaceholder(3, true))

		return v5
	end
end

function extended.render(p2)
	local pageBackgroundTransparency = p2.props.pageBackgroundTransparency
	return withStyle(function(p3)
		local createElement = Roact.createElement
		local v6 = {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = p3.Theme.BackgroundDefault.Color,
			BackgroundTransparency = 0,
			BorderSizePixel = 0
		}
		local v7 = if pageBackgroundTransparency == nil then p3.Tokens.Color.None.Transparency else pageBackgroundTransparency
		v6.BackgroundTransparency = v7
		return createElement("Frame", v6, p2.allConversationPlaceholdersList())
	end)
end

return extended
