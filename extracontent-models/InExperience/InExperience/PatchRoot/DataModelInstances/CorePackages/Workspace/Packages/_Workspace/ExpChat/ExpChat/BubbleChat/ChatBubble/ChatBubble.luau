local ExpChat = script:FindFirstAncestor("ExpChat")
local TextChatService = game:GetService("TextChatService")

local Flags = ExpChat.Flags
local getEnablePerBubbleCustomization = require(Flags.getEnablePerBubbleCustomization)

local parent = ExpChat.Parent
local Roact = require(parent.Roact)
local Otter = require(parent.Otter)
local llama = require(parent.llama)
local dictionary = llama.Dictionary
local ExpChatShared = require(parent.ExpChatShared)

local Config = require(ExpChat.Config)

local memoize = require(ExpChat.memoize)

local Helpers = ExpChat.BubbleChat.Helpers
local getSpringFromSettings = require(Helpers.getSpringFromSettings)
local getTextBounds = require(Helpers.getTextBounds)
local getDictFromBubbleChatMessageProperties = require(Helpers.getDictFromBubbleChatMessageProperties)
local shouldSendHighFrequencyTelemetry = require(ExpChat.shouldSendHighFrequencyTelemetry)

local ClientSettingsUtility = require(ExpChat.ClientSettings.ClientSettingsUtility)
local getFFlagExpChatUseUpdatedMessageRendered = require(ExpChat.Flags.getFFlagExpChatUseUpdatedMessageRendered)

local getFIntExpChatMessageRenderUserThrottlePermyriad = require(ExpChat.Flags.getFIntExpChatMessageRenderUserThrottlePermyriad)
local fIntExpChatMessageRenderUserThrottlePermyriad = getFIntExpChatMessageRenderUserThrottlePermyriad()
local getFFlagExpChatExcludeFOMORenders = require(ExpChat.Flags.getFFlagExpChatExcludeFOMORenders)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled

local EngineFeatureExpChatGlobalChatEngineTelemetryEnabled = require(ExpChat.Flags.EngineFeatureExpChatGlobalChatEngineTelemetryEnabled)

local getPresetIconRichText = ExpChatShared.getPresetIconRichText
local getPresetIconSize = ExpChatShared.getPresetIconSize
local isPresetMessage = ExpChatShared.isPresetMessage

local extended = Roact.Component:extend("ChatBubble")
extended.defaultProps = { isMostRecent = true, text = "", timestamp = 0 }

local v = memoize(function(p, p2)
	if p2 then
		return dictionary.join(p, getDictFromBubbleChatMessageProperties(p2))
	end

	return p
end)

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

	local binding4, updateBackgroundTransparency = Roact.createBinding(1)
	self.backgroundTransparency = binding4
	self.updateBackgroundTransparency = updateBackgroundTransparency
	self.backgroundTransparencyMotor = Otter.createSingleMotor(1)
	self.backgroundTransparencyMotor:onStep(self.updateBackgroundTransparency)

	self.size = Roact.joinBindings({ self.width, self.height }):map(function(list)
		return UDim2.fromOffset(list[1], list[2])
	end)
end

