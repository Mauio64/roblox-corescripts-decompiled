local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local color3 = Color3.fromRGB(98, 98, 99)
local color3_2 = Color3.fromRGB(255, 255, 255)
local color3_3 = Color3.fromRGB(196, 0, 1)
local v11 = Images["component_assets/circle_29"]
local v12 = Roact.PureComponent:extend("FillCircle")

v12.validateProps = t.strictInterface({
	Position = t.UDim2,
	AnchorPoint = t.Vector2,
	fillFraction = t.number,
	largerCircleFraction = t.number,
	popCircleFraction = t.number,
	shakeCircleFraction = t.number,
	BackgroundColor = t.Color3
})

local function getFillRingZIndex(p1) -- line: 36
	if p1 > 0.75 then
		return 8
	end

	if p1 > 0.5 then
		return 6
	end

	if p1 > 0.25 then
		return 4
	end

	if p1 > 0 then
		return 2
	end

	return 0
end
local function linearTween(p2, p3, p4) -- line: 49
	local v23 = (p4 - p3) / 30

	return (p2 - p3 / 30) / v23
end
local function isBetweenFrames(p5, p6, p7) -- line: 54
	return p5 >= p6 / 30 and p5 <= p7 / 30
end
local function largerCircleAnimation(p8, p9, p10, p11) -- line: 58
	if p10 then
		p8 = 0.26666666666666666 - p8
	end

	if p8 >= 0 and p8 <= 0.16666666666666666 then
		local v31 = 16 + 6 * ((p8 - 0) / 0.16666666666666666)

		p9.size(UDim2.new(0, v31, 0, v31))

		return
	end

	if p8 >= 0.16666666666666666 and p8 <= 0.26666666666666666 then
		local v32 = 22 - 2 * ((p8 - 0.16666666666666666) / 0.1)

		p9.size(UDim2.new(0, v32, 0, v32))

		return
	end

	if p8 < 0 then
		p9.size(UDim2.new(0, 16, 0, 16))
		p11()

		return
	end

	p9.size(UDim2.new(0, 20, 0, 20))
	p11()
end
local function popCircleAnimation(p12, p13, _, p15) -- line: 86
	if p12 >= 0 and p12 <= 0.1 then
		local v37 = 20 + 4 * ((p12 - 0) / 0.1)

		p13.size(UDim2.new(0, v37, 0, v37))

		return
	end

	if p12 >= 0.1 and p12 <= 0.2 then
		local v38 = 24 - 4 * ((p12 - 0.1) / 0.1)

		p13.size(UDim2.new(0, v38, 0, v38))

		return
	end

	p13.size(UDim2.new(0, 20, 0, 20))
	p15()
end
local function shakeCircleAnimation(p16, p17, _, p19) -- line: 107
	if p16 >= 0 and p16 <= 0.1 then
		local v43 = (p16 - 0) / 0.1

		p17.positionOffset(UDim2.new(0, -4 * v43, 0, 0))

		return
	end

	if p16 >= 0.1 and p16 <= 0.2 then
		local v44 = (p16 - 0.1) / 0.1

		p17.positionOffset(UDim2.new(0, -4 + 12 * v44, 0, 0))

		return
	end

	if p16 >= 0.2 and p16 <= 0.26666666666666666 then
		local v45 = (p16 - 0.2) / 0.06666666666666667

		p17.positionOffset(UDim2.new(0, 8 - 16 * v45, 0, 0))

		return
	end

	if p16 >= 0.26666666666666666 and p16 <= 0.3333333333333333 then
		local v46 = (p16 - 0.26666666666666666) / 0.06666666666666667

		p17.positionOffset(UDim2.new(0, -8 + 16 * v46, 0, 0))

		return
	end

	if p16 >= 0.3333333333333333 and p16 <= 0.4 then
		local v47 = (p16 - 0.3333333333333333) / 0.06666666666666667

		p17.positionOffset(UDim2.new(0, 8 - 16 * v47, 0, 0))

		return
	end

	if p16 >= 0.4 and p16 <= 0.4666666666666667 then
		local v48 = (p16 - 0.4) / 0.06666666666666667

		p17.positionOffset(UDim2.new(0, -8 + 8 * v48, 0, 0))

		return
	end

	p17.positionOffset(UDim2.new(0, 0, 0, 0))
	p19()
end

function v12.init(p20) -- line: 142
	-- upvalues: Roact (copy)
	local v50, v51 = Roact.createBinding(UDim2.new(0, 16, 0, 16))

	p20.sizeBinding = v50
	p20.sizeBindingUpdate = v51
	p20.largerSizeBinding = p20.sizeBinding:map(function(p21) -- line: 145
		return p21 + UDim2.new(0, 2, 0, 2)
	end)

	local v52, v53 = Roact.createBinding(UDim2.new(0, 0, 0, 0))

	p20.positionOffsetBinding = v52
	p20.positionOffsetBindingUpdate = v53
	p20.updateBindings = {
		size = p20.sizeBindingUpdate,
		positionOffset = p20.positionOffsetBindingUpdate
	}
	p20.animationStartTime = nil
	p20.animationFunction = nil
	p20.reverseAnimation = false
	p20.renderSteppedConnection = nil
