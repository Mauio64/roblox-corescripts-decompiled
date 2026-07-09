local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local DEPRECATED_ImageSetButton = require(Modules.LuaApp.Components.DEPRECATED_ImageSetButton)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local ShimmerAnimation = require(Modules.LuaApp.Components.ShimmerAnimation)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local Center = Enum.HorizontalAlignment.Center
local SourceSans = Enum.Font.SourceSans
local rect = Rect.new(8, 8, 9, 9)
local v11 = Roact.PureComponent:extend("GenericIconTextButton")

v11.defaultProps = {
	LayoutOrder = 1,
	iconRightPadding = 3,
	setIconTransparencyEnabled = false,
	iconTransparency = 0,
	leftIconEnabled = false,
	TextSize = 20,
	Text = "",
	isDisabled = false,
	isLoading = false,
	AnchorPoint = Vector2.new(0, 0),
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 1, 0),
	iconSize = UDim2.new(0, 16, 0, 16),
	horizontalAlignment = Center,
	Font = SourceSans
}

function v11.init(p1) -- line: 41
	p1.state = {
		isButtonPressed = false
	}

	function p1.onInputBegan() -- line: 46
		-- upvalues: p1 (copy)
		p1:setState({
			isButtonPressed = true
		})
	end
	function p1.onInputEnded() -- line: 52
		-- upvalues: p1 (copy)
		p1:setState({
			isButtonPressed = false
		})
	end
end

local function getCombinedTransparency(p2, p3) -- line: 59
	return 1 - (1 - p2) * (1 - p3)
end

function v11.render(p4) -- line: 63
	-- upvalues: withStyle (copy), Roact (copy), DEPRECATED_ImageSetButton (copy), DEPRECATED_ImageSetLabel (copy), rect (copy), ShimmerAnimation (copy)
	local themeSettings = p4.props.themeSettings
	local propsSize = p4.props.Size
	local propsText = p4.props.Text
	local propsFont = p4.props.Font
	local propsTextSize = p4.props.TextSize
	local buttonRef = p4.props.buttonRef
	local propsLayoutOrder = p4.props.LayoutOrder
	local iconImage = p4.props.iconImage
	local iconSize = p4.props.iconSize
	local onActivated = p4.props.onActivated
	local isDisabled = p4.props.isDisabled
	local isLoading = p4.props.isLoading
	local v29 = not isLoading
	local v30 = themeSettings.Border.Hidden == false
	local iconRightPadding = p4.props.iconRightPadding
	local isButtonPressed = p4.state.isButtonPressed
	local horizontalAlignment = p4.props.horizontalAlignment
	local leftIconEnabled = p4.props.leftIconEnabled
	local themeSettingsColor = themeSettings.Color
	local n1 = 0
	local g45 = nil
	local v44 = nil

	if isLoading or isDisabled then
		themeSettingsColor = themeSettings.DisabledColor
		n1 = themeSettings.DisabledTransparency
	elseif isButtonPressed then
		themeSettingsColor = themeSettings.OnPressColor
		n1 = themeSettings.OnPressTransparency
	end

	local NextSelectionDown = p4.props.NextSelectionDown
	local NextSelectionLeft = p4.props.NextSelectionLeft
	local NextSelectionRight = p4.props.NextSelectionRight
	local NextSelectionUp = p4.props.NextSelectionUp
	local themeSettingsTransparency = themeSettings.Transparency
	local v42 = 1 - (1 - n1) * (1 - themeSettingsTransparency)

	if v30 then
		local BorderTransparency = themeSettings.Border.Transparency

		v44 = 1 - (1 - n1) * (1 - BorderTransparency)

		if v44 then
			g45 = true
		end
	end

	if not g45 then
		v44 = 1
	end

	g45 = false

	local v46 = v44

	return withStyle(function(p5) -- line: 103
		-- upvalues: Roact (copy), DEPRECATED_ImageSetButton (copy), propsSize (copy), propsLayoutOrder (copy), themeSettingsColor (ref), v42 (copy), NextSelectionDown (copy), NextSelectionLeft (copy), NextSelectionRight (copy), NextSelectionUp (copy), v29 (copy), onActivated (copy), p4 (copy), buttonRef (copy), DEPRECATED_ImageSetLabel (copy), v46 (copy), themeSettings (copy), rect (copy), horizontalAlignment (copy), leftIconEnabled (copy), iconSize (copy), iconImage (copy), iconRightPadding (copy), propsText (copy), propsFont (copy), propsTextSize (copy), isLoading (copy), ShimmerAnimation (copy)
		return Roact.createElement(DEPRECATED_ImageSetButton, {
			Size = propsSize,
			LayoutOrder = propsLayoutOrder,
			BackgroundTransparency = 1,
			Image = "LuaApp/buttons/buttonFill",
			ImageColor3 = themeSettingsColor or p5.Theme.SystemPrimaryDefault.Color,
			ImageTransparency = v42 or p5.Theme.SystemPrimaryDefault.Transparency,
			BorderSizePixel = 0,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 9, 9),
			NextSelectionDown = NextSelectionDown,
			NextSelectionLeft = NextSelectionLeft,
			NextSelectionRight = NextSelectionRight,
			NextSelectionUp = NextSelectionUp,
			ClipsDescendants = false,
			[Roact.Event.Activated] = v29 and onActivated or nil,
			[Roact.Event.InputBegan] = p4.onInputBegan,
			[Roact.Event.InputEnded] = p4.onInputEnded,
			[Roact.Ref] = buttonRef
		}, {
			Border = Roact.createElement(DEPRECATED_ImageSetLabel, {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Image = "LuaApp/buttons/buttonStroke",
				Size = UDim2.new(1, 0, 1, 0),
				ImageTransparency = v46,
				ImageColor3 = themeSettings.Border.Color,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = rect
			}),
			AlignmentContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = propsSize,
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = horizontalAlignment,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				LeftIcon = leftIconEnabled and Roact.createElement(DEPRECATED_ImageSetLabel, {
					Size = iconSize,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Image = iconImage,
					ImageTransparency = p5.Theme.IconEmphasis.Transparency,
					ImageColor3 = p5.Theme.IconEmphasis.Color,
					LayoutOrder = 1,
					ScaleType = Enum.ScaleType.Fit,
					[Roact.Children] = {
						UIPadding = Roact.createElement("UIPadding", {
							PaddingRight = UDim.new(0, iconRightPadding)
						})
					}
				}),
				Text = Roact.createElement("TextLabel", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.X,
					Text = propsText,
					Font = propsFont,
					TextSize = propsTextSize,
					TextColor3 = themeSettings.Text.Color or p5.Theme.SystemPrimaryContent.Color,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center
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

return v11
