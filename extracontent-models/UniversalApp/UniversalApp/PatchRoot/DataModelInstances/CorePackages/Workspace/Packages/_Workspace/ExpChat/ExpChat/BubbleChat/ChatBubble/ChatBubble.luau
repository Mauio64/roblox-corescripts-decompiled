local ExpChat = script:FindFirstAncestor("ExpChat")
local TextChatService = game:GetService("TextChatService")
local Flags = ExpChat.Flags
local getEnablePerBubbleCustomization = require(Flags.getEnablePerBubbleCustomization)
local ExpChatParent = ExpChat.Parent
local Roact = require(ExpChatParent.Roact)
local Otter = require(ExpChatParent.Otter)
local Dictionary = require(ExpChatParent.llama).Dictionary
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local Config = require(ExpChat.Config)
local memoize = require(ExpChat.memoize)
local Helpers = ExpChat.BubbleChat.Helpers
local getSpringFromSettings = require(Helpers.getSpringFromSettings)
local getTextBounds = require(Helpers.getTextBounds)
local getDictFromBubbleChatMessageProperties = require(Helpers.getDictFromBubbleChatMessageProperties)
local shouldSendHighFrequencyTelemetry = require(ExpChat.shouldSendHighFrequencyTelemetry)
local ClientSettingsUtility = require(ExpChat.ClientSettings.ClientSettingsUtility)
local getFFlagExpChatUseUpdatedMessageRendered = require(ExpChat.Flags.getFFlagExpChatUseUpdatedMessageRendered)
local v19 = require(ExpChat.Flags.getFIntExpChatMessageRenderUserThrottlePermyriad)()
local getFFlagExpChatExcludeFOMORenders = require(ExpChat.Flags.getFFlagExpChatExcludeFOMORenders)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local EngineFeatureExpChatGlobalChatEngineTelemetryEnabled = require(ExpChat.Flags.EngineFeatureExpChatGlobalChatEngineTelemetryEnabled)
local getPresetIconRichText = ExpChatShared.getPresetIconRichText
local getPresetIconSize = ExpChatShared.getPresetIconSize
local isPresetMessage = ExpChatShared.isPresetMessage
local v26 = Roact.Component:extend("ChatBubble")

v26.defaultProps = {
	isMostRecent = true,
	text = "",
	timestamp = 0
}

local v27 = memoize(function(p1, p2) -- line: 43
	-- upvalues: Dictionary (copy), getDictFromBubbleChatMessageProperties (copy)
	if p2 then
		return Dictionary.join(p1, getDictFromBubbleChatMessageProperties(p2))
	end

	return p1
end)

function v26.init(p3) -- line: 54
	-- upvalues: Roact (copy), Otter (copy)
	local v31, v32 = Roact.createBinding(0)

	p3.width = v31
	p3.updateWidth = v32
	p3.widthMotor = Otter.createSingleMotor(0)
	p3.widthMotor:onStep(function(p4) -- line: 57
		-- upvalues: p3 (copy)
		p3.updateWidth((math.round(p4)))
	end)

	local v33, v34 = Roact.createBinding(0)

	p3.height = v33
	p3.updateHeight = v34
	p3.heightMotor = Otter.createSingleMotor(0)
	p3.heightMotor:onStep(function(p5) -- line: 63
		-- upvalues: p3 (copy)
		p3.updateHeight((math.round(p5)))
	end)

	local v35, v36 = Roact.createBinding(1)

	p3.transparency = v35
	p3.updateTransparency = v36
	p3.transparencyMotor = Otter.createSingleMotor(1)
	p3.transparencyMotor:onStep(p3.updateTransparency)

	local v37, v38 = Roact.createBinding(1)

	p3.backgroundTransparency = v37
	p3.updateBackgroundTransparency = v38
	p3.backgroundTransparencyMotor = Otter.createSingleMotor(1)
	p3.backgroundTransparencyMotor:onStep(p3.updateBackgroundTransparency)
	p3.size = Roact.joinBindings({
		p3.width,
		p3.height
	}):map(function(p6) -- line: 75
		return UDim2.fromOffset(p6[1], p6[2])
	end)