end
function v12.render(p22) -- line: 161
	-- upvalues: color3_3 (copy), color3_2 (copy), Roact (copy), color3 (copy), ImageSetLabel (copy), v11 (copy)
	local props = p22.props
	local v56 = props.fillFraction >= 1 and color3_3 or color3_2
	local createElement = Roact.createElement
	local t1 = {
		BackgroundTransparency = 1,
		Size = p22.sizeBinding,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint
	}
	local t2 = {}
	local createElement2 = Roact.createElement
	local t3 = {
		BorderSizePixel = 0,
		Position = p22.positionOffsetBinding,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = color3
	}
	local t4 = {
		OuterRing = Roact.createElement(ImageSetLabel, {
			Image = "rbxasset://textures/ui/InGameMenu/CircleCutout.png",
			BackgroundTransparency = 1,
			ZIndex = 10,
			Size = UDim2.new(1, 0, 1, 0),
			ImageColor3 = props.BackgroundColor
		}),
		InnerRing = Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			ZIndex = 10,
			Image = v11,
			Size = UDim2.new(1, -4, 1, -4),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageColor3 = props.BackgroundColor
		})
	}
	local createElement3 = Roact.createElement
	local t5 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Rotation = props.fillFraction * 360
	}
	local fillFraction = props.fillFraction

	t5.ZIndex = if not (fillFraction > 0.75) then if not (fillFraction > 0.5) then if not (fillFraction > 0.25) then not (fillFraction > 0) and 0 or 2 else 4 else 6 else 8
	t4.FillRingRotationFrame = createElement3("Frame", t5, {
		FillRing = Roact.createElement(ImageSetLabel, {
			Image = "rbxasset://textures/ui/InGameMenu/QuarterCircle.png",
			BackgroundTransparency = 1,
			Size = p22.largerSizeBinding,
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageColor3 = v56
		})
	})
	t4.EdgeBlockers = Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 10,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		Top = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 0, 0),
			Size = UDim2.new(1, 4, 0, 2),
			BackgroundColor3 = props.BackgroundColor
		}),
		Right = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.new(0, 2, 1, 4),
			BackgroundColor3 = props.BackgroundColor
		}),
		Bottom = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 1, 0),
			Size = UDim2.new(1, 4, 0, 2),
			BackgroundColor3 = props.BackgroundColor
		}),
		Left = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.new(0, 2, 1, 4),
			BackgroundColor3 = props.BackgroundColor
		})
	})
	t4.TopLeftFill = Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = props.fillFraction >= 1 and v56 or color3,
		ZIndex = not (props.fillFraction >= 1) and 7 or 9
	})
	t4.BottomLeftFill = Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(0.5, 0, 0.5, 0),
		Position = UDim2.new(0, 0, 0.5, 0),
		BackgroundColor3 = props.fillFraction >= 0.75 and v56 or color3,
		ZIndex = not (props.fillFraction >= 0.75) and 5 or 9
	})
	t4.BottomRightFill = Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(0.5, 0, 0.5, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = props.fillFraction >= 0.5 and v56 or color3,
		ZIndex = not (props.fillFraction >= 0.5) and 3 or 9
	})
	t4.TopRightFill = Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(0.5, 0, 0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		BackgroundColor3 = props.fillFraction >= 0.25 and v56 or color3,
		ZIndex = not (props.fillFraction >= 0.25) and 1 or 9
	})
	t2.PositionOffsetFrame = createElement2("Frame", t3, t4)

	return createElement("Frame", t1, t2)
end
function v12.didUpdate(p23, p24, _) -- line: 284
	-- upvalues: largerCircleAnimation (copy), popCircleAnimation (copy), shakeCircleAnimation (copy)
	local v69 = p24.fillFraction >= p24.largerCircleFraction
	local v70 = p23.props.fillFraction >= p23.props.largerCircleFraction

	if v69 ~= v70 then
		p23:playAnimation(largerCircleAnimation, not v70)
	end

	local v71 = p24.fillFraction >= p24.popCircleFraction

	if p23.props.fillFraction >= p23.props.popCircleFraction and not v71 then
		p23:playAnimation(popCircleAnimation, false)
	end

	local v72 = p24.fillFraction >= p24.shakeCircleFraction

	if p23.props.fillFraction >= p23.props.shakeCircleFraction and not v72 then
		p23:playAnimation(shakeCircleAnimation, false)
	end
end
function v12.playAnimation(p26, p27, p28) -- line: 304
	-- upvalues: RunService (copy)
	if p26.animationFunction then
		p26.animationFunction(100, p26.updateBindings, p26.reverseAnimation, function() -- line: 307
		end)
	end

	p26.animationStartTime = tick()
	p26.animationFunction = p27
	p26.reverseAnimation = p28

	if not p26.renderSteppedConnection then
		p26.renderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 313
			-- upvalues: p26 (copy)
			p26.animationFunction(tick() - p26.animationStartTime, p26.updateBindings, p26.reverseAnimation, function() -- line: 318
				-- upvalues: p26 (copy)
				p26:stopAnimation()
			end)
		end)
	end
end
function v12.stopAnimation(p29) -- line: 326
	if p29.renderSteppedConnection then
		p29.renderSteppedConnection:Disconnect()
		p29.renderSteppedConnection = nil
	end
end
function v12.willUnmount(p30) -- line: 333
	p30:stopAnimation()
end

return v12
