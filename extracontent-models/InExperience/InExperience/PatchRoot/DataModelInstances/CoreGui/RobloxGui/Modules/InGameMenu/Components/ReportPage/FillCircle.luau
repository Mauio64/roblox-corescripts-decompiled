local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local ParentParent = script.Parent.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Image = require(CorePackages.Packages.Foundation).Image
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local color3 = Color3.fromRGB(98, 98, 99)
local color3_2 = Color3.fromRGB(255, 255, 255)
local color3_3 = Color3.fromRGB(196, 0, 1)
local v15 = Roact.PureComponent:extend("FillCircle")

v15.validateProps = t.strictInterface({
	Position = t.UDim2,
	AnchorPoint = t.Vector2,
	fillFraction = t.number,
	largerCircleFraction = t.number,
	popCircleFraction = t.number,
	shakeCircleFraction = t.number,
	BackgroundColor = t.Color3
})

local function getFillRingZIndex(p1) -- line: 42
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
local function linearTween(p2, p3, p4) -- line: 55
	local v26 = (p4 - p3) / 30

	return (p2 - p3 / 30) / v26
end
local function isBetweenFrames(p5, p6, p7) -- line: 60
	return p5 >= p6 / 30 and p5 <= p7 / 30
end
local function largerCircleAnimation(p8, p9, p10, p11) -- line: 64
	if p10 then
		p8 = 0.26666666666666666 - p8
	end

	if p8 >= 0 and p8 <= 0.16666666666666666 then
		local v34 = 16 + 6 * ((p8 - 0) / 0.16666666666666666)

		p9.size(UDim2.new(0, v34, 0, v34))

		return
	end

	if p8 >= 0.16666666666666666 and p8 <= 0.26666666666666666 then
		local v35 = 22 - 2 * ((p8 - 0.16666666666666666) / 0.1)

		p9.size(UDim2.new(0, v35, 0, v35))

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
local function popCircleAnimation(p12, p13, _, p15) -- line: 92
	if p12 >= 0 and p12 <= 0.1 then
		local v40 = 20 + 4 * ((p12 - 0) / 0.1)

		p13.size(UDim2.new(0, v40, 0, v40))

		return
	end

	if p12 >= 0.1 and p12 <= 0.2 then
		local v41 = 24 - 4 * ((p12 - 0.1) / 0.1)

		p13.size(UDim2.new(0, v41, 0, v41))

		return
	end

	p13.size(UDim2.new(0, 20, 0, 20))
	p15()
end
local function shakeCircleAnimation(p16, p17, _, p19) -- line: 113
	if p16 >= 0 and p16 <= 0.1 then
		local v46 = (p16 - 0) / 0.1

		p17.positionOffset(UDim2.new(0, -4 * v46, 0, 0))

		return
	end

	if p16 >= 0.1 and p16 <= 0.2 then
		local v47 = (p16 - 0.1) / 0.1

		p17.positionOffset(UDim2.new(0, -4 + 12 * v47, 0, 0))

		return
	end

	if p16 >= 0.2 and p16 <= 0.26666666666666666 then
		local v48 = (p16 - 0.2) / 0.06666666666666667

		p17.positionOffset(UDim2.new(0, 8 - 16 * v48, 0, 0))

		return
	end

	if p16 >= 0.26666666666666666 and p16 <= 0.3333333333333333 then
		local v49 = (p16 - 0.26666666666666666) / 0.06666666666666667

		p17.positionOffset(UDim2.new(0, -8 + 16 * v49, 0, 0))

		return
	end

	if p16 >= 0.3333333333333333 and p16 <= 0.4 then
		local v50 = (p16 - 0.3333333333333333) / 0.06666666666666667

		p17.positionOffset(UDim2.new(0, 8 - 16 * v50, 0, 0))

		return
	end

	if p16 >= 0.4 and p16 <= 0.4666666666666667 then
		local v51 = (p16 - 0.4) / 0.06666666666666667

		p17.positionOffset(UDim2.new(0, -8 + 8 * v51, 0, 0))

		return
	end

	p17.positionOffset(UDim2.new(0, 0, 0, 0))
	p19()
end

function v15.init(p20) -- line: 148
	-- upvalues: Roact (copy)
	local v53, v54 = Roact.createBinding(UDim2.new(0, 16, 0, 16))

	p20.sizeBinding = v53
	p20.sizeBindingUpdate = v54
	p20.largerSizeBinding = p20.sizeBinding:map(function(p21) -- line: 151
		return p21 + UDim2.new(0, 2, 0, 2)
	end)

	local v55, v56 = Roact.createBinding(UDim2.new(0, 0, 0, 0))

	p20.positionOffsetBinding = v55
	p20.positionOffsetBindingUpdate = v56
	p20.updateBindings = {
		size = p20.sizeBindingUpdate,
		positionOffset = p20.positionOffsetBindingUpdate
	}
	p20.animationStartTime = nil
	p20.animationFunction = nil
	p20.reverseAnimation = false
	p20.renderSteppedConnection = nil
