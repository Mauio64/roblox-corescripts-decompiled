local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Roact = require(parent.Roact)
local ReactIs = require(parent.ReactIs)
local Otter = require(parent.Otter)
local MessageEffect = require(ExpChat.MessageEffects.MessageEffect)

local RunService = game:GetService("RunService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local BubbleChat = script:FindFirstAncestor("BubbleChat")
local getSpringFromSettings = require(BubbleChat.Helpers.getSpringFromSettings)
local sendBubbleChatRenderedTelemetry = require(BubbleChat.Helpers.sendBubbleChatRenderedTelemetry)
local getBorderlessBubbleChatAnimation = require(BubbleChat.Helpers.getBorderlessBubbleChatAnimation)
local getServerTimeNowMillis = require(BubbleChat.Helpers.getServerTimeNowMillis)

local v = { MessageEffect.BorderlessBubbleChat }

local function getScale(flag: boolean): number -- 1 equivalent call inferred from this helper
	return if flag then 0.75 else 1
end

local function combineTransparencies(p: number, p2: number) -- 3 equivalent calls inferred from this helper
	return 1 - (1 - p) * (1 - p2)
end

local extended = Roact.Component:extend("BorderlessBubbleChat")
extended.defaultProps = { text = "", timestamp = 0, isDistant = false, distanceTransparency = 0 }

function extended:init()
	local binding, updateAnimation = Roact.createBinding(self:getAnimation())
	self.animation = binding
	self.updateAnimation = updateAnimation
	self.animationConnection = nil

	local binding2, updateTransparency = Roact.createBinding(0)
	self.transparency = binding2
	self.updateTransparency = updateTransparency
	self.transparencyMotor = Otter.createSingleMotor(0)
	self.transparencyMotor:onStep(self.updateTransparency)

	self.animatedTransparency = Roact.joinBindings({ self.transparency, self.animation }):map(function(list)
		return combineTransparencies(list[1], list[2].transparency) -- inferred equivalent call
	end)

	self.textPosition = self.animation:map(function(p)
		return UDim2.new(0.5, 0, 1, p.yOffset)
	end)

	self.animationScale = self.animation:map(function(p)
		return p.scale
	end)
end

function extended:getAnimation()
	local borderlessBubbleChatAnimation = getBorderlessBubbleChatAnimation((getServerTimeNowMillis() - self.props.receivedAtMillis) / 1000)

	if UserGameSettings.ReducedMotion then
		borderlessBubbleChatAnimation.scale = 1
		borderlessBubbleChatAnimation.yOffset = 0
	end

	return borderlessBubbleChatAnimation
end

function extended:stopAnimating()
	if self.animationConnection then
		self.animationConnection:Disconnect()
		self.animationConnection = nil
	end
end

function extended.render(props)
	if props.props.textChatMessageInstance then
		sendBubbleChatRenderedTelemetry(props.props.textChatMessageInstance, v)
	end

	local distanceTransparency = props.props.distanceTransparency
	local textTransparency

	if ReactIs.isBinding(distanceTransparency) then
		textTransparency = Roact.joinBindings({ props.animatedTransparency, distanceTransparency }):map(function(list)
			return combineTransparencies(list[1], list[2]) -- inferred equivalent call
		end)
	else
		textTransparency = props.animatedTransparency:map(function(p)
			return combineTransparencies(p, distanceTransparency) -- inferred equivalent call
		end)
	end

	local createElement = Roact.createElement
	local v2 = {
		LayoutOrder = props.props.timestamp,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.fromScale(0.5, 1),
		Size = UDim2.fromOffset(48, 48),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local createElement2 = Roact.createElement
	local scale

	if ReactIs.isBinding(props.props.isDistant) then
		scale = props.props.isDistant:map(getScale)
	else
		scale = getScale(props.props.isDistant) -- inferred equivalent call
	end

	return createElement("Frame", v2, {
		Scale = createElement2("UIScale", { Scale = scale }),
		Text = Roact.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 1),
			Position = props.textPosition,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.fromOffset(0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = props.props.text,
			TextSize = 48,
			TextTransparency = textTransparency,
			AutoLocalize = false
		}, {
			AnimationScale = Roact.createElement("UIScale", { Scale = props.animationScale })
		})
	})
end

function extended:reportFadeOut()
	if self.props.onFadeOut then
		self.props.onFadeOut(self.props.messageId)
	end
end

function extended:fadeOut()
	if self.isFadingOut then
		return
	end

	self.isFadingOut = true

	if self:getAnimation().isComplete then
		self:reportFadeOut()
		return
	end

	self.transparencyMotor:onComplete(function()
		self:reportFadeOut()
	end)

	local springFromSettings = getSpringFromSettings(self.props.chatSettings, "transparency")
	self.transparencyMotor:setGoal(springFromSettings(1))
end

function extended:didMount()
	if not self.animation:getValue().isComplete then
		self.animationConnection = RunService.RenderStepped:Connect(function()
			local animation = self:getAnimation()
			self.updateAnimation(animation)

			if animation.isComplete then
				self:stopAnimating()
			end
		end)
	end

	if self.props.fadingOut then
		self:fadeOut()
	end
end

function extended:didUpdate()
	if self.props.fadingOut then
		self:fadeOut()
	end
end

function extended:willUnmount()
	self:stopAnimating()
	self.transparencyMotor:destroy()
end

return extended
