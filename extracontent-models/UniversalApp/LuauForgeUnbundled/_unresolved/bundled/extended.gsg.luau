local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ego")
local module2 = require("@luauforge/bundled/egM")
local module3 = require("@luauforge/bundled/egF")
local module4 = require("@luauforge/bundled/gsh")
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle

local center = Enum.HorizontalAlignment.Center
local sourceSans = Enum.Font.SourceSans

local rect = Rect.new(8, 8, 9, 9)

local extended = module.PureComponent:extend("GenericIconTextButton")

extended.defaultProps = {
	AnchorPoint = Vector2.new(0, 0),
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 1, 0),
	LayoutOrder = 1,
	iconRightPadding = 3,
	iconSize = UDim2.new(0, 16, 0, 16),
	horizontalAlignment = center,
	setIconTransparencyEnabled = false,
	iconTransparency = 0,
	leftIconEnabled = false,
	Font = sourceSans,
	TextSize = 20,
	Text = "",
	isDisabled = false,
	isLoading = false
}

function extended:init()
	self.state = { isButtonPressed = false }

	function self.onInputBegan()
		self:setState({ isButtonPressed = true })
	end

	function self.onInputEnded()
		self:setState({ isButtonPressed = false })
	end
end

local function getCombinedTransparency(p2, p3)
	return 1 - (1 - p2) * (1 - p3)
end

function extended.render(data)
	local themeSettings = data.props.themeSettings
	local size = data.props.Size
	local text = data.props.Text
	local font = data.props.Font
	local textSize = data.props.TextSize
	local buttonRef = data.props.buttonRef
	local layoutOrder = data.props.LayoutOrder
	local iconImage = data.props.iconImage
	local iconSize = data.props.iconSize
	local onActivated = data.props.onActivated
	local isDisabled = data.props.isDisabled
	local isLoading = data.props.isLoading
	local v5 = not isLoading
	local v6 = themeSettings.Border.Hidden == false
	local iconRightPadding = data.props.iconRightPadding
	local isButtonPressed = data.state.isButtonPressed
	local horizontalAlignment = data.props.horizontalAlignment
	local leftIconEnabled = data.props.leftIconEnabled

	local v7 = themeSettings.Color
	local v8 = 0

	if isLoading or isDisabled then
		v7 = themeSettings.DisabledColor
		v8 = themeSettings.DisabledTransparency
	elseif isButtonPressed then
		v7 = themeSettings.OnPressColor
		v8 = themeSettings.OnPressTransparency
	end

	local nextSelectionDown = data.props.NextSelectionDown
	local nextSelectionLeft = data.props.NextSelectionLeft
	local nextSelectionRight = data.props.NextSelectionRight
	local nextSelectionUp = data.props.NextSelectionUp

	local transparency = themeSettings.Transparency
	local v9 = 1 - (1 - v8) * (1 - transparency)
	local v10

	if v6 then
		local transparency2 = themeSettings.Border.Transparency
		v10 = 1 - (1 - v8) * (1 - transparency2) or 1
	else
		v10 = 1
	end

	return withStyle(function(p2)
		local createElement = module.createElement
		local v12 = {
			Size = size,
			LayoutOrder = layoutOrder,
			BackgroundTransparency = 1,
			Image = "LuaApp/buttons/buttonFill",
			ImageColor3 = v7 or p2.Theme.SystemPrimaryDefault.Color,
			ImageTransparency = v9 or p2.Theme.SystemPrimaryDefault.Transparency,
			BorderSizePixel = 0,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 9, 9),
			NextSelectionDown = nextSelectionDown,
			NextSelectionLeft = nextSelectionLeft,
			NextSelectionRight = nextSelectionRight,
			NextSelectionUp = nextSelectionUp,
			ClipsDescendants = false,
			[module.Event.Activated] = v5 and onActivated or nil,
			[module.Event.InputBegan] = data.onInputBegan,
			[module.Event.InputEnded] = data.onInputEnded,
			[module.Ref] = buttonRef
		}
		local v13 = {
			Border = module.createElement(module3, {
				Size = UDim2.new(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				ImageTransparency = v10,
				ImageColor3 = themeSettings.Border.Color,
				Image = "LuaApp/buttons/buttonStroke",
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = rect
			}),
			AlignmentContainer = 0,
			ShimmerAnimation = 0
		}

		local createElement2 = module.createElement
		local v15 = {
			BackgroundTransparency = 1,
			Size = size,
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}
		local v16 = {
			Layout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = horizontalAlignment,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			LeftIcon = 0,
			Text = 0
		}

		local v17 = leftIconEnabled

		if v17 then
			v17 = module.createElement(module3, {
				Size = iconSize,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Image = iconImage,
				ImageTransparency = p2.Theme.IconEmphasis.Transparency,
				ImageColor3 = p2.Theme.IconEmphasis.Color,
				LayoutOrder = 1,
				ScaleType = Enum.ScaleType.Fit,
				[module.Children] = {
					UIPadding = module.createElement("UIPadding", {
						PaddingRight = UDim.new(0, iconRightPadding)
					})
				}
			})
		end

		v16.LeftIcon = v17

		v16.Text = module.createElement("TextLabel", {
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.X,
			Text = text,
			Font = font,
			TextSize = textSize,
			TextColor3 = themeSettings.Text.Color or p2.Theme.SystemPrimaryContent.Color,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundTransparency = 1
		})
		v13.AlignmentContainer = createElement2("Frame", v15, v16)

		v13.ShimmerAnimation = isLoading
			and module.createElement(module4, {
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				shimmerSpeed = 1.5
			})
		return createElement(module2, v12, v13)
	end)
end

return extended
