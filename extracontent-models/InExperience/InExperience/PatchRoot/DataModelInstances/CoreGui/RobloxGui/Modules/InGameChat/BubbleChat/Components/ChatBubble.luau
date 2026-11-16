local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local TextChatService = game:GetService("TextChatService")

local Otter = require(CorePackages.Packages.Otter)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)

local parent = script.Parent.Parent
local Types = require(parent.Types)
local getSizeSpringFromSettings = require(parent.Helpers.getSizeSpringFromSettings)
local getTransparencySpringFromSettings = require(parent.Helpers.getTransparencySpringFromSettings)

local CoreGui = game:GetService("CoreGui")
local extended = Roact.PureComponent:extend("ChatBubble")

extended.validateProps = t.strictInterface({
	messageId = t.string,
	fadingOut = t.optional(t.boolean),
	onFadeOut = t.optional(t.callback),
	isMostRecent = t.optional(t.boolean),
	theme = t.optional(t.string),
	renderInsert = t.optional(t.callback),
	insertSize = t.optional(t.Vector2),
	chatSettings = Types.IChatSettings,
	text = t.string,
	timestamp = t.number
})

extended.defaultProps = { theme = "Light", isMostRecent = true }

local function initMockSizingLabel() -- 1 equivalent call inferred from this helper
	local richTextSizingLabel = Instance.new("ScreenGui")
	richTextSizingLabel.Enabled = false
	richTextSizingLabel.Name = "RichTextSizingLabel"
	local textLabel = Instance.new("TextLabel")
	textLabel.TextWrapped = true
	textLabel.RichText = true
	textLabel.Parent = richTextSizingLabel
	richTextSizingLabel.Parent = CoreGui
	return textLabel
end

function extended:init()
	local binding, updateWidth = Roact.createBinding(0)
	self.width = binding
	self.updateWidth = updateWidth
	self.widthMotor = Otter.createSingleMotor(0)
	self.widthMotor:onStep(function(p)
		self.updateWidth((math.round(p)))
	end)

	local binding2, updateHeight = Roact.createBinding(0)
	self.height = binding2
	self.updateHeight = updateHeight
	self.heightMotor = Otter.createSingleMotor(0)
	self.heightMotor:onStep(function(p)
		self.updateHeight((math.round(p)))
	end)

	local binding3, updateTransparency = Roact.createBinding(1)
	self.transparency = binding3
	self.updateTransparency = updateTransparency
	self.transparencyMotor = Otter.createSingleMotor(1)
	self.transparencyMotor:onStep(self.updateTransparency)

	self.size = Roact.joinBindings({ self.width, self.height }):map(function(list)
		return UDim2.fromOffset(list[1], list[2])
	end)

	self.mockSizingLabel = nil

	self.isRichTextEnabled = TextChatService.ChatVersion == Enum.ChatVersion.TextChatService
end

function extended:getBoundsFromSizingLabel(text, textSize, font, p)
	local textLabel = initMockSizingLabel() -- inferred equivalent call
	textLabel.Text = text
	textLabel.TextSize = textSize
	textLabel.Font = font
	textLabel.Size = UDim2.fromOffset(p.X, p.Y)

	local textBounds = textLabel.TextBounds
	textLabel.Parent:Destroy()

	return textBounds
end

function extended:getTextBounds()
	local chatSettings = self.props.chatSettings
	local vector2 = Vector2.new(chatSettings.Padding * 4, chatSettings.Padding * 2)

	Vector2.new(0, 0)
	local v

	if self.isRichTextEnabled then
		v = self:getBoundsFromSizingLabel(
			self.props.text,
			chatSettings.TextSize,
			chatSettings.Font,
			Vector2.new(chatSettings.MaxWidth, 10000)
		)
	else
		v = TextService:GetTextSize(
			self.props.text,
			chatSettings.TextSize,
			chatSettings.Font,
			Vector2.new(chatSettings.MaxWidth, 10000)
		)
	end

	return v + vector2
end

