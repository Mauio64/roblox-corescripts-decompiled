local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)

local roact = dependencies.Roact

local CallbackInputBox = require(script.Parent.CallbackInputBox)
local extended = roact.PureComponent:extend("CallbackInputBoxWithIcon")

extended.defaultProps = {
	backgroundTransparency = 0,
	backgroundColor3 = Color3.new(1, 1, 1),
	borderColor = nil,
	borderThickness = 0,
	borderTransparency = 1,
	cornerRadius = 0,
	iconCellWidth = 60,
	iconSize = 24,
	iconColor3 = Color3.new(1, 1, 1),
	iconTransparency = 0,
	iconImage = "rbxasset://textures/ui/LuaChat/icons/ic-search.png",
	inputTextFont = Enum.Font.BuilderSans,
	inputTextColor3 = Color3.new(1, 0, 1),
	inputTextSize = 14,
	inputTextYAlignment = Enum.TextYAlignment.Center,
	inputTextXAlignment = Enum.TextXAlignment.Left,
	inputTextTransparency = 0,
	placeholderTextTransparency = 0.6,
	placeholderTextColor3 = Color3.new(1, 0, 0),
	placeholderText = "Test placeholder text",
	clearIconColor3 = Color3.new(1, 1, 0),
	clearIcon = "rbxasset://textures/ui/LuaChat/icons/ic-close-white.png",
	clearButtonDisabled = nil,
	textChangedCallback = nil
}

function extended.render(p)
	local iconCellWidth = p.props.iconCellWidth
	local iconSize = p.props.iconSize

	return roact.createElement(
		"Frame",
		{
			BackgroundTransparency = p.props.backgroundTransparency,
			BackgroundColor3 = p.props.backgroundColor3,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0)
		},
		{
			UIStroke = roact.createElement("UIStroke", {
				Thickness = p.props.borderThickness,
				Color = p.props.borderColor,
				Transparency = p.props.borderTransparency
			}),
			UICorner = roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, p.props.cornerRadius)
			}),
			layout = roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, iconCellWidth / 4)
			}),
			padding = roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, iconCellWidth / 4)
			}),
			icon = roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, iconSize, 0, iconSize),
				ImageColor3 = p.props.iconColor3,
				ImageTransparency = p.props.iconTransparency,
				Image = p.props.iconImage,
				LayoutOrder = 1
			}),
			inputBoxContainer = roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -iconSize - iconCellWidth / 4, 1, 0),
				LayoutOrder = 2
			}, {
				padding = roact.createElement("UIPadding", {
					PaddingRight = UDim.new(0, iconCellWidth / 4)
				}),
				inputBox = roact.createElement(CallbackInputBox, p.props)
			})
		}
	)
end

return extended