end
function v26.render(p7) -- line: 80
	-- upvalues: getEnablePerBubbleCustomization (copy), v27 (copy), Config (copy), FFlagExpChatPresetChatEnabled (copy), isPresetMessage (copy), getFFlagExpChatUseUpdatedMessageRendered (copy), shouldSendHighFrequencyTelemetry (copy), v19 (copy), getFFlagExpChatExcludeFOMORenders (copy), EngineFeatureExpChatGlobalChatEngineTelemetryEnabled (copy), TextChatService (copy), getPresetIconRichText (copy), Roact (copy), Dictionary (copy)
	local chatSettings = p7.props.chatSettings

	if getEnablePerBubbleCustomization() then
		chatSettings = v27(p7.props.chatSettings, p7.props.bubbleChatMessageProperties)
	end

	local UICorner = nil
	local chatSettingsFontFace = nil
	local ImageLabel, UIGradient, UIPadding

	if p7.props.isTextChatServiceOn then
		ImageLabel = chatSettings.ImageLabel
		UIGradient = chatSettings.UIGradient
		UICorner = chatSettings.UICorner
		UIPadding = chatSettings.UIPadding
		chatSettingsFontFace = chatSettings.FontFace
	else
		ImageLabel = chatSettings.BackgroundImage
		UIGradient = chatSettings.BackgroundGradient

		if chatSettings.CornerEnabled then
			UICorner = {
				CornerRadius = chatSettings.CornerRadius
			}
		elseif chatSettings.CornerEnabled == false then
			UICorner = {
				CornerRadius = UDim.new(0, 0)
			}
		end

		UIPadding = chatSettings.Padding and {
			PaddingTop = UDim.new(0, chatSettings.Padding),
			PaddingRight = UDim.new(0, chatSettings.Padding),
			PaddingBottom = UDim.new(0, chatSettings.Padding),
			PaddingLeft = UDim.new(0, chatSettings.Padding)
		} or nil
	end

	local CornerRadius = Config.DefaultBubbleChatChildrenCustomizationProperties.UICorner.CornerRadius
	local UIPadding2 = Config.DefaultBubbleChatChildrenCustomizationProperties.UIPadding
	local v48 = p7.props.renderInsert and p7.props.insertSize.X + chatSettings.Padding or 0
	local v49 = FFlagExpChatPresetChatEnabled and (isPresetMessage(p7.props) and p7.props.isTextChatServiceOn)
	local v50 = p7.props.isMostRecent and (chatSettings.TailVisible and p7.props.showCaret)

	if getFFlagExpChatUseUpdatedMessageRendered() and p7.props.textChatMessageInstance and shouldSendHighFrequencyTelemetry(v19) and (not getFFlagExpChatExcludeFOMORenders() or not p7.props.isHiddenMessage) then
		if EngineFeatureExpChatGlobalChatEngineTelemetryEnabled then
			TextChatService:SendExpChatMessageClientRendered(p7.props.textChatMessageInstance, "bubble_chat", -1)
		else
			TextChatService:SendExpChatMessageClientRendered(p7.props.textChatMessageInstance, "bubble_chat")
		end
	end

	local v51 = nil

	if FFlagExpChatPresetChatEnabled then
		v51 = if not p7.props.useTranslation or (not p7.props.translation or p7.props.translation == "") then p7.props.text else p7.props.translation

		if v49 then
			v51 ..= (" %*"):format((getPresetIconRichText(chatSettings.TextSize)))
		end
	end

	return Roact.createElement("Frame", {
		Transparency = 1,
		LayoutOrder = p7.props.timestamp,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = p7.size,
		Position = UDim2.fromScale(1, 0.5)
	}, {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, -1)
		}),
		ChatBubbleFrame = Roact.createElement("ImageLabel", Dictionary.join(ImageLabel, {
			LayoutOrder = 1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			BackgroundColor3 = chatSettings.BackgroundColor3,
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = if not ImageLabel or ImageLabel.Image == "" then p7.backgroundTransparency or p7.transparency else 1,
			ImageTransparency = p7.backgroundTransparency or p7.transparency
		}), {
			UICorner = UICorner and Roact.createElement("UICorner", {
				CornerRadius = UICorner.CornerRadius
			}) or Roact.createElement("UICorner", {
				CornerRadius = CornerRadius
			}),
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				Padding = UDim.new(0, chatSettings.Padding)
			}),
			Padding = UIPadding and Roact.createElement("UIPadding", UIPadding) or Roact.createElement("UIPadding", UIPadding2),
			Insert = p7.props.renderInsert and p7.props.renderInsert(),
			Text = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				AutoLocalize = false,
				LayoutOrder = 2,
				Text = if FFlagExpChatPresetChatEnabled then v51 else if not p7.props.useTranslation or (not p7.props.translation or p7.props.translation == "") then p7.props.text else p7.props.translation,
				Size = UDim2.new(1, -v48, 1, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				FontFace = chatSettingsFontFace or nil,
				Font = if chatSettingsFontFace then nil else chatSettings.Font,
				TextColor3 = chatSettings.TextColor3,
				TextSize = chatSettings.TextSize,
				TextTransparency = p7.transparency,
				RichText = p7.props.isTextChatServiceOn
			}),
			Gradient = UIGradient ~= nil and Roact.createElement("UIGradient", UIGradient)
		}),
		Caret = if not v50 then nil else Roact.createElement("ImageLabel", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/InGameChat/Caret.png",
			Size = UDim2.fromOffset(9, 6),
			ImageColor3 = chatSettings.BackgroundColor3,
			ImageTransparency = p7.backgroundTransparency
		}, {
			Gradient = UIGradient ~= nil and Roact.createElement("UIGradient", UIGradient)
		})
	})
