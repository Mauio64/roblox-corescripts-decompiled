local CorePackages = game:GetService("CorePackages")

local Otter = require(CorePackages.Packages.Otter)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)

local parent = script.Parent.Parent
local Types = require(parent.Types)
local getSizeSpringFromSettings = require(parent.Helpers.getSizeSpringFromSettings)
local getTransparencySpringFromSettings = require(parent.Helpers.getTransparencySpringFromSettings)
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts

local CoreGui = game:GetService("CoreGui")
CoreGui:WaitForChild("RobloxGui")

local extended = Roact.PureComponent:extend("ChatBubbleDistant")

extended.validateProps = t.strictInterface({
	width = t.optional(t.number),
	height = t.optional(t.number),
	fadingOut = t.optional(t.boolean),
	onFadeOut = t.optional(t.callback),
	chatSettings = Types.IChatSettings,
	renderInsert = t.optional(t.callback),
	insertSize = t.optional(t.Vector2)
})

extended.defaultProps = { width = 32, height = 16 }

local function getFullHeight(data) -- 2 equivalent calls inferred from this helper
	local height = data.height

	if data.renderInsert then
		height = math.max(height, data.insertSize.Y)
	end

	return height + data.chatSettings.Padding * 2
end

function extended:init(data)
	local binding, updateWidth = Roact.createBinding(0)
	self.width = binding
	self.updateWidth = updateWidth
	self.widthMotor = Otter.createSingleMotor(0)
	self.widthMotor:onStep(function(p)
		self.updateWidth((math.round(p)))
	end)

	local binding2, updateHeight = Roact.createBinding(getFullHeight(data)) -- inferred equivalent call
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

	if data.fadingOut then
		self:fadeOut()
	end
end

function extended.getDerivedStateFromProps(data, p)
	local chatSettings = data.chatSettings
	local fullWidth

	if data.renderInsert then
		fullWidth = data.width + data.insertSize.X + chatSettings.Padding * 2
	else
		fullWidth = data.width + chatSettings.Padding * 2
	end

	local fullHeight = getFullHeight(data) -- inferred equivalent call

	if fullWidth == p.fullWidth and fullHeight == p.fullHeight then
		return nil
	end

	return { fullWidth = fullWidth, fullHeight = fullHeight }
end

function extended.render(props)
	local chatSettings = props.props.chatSettings
	local backgroundImage = chatSettings.BackgroundImage
	local backgroundGradient = chatSettings.BackgroundGradient

	local x = props.props.renderInsert and props.props.insertSize.X or 0

	return Roact.createElement(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5, 1),
			Size = UDim2.fromOffset(props.state.fullWidth, props.state.fullHeight),
			Position = UDim2.new(0.5, 0, 1, -8),
			Transparency = 1
		},
		{
			Scale = Roact.createElement("UIScale", { Scale = 0.75 }),
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
						Font = AppFonts.default:getBlack(),
						TextScaled = true,
						Size = UDim2.new(1, -x, 1, 0),
						LayoutOrder = 2
					})
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
		return
	end

	if self.state.fullHeight ~= p.fullHeight then
		self.updateHeight(self.state.fullHeight)
	end

	if self.state.fullWidth ~= p.fullWidth then
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
