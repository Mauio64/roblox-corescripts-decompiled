local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Foundation = require(CorePackages.Packages.Foundation)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local module = require("@luauforge/bundled/dzD")
local module2 = require("@luauforge/bundled/egZ")

local module3 = require("@luauforge/bundled/egF")

local extended = Roact.PureComponent:extend("MoreButton")

extended.defaultProps = {
	Size = UDim2.new(1, 0, 1, 0),
	Position = UDim2.new(0, 0, 0, 0),
	TextXAlignment = Enum.TextXAlignment.Left,
	LayoutOrder = 1,
	buttonRef = nil
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
	if not self.state.buttonPressed then
		self:eventDisconnect()
		self.onAbsolutePositionChanged = self.buttonRef.current
			and self.buttonRef.current:GetPropertyChangedSignal("AbsolutePosition"):connect(function()
				self:onButtonUp()
			end)
		self:setState({ buttonPressed = true })
	end
end

function extended:init()
	self.state = { buttonPressed = false }

	self.buttonRef = self.props.buttonRef or Roact.createRef()

	function self.onButtonInputBegan(p2, p3)
		if
			p3.UserInputState == Enum.UserInputState.Begin
			and (p3.UserInputType == Enum.UserInputType.Touch or p3.UserInputType == Enum.UserInputType.MouseButton1)
		then
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

function extended.render(data)
	local buttonPressed = data.state.buttonPressed

	local size = data.props.Size
	local position = data.props.Position
	local layoutOrder = data.props.LayoutOrder
	local textKey = data.props.textKey
	local textXAlignment = data.props.TextXAlignment
	local icon = data.props.icon
	local rightImage = data.props.rightImage
	local badgeComponent = data.props.badgeComponent
	local badgeCount = data.props.badgeCount

	local v5 = textXAlignment == Enum.TextXAlignment.Center and 0
		or icon and module.MORE_PAGE_TEXT_PADDING_WITH_ICON
		or module.MORE_PAGE_ROW_PADDING_LEFT
	local v6 = badgeComponent and badgeCount and badgeCount > 0

	local function fn(p2, p3, props, textDefault, iconDefault)
		return Roact.createElement("ImageButton", {
			Size = size,
			Position = position,
			AutoButtonColor = false,
			LayoutOrder = layoutOrder,
			BackgroundColor3 = p3.Color,
			BackgroundTransparency = p3.Transparency,
			BorderSizePixel = 0,
			[Roact.Event.InputBegan] = data.onButtonInputBegan,
			[Roact.Event.InputEnded] = data.onButtonInputEnded,
			[Roact.Event.Activated] = data.onButtonActivated,
			[Roact.Ref] = data.buttonRef
		}, {
			Icon = icon and Roact.createElement(module3, {
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(0, 26, 0, 26),
				Position = UDim2.new(0, module.MORE_PAGE_ROW_PADDING_LEFT, 0.5, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				Image = icon,
				ImageColor3 = textDefault.Color,
				ImageTransparency = textDefault.Transparency
			}),
			Text = Roact.createElement("TextLabel", {
				Size = UDim2.new(
					1,
					-module.MORE_PAGE_ROW_PADDING_RIGHT - module.MORE_PAGE_ROW_PADDING_LEFT - (icon and 26 or 0) - (rightImage and 14 or 0),
					1,
					0
				),
				Position = UDim2.new(0, v5, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = p2.moreButtonText,
				Font = props.Font,
				FontFace = props.FontFace,
				TextSize = props.Size,
				TextColor3 = props.Color,
				TextTransparency = props.Transparency,
				TextXAlignment = textXAlignment,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.SplitWord
			}),
			RightImage = rightImage and Roact.createElement(module3, {
				AnchorPoint = Vector2.new(1, 0.5),
				Size = UDim2.new(0, 14, 0, 14),
				Position = UDim2.new(1, -module.MORE_PAGE_ROW_PADDING_RIGHT, 0.5, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = rightImage,
				ImageColor3 = iconDefault.Color,
				ImageTransparency = iconDefault.Transparency
			}),
			NotificationBadge = v6 and Roact.createElement(badgeComponent, {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -module.MORE_PAGE_ROW_PADDING_RIGHT * 2 - 14, 0.5, 0),
				badgeCount = badgeCount
			})
		})
	end

	return module2({ moreButtonText = textKey })(function(p2)
		return withStyle(function(p3)
			local backgroundOnPress = buttonPressed and p3.Theme.BackgroundOnPress
				or p3.Theme.BackgroundDefault
			local v7 = data.props.transparentBackground
				and not buttonPressed
				and { Color = backgroundOnPress.Color, Transparency = 1 }
				or backgroundOnPress

			local titleLarge = p3.Tokens.Typography.TitleLarge
			return fn(
				p2,
				v7,
				Cryo.Dictionary.join(p3.Theme.TextDefault, {
					FontFace = normalizeFontFace(titleLarge.Font),
					Size = titleLarge.FontSize
				}),
				p3.Theme.TextDefault,
				p3.Theme.IconDefault
			)
		end)
	end)
end

function extended:willUnmount()
	self:eventDisconnect()
end

return extended
