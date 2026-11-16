local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ecR")
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local module3 = require("@luauforge/bundled/edq")
local module4 = require("@luauforge/bundled/edi")

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle

local function lerp(p2, p3, p4)
	return (1 - p2) * p3 + p2 * p4
end

local function findPosition(parentShape, p2, frameHeight)
	local v5 = parentShape.x + parentShape.width * 0.5
	local v6 = parentShape.y + parentShape.height * 0.5

	local v7 = 0.1 * frameHeight
	local position = {}
	position.pointerHeight = 6
	position.pointerWidth = 12
	position.x = parentShape.x + parentShape.width * 0.5 - p2 * 0.5
	position.pointerX = v5 - position.pointerWidth * 0.5

	if v6 < parentShape.parentHeight * 0.5 then
		position.y = parentShape.y + parentShape.height + position.pointerHeight
		position.height = math.min(parentShape.parentHeight - position.y - 10, frameHeight)

		position.pointerIcon = "LuaApp/dropdown/gr-tip-up"
		position.pointerY = parentShape.y + parentShape.height
		position.menuStartY = position.y
	else
		local v8 = parentShape.y - position.pointerHeight
		position.height = math.min(v8 - 10, frameHeight)
		position.y = v8 - position.height

		position.pointerIcon = "LuaApp/dropdown/gr-tip-down"
		position.pointerY = v8
		position.menuStartY = position.pointerY - v7
	end

	if position.height < frameHeight then
		position.pointerHeight = 12
		position.pointerWidth = 6

		position.height = math.min(parentShape.parentHeight - 20, frameHeight)
		position.y = v6 - position.height * 0.5

		if position.y < 10 then
			position.y = 10
		elseif parentShape.parentHeight - 10 < position.y + position.height then
			position.y = parentShape.parentHeight - 10 - position.height
		end

		position.pointerY = v6 - position.pointerHeight * 0.5
		position.menuStartY = position.pointerY + position.pointerHeight / 2 - v7 / 2

		if v5 <= parentShape.parentWidth * 0.5 then
			position.x = parentShape.x + parentShape.width + position.pointerWidth

			if position.x + p2 > parentShape.parentWidth - 10 then
				position.x = parentShape.parentWidth - p2 - 10
			end

			position.pointerIcon = "LuaApp/dropdown/gr-tip-left"
			position.pointerX = position.x - position.pointerWidth
		else
			position.x = parentShape.x - p2 - position.pointerWidth

			if position.x < 10 then
				position.x = 10
			end

			position.pointerIcon = "LuaApp/dropdown/gr-tip-right"
			position.pointerX = position.x + p2
		end
	elseif position.x < 10 then
		position.x = 10
	elseif position.x + p2 > parentShape.parentWidth - 10 then
		position.x = parentShape.parentWidth - p2 - 10
	end

	position.pointerX += -1
	position.pointerY += -1

	position.pointerWidth += 2
	position.pointerHeight += 2

	return position
end

local extended = module.PureComponent:extend("FramePopOut")

extended.defaultProps = { isAnimated = false }

function extended:init()
	self.state = { hidden = self.props.isAnimated, frameHeight = 0 }

	self.isMounted = false

	self.animationPercentage = self.state.hidden and 0 or 1
	self.stiffness = nil
	self.damping = nil
	self.onRested = nil

	function self.onActivated()
		self:close()
	end

	function self.onSizeChanged(p2)
		spawn(function()
			if self.isMounted then
				self:setState({ frameHeight = p2.AbsoluteSize.Y })
			end
		end)
	end
end

function extended:open()
	if self.state.hidden and self.props.isAnimated then
		self.animationPercentage = 1
		self.stiffness = nil
		self.damping = nil
		self.onRested = nil

		self:setState({ hidden = false })
	end

	self.animationPercentage = 1
	self.stiffness = nil
	self.damping = nil
	self.onRested = nil
	self:setState({ hidden = false })
end

function extended:close()
	local onCancel = self.props.onCancel

	if self.state.hidden or not self.props.isAnimated then
		if not self.props.isAnimated then
			onCancel()
		end
	else
		self.animationPercentage = 0

		self.stiffness = 270
		self.damping = nil
		self.onRested = onCancel

		self:setState({ hidden = true })
	end
end

function extended:didMount()
	self.isMounted = true
	self:open()
end

function extended:willUnmount()
	self.isMounted = false
end

function extended.render(data)
	local v5 = data.props[module.Children]
	local itemWidth = data.props.itemWidth
	local parentShape = data.props.parentShape

	local v6 = data.state.frameHeight == 0 and 0 or itemWidth

	local position = findPosition(parentShape, v6, data.state.frameHeight)

	return withStyle(function(p2)
		return module.createElement("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Text = "",
			Selectable = false,
			[module.Event.Activated] = data.onActivated
		}, {
			Pointer = module.createElement(module4, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				Image = position.pointerIcon,
				ImageColor3 = p2.Theme.BackgroundUIDefault.Color,
				ImageTransparency = p2.Theme.BackgroundUIDefault.Transparency,
				Position = UDim2.new(0, position.pointerX, 0, position.pointerY),
				Size = UDim2.new(0, position.pointerWidth, 0, position.pointerHeight)
			}),
			AnimatedPopout = module.createElement(module3.SimpleMotion, {
				style = {
					animationPercentage = module3.spring(
						data.animationPercentage,
						data.stiffness,
						data.damping
					)
				},
				onRested = function()
					if data.onRested then
						data.onRested()
					end
				end,
				render = function(p3)
					local createElement2 = module.createElement
					local v8 = {
						BorderSizePixel = 0,
						BackgroundColor3 = p2.Theme.BackgroundUIDefault.Color,
						BackgroundTransparency = p2.Theme.BackgroundUIDefault.Transparency,
						Position = 0,
						Size = 0,
						ClipsDescendants = true
					}
					local newUDim2 = UDim2.new

					local x = position.x

					local animationPercentage = p3.animationPercentage
					local menuStartY = position.menuStartY
					local y = position.y
					v8.Position = newUDim2(
						0,
						x,
						0,
						(1 - animationPercentage) * menuStartY + animationPercentage * y
					)

					local newUDim2_2 = UDim2.new

					local animationPercentage2 = p3.animationPercentage
					v8.Size = newUDim2_2(
						0,
						v6,
						0,
						((1 - animationPercentage2) * 0.1 + animationPercentage2 * 1) * data.state.frameHeight
					)
					return createElement2("Frame", v8, {
						Frame = module.createElement(FitChildren.FitFrame, {
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, 0),
							fitAxis = FitChildren.FitAxis.Height,
							ClipsDescendants = false,
							[module.Change.AbsoluteSize] = data.onSizeChanged
						}, v5)
					})
				end
			})
		})
	end)
end

return extended