function extended.render(props)
	local v2 = props.props.chatSettings

	if getEnablePerBubbleCustomization() then
		v2 = v(props.props.chatSettings, props.props.bubbleChatMessageProperties)
	end

	local v3 = nil

	local fontFace = nil
	local v4, v5, v6, v7

	if props.props.isTextChatServiceOn then
		v4 = v2.ImageLabel
		v5 = v2.UIGradient
		v6 = v2.UICorner
		v7 = v2.UIPadding
		fontFace = v2.FontFace
	else
		v4 = v2.BackgroundImage

		v5 = v2.BackgroundGradient

		if v2.CornerEnabled then
			v6 = { CornerRadius = v2.CornerRadius }
		else
			v6 = v2.CornerEnabled == false and { CornerRadius = UDim.new(0, 0) } or v3
		end

		v7 = v2.Padding
			and ({
				PaddingTop = UDim.new(0, v2.Padding),
				PaddingRight = UDim.new(0, v2.Padding),
				PaddingBottom = UDim.new(0, v2.Padding),
				PaddingLeft = UDim.new(0, v2.Padding)
			} or nil)
			or nil
	end

	local cornerRadius = Config.DefaultBubbleChatChildrenCustomizationProperties.UICorner.CornerRadius
	local uiPadding = Config.DefaultBubbleChatChildrenCustomizationProperties.UIPadding

	local v8 = props.props.renderInsert and props.props.insertSize.X + v2.Padding or 0

	local isTextChatServiceOn = FFlagExpChatPresetChatEnabled
		and isPresetMessage(props.props)
		and props.props.isTextChatServiceOn
	local showCaret = props.props.isMostRecent and v2.TailVisible and props.props.showCaret

	if
		getFFlagExpChatUseUpdatedMessageRendered()
		and props.props.textChatMessageInstance
		and shouldSendHighFrequencyTelemetry(fIntExpChatMessageRenderUserThrottlePermyriad)
		and not (getFFlagExpChatExcludeFOMORenders() and props.props.isHiddenMessage)
	then
		if EngineFeatureExpChatGlobalChatEngineTelemetryEnabled then
			TextChatService:SendExpChatMessageClientRendered(props.props.textChatMessageInstance, "bubble_chat", -1)
		else
			TextChatService:SendExpChatMessageClientRendered(props.props.textChatMessageInstance, "bubble_chat")
		end
	end

	local text

	if FFlagExpChatPresetChatEnabled then
		if props.props.useTranslation and props.props.translation and props.props.translation ~= "" then
			text = props.props.translation
		else
			text = props.props.text
		end

		if isTextChatServiceOn then
			text ..= ` {getPresetIconRichText(v2.TextSize)}`
		end
	end

	local createElement = Roact.createElement
	local v9 = {
		LayoutOrder = props.props.timestamp,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = props.size,
		Position = UDim2.fromScale(1, 0.5),
		Transparency = 1
	}

	local v10 = {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, -1)
		}),
		ChatBubbleFrame = 0,
		Caret = 0
	}

	local createElement2 = Roact.createElement

	local joined = dictionary.join(v4, {
		LayoutOrder = 1,
		BackgroundColor3 = v2.BackgroundColor3,
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 0, 0, 0),
		BackgroundTransparency = v4 and v4.Image ~= "" and 1 or props.backgroundTransparency or props.transparency,
		ClipsDescendants = true,
		ImageTransparency = props.backgroundTransparency or props.transparency
	})

	local v11 = {
		UICorner = v6 and Roact.createElement("UICorner", { CornerRadius = v6.CornerRadius }) or Roact.createElement("UICorner", {
			CornerRadius = cornerRadius
		}),
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, v2.Padding)
		}),
		Padding = v7 and Roact.createElement("UIPadding", v7) or Roact.createElement("UIPadding", uiPadding),
		Insert = props.props.renderInsert and props.props.renderInsert(),
		Text = 0,
		Gradient = 0
	}

	local createElement3 = Roact.createElement

	if not FFlagExpChatPresetChatEnabled then
		if props.props.useTranslation and props.props.translation and props.props.translation ~= "" then
			text = props.props.translation
		else
			text = props.props.text
		end
	end

	local v12 = {
		Text = text,
		Size = UDim2.new(1, -v8, 1, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		FontFace = fontFace or nil,
		Font = 0,
		TextColor3 = 0,
		TextSize = 0,
		TextTransparency = 0,
		TextWrapped = true,
		AutoLocalize = false,
		LayoutOrder = 2,
		RichText = 0
	}
	local font

	if not fontFace then
		font = v2.Font
	end

	v12.Font = font
	v12.TextColor3 = v2.TextColor3
	v12.TextSize = v2.TextSize
	v12.TextTransparency = props.transparency

	v12.RichText = props.props.isTextChatServiceOn
	v11.Text = createElement3("TextLabel", v12)

	v11.Gradient = v5 ~= nil and Roact.createElement("UIGradient", v5)
	v10.ChatBubbleFrame = createElement2("ImageLabel", joined, v11)
	local caret

	if showCaret then
		caret = Roact.createElement("ImageLabel", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(9, 6),
			Image = "rbxasset://textures/ui/InGameChat/Caret.png",
			ImageColor3 = v2.BackgroundColor3,
			ImageTransparency = props.backgroundTransparency
		}, {
			Gradient = v5 ~= nil and Roact.createElement("UIGradient", v5)
		})
	end

	v10.Caret = caret
	return createElement("Frame", v9, v10)
end

