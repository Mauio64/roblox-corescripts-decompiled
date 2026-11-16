local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ecR")
local module2 = require("@luauforge/bundled/edp")
local module3 = require("@luauforge/bundled/edi")
local module4 = require("@luauforge/bundled/fNM")
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local module5 = require("@luauforge/bundled/fNO")

local rect = Rect.new(8, 8, 9, 9)

local rect2 = Rect.new(8, 8, 9, 9)

local extended = module.PureComponent:extend("GenericIconButton")

extended.defaultProps = {
	AnchorPoint = Vector2.new(0, 0),
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 1, 0),
	LayoutOrder = 1,
	isDisabled = false,
	isChecked = false,
	isLoading = false,
	iconComponent = module3
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

function extended.render(data)
	local iconButton = data.props.appTheme.IconButton
	local anchorPoint = data.props.AnchorPoint
	local size = data.props.Size
	local buttonRef = data.props.buttonRef
	local position = data.props.Position
	local layoutOrder = data.props.LayoutOrder
	local iconImage = data.props.iconImage
	local iconSize = data.props.iconSize
	local onActivated = data.props.onActivated
	local isDisabled = data.props.isDisabled
	local v5 = data.props.isChecked
	local v6 = data.props.isLoading
	local v7 = not v6

	local v8 = data.state.isButtonPressed

	local v9 = iconButton.Border.Off
	local v10 = iconButton.Fill.Off
	local v11 = iconButton.Icon.Off

	local withNewThemeProvider = data.props.withNewThemeProvider

	return withStyle(function(p2)
		if isDisabled then
			v9 = iconButton.Border.Disabled
			v10 = iconButton.Fill.Disabled
			v11 = iconButton.Icon.Disabled
			v8 = false
			v5 = false
			v6 = false
		end

		if v5 then
			v9 = iconButton.Border.On
			v10 = iconButton.Fill.On
			v11 = iconButton.Icon.On
		end

		if v6 then
			v9 = iconButton.Border.Loading
			v10 = iconButton.Fill.Loading
			v11 = iconButton.Icon.Loading
		end

		if v8 and v7 then
			v9 = iconButton.Border.OnPress
			v10 = iconButton.Fill.OnPress
			v11 = iconButton.Icon.OnPress
		end

		if withNewThemeProvider then
			v10.Transparency = 1
			v9.Color = p2.Theme.SecondaryDefault.Color
			v11.Color = p2.Theme.SecondaryDefault.Color

			if v5 then
				v11.Color = p2.Theme.ContextualPrimaryDefault.Color
			end

			if v8 and v7 then
				v11.Color = p2.Theme.ContextualPrimaryDefault.Color
			end
		end

		local v12 = module3

		if data.props.iconComponent then
			v12 = data.props.iconComponent
		end

		return module.createElement(module2, {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			AnchorPoint = anchorPoint,
			Size = size,
			Position = position,
			Image = "LuaApp/buttons/buttonFill",
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = rect2,
			ImageTransparency = v10.Transparency,
			ImageColor3 = v10.Color,
			LayoutOrder = layoutOrder,
			ClipsDescendants = false,
			[module.Event.Activated] = v7 and onActivated or nil,
			[module.Event.InputBegan] = data.onInputBegan,
			[module.Event.InputEnded] = data.onInputEnded,
			[module.Ref] = buttonRef
		}, {
			Border = module.createElement(module3, {
				Size = UDim2.new(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				ImageTransparency = v9.Transparency,
				ImageColor3 = v9.Color,
				Image = "LuaApp/buttons/buttonStroke",
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = rect
			}, {
				Icon = module.createElement(v12, {
					Size = iconSize,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Image = iconImage,
					ImageTransparency = v11.Transparency,
					ImageColor3 = v11.Color
				})
			}),
			ShimmerAnimation = v6 and module.createElement(module4, {
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				shimmerSpeed = 1.5
			})
		})
	end)
end

return (module5(extended))
