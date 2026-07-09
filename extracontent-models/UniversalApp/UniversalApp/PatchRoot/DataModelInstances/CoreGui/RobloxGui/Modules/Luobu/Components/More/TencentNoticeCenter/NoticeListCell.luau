local CorePackages = game:GetService("CorePackages")
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Roact = require(CorePackages.Packages.Roact)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local t = require(CorePackages.Packages.t)
local v6 = Roact.PureComponent:extend("NoticeListCell")

v6.validateProps = t.strictInterface({
	screenWidth = t.number,
	Size = t.UDim2,
	Position = t.UDim2,
	LayoutOrder = t.number,
	onActivated = t.callback,
	item = t.table,
	dateText = t.string,
	noticeReadStatus = t.table
})
v6.defaultProps = {
	LayoutOrder = 1,
	Size = UDim2.new(1, 0, 1, 0),
	Position = UDim2.new(0, 0, 0, 0)
}

function v6.eventDisconnect(p1) -- line: 36
	if p1.onAbsolutePositionChanged then
		p1.onAbsolutePositionChanged:disconnect()
		p1.onAbsolutePositionChanged = nil
	end
end
function v6.onButtonUp(p2) -- line: 43
	if p2.state.buttonPressed then
		p2:setState({
			buttonPressed = false
		})
	end

	p2:eventDisconnect()
end
function v6.onButtonDown(p3) -- line: 52
	if p3.state.buttonPressed then
		return
	end

	p3:eventDisconnect()

	local current = p3.buttonRef.current

	if current then
		p3.onAbsolutePositionChanged = current:GetPropertyChangedSignal("AbsolutePosition"):connect(function() -- line: 59
			-- upvalues: p3 (copy)
			p3:onButtonUp()
		end)
	end

	p3:setState({
		buttonPressed = true
	})
end
function v6.init(p4) -- line: 68
	-- upvalues: Roact (copy)
	p4.state = {
		buttonPressed = false
	}
	p4.buttonRef = Roact.createRef()

	function p4.onButtonInputBegan(_, p6) -- line: 73
		-- upvalues: p4 (copy)
		local v32 = p6.UserInputState == Enum.UserInputState.Begin
		local v33 = p6.UserInputType == Enum.UserInputType.Touch
		local v34 = p6.UserInputType == Enum.UserInputType.MouseButton1

		if v32 and (v33 or v34) then
			p4:onButtonDown()
		end
	end
	function p4.onButtonInputEnded() -- line: 81
		-- upvalues: p4 (copy)
		p4:onButtonUp()
	end
	function p4.onButtonActivated() -- line: 84
		-- upvalues: p4 (copy)
		p4:onButtonUp()

		local onActivated = p4.props.onActivated

		if onActivated then
			onActivated()
		end
	end
end

local function trimDescriptionText(p7) -- line: 94
	if p7 == nil or p7 == "" then
		return ""
	end

	return p7:sub(1, (string.find(p7, "\n")))
end

function v6.render(p8) -- line: 102
	-- upvalues: withStyle (copy), Roact (copy)
	local buttonPressed = p8.state.buttonPressed
	local screenWidth = p8.props.screenWidth
	local propsSize = p8.props.Size
	local propsPosition = p8.props.Position
	local propsLayoutOrder = p8.props.LayoutOrder
	local item = p8.props.item
	local title = item.title
	local noticeReadStatus = p8.props.noticeReadStatus
	local v24 = item.hasRead or noticeReadStatus[item.noticeId]
	local v25 = screenWidth - 24 - 12
	local content = p8.props.item.content
	local v27 = if content ~= nil and content ~= "" then content:sub(1, (string.find(content, "\n"))) else ""

	return withStyle(function(t1: {[any]: any}) -- line: 114
		-- upvalues: buttonPressed (copy), v24 (copy), Roact (copy), propsSize (copy), propsPosition (copy), propsLayoutOrder (copy), p8 (copy), title (copy), v25 (copy), v27 (copy)
		local v37 = buttonPressed and t1.Theme.BackgroundOnPress or t1.Theme.BackgroundDefault
		local v38 = v24 and t1.Theme.TextDefault or t1.Theme.TextEmphasis
		local Header2Font = t1.Font.Header2.Font
		local v40 = t1.Font.BaseSize * t1.Font.Header2.RelativeSize
		local CaptionBodyFont = t1.Font.CaptionBody.Font
		local v42 = t1.Font.BaseSize * t1.Font.CaptionBody.RelativeSize
		local CaptionBodyFont2 = t1.Font.CaptionBody.Font
		local v44 = t1.Font.BaseSize * t1.Font.CaptionBody.RelativeSize

		return Roact.createElement("ImageButton", {
			Size = propsSize,
			Position = propsPosition,
			AutoButtonColor = false,
			LayoutOrder = propsLayoutOrder,
			BackgroundColor3 = v37.Color,
			BackgroundTransparency = v37.Transparency,
			BorderSizePixel = 0,
			[Roact.Event.InputBegan] = p8.onButtonInputBegan,
			[Roact.Event.InputEnded] = p8.onButtonInputEnded,
			[Roact.Event.Activated] = p8.onButtonActivated,
			[Roact.Ref] = p8.buttonRef
		}, {
			TitleText = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(0.5, 0, 0, 22),
				Position = UDim2.fromOffset(24, 14),
				Text = title,
				Font = Header2Font,
				TextSize = v40,
				TextColor3 = v38.Color,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextTransparency = v38.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			}),
			DescriptionText = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				TextWrapped = false,
				Size = UDim2.fromOffset(v25, 22),
				Position = UDim2.fromOffset(24, 36),
				Text = v27,
				Font = CaptionBodyFont,
				TextSize = v42,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextColor3 = v38.Color,
				TextTransparency = v38.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			}),
			DateLabel = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(1, 0),
				Size = UDim2.new(0, 100, 0, 22),
				Position = UDim2.new(1, -12, 0, 14),
				Text = p8.props.dateText,
				Font = CaptionBodyFont2,
				TextSize = v44,
				TextColor3 = v38.Color,
				TextTransparency = v38.Transparency,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextYAlignment = Enum.TextYAlignment.Center
			})
		})
	end)
end
function v6.willUnmount(p9) -- line: 186
	p9:eventDisconnect()
end

local function mapStateToProps(p10) -- line: 190
	return {
		screenWidth = p10.ScreenSize.X,
		noticeReadStatus = p10.Luobu.TencentNoticeReadStatus
	}
end

return (RoactRodux.connect(mapStateToProps)(v6))
