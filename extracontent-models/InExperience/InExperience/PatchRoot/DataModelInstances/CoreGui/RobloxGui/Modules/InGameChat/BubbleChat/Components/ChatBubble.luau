local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local TextChatService = game:GetService("TextChatService")
local Otter = require(CorePackages.Packages.Otter)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local ParentParent = script.Parent.Parent
local Types = require(ParentParent.Types)
local getSizeSpringFromSettings = require(ParentParent.Helpers.getSizeSpringFromSettings)
local getTransparencySpringFromSettings = require(ParentParent.Helpers.getTransparencySpringFromSettings)
local CoreGui = game:GetService("CoreGui")
local v14 = Roact.PureComponent:extend("ChatBubble")

v14.validateProps = t.strictInterface({
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
v14.defaultProps = {
	theme = "Light",
	isMostRecent = true
}

local function initMockSizingLabel() -- line: 41
	-- upvalues: CoreGui (copy)
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Enabled = false
	ScreenGui.Name = "RichTextSizingLabel"

	local TextLabel = Instance.new("TextLabel")

	TextLabel.TextWrapped = true
	TextLabel.RichText = true
	TextLabel.Parent = ScreenGui
	ScreenGui.Parent = CoreGui

	return TextLabel
end

function v14.init(p1) -- line: 53
	-- upvalues: Roact (copy), Otter (copy), TextChatService (copy)
	local v20, v21 = Roact.createBinding(0)

	p1.width = v20
	p1.updateWidth = v21
	p1.widthMotor = Otter.createSingleMotor(0)
	p1.widthMotor:onStep(function(p2) -- line: 56
		-- upvalues: p1 (copy)
		p1.updateWidth((math.round(p2)))
	end)

	local v22, v23 = Roact.createBinding(0)

	p1.height = v22
	p1.updateHeight = v23
	p1.heightMotor = Otter.createSingleMotor(0)
	p1.heightMotor:onStep(function(p3) -- line: 62
		-- upvalues: p1 (copy)
		p1.updateHeight((math.round(p3)))
	end)

	local v24, v25 = Roact.createBinding(1)

	p1.transparency = v24
	p1.updateTransparency = v25
	p1.transparencyMotor = Otter.createSingleMotor(1)
	p1.transparencyMotor:onStep(p1.updateTransparency)
	p1.size = Roact.joinBindings({
		p1.width,
		p1.height
	}):map(function(p4) -- line: 70
		return UDim2.fromOffset(p4[1], p4[2])
	end)
	p1.mockSizingLabel = nil
	p1.isRichTextEnabled = TextChatService.ChatVersion == Enum.ChatVersion.TextChatService
end
function v14.getBoundsFromSizingLabel(_, p6, p7, p8, p9) -- line: 79
	-- upvalues: CoreGui (copy)
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Enabled = false
	ScreenGui.Name = "RichTextSizingLabel"

	local TextLabel = Instance.new("TextLabel")

	TextLabel.TextWrapped = true
	TextLabel.RichText = true
	TextLabel.Parent = ScreenGui
	ScreenGui.Parent = CoreGui
	TextLabel.Text = p6
	TextLabel.TextSize = p7
	TextLabel.Font = p8
	TextLabel.Size = UDim2.fromOffset(p9.X, p9.Y)

	local TextBounds = TextLabel.TextBounds

	TextLabel.Parent:Destroy()

	return TextBounds
end
function v14.getTextBounds(p10) -- line: 92
	-- upvalues: TextService (copy)
	local chatSettings = p10.props.chatSettings
	local vector2 = Vector2.new(chatSettings.Padding * 4, chatSettings.Padding * 2)

	Vector2.new(0, 0)

	return ((if not p10.isRichTextEnabled then TextService:GetTextSize(p10.props.text, chatSettings.TextSize, chatSettings.Font, Vector2.new(chatSettings.MaxWidth, 10000)) else p10:getBoundsFromSizingLabel(p10.props.text, chatSettings.TextSize, chatSettings.Font, Vector2.new(chatSettings.MaxWidth, 10000)))) + vector2
end
function v14.render(p11) -- line: 116
	-- upvalues: Roact (copy), Cryo (copy)
	local chatSettings = p11.props.chatSettings
	local BackgroundImage = chatSettings.BackgroundImage
	local BackgroundGradient = chatSettings.BackgroundGradient
	local v41 = p11.props.renderInsert and p11.props.insertSize.X + chatSettings.Padding or 0

	return Roact.createElement("Frame", {
		Transparency = 1,
		LayoutOrder = p11.props.timestamp,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = p11.size,
		Position = UDim2.fromScale(1, 0.5)
	}, {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, -1)
		}),
		Frame = Roact.createElement("ImageLabel", Cryo.Dictionary.join(BackgroundImage, {
			LayoutOrder = 1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			BackgroundColor3 = chatSettings.BackgroundColor3,
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = if BackgroundImage.Image == "" then p11.transparency else 1,
			ImageTransparency = p11.transparency
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
			Insert = p11.props.renderInsert and p11.props.renderInsert(),
			Text = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				AutoLocalize = false,
				LayoutOrder = 2,
				Text = p11.props.text,
				Size = UDim2.new(1, -v41, 1, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Font = chatSettings.Font,
				TextColor3 = chatSettings.TextColor3,
				TextSize = chatSettings.TextSize,
				TextTransparency = p11.transparency,
				RichText = p11.isRichTextEnabled
			}),
			Gradient = BackgroundGradient.Enabled and Roact.createElement("UIGradient", BackgroundGradient)
		}),
		Carat = p11.props.isMostRecent and (chatSettings.TailVisible and (p11.props.showCarat and Roact.createElement("ImageLabel", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/InGameChat/Caret.png",
			Size = UDim2.fromOffset(9, 6),
			ImageColor3 = chatSettings.BackgroundColor3,
			ImageTransparency = p11.transparency
		})))
	})