end
function v26.fadeOut(p8) -- line: 246
	-- upvalues: getEnablePerBubbleCustomization (copy), v27 (copy), getSpringFromSettings (copy)
	local chatSettings = p8.props.chatSettings

	if getEnablePerBubbleCustomization() then
		chatSettings = v27(p8.props.chatSettings, p8.props.bubbleChatMessageProperties)
	end

	if not p8.isFadingOut then
		p8.isFadingOut = true
		p8.transparencyMotor:onComplete(function() -- line: 254
			-- upvalues: p8 (copy)
			if p8.props.onFadeOut then
				p8.props.onFadeOut(p8.props.messageId)
			end
		end)

		local v54 = getSpringFromSettings(chatSettings, "transparency")

		p8.transparencyMotor:setGoal(v54(1))
		p8.backgroundTransparencyMotor:setGoal(v54(1))
	end
end
function v26.didUpdate(p9, p10) -- line: 266
	-- upvalues: getEnablePerBubbleCustomization (copy), v27 (copy), getTextBounds (copy), getSpringFromSettings (copy), FFlagExpChatPresetChatEnabled (copy), isPresetMessage (copy), getPresetIconSize (copy)
	if p9.props.fadingOut then
		p9:fadeOut()
	end

	local chatSettings = p9.props.chatSettings

	if getEnablePerBubbleCustomization() then
		chatSettings = v27(p9.props.chatSettings, p9.props.bubbleChatMessageProperties)
	end

	if p10.text ~= p9.props.text or p10.useTranslation ~= p9.props.useTranslation or p10.translation ~= p9.props.translation or p10.chatSettings ~= p9.props.chatSettings or p10.renderInsert ~= p9.props.renderInsert or p10.insertSize ~= p9.props.insertSize then
		local v58 = if not p9.props.useTranslation or (not p9.props.translation or p9.props.translation == "") then getTextBounds(p9.props.text, chatSettings) else getTextBounds(p9.props.translation, chatSettings)
		local v59 = getSpringFromSettings(chatSettings, "size")
		local chatSettingsPadding = chatSettings.Padding
		local X = v58.X
		local Y = v58.Y

		if p9.props.renderInsert then
			X += p9.props.insertSize.X + chatSettingsPadding
			Y = math.max(Y, p9.props.insertSize.Y + chatSettingsPadding * 2)
		end

		local v63 = FFlagExpChatPresetChatEnabled and (isPresetMessage(p9.props) and p9.props.isTextChatServiceOn)

		if FFlagExpChatPresetChatEnabled and v63 then
			local v64 = getPresetIconSize(chatSettings.TextSize)

			X += v64 + chatSettingsPadding
			Y = math.max(Y, v64)
		end

		p9.heightMotor:setGoal(v59(Y))
		p9.widthMotor:setGoal(v59(X))
	end
