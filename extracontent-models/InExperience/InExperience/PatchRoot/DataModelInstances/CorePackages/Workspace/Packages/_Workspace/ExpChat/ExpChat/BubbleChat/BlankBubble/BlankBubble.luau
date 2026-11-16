local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local llama = require(parent.llama)
local dictionary = llama.Dictionary
local Roact = require(parent.Roact)
local Otter = require(parent.Otter)

local Config = require(ExpChat.Config)

local BubbleChat = script:FindFirstAncestor("BubbleChat")
local getSpringFromSettings = require(BubbleChat.Helpers.getSpringFromSettings)
local ClientSettingsUtility = require(ExpChat.ClientSettings.ClientSettingsUtility)

local extended = Roact.PureComponent:extend("BlankBubble")

function extended:init(p)
	self.state = {}
	local binding, updateWidth = Roact.createBinding(0)
	self.width = binding
	self.updateWidth = updateWidth
	self.widthMotor = Otter.createSingleMotor(0)
	self.widthMotor:onStep(function(p2)
		self.updateWidth((math.round(p2)))
	end)

	self.frameSize = self.width:map(function(p2)
		if self.props.insertSize then
			return UDim2.fromOffset(p2, self.props.insertSize.Y + self.props.chatSettings.Padding * 2)
		end

		return UDim2.fromOffset(p2, 0)
	end)

	local binding2, updateTransparency = Roact.createBinding(1)
	self.transparency = binding2
	self.updateTransparency = updateTransparency
	self.transparencyMotor = Otter.createSingleMotor(1)
	self.transparencyMotor:onStep(self.updateTransparency)

	local binding3, updateBackgroundTransparency = Roact.createBinding(1)
	self.backgroundTransparency = binding3
	self.updateBackgroundTransparency = updateBackgroundTransparency
	self.backgroundTransparencyMotor = Otter.createSingleMotor(1)
	self.backgroundTransparencyMotor:onStep(self.updateBackgroundTransparency)

	if p.fadingOut then
		self:fadeOut()
	end
end

function extended.getDerivedStateFromProps(p, p2)
	local fullWidth = not p.insertSize and 0 or p.insertSize.X + p.chatSettings.Padding * 2

	if fullWidth == p2.fullWidth then
		return nil
	end

	return { fullWidth = fullWidth }
end

function extended.render(props)
	local chatSettings = props.props.chatSettings
	local imageLabel = chatSettings.ImageLabel
	local uiGradient = chatSettings.UIGradient
	local uiCorner = chatSettings.UICorner
	local cornerRadius = Config.DefaultBubbleChatChildrenCustomizationProperties.UICorner.CornerRadius

	local v = not props.props.insertSize and 0 or props.props.insertSize.Y + props.props.chatSettings.Padding * 2

	local createElement = Roact.createElement
	local v2 = {
		AnchorPoint = Vector2.new(0.5, 1),
		Size = UDim2.fromOffset(props.state.fullWidth, v),
		Position = UDim2.new(0.5, 0, 1, -8),
		Transparency = 1
	}

	local v3 = {
		Scale = Roact.createElement("UIScale", {
			Scale = props.props.isDistant and 0.75 or 1
		}),
		Caret = 0,
		RoundedFrame = 0
	}

	local caret = props.props.chatSettings.TailVisible

	if caret then
		caret = Roact.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 1, -1),
			Size = UDim2.fromOffset(12, 8),
			Image = "rbxasset://textures/ui/InGameChat/Caret.png",
			ImageColor3 = chatSettings.BackgroundColor3,
			ImageTransparency = props.backgroundTransparency
		}, {
			Gradient = uiGradient ~= nil and Roact.createElement("UIGradient", uiGradient)
		})
	end

	v3.Caret = caret

	v3.RoundedFrame = Roact.createElement("ImageLabel", dictionary.join(imageLabel, {
		Size = props.frameSize,
		BackgroundColor3 = chatSettings.BackgroundColor3,
		BackgroundTransparency = imageLabel and imageLabel.Image ~= "" and 1 or props.backgroundTransparency or props.transparency,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		ClipsDescendants = true,
		ImageTransparency = props.backgroundTransparency or props.transparency,
		Image = imageLabel and imageLabel.Image or ""
	}), {
		UICorner = uiCorner and Roact.createElement("UICorner", {
			CornerRadius = uiCorner.CornerRadius
		}) or Roact.createElement("UICorner", { CornerRadius = cornerRadius }),
		Contents = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1
		}, {
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, props.props.chatSettings.Padding),
				PaddingRight = UDim.new(0, props.props.chatSettings.Padding),
				PaddingBottom = UDim.new(0, props.props.chatSettings.Padding),
				PaddingLeft = UDim.new(0, props.props.chatSettings.Padding)
			}),
			Insert = props.props.renderInsert and props.props.renderInsert()
		}),
		Gradient = uiGradient ~= nil and Roact.createElement("UIGradient", uiGradient)
	})
	return createElement("Frame", v2, v3)
end

function extended:fadeIn()
	local springFromSettings = getSpringFromSettings(self.props.chatSettings, "transparency")

	self.transparencyMotor:setGoal(springFromSettings(self.props.chatSettings.Transparency))

	local backgroundTransparency = ClientSettingsUtility.getBackgroundTransparency(
		self.props.chatSettings,
		self.props.clientSettings
	)

	self.backgroundTransparencyMotor:setGoal(springFromSettings(backgroundTransparency))

	local springFromSettings2 = getSpringFromSettings(self.props.chatSettings, "size")
	self.widthMotor:setGoal(springFromSettings2(self.state.fullWidth))
end

function extended:fadeOut()
	self.transparencyMotor:onComplete(function()
		if self.props.onFadeOut then
			self.props.onFadeOut()
		end
	end)

	local springFromSettings = getSpringFromSettings(self.props.chatSettings, "transparency")
	self.transparencyMotor:setGoal(springFromSettings(1))
	self.backgroundTransparencyMotor:setGoal(springFromSettings(1))
end

function extended:didUpdate(p, p2)
	if p.fadingOut ~= self.props.fadingOut then
		if self.props.fadingOut then
			self:fadeOut()
		else
			self:fadeIn()
		end
	end

	if self.state.fullWidth ~= p2.fullWidth then
		local springFromSettings = getSpringFromSettings(self.props.chatSettings, "size")
		self.widthMotor:setGoal(springFromSettings(self.state.fullWidth))
	end
end

function extended.didMount(data)
	if not data.props.fadingOut then
		local springFromSettings = getSpringFromSettings(data.props.chatSettings, "size")
		local springFromSettings2 = getSpringFromSettings(data.props.chatSettings, "transparency")

		data.transparencyMotor:setGoal(springFromSettings2(data.props.chatSettings.Transparency))

		local backgroundTransparency = ClientSettingsUtility.getBackgroundTransparency(
			data.props.chatSettings,
			data.props.clientSettings
		)

		data.backgroundTransparencyMotor:setGoal(springFromSettings2(backgroundTransparency))

		data.widthMotor:setGoal(springFromSettings(data.state.fullWidth))
	end
end

function extended.willUnmount(data)
	data.transparencyMotor:destroy()

	data.backgroundTransparencyMotor:destroy()

	data.widthMotor:destroy()
end

return extended
