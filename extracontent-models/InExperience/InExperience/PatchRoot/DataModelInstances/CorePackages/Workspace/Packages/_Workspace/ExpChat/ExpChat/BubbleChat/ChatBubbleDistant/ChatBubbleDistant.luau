local ExpChat = script:FindFirstAncestor("ExpChat")

local parent = ExpChat.Parent
local Roact = require(parent.Roact)
local Otter = require(parent.Otter)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local Config = require(ExpChat.Config)

local Helpers = ExpChat.BubbleChat.Helpers
local getSpringFromSettings = require(Helpers.getSpringFromSettings)
local getAbsolutePaddingbyDimension = require(Helpers.getAbsolutePaddingbyDimension)
local ClientSettingsUtility = require(ExpChat.ClientSettings.ClientSettingsUtility)

local extended = Roact.Component:extend("ChatBubbleDistant")
extended.defaultProps = { width = 32, height = 16 }

local function getFullHeight(data)
	local height = data.height

	if data.renderInsert then
		height = math.max(height, data.insertSize.Y)
	end

	if data.chatSettings.UIPadding then
		local uiPadding = data.chatSettings.UIPadding
		local absolutePaddingbyDimension = getAbsolutePaddingbyDimension(uiPadding.PaddingTop, height)
		local absolutePaddingbyDimension2 = getAbsolutePaddingbyDimension(uiPadding.PaddingBottom, height)

		if data.renderInsert then
			height = math.max(height, data.insertSize.Y)
		end

		return height + (absolutePaddingbyDimension + absolutePaddingbyDimension2)
	end

	if data.renderInsert then
		height = math.max(height, data.insertSize.Y)
	end

	return height + data.chatSettings.Padding * 2
end

function extended:init()
	self.state = {}

	local binding, updateWidth = Roact.createBinding(0)
	self.width = binding
	self.updateWidth = updateWidth
	self.widthMotor = Otter.createSingleMotor(0)
	self.widthMotor:onStep(function(p)
		self.updateWidth((math.round(p)))
	end)

	local binding2, updateHeight = Roact.createBinding(getFullHeight(self.props))
	self.height = binding2
	self.updateHeight = updateHeight

	self.frameSize = Roact.joinBindings({ self.width, self.height }):map(function(list)
		return UDim2.fromOffset(list[1], list[2])
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

	if self.props.fadingOut then
		self:fadeOut()
	end
end

function extended.getDerivedStateFromProps(data, p)
	local fullWidth

	if data.chatSettings.UIPadding then
		local width = data.width

		if data.renderInsert then
			width += data.insertSize.X
		end

		local uiPadding = data.chatSettings.UIPadding
		fullWidth = width + (getAbsolutePaddingbyDimension(uiPadding.PaddingLeft, width) + getAbsolutePaddingbyDimension(uiPadding.PaddingRight, width))
	elseif data.renderInsert then
		fullWidth = data.width + data.insertSize.X + data.chatSettings.Padding * 2
	else
		fullWidth = data.width + data.chatSettings.Padding * 2
	end

	local fullHeight = getFullHeight(data)

	if fullWidth == p.fullWidth and fullHeight == p.fullHeight then
		return nil
	end

	return { fullWidth = fullWidth, fullHeight = fullHeight }
end

function extended.render(props)
	local chatSettings = props.props.chatSettings

	local v = nil
	local v2, v3, v4, v5

	if props.props.isTextChatServiceOn then
		v2 = chatSettings.ImageLabel
		v3 = chatSettings.UIGradient
		v4 = chatSettings.UICorner
		v5 = chatSettings.UIPadding
	else
		v2 = chatSettings.BackgroundImage

		v3 = chatSettings.BackgroundGradient

		if chatSettings.CornerEnabled then
			v4 = { CornerRadius = chatSettings.CornerRadius }
		else
			v4 = chatSettings.CornerEnabled == false and { CornerRadius = UDim.new(0, 0) } or v
		end

		v5 = chatSettings.Padding
			and ({
				PaddingTop = UDim.new(0, chatSettings.Padding),
				PaddingRight = UDim.new(0, chatSettings.Padding),
				PaddingBottom = UDim.new(0, chatSettings.Padding),
				PaddingLeft = UDim.new(0, chatSettings.Padding)
			} or nil)
			or nil
	end

	local cornerRadius = Config.DefaultBubbleChatChildrenCustomizationProperties.UICorner.CornerRadius
	local uiPadding = Config.DefaultBubbleChatChildrenCustomizationProperties.UIPadding

	local x = props.props.renderInsert and props.props.insertSize.X or 0
	local showCaret = props.props.chatSettings.TailVisible and props.props.showCaret

	local createElement = Roact.createElement
	local v6 = {
		AnchorPoint = Vector2.new(0.5, 1),
		Size = UDim2.fromOffset(props.state.fullWidth, props.state.fullHeight),
		Position = UDim2.new(0.5, 0, 1, -8),
		Transparency = 1
	}

	local v7 = {
		Scale = Roact.createElement("UIScale", { Scale = 0.75 }),
		Carat = 0,
		RoundedFrame = 0
	}

	local carat = props.props.chatSettings.TailVisible

	if carat then
		if showCaret then
			carat = Roact.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 1, -1),
				Size = UDim2.fromOffset(12, 8),
				Image = "rbxasset://textures/ui/InGameChat/Caret.png",
				ImageColor3 = chatSettings.BackgroundColor3,
				ImageTransparency = props.backgroundTransparency
			}, {
				Gradient = v3 ~= nil and Roact.createElement("UIGradient", v3)
			})
		else
			carat = showCaret
		end
	end

	v7.Carat = carat

	v7.RoundedFrame = Roact.createElement("ImageLabel", dictionary.join(v2, {
		Size = props.frameSize,
		BackgroundColor3 = chatSettings.BackgroundColor3,
		BackgroundTransparency = v2 and v2.Image ~= "" and 1 or props.backgroundTransparency or props.transparency,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		ClipsDescendants = true,
		ImageTransparency = props.backgroundTransparency or props.transparency,
		Image = v2 and v2.Image or ""
	}), {
		UICorner = v4 and Roact.createElement("UICorner", { CornerRadius = v4.CornerRadius }) or Roact.createElement("UICorner", {
			CornerRadius = cornerRadius
		}),
		Contents = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1
		}, {
			Padding = v5 and Roact.createElement("UIPadding", v5) or Roact.createElement("UIPadding", uiPadding),
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Insert = props.props.renderInsert and props.props.renderInsert(),
			Ellipsis = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Text = "…",
				TextColor3 = chatSettings.TextColor3,
				TextTransparency = props.transparency,
				Font = Enum.Font.BuilderSansExtraBold,
				TextScaled = false,
				TextSize = chatSettings.TextSize,
				Size = UDim2.new(1, -x, 1, 0),
				LayoutOrder = 2
			})
		}),
		Gradient = v3 ~= nil and Roact.createElement("UIGradient", v3)
	})
	return createElement("Frame", v6, v7)
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
	if p.fadingOut == self.props.fadingOut then
		if self.state.fullHeight ~= p2.fullHeight then
			self.updateHeight(self.state.fullHeight)
		end

		if self.state.fullWidth ~= p2.fullWidth then
			local springFromSettings = getSpringFromSettings(self.props.chatSettings, "size")
			self.widthMotor:setGoal(springFromSettings(self.state.fullWidth))
		end
	elseif self.props.fadingOut then
		self:fadeOut()
	else
		self:fadeIn()
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
