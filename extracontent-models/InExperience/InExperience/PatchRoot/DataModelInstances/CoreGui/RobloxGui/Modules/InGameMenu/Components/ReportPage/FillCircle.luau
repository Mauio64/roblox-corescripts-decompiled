local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox

local parent = script.Parent.Parent.Parent

local Assets = require(parent.Resources.Assets)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local Foundation = require(CorePackages.Packages.Foundation)
local Image = Foundation.Image
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation

local color = Color3.fromRGB(98, 98, 99)
local color2 = Color3.fromRGB(255, 255, 255)
local color3 = Color3.fromRGB(196, 0, 1)

local extended = Roact.PureComponent:extend("FillCircle")

extended.validateProps = t.strictInterface({
	Position = t.UDim2,
	AnchorPoint = t.Vector2,
	fillFraction = t.number,
	largerCircleFraction = t.number,
	popCircleFraction = t.number,
	shakeCircleFraction = t.number,
	BackgroundColor = t.Color3
})

local function getFillRingZIndex(fillFraction): number -- 1 equivalent arithmetic call inferred from this helper
	if fillFraction > 0.75 then
		return 8
	end

	if fillFraction > 0.5 then
		return 6
	end

	if fillFraction > 0.25 then
		return 4
	end

	return if fillFraction > 0 then 2 else 0
end

local function linearTween(p, p2, p3)
	local v = (p3 - p2) / 30
	return (p - p2 / 30) / v
end

local function isBetweenFrames(p, p2, p3): boolean
	return p2 / 30 <= p and p <= p3 / 30
end

local function largerCircleAnimation(p, p2, p3, callback)
	if p3 then
		p = 4 / 15 - p
	end

	local v

	if p >= 0 then
		v = p <= 1 / 6
	else
		v = false
	end

	if v then
		local v2 = 16 + 6 * ((p - 0) / (1 / 6))
		p2.size(UDim2.new(0, v2, 0, v2))
	else
		local v2

		if p >= 1 / 6 then
			v2 = p <= 4 / 15
		else
			v2 = false
		end

		if v2 then
			local v3 = 22 - 2 * ((p - 1 / 6) / 0.1)
			p2.size(UDim2.new(0, v3, 0, v3))
		else
			if p < 0 then
				p2.size(UDim2.new(0, 16, 0, 16))
			else
				p2.size(UDim2.new(0, 20, 0, 20))
			end

			callback()
		end
	end
end

local function popCircleAnimation(p, p2, _, callback)
	local v

	if p >= 0 then
		v = p <= 0.1
	else
		v = false
	end

	if v then
		local v2 = 20 + 4 * ((p - 0) / 0.1)
		p2.size(UDim2.new(0, v2, 0, v2))
	else
		local v2

		if p >= 0.1 then
			v2 = p <= 0.2
		else
			v2 = false
		end

		if v2 then
			local v3 = 24 - 4 * ((p - 0.1) / 0.1)
			p2.size(UDim2.new(0, v3, 0, v3))
		else
			p2.size(UDim2.new(0, 20, 0, 20))
			callback()
		end
	end
end

local function shakeCircleAnimation(p, p2, _, callback)
	local v

	if p >= 0 then
		v = p <= 0.1
	else
		v = false
	end

	if v then
		local v2 = (p - 0) / 0.1

		p2.positionOffset(UDim2.new(0, -4 * v2, 0, 0))
	else
		local v2

		if p >= 0.1 then
			v2 = p <= 0.2
		else
			v2 = false
		end

		if v2 then
			local v3 = (p - 0.1) / 0.1

			p2.positionOffset(UDim2.new(0, -4 + 12 * v3, 0, 0))
		else
			local v3

			if p >= 0.2 then
				v3 = p <= 4 / 15
			else
				v3 = false
			end

			if v3 then
				local v4 = (p - 0.2) / (1 / 15)

				p2.positionOffset(UDim2.new(0, 8 - 16 * v4, 0, 0))
			else
				local v4

				if p >= 4 / 15 then
					v4 = p <= 1 / 3
				else
					v4 = false
				end

				if v4 then
					local v5 = (p - 4 / 15) / (1 / 15)

					p2.positionOffset(UDim2.new(0, -8 + 16 * v5, 0, 0))
				else
					local v5

					if p >= 1 / 3 then
						v5 = p <= 0.4
					else
						v5 = false
					end

					if v5 then
						local v6 = (p - 1 / 3) / (1 / 15)

						p2.positionOffset(UDim2.new(0, 8 - 16 * v6, 0, 0))
					else
						local v6

						if p >= 0.4 then
							v6 = p <= 7 / 15
						else
							v6 = false
						end

						if v6 then
							local v7 = (p - 0.4) / (1 / 15)

							p2.positionOffset(UDim2.new(0, -8 + 8 * v7, 0, 0))
						else
							p2.positionOffset(UDim2.new(0, 0, 0, 0))
							callback()
						end
					end
				end
			end
		end
	end
