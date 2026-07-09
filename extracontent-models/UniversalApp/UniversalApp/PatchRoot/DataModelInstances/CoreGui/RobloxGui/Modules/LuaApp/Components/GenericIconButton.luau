local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local DEPRECATED_ImageSetButton = require(Modules.LuaApp.Components.DEPRECATED_ImageSetButton)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local ShimmerAnimation = require(Modules.LuaApp.Components.ShimmerAnimation)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local withTheme_DEPRECATED = require(Modules.LuaApp.withTheme_DEPRECATED)
local rect = Rect.new(8, 8, 9, 9)
local rect2 = Rect.new(8, 8, 9, 9)
local v11 = Roact.PureComponent:extend("GenericIconButton")

v11.defaultProps = {
	LayoutOrder = 1,
	isDisabled = false,
	isChecked = false,
	isLoading = false,
	AnchorPoint = Vector2.new(0, 0),
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 1, 0),
	iconComponent = DEPRECATED_ImageSetLabel
}

function v11.init(p1) -- line: 29
	p1.state = {
		isButtonPressed = false
	}

	function p1.onInputBegan() -- line: 34
		-- upvalues: p1 (copy)
		p1:setState({
			isButtonPressed = true
		})
	end
	function p1.onInputEnded() -- line: 40
		-- upvalues: p1 (copy)
		p1:setState({
			isButtonPressed = false
		})
	end
end
function v11.render(p2) -- line: 47
	-- upvalues: withStyle (copy), DEPRECATED_ImageSetLabel (copy), Roact (copy), DEPRECATED_ImageSetButton (copy), rect2 (copy), rect (copy), ShimmerAnimation (copy)
	local IconButton = p2.props.appTheme.IconButton
	local propsAnchorPoint = p2.props.AnchorPoint
	local propsSize = p2.props.Size
	local buttonRef = p2.props.buttonRef
	local propsPosition = p2.props.Position
	local propsLayoutOrder = p2.props.LayoutOrder
	local iconImage = p2.props.iconImage
	local iconSize = p2.props.iconSize
	local onActivated = p2.props.onActivated
	local isDisabled = p2.props.isDisabled
	local isChecked = p2.props.isChecked
	local isLoading = p2.props.isLoading
	local v26 = not isLoading
	local isButtonPressed = p2.state.isButtonPressed
	local Off = IconButton.Border.Off
	local Off2 = IconButton.Fill.Off
	local Off3 = IconButton.Icon.Off
	local withNewThemeProvider = p2.props.withNewThemeProvider

	return withStyle(function(p3) -- line: 70
		-- upvalues: isDisabled (copy), Off (ref), IconButton (copy), Off2 (ref), Off3 (ref), isButtonPressed (ref), isChecked (ref), isLoading (ref), v26 (copy), withNewThemeProvider (copy), DEPRECATED_ImageSetLabel (copy), p2 (copy), Roact (copy), DEPRECATED_ImageSetButton (copy), propsAnchorPoint (copy), propsSize (copy), propsPosition (copy), rect2 (copy), propsLayoutOrder (copy), onActivated (copy), buttonRef (copy), rect (copy), iconSize (copy), iconImage (copy), ShimmerAnimation (copy)
		if isDisabled then
			Off = IconButton.Border.Disabled
			Off2 = IconButton.Fill.Disabled
			Off3 = IconButton.Icon.Disabled
			isButtonPressed = false
			isChecked = false
			isLoading = false
		end

		if isChecked then
			Off = IconButton.Border.On
			Off2 = IconButton.Fill.On
			Off3 = IconButton.Icon.On
		end

		if isLoading then
			Off = IconButton.Border.Loading
			Off2 = IconButton.Fill.Loading
			Off3 = IconButton.Icon.Loading
		end

		if isButtonPressed and v26 then
			Off = IconButton.Border.OnPress
			Off2 = IconButton.Fill.OnPress
			Off3 = IconButton.Icon.OnPress
		end

		if withNewThemeProvider then
			Off2.Transparency = 1
			Off.Color = p3.Theme.SecondaryDefault.Color
			Off3.Color = p3.Theme.SecondaryDefault.Color

			if isChecked then
				Off3.Color = p3.Theme.ContextualPrimaryDefault.Color
			end

			if isButtonPressed and v26 then
				Off3.Color = p3.Theme.ContextualPrimaryDefault.Color
			end
		end

		local v33 = DEPRECATED_ImageSetLabel

		if p2.props.iconComponent then
			v33 = p2.props.iconComponent
		end

		return Roact.createElement(DEPRECATED_ImageSetButton, {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			AnchorPoint = propsAnchorPoint,
			Size = propsSize,
			Position = propsPosition,
			Image = "LuaApp/buttons/buttonFill",
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = rect2,
			ImageTransparency = Off2.Transparency,
			ImageColor3 = Off2.Color,
			LayoutOrder = propsLayoutOrder,
			ClipsDescendants = false,
			[Roact.Event.Activated] = v26 and onActivated or nil,
			[Roact.Event.InputBegan] = p2.onInputBegan,
			[Roact.Event.InputEnded] = p2.onInputEnded,
			[Roact.Ref] = buttonRef
		}, {
			Border = Roact.createElement(DEPRECATED_ImageSetLabel, {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Image = "LuaApp/buttons/buttonStroke",
				Size = UDim2.new(1, 0, 1, 0),
				ImageTransparency = Off.Transparency,
				ImageColor3 = Off.Color,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = rect
			}, {
				Icon = Roact.createElement(v33, {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Size = iconSize,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Image = iconImage,
					ImageTransparency = Off3.Transparency,
					ImageColor3 = Off3.Color
				})
			}),
			ShimmerAnimation = isLoading and Roact.createElement(ShimmerAnimation, {
				shimmerSpeed = 1.5,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0)
			})
		})
	end)
end

return (withTheme_DEPRECATED(v11))
