local CorePackages = game:GetService("CorePackages")
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local withStyle = UIBlox.Style.withStyle
local t = require(CorePackages.Packages.t)

local extended = Roact.PureComponent:extend("NoticeListCell")

extended.validateProps = t.strictInterface({
	screenWidth = t.number,
	Size = t.UDim2,
	Position = t.UDim2,
	LayoutOrder = t.number,
	onActivated = t.callback,
	item = t.table,
	dateText = t.string,
	noticeReadStatus = t.table
})

extended.defaultProps = {
	Size = UDim2.new(1, 0, 1, 0),
	Position = UDim2.new(0, 0, 0, 0),
	LayoutOrder = 1
}

function extended:eventDisconnect()
	if self.onAbsolutePositionChanged then
		self.onAbsolutePositionChanged:disconnect()
		self.onAbsolutePositionChanged = nil
	end
end

function extended:onButtonUp()
	if self.state.buttonPressed then
		self:setState({ buttonPressed = false })
	end

	self:eventDisconnect()
end

function extended:onButtonDown()
	if self.state.buttonPressed then
		return
	end

	self:eventDisconnect()
	local current = self.buttonRef.current

	if current then
		self.onAbsolutePositionChanged = current:GetPropertyChangedSignal("AbsolutePosition"):connect(function()
			self:onButtonUp()
		end)
	end

	self:setState({ buttonPressed = true })
end

function extended:init()
	self.state = { buttonPressed = false }

	self.buttonRef = Roact.createRef()
	function self.onButtonInputBegan(p2, p3)
		local v5 = p3.UserInputState == Enum.UserInputState.Begin
		local v6 = p3.UserInputType == Enum.UserInputType.Touch
		local v7 = p3.UserInputType == Enum.UserInputType.MouseButton1

		if v5 and (v6 or v7) then
			self:onButtonDown()
		end
	end
	function self.onButtonInputEnded()
		self:onButtonUp()
	end
	function self.onButtonActivated()
		self:onButtonUp()
		local onActivated = self.props.onActivated

		if onActivated then
			onActivated()
		end
	end
end

local function trimDescriptionText(value)
	if value == nil or value == "" then
		return ""
	end

	return value:sub(1, (string.find(value, "\n")))
end

function extended.render(data)
	local buttonPressed = data.state.buttonPressed
	local screenWidth = data.props.screenWidth
	local size = data.props.Size
	local position = data.props.Position
	local layoutOrder = data.props.LayoutOrder
	local item = data.props.item
	local title = item.title
	local noticeReadStatus = data.props.noticeReadStatus
	local hasRead = item.hasRead or noticeReadStatus[item.noticeId]
	local v5 = screenWidth - 24 - 12
	local content = data.props.item.content
	local v6 = (content == nil or content == "") and "" or content:sub(1, (string.find(content, "\n")))

	return withStyle(function(props)
		local backgroundOnPress = buttonPressed and props.Theme.BackgroundOnPress
			or props.Theme.BackgroundDefault
		local textDefault = hasRead and props.Theme.TextDefault or props.Theme.TextEmphasis
		local v7 = props.Font.BaseSize * props.Font.Header2.RelativeSize

		local v8 = props.Font.BaseSize * props.Font.CaptionBody.RelativeSize

		local v9 = props.Font.BaseSize * props.Font.CaptionBody.RelativeSize

		return Roact.createElement("ImageButton", {
			Size = size,
			Position = position,
			AutoButtonColor = false,
			LayoutOrder = layoutOrder,
			BackgroundColor3 = backgroundOnPress.Color,
			BackgroundTransparency = backgroundOnPress.Transparency,
			BorderSizePixel = 0,
			[Roact.Event.InputBegan] = data.onButtonInputBegan,
			[Roact.Event.InputEnded] = data.onButtonInputEnded,
			[Roact.Event.Activated] = data.onButtonActivated,
			[Roact.Ref] = data.buttonRef
		}, {
			TitleText = Roact.createElement("TextLabel", {
				Size = UDim2.new(0.5, 0, 0, 22),
				Position = UDim2.fromOffset(24, 14),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = title,
				FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
				TextSize = v7,
				TextColor3 = textDefault.Color,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextTransparency = textDefault.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			}),
			DescriptionText = Roact.createElement("TextLabel", {
				Size = UDim2.fromOffset(v5, 22),
				Position = UDim2.fromOffset(24, 36),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = v6,
				FontFace = normalizeFontFace(props.Tokens.Typography.BodySmall.Font),
				TextSize = v8,
				TextWrapped = false,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextColor3 = textDefault.Color,
				TextTransparency = textDefault.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			}),
			DateLabel = Roact.createElement("TextLabel", {
				AnchorPoint = Vector2.new(1, 0),
				Size = UDim2.new(0, 100, 0, 22),
				Position = UDim2.new(1, -12, 0, 14),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = data.props.dateText,
				FontFace = normalizeFontFace(props.Tokens.Typography.BodySmall.Font),
				TextSize = v9,
				TextColor3 = textDefault.Color,
				TextTransparency = textDefault.Transparency,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextYAlignment = Enum.TextYAlignment.Center
			})
		})
	end)
end

function extended:willUnmount()
	self:eventDisconnect()
end

local function mapStateToProps(p2)
	return {
		screenWidth = p2.ScreenSize.X,
		noticeReadStatus = p2.Luobu.TencentNoticeReadStatus
	}
end

return (RoactRodux.connect(mapStateToProps)(extended))
