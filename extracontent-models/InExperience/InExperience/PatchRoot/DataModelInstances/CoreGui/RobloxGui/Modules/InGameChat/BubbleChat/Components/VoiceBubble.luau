local CorePackages = game:GetService("CorePackages")

local Otter = require(CorePackages.Packages.Otter)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)

local parent = script.Parent.Parent
local Types = require(parent.Types)
local getSizeSpringFromSettings = require(parent.Helpers.getSizeSpringFromSettings)
local getTransparencySpringFromSettings = require(parent.Helpers.getTransparencySpringFromSettings)

local CoreGui = game:GetService("CoreGui")
CoreGui:WaitForChild("RobloxGui")

local extended = Roact.PureComponent:extend("VoiceBubble")

extended.validateProps = t.strictInterface({
	fadingOut = t.optional(t.boolean),
	onFadeOut = t.optional(t.callback),
	chatSettings = Types.IChatSettings,
	renderInsert = t.optional(t.callback),
	insertSize = t.optional(t.Vector2),
	isDistant = t.optional(t.boolean)
})

function extended:init(p)
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

	if p.fadingOut then
		self:fadeOut()
	end
end

function extended.getDerivedStateFromProps(p, p2)
	local chatSettings = p.chatSettings

	local fullWidth = not p.insertSize and 0 or p.insertSize.X + chatSettings.Padding * 2

	if fullWidth == p2.fullWidth then
		return nil
	end

	return { fullWidth = fullWidth }
end

function extended.render(props)
	local chatSettings = props.props.chatSettings
	local backgroundImage = chatSettings.BackgroundImage
	local backgroundGradient = chatSettings.BackgroundGradient

	local v = not props.props.insertSize and 0 or props.props.insertSize.Y + chatSettings.Padding * 2

	return Roact.createElement(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5, 1),
			Size = UDim2.fromOffset(props.state.fullWidth, v),
			Position = UDim2.new(0.5, 0, 1, -8),
			Transparency = 1
		},
		{
			Scale = Roact.createElement("UIScale", {
				Scale = props.props.isDistant and 0.75 or 1
			}),
			Carat = chatSettings.TailVisible and Roact.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 1, -1),
				Size = UDim2.fromOffset(12, 8),
				Image = "rbxasset://textures/ui/InGameChat/Caret.png",
				ImageColor3 = chatSettings.BackgroundColor3,
				ImageTransparency = props.transparency
			}),
			RoundedFrame = Roact.createElement("ImageLabel", Cryo.Dictionary.join(backgroundImage, {
				Size = props.frameSize,
				BackgroundColor3 = chatSettings.BackgroundColor3,
				BackgroundTransparency = backgroundImage.Image == "" and props.transparency or 1,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				ClipsDescendants = true,
				ImageTransparency = props.transparency
			}), {
				UICorner = chatSettings.CornerEnabled and Roact.createElement("UICorner", {
					CornerRadius = chatSettings.CornerRadius
				}),
				Contents = Roact.createElement("Frame", {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, chatSettings.Padding),
						PaddingRight = UDim.new(0, chatSettings.Padding),
						PaddingBottom = UDim.new(0, chatSettings.Padding),
						PaddingLeft = UDim.new(0, chatSettings.Padding)
					}),
					Insert = props.props.renderInsert and props.props.renderInsert()
				}),
				Gradient = backgroundGradient.Enabled and Roact.createElement("UIGradient", backgroundGradient)
			})
		}
	)
end

function extended:fadeOut()
	if not self.isFadingOut then
		self.isFadingOut = true

		self.transparencyMotor:onComplete(function()
			if self.props.onFadeOut then
				self.props.onFadeOut()
			end
		end)

		local transparencySpringFromSettings = getTransparencySpringFromSettings(self.props.chatSettings)
		self.transparencyMotor:setGoal(transparencySpringFromSettings(1))
	end
end

function extended:didUpdate(_, p)
	if self.props.fadingOut then
		self:fadeOut()
	elseif self.state.fullWidth ~= p.fullWidth then
		local sizeSpringFromSettings = getSizeSpringFromSettings(self.props.chatSettings)
		self.widthMotor:setGoal(sizeSpringFromSettings(self.state.fullWidth))
	end
end

function extended.didMount(data)
	if not data.props.fadingOut then
		local chatSettings = data.props.chatSettings
		local sizeSpringFromSettings = getSizeSpringFromSettings(chatSettings)
		local transparencySpringFromSettings = getTransparencySpringFromSettings(chatSettings)

		data.transparencyMotor:setGoal(transparencySpringFromSettings(data.props.chatSettings.Transparency))
		data.widthMotor:setGoal(sizeSpringFromSettings(data.state.fullWidth))
	end
end

function extended.willUnmount(p)
	p.transparencyMotor:destroy()
	p.widthMotor:destroy()
end

return extended