end
function v15.render(p22) -- line: 167
	-- upvalues: color3_3 (copy), color3_2 (copy), Roact (copy), color3 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Image (copy), Assets (copy), ImageSetLabel (copy)
	local props = p22.props
	local v59 = props.fillFraction >= 1 and color3_3 or color3_2
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
		OuterRing = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			ZIndex = 10,
			Image = Assets.Images.CircleCutout,
			Size = UDim2.new(1, 0, 1, 0),
			ImageColor3 = props.BackgroundColor
		}) else Roact.createElement(Image, {
			ZIndex = 10,
			Image = Assets.Images.CircleCutout,
			Size = UDim2.new(1, 0, 1, 0),
			imageStyle = {
				Transparency = 0,
				Color3 = props.BackgroundColor
			}
		}),
		InnerRing = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			ZIndex = 10,
			Image = Assets.Images.Circle,
			Size = UDim2.new(1, -4, 1, -4),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageColor3 = props.BackgroundColor
		}) else Roact.createElement(Image, {
			ZIndex = 10,
			Image = Assets.Images.Circle,
			Size = UDim2.new(1, -4, 1, -4),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			imageStyle = {
				Transparency = 0,
				Color3 = props.BackgroundColor
			}
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
		FillRing = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Image = Assets.Images.QuarterCircle,
			Size = p22.largerSizeBinding,
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageColor3 = v59
		}) else Roact.createElement(Image, {
			Image = Assets.Images.QuarterCircle,
			Size = p22.largerSizeBinding,
			AnchorPoint = Vector2.new(0.5, 0.5),
			imageStyle = {
				Transparency = 0,
				Color3 = v59
			}
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
		BackgroundColor3 = props.fillFraction >= 1 and v59 or color3,
		ZIndex = not (props.fillFraction >= 1) and 7 or 9
	})
	t4.BottomLeftFill = Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(0.5, 0, 0.5, 0),
		Position = UDim2.new(0, 0, 0.5, 0),
		BackgroundColor3 = props.fillFraction >= 0.75 and v59 or color3,
		ZIndex = not (props.fillFraction >= 0.75) and 5 or 9
	})
	t4.BottomRightFill = Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(0.5, 0, 0.5, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = props.fillFraction >= 0.5 and v59 or color3,
		ZIndex = not (props.fillFraction >= 0.5) and 3 or 9
	})
	t4.TopRightFill = Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(0.5, 0, 0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		BackgroundColor3 = props.fillFraction >= 0.25 and v59 or color3,
		ZIndex = not (props.fillFraction >= 0.25) and 1 or 9
	})
	t2.PositionOffsetFrame = createElement2("Frame", t3, t4)

	return createElement("Frame", t1, t2)
end
function v15.didUpdate(p23, p24, _) -- line: 313
	-- upvalues: largerCircleAnimation (copy), popCircleAnimation (copy), shakeCircleAnimation (copy)
	local v72 = p24.fillFraction >= p24.largerCircleFraction
	local v73 = p23.props.fillFraction >= p23.props.largerCircleFraction

	if v72 ~= v73 then
		p23:playAnimation(largerCircleAnimation, not v73)
	end

	local v74 = p24.fillFraction >= p24.popCircleFraction

	if p23.props.fillFraction >= p23.props.popCircleFraction and not v74 then
		p23:playAnimation(popCircleAnimation, false)
	end

	local v75 = p24.fillFraction >= p24.shakeCircleFraction

	if p23.props.fillFraction >= p23.props.shakeCircleFraction and not v75 then
		p23:playAnimation(shakeCircleAnimation, false)
	end
end
function v15.playAnimation(p26, p27, p28) -- line: 333
	-- upvalues: RunService (copy)
	if p26.animationFunction then
		p26.animationFunction(100, p26.updateBindings, p26.reverseAnimation, function() -- line: 336
		end)
	end

	p26.animationStartTime = tick()
	p26.animationFunction = p27
	p26.reverseAnimation = p28

	if not p26.renderSteppedConnection then
		p26.renderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 342
			-- upvalues: p26 (copy)
			p26.animationFunction(tick() - p26.animationStartTime, p26.updateBindings, p26.reverseAnimation, function() -- line: 347
				-- upvalues: p26 (copy)
				p26:stopAnimation()
			end)
		end)
	end
end
function v15.stopAnimation(p29) -- line: 355
	if p29.renderSteppedConnection then
		p29.renderSteppedConnection:Disconnect()
		p29.renderSteppedConnection = nil
	end
end
function v15.willUnmount(p30) -- line: 362
	p30:stopAnimation()
end

return v15
