local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local Constants = require(Modules.LuaApp.Constants)
local withLocalization = require(Modules.LuaApp.withLocalization)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local v9 = Roact.PureComponent:extend("MoreButton")

v9.defaultProps = {
	LayoutOrder = 1,
	buttonRef = nil,
	Size = UDim2.new(1, 0, 1, 0),
	Position = UDim2.new(0, 0, 0, 0),
	TextXAlignment = Enum.TextXAlignment.Left
}

function v9.eventDisconnect(p1) -- line: 28
	if p1.onAbsolutePositionChanged then
		p1.onAbsolutePositionChanged:disconnect()
		p1.onAbsolutePositionChanged = nil
	end
end
function v9.onButtonUp(p2) -- line: 35
	if p2.state.buttonPressed then
		p2:setState({
			buttonPressed = false
		})
	end

	p2:eventDisconnect()
end
function v9.onButtonDown(p3) -- line: 44
	if not p3.state.buttonPressed then
		p3:eventDisconnect()
		p3.onAbsolutePositionChanged = p3.buttonRef.current and p3.buttonRef.current:GetPropertyChangedSignal("AbsolutePosition"):connect(function() -- line: 48
			-- upvalues: p3 (copy)
			p3:onButtonUp()
		end)
		p3:setState({
			buttonPressed = true
		})
	end
end
function v9.init(p4) -- line: 57
	-- upvalues: Roact (copy)
	p4.state = {
		buttonPressed = false
	}
	p4.buttonRef = p4.props.buttonRef or Roact.createRef()

	function p4.onButtonInputBegan(_, p6) -- line: 64
		-- upvalues: p4 (copy)
		if p6.UserInputState == Enum.UserInputState.Begin and (p6.UserInputType == Enum.UserInputType.Touch or p6.UserInputType == Enum.UserInputType.MouseButton1) then
			p4:onButtonDown()
		end
	end
	function p4.onButtonInputEnded() -- line: 76
		-- upvalues: p4 (copy)
		p4:onButtonUp()
	end
	function p4.onButtonActivated() -- line: 80
		-- upvalues: p4 (copy)
		p4:onButtonUp()

		local onActivated = p4.props.onActivated

		if onActivated then
			onActivated()
		end
	end
end
function v9.render(p7) -- line: 89
	-- upvalues: Constants (copy), Roact (copy), DEPRECATED_ImageSetLabel (copy), withLocalization (copy), withStyle (copy), Cryo (copy)
	local buttonPressed = p7.state.buttonPressed
	local propsSize = p7.props.Size
	local propsPosition = p7.props.Position
	local propsLayoutOrder = p7.props.LayoutOrder
	local textKey = p7.props.textKey
	local TextXAlignment = p7.props.TextXAlignment
	local icon = p7.props.icon
	local rightImage = p7.props.rightImage
	local badgeComponent = p7.props.badgeComponent
	local badgeCount = p7.props.badgeCount
	local v25 = if TextXAlignment ~= Enum.TextXAlignment.Center then icon and Constants.MORE_PAGE_TEXT_PADDING_WITH_ICON or Constants.MORE_PAGE_ROW_PADDING_LEFT else 0
	local v26 = badgeComponent and (badgeCount and badgeCount > 0)

	local function v27(p8, p9, p10, p11, p12) -- line: 107
		-- upvalues: Roact (copy), propsSize (copy), propsPosition (copy), propsLayoutOrder (copy), p7 (copy), icon (copy), DEPRECATED_ImageSetLabel (copy), Constants (copy), rightImage (copy), v25 (copy), TextXAlignment (copy), v26 (copy), badgeComponent (copy), badgeCount (copy)
		return Roact.createElement("ImageButton", {
			Size = propsSize,
			Position = propsPosition,
			AutoButtonColor = false,
			LayoutOrder = propsLayoutOrder,
			BackgroundColor3 = p9.Color,
			BackgroundTransparency = p9.Transparency,
			BorderSizePixel = 0,
			[Roact.Event.InputBegan] = p7.onButtonInputBegan,
			[Roact.Event.InputEnded] = p7.onButtonInputEnded,
			[Roact.Event.Activated] = p7.onButtonActivated,
			[Roact.Ref] = p7.buttonRef
		}, {
			Icon = icon and Roact.createElement(DEPRECATED_ImageSetLabel, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(0, 26, 0, 26),
				Position = UDim2.new(0, Constants.MORE_PAGE_ROW_PADDING_LEFT, 0.5, 0),
				Image = icon,
				ImageColor3 = p11.Color,
				ImageTransparency = p11.Transparency
			}),
			Text = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -Constants.MORE_PAGE_ROW_PADDING_RIGHT - Constants.MORE_PAGE_ROW_PADDING_LEFT - (not icon and 0 or 26) - (not rightImage and 0 or 14), 1, 0),
				Position = UDim2.new(0, v25, 0, 0),
				Text = p8.moreButtonText,
				Font = p10.Font,
				TextSize = p10.Size,
				TextColor3 = p10.Color,
				TextTransparency = p10.Transparency,
				TextXAlignment = TextXAlignment,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.SplitWord
			}),
			RightImage = rightImage and Roact.createElement(DEPRECATED_ImageSetLabel, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(1, 0.5),
				Size = UDim2.new(0, 14, 0, 14),
				Position = UDim2.new(1, -Constants.MORE_PAGE_ROW_PADDING_RIGHT, 0.5, 0),
				Image = rightImage,
				ImageColor3 = p12.Color,
				ImageTransparency = p12.Transparency
			}),
			NotificationBadge = v26 and Roact.createElement(badgeComponent, {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -Constants.MORE_PAGE_ROW_PADDING_RIGHT * 2 - 14, 0.5, 0),
				badgeCount = badgeCount
			})
		})
	end

	return withLocalization({
		moreButtonText = textKey
	})(function(p13) -- line: 174
		-- upvalues: withStyle (copy), buttonPressed (copy), Cryo (copy), v27 (copy)
		return withStyle(function(p14) -- line: 175
			-- upvalues: buttonPressed (copy), Cryo (copy), v27 (copy), p13 (copy)
			local v39 = buttonPressed and p14.Theme.BackgroundOnPress or p14.Theme.BackgroundDefault
			local v40 = Cryo.Dictionary.join(p14.Theme.TextDefault, {
				Font = p14.Font.Header2.Font,
				Size = p14.Font.BaseSize * p14.Font.Header2.RelativeSize
			})

			return v27(p13, v39, v40, p14.Theme.TextDefault, p14.Theme.IconDefault)
		end)
	end)
end
function v9.willUnmount(p15) -- line: 192
	p15:eventDisconnect()
end

return v9