function extended.render(props)
	local chatSettings = props.props.chatSettings
	local backgroundImage = chatSettings.BackgroundImage
	local backgroundGradient = chatSettings.BackgroundGradient

	local v = props.props.renderInsert and props.props.insertSize.X + chatSettings.Padding or 0

	return Roact.createElement("Frame", {
		LayoutOrder = props.props.timestamp,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = props.size,
		Position = UDim2.fromScale(1, 0.5),
		Transparency = 1
	}, {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, -1)
		}),
		Frame = Roact.createElement("ImageLabel", Cryo.Dictionary.join(backgroundImage, {
			LayoutOrder = 1,
			BackgroundColor3 = chatSettings.BackgroundColor3,
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.fromScale(1, 1),
			BorderSizePixel = 0,
			Position = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = backgroundImage.Image ~= "" and 1 or props.transparency,
			ClipsDescendants = true,
			ImageTransparency = props.transparency
		}), {
			UICorner = chatSettings.CornerEnabled and Roact.createElement("UICorner", {
				CornerRadius = chatSettings.CornerRadius
			}),
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				Padding = UDim.new(0, chatSettings.Padding)
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, chatSettings.Padding),
				PaddingRight = UDim.new(0, chatSettings.Padding),
				PaddingBottom = UDim.new(0, chatSettings.Padding),
				PaddingLeft = UDim.new(0, chatSettings.Padding)
			}),
			Insert = props.props.renderInsert and props.props.renderInsert(),
			Text = Roact.createElement("TextLabel", {
				Text = props.props.text,
				Size = UDim2.new(1, -v, 1, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
				Font = chatSettings.Font,
				TextColor3 = chatSettings.TextColor3,
				TextSize = chatSettings.TextSize,
				TextTransparency = props.transparency,
				TextWrapped = true,
				AutoLocalize = false,
				LayoutOrder = 2,
				RichText = props.isRichTextEnabled
			}),
			Gradient = backgroundGradient.Enabled and Roact.createElement("UIGradient", backgroundGradient)
		}),
		Carat = props.props.isMostRecent and chatSettings.TailVisible and props.props.showCarat and Roact.createElement("ImageLabel", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(9, 6),
			Image = "rbxasset://textures/ui/InGameChat/Caret.png",
			ImageColor3 = chatSettings.BackgroundColor3,
			ImageTransparency = props.transparency
		})
	})
end

function extended:fadeOut()
	if not self.isFadingOut then
		self.isFadingOut = true

		self.transparencyMotor:onComplete(function()
			if self.props.onFadeOut then
				self.props.onFadeOut(self.props.messageId)
			end
		end)

		local transparencySpringFromSettings = getTransparencySpringFromSettings(self.props.chatSettings)
		self.transparencyMotor:setGoal(transparencySpringFromSettings(1))
	end
end

function extended:didUpdate(data)
	if self.props.fadingOut then
		self:fadeOut()
	end

	if
		data.text ~= self.props.text
		or data.chatSettings ~= self.props.chatSettings
		or data.renderInsert ~= self.props.renderInsert
		or data.insertSize ~= self.props.insertSize
	then
		local textBounds = self:getTextBounds()
		local sizeSpringFromSettings = getSizeSpringFromSettings(self.props.chatSettings)
		local padding = self.props.chatSettings.Padding

		local x = textBounds.X
		local y = textBounds.Y

		if self.props.renderInsert then
			x += self.props.insertSize.X + padding
			y = math.max(y, self.props.insertSize.Y + padding * 2)
		end

		self.heightMotor:setGoal(sizeSpringFromSettings(y))
		self.widthMotor:setGoal(sizeSpringFromSettings(x))
	end
end

function extended:didMount()
	self.isMounted = true

	local textBounds = self:getTextBounds()
	local chatSettings = self.props.chatSettings
	local sizeSpringFromSettings = getSizeSpringFromSettings(chatSettings)
	local transparencySpringFromSettings = getTransparencySpringFromSettings(chatSettings)

	local x = textBounds.X
	local y = textBounds.Y

	if self.props.renderInsert then
		x += self.props.insertSize.X + chatSettings.Padding
		y = math.max(y, self.props.insertSize.Y + chatSettings.Padding * 2)
	end

	if self.props.isMostRecent then
		self.heightMotor:setGoal(sizeSpringFromSettings(y))
		self.widthMotor:setGoal(Otter.instant(x))
	else
		self.heightMotor:setGoal(sizeSpringFromSettings(y))
		self.widthMotor:setGoal(sizeSpringFromSettings(x))
	end

	self.transparencyMotor:setGoal(transparencySpringFromSettings(chatSettings.Transparency))
end

function extended:willUnmount()
	self.isMounted = false
	self.transparencyMotor:destroy()
	self.heightMotor:destroy()
	self.widthMotor:destroy()
end

local function mapStateToProps(p, p2)
	local message = p.messages[p2.messageId]
	return {
		text = message and message.text or "",
		timestamp = message and message.timestamp or 0
	}
end

return RoactRodux.connect(mapStateToProps)(extended)