end
function v14.fadeOut(p12) -- line: 205
	-- upvalues: getTransparencySpringFromSettings (copy)
	if not p12.isFadingOut then
		p12.isFadingOut = true
		p12.transparencyMotor:onComplete(function() -- line: 209
			-- upvalues: p12 (copy)
			if p12.props.onFadeOut then
				p12.props.onFadeOut(p12.props.messageId)
			end
		end)

		local v43 = getTransparencySpringFromSettings(p12.props.chatSettings)

		p12.transparencyMotor:setGoal(v43(1))
	end
end
function v14.didUpdate(p13, p14) -- line: 220
	-- upvalues: getSizeSpringFromSettings (copy)
	if p13.props.fadingOut then
		p13:fadeOut()
	end

	if p14.text ~= p13.props.text or p14.chatSettings ~= p13.props.chatSettings or p14.renderInsert ~= p13.props.renderInsert or p14.insertSize ~= p13.props.insertSize then
		local v46 = p13:getTextBounds()
		local v47 = getSizeSpringFromSettings(p13.props.chatSettings)
		local chatSettingsPadding = p13.props.chatSettings.Padding
		local X = v46.X
		local Y = v46.Y

		if p13.props.renderInsert then
			X += p13.props.insertSize.X + chatSettingsPadding
			Y = math.max(Y, p13.props.insertSize.Y + chatSettingsPadding * 2)
		end

		p13.heightMotor:setGoal(v47(Y))
		p13.widthMotor:setGoal(v47(X))
	end
end
function v14.didMount(p15) -- line: 247
	-- upvalues: getSizeSpringFromSettings (copy), getTransparencySpringFromSettings (copy), Otter (copy)
	p15.isMounted = true

	local v52 = p15:getTextBounds()
	local chatSettings = p15.props.chatSettings
	local v54 = getSizeSpringFromSettings(chatSettings)
	local v55 = getTransparencySpringFromSettings(chatSettings)
	local X = v52.X
	local Y = v52.Y

	if p15.props.renderInsert then
		X += p15.props.insertSize.X + chatSettings.Padding
		Y = math.max(Y, p15.props.insertSize.Y + chatSettings.Padding * 2)
	end

	if p15.props.isMostRecent then
		p15.heightMotor:setGoal(v54(Y))
		p15.widthMotor:setGoal(Otter.instant(X))
	else
		p15.heightMotor:setGoal(v54(Y))
		p15.widthMotor:setGoal(v54(X))
	end

	p15.transparencyMotor:setGoal(v55(chatSettings.Transparency))
end
function v14.willUnmount(p16) -- line: 275
	p16.isMounted = false
	p16.transparencyMotor:destroy()
	p16.heightMotor:destroy()
	p16.widthMotor:destroy()
end

local function mapStateToProps(p17, p18) -- line: 282
	local v61 = p17.messages[p18.messageId]

	return {
		text = v61 and v61.text or "",
		timestamp = v61 and v61.timestamp or 0
	}
end

return RoactRodux.connect(mapStateToProps)(v14)