function extended:fadeOut()
	local v2 = self.props.chatSettings

	if getEnablePerBubbleCustomization() then
		v2 = v(self.props.chatSettings, self.props.bubbleChatMessageProperties)
	end

	if not self.isFadingOut then
		self.isFadingOut = true

		self.transparencyMotor:onComplete(function()
			if self.props.onFadeOut then
				self.props.onFadeOut(self.props.messageId)
			end
		end)

		local springFromSettings = getSpringFromSettings(v2, "transparency")
		self.transparencyMotor:setGoal(springFromSettings(1))
		self.backgroundTransparencyMotor:setGoal(springFromSettings(1))
	end
end

function extended:didUpdate(data)
	if self.props.fadingOut then
		self:fadeOut()
	end

	local v2 = self.props.chatSettings

	if getEnablePerBubbleCustomization() then
		v2 = v(self.props.chatSettings, self.props.bubbleChatMessageProperties)
	end

	if
		data.text ~= self.props.text
		or data.useTranslation ~= self.props.useTranslation
		or data.translation ~= self.props.translation
		or data.chatSettings ~= self.props.chatSettings
		or data.renderInsert ~= self.props.renderInsert
		or data.insertSize ~= self.props.insertSize
	then
		local v3

		if self.props.useTranslation and self.props.translation and self.props.translation ~= "" then
			v3 = getTextBounds(self.props.translation, v2)
		else
			v3 = getTextBounds(self.props.text, v2)
		end

		local springFromSettings = getSpringFromSettings(v2, "size")
		local padding = v2.Padding

		local x = v3.X
		local y = v3.Y

		if self.props.renderInsert then
			x += self.props.insertSize.X + padding
			y = math.max(y, self.props.insertSize.Y + padding * 2)
		end

		local isTextChatServiceOn = FFlagExpChatPresetChatEnabled
			and isPresetMessage(self.props)
			and self.props.isTextChatServiceOn

		if FFlagExpChatPresetChatEnabled and isTextChatServiceOn then
			local presetIconSize = getPresetIconSize(v2.TextSize)
			x += presetIconSize + padding
			y = math.max(y, presetIconSize)
		end

		self.heightMotor:setGoal(springFromSettings(y))
		self.widthMotor:setGoal(springFromSettings(x))
	end
end

function extended:didMount()
	self.isMounted = true

	local v2 = self.props.chatSettings

	if getEnablePerBubbleCustomization() then
		v2 = v(self.props.chatSettings, self.props.bubbleChatMessageProperties)
	end

	local v3

	if self.props.useTranslation and self.props.translation and self.props.translation ~= "" then
		v3 = getTextBounds(self.props.translation, v2)
	else
		v3 = getTextBounds(self.props.text, v2)
	end

	local springFromSettings = getSpringFromSettings(v2, "size")
	local springFromSettings2 = getSpringFromSettings(v2, "transparency")

	local x = v3.X
	local y = v3.Y

	if self.props.renderInsert then
		x += self.props.insertSize.X + v2.Padding
		y = math.max(y, self.props.insertSize.Y + v2.Padding * 2)
	end

	local isTextChatServiceOn = FFlagExpChatPresetChatEnabled
		and isPresetMessage(self.props)
		and self.props.isTextChatServiceOn

	if FFlagExpChatPresetChatEnabled and isTextChatServiceOn then
		local presetIconSize = getPresetIconSize(v2.TextSize)
		x += presetIconSize + v2.Padding
		y = math.max(y, presetIconSize)
	end

	if self.props.isMostRecent then
		self.heightMotor:setGoal(springFromSettings(y))
		self.widthMotor:setGoal(Otter.instant(x))
	else
		self.heightMotor:setGoal(springFromSettings(y))
		self.widthMotor:setGoal(springFromSettings(x))
	end

	local transparency = v2.Transparency
	self.transparencyMotor:setGoal(springFromSettings2(transparency))

	local v4 = ClientSettingsUtility.getBackgroundTransparency(v2, self.props.clientSettings)

	if getEnablePerBubbleCustomization() then
		local bubbleChatMessageProperties = self.props.bubbleChatMessageProperties

		if bubbleChatMessageProperties and bubbleChatMessageProperties.BackgroundTransparency then
			v4 = ClientSettingsUtility.getBackgroundTransparency(
				{ BackgroundTransparency = bubbleChatMessageProperties.BackgroundTransparency },
				self.props.clientSettings
			)
		end
	end

	self.backgroundTransparencyMotor:setGoal(springFromSettings2(v4))
end

function extended:willUnmount()
	self.isMounted = false
	self.transparencyMotor:destroy()
	self.backgroundTransparencyMotor:destroy()
	self.heightMotor:destroy()
	self.widthMotor:destroy()
end

return extended