end

function extended:init()
	local binding, sizeBindingUpdate = Roact.createBinding(UDim2.new(0, 16, 0, 16))
	self.sizeBinding = binding
	self.sizeBindingUpdate = sizeBindingUpdate

	self.largerSizeBinding = self.sizeBinding:map(function(p)
		return p + UDim2.new(0, 2, 0, 2)
	end)

	local binding2, positionOffsetBindingUpdate = Roact.createBinding(UDim2.new(0, 0, 0, 0))
	self.positionOffsetBinding = binding2
	self.positionOffsetBindingUpdate = positionOffsetBindingUpdate

	self.updateBindings = {
		size = self.sizeBindingUpdate,
		positionOffset = self.positionOffsetBindingUpdate
	}

	self.animationStartTime = nil
	self.animationFunction = nil
	self.reverseAnimation = false
	self.renderSteppedConnection = nil
end

function extended.render(props)
	local props2 = props.props

	local v = props2.fillFraction >= 1 and color3 or color2

	local createElement = Roact.createElement
	local v2 = {
		Size = props.sizeBinding,
		Position = props2.Position,
		AnchorPoint = props2.AnchorPoint,
		BackgroundTransparency = 1
	}

	local createElement2 = Roact.createElement
	local v3 = {
		Position = props.positionOffsetBinding,
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = color
	}
	local outerRing

	if FFlagCoreUiMigrateUIBloxToFoundation then
		outerRing = Roact.createElement(Image, {
			Image = Assets.Images.CircleCutout,
			Size = UDim2.new(1, 0, 1, 0),
			imageStyle = { Color3 = props2.BackgroundColor, Transparency = 0 },
			ZIndex = 10
		})
	else
		outerRing = Roact.createElement(ImageSetLabel, {
			Image = Assets.Images.CircleCutout,
			Size = UDim2.new(1, 0, 1, 0),
			ImageColor3 = props2.BackgroundColor,
			BackgroundTransparency = 1,
			ZIndex = 10
		})
	end

	local innerRing

	if FFlagCoreUiMigrateUIBloxToFoundation then
		innerRing = Roact.createElement(Image, {
			Image = Assets.Images.Circle,
			Size = UDim2.new(1, -4, 1, -4),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			imageStyle = { Color3 = props2.BackgroundColor, Transparency = 0 },
			ZIndex = 10
		})
	else
		innerRing = Roact.createElement(ImageSetLabel, {
			Image = Assets.Images.Circle,
			Size = UDim2.new(1, -4, 1, -4),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageColor3 = props2.BackgroundColor,
			BackgroundTransparency = 1,
			ZIndex = 10
		})
	end

	local createElement3 = Roact.createElement
	local v4 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Rotation = props2.fillFraction * 360,
		ZIndex = getFillRingZIndex(props2.fillFraction) -- inferred equivalent call
	}
	local fillRing

	if FFlagCoreUiMigrateUIBloxToFoundation then
		fillRing = Roact.createElement(Image, {
			Image = Assets.Images.QuarterCircle,
			Size = props.largerSizeBinding,
			AnchorPoint = Vector2.new(0.5, 0.5),
			imageStyle = { Color3 = v, Transparency = 0 }
		})
	else
		fillRing = Roact.createElement(ImageSetLabel, {
			Image = Assets.Images.QuarterCircle,
			Size = props.largerSizeBinding,
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageColor3 = v,
			BackgroundTransparency = 1
		})
	end

	return createElement("Frame", v2, {
		PositionOffsetFrame = createElement2("Frame", v3, {
			OuterRing = outerRing,
			InnerRing = innerRing,
			FillRingRotationFrame = createElement3("Frame", v4, { FillRing = fillRing }),
			EdgeBlockers = Roact.createElement(
				"Frame",
				{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 10 },
				{
					Top = Roact.createElement("Frame", {
						AnchorPoint = Vector2.new(0.5, 1),
						Position = UDim2.new(0.5, 0, 0, 0),
						Size = UDim2.new(1, 4, 0, 2),
						BackgroundColor3 = props2.BackgroundColor,
						BorderSizePixel = 0
					}),
					Right = Roact.createElement("Frame", {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(1, 0, 0.5, 0),
						Size = UDim2.new(0, 2, 1, 4),
						BackgroundColor3 = props2.BackgroundColor,
						BorderSizePixel = 0
					}),
					Bottom = Roact.createElement("Frame", {
						AnchorPoint = Vector2.new(0.5, 0),
						Position = UDim2.new(0.5, 0, 1, 0),
						Size = UDim2.new(1, 4, 0, 2),
						BackgroundColor3 = props2.BackgroundColor,
						BorderSizePixel = 0
					}),
					Left = Roact.createElement("Frame", {
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(0, 0, 0.5, 0),
						Size = UDim2.new(0, 2, 1, 4),
						BackgroundColor3 = props2.BackgroundColor,
						BorderSizePixel = 0
					})
				}
			),
			TopLeftFill = Roact.createElement("Frame", {
				Size = UDim2.new(0.5, 0, 0.5, 0),
				BackgroundColor3 = props2.fillFraction >= 1 and v or color,
				BorderSizePixel = 0,
				ZIndex = props2.fillFraction >= 1 and 9 or 7
			}),
			BottomLeftFill = Roact.createElement("Frame", {
				Size = UDim2.new(0.5, 0, 0.5, 0),
				Position = UDim2.new(0, 0, 0.5, 0),
				BackgroundColor3 = props2.fillFraction >= 0.75 and v or color,
				BorderSizePixel = 0,
				ZIndex = props2.fillFraction >= 0.75 and 9 or 5
			}),
			BottomRightFill = Roact.createElement("Frame", {
				Size = UDim2.new(0.5, 0, 0.5, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BackgroundColor3 = props2.fillFraction >= 0.5 and v or color,
				BorderSizePixel = 0,
				ZIndex = props2.fillFraction >= 0.5 and 9 or 3
			}),
			TopRightFill = Roact.createElement("Frame", {
				Size = UDim2.new(0.5, 0, 0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				BackgroundColor3 = props2.fillFraction >= 0.25 and v or color,
				BorderSizePixel = 0,
				ZIndex = props2.fillFraction >= 0.25 and 9 or 1
			})
		})
	})
end

function extended:didUpdate(data, _)
	local v = data.fillFraction >= data.largerCircleFraction
	local v2 = self.props.fillFraction >= self.props.largerCircleFraction

	if v ~= v2 then
		self:playAnimation(largerCircleAnimation, not v2)
	end

	local v3 = data.fillFraction >= data.popCircleFraction

	if self.props.fillFraction >= self.props.popCircleFraction and not v3 then
		self:playAnimation(popCircleAnimation, false)
	end

	local v4 = data.fillFraction >= data.shakeCircleFraction

	if self.props.fillFraction >= self.props.shakeCircleFraction and not v4 then
		self:playAnimation(shakeCircleAnimation, false)
	end
end

function extended:playAnimation(animationFunction, reverseAnimation)
	if self.animationFunction then
		self.animationFunction(100, self.updateBindings, self.reverseAnimation, function() end)
	end

	self.animationStartTime = tick()
	self.animationFunction = animationFunction
	self.reverseAnimation = reverseAnimation

	if not self.renderSteppedConnection then
		self.renderSteppedConnection = RunService.RenderStepped:Connect(function()
			self.animationFunction(
				tick() - self.animationStartTime,
				self.updateBindings,
				self.reverseAnimation,
				function()
					self:stopAnimation()
				end
			)
		end)
	end
end

function extended:stopAnimation()
	if self.renderSteppedConnection then
		self.renderSteppedConnection:Disconnect()
		self.renderSteppedConnection = nil
	end
end

function extended:willUnmount()
	self:stopAnimation()
end

return extended