end
function v26.didMount(p11) -- line: 311
	-- upvalues: getEnablePerBubbleCustomization (copy), v27 (copy), getTextBounds (copy), getSpringFromSettings (copy), FFlagExpChatPresetChatEnabled (copy), isPresetMessage (copy), getPresetIconSize (copy), Otter (copy), ClientSettingsUtility (copy)
	p11.isMounted = true

	local chatSettings = p11.props.chatSettings

	if getEnablePerBubbleCustomization() then
		chatSettings = v27(p11.props.chatSettings, p11.props.bubbleChatMessageProperties)
	end

	local v67 = if not p11.props.useTranslation or (not p11.props.translation or p11.props.translation == "") then getTextBounds(p11.props.text, chatSettings) else getTextBounds(p11.props.translation, chatSettings)
	local v68 = getSpringFromSettings(chatSettings, "size")
	local v69 = getSpringFromSettings(chatSettings, "transparency")
	local X = v67.X
	local Y = v67.Y

	if p11.props.renderInsert then
		X += p11.props.insertSize.X + chatSettings.Padding
		Y = math.max(Y, p11.props.insertSize.Y + chatSettings.Padding * 2)
	end

	local v72 = FFlagExpChatPresetChatEnabled and (isPresetMessage(p11.props) and p11.props.isTextChatServiceOn)

	if FFlagExpChatPresetChatEnabled and v72 then
		local v73 = getPresetIconSize(chatSettings.TextSize)

		X += v73 + chatSettings.Padding
		Y = math.max(Y, v73)
	end

	if p11.props.isMostRecent then
		p11.heightMotor:setGoal(v68(Y))
		p11.widthMotor:setGoal(Otter.instant(X))
	else
		p11.heightMotor:setGoal(v68(Y))
		p11.widthMotor:setGoal(v68(X))
	end

	local chatSettingsTransparency = chatSettings.Transparency

	p11.transparencyMotor:setGoal(v69(chatSettingsTransparency))

	local v75 = ClientSettingsUtility.getBackgroundTransparency(chatSettings, p11.props.clientSettings)

	if getEnablePerBubbleCustomization() then
		local bubbleChatMessageProperties = p11.props.bubbleChatMessageProperties

		if bubbleChatMessageProperties and bubbleChatMessageProperties.BackgroundTransparency then
			v75 = ClientSettingsUtility.getBackgroundTransparency({
				BackgroundTransparency = bubbleChatMessageProperties.BackgroundTransparency
			}, p11.props.clientSettings)
		end
	end

	p11.backgroundTransparencyMotor:setGoal(v69(v75))
end
function v26.willUnmount(p12) -- line: 370
	p12.isMounted = false
	p12.transparencyMotor:destroy()
	p12.backgroundTransparencyMotor:destroy()
	p12.heightMotor:destroy()
	p12.widthMotor:destroy()
end

return v26
