local React = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryHeroUnit/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryHeroUnit/Foundation")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryHeroUnit/ArgCheck")

local fFlagLuaAppHomePageFirstImageLoadObserver = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryHeroUnit/SharedFlags").FFlagLuaAppHomePageFirstImageLoadObserver

local ParallaxUtils = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryHeroUnit/DiscoveryHeroUnit/ParallaxUtils")
local useNormalizedVerticalProgress = ParallaxUtils.useNormalizedVerticalProgress
local getYPositionOffsetForMotion = ParallaxUtils.getYPositionOffsetForMotion
local getNormalizedTopPosition = ParallaxUtils.getNormalizedTopPosition
require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryHeroUnit/DiscoveryHeroUnit/HeroUnitTypes")

local function calculateModifiedNormalizedPosition(p2, p3, p4)
	if p2 < 0 and p4 and p4 > 0 then
		return (math.clamp(p2 / p4, -1, 0))
	end

	if p3 == nil or p3 <= 0 or p3 >= 1 then
		return p2
	end

	return (math.clamp(p2 / p3, 0, 1))
end

local function computeNormalizedHeroUnitHeight(p2, p3)
	if p2 == nil then
		return nil
	end

	local y = p2.AbsoluteWindowSize.Y

	if y <= 0 then
		return nil
	end

	return p3 / y
end

local function HeroImages(props)
	ArgCheck.assert(props.foregroundAspectRatio > 0, "HeroImages: foregroundAspectRatio must be > 0")

	local ref = React.useRef(nil)

	local ref2 = React.useRef(nil)
	local v5, v6 = React.useBinding(Vector2.new(0, 0))

	React.useEffect(function()
		if ref and ref.current then
			v6(ref.current.AbsoluteSize)
		end
	end, {})

	local v7 = React.useCallback(function(p2)
		if p2 then
			ref2.current = getNormalizedTopPosition(props.verticalScrollingFrameRef.current, p2)
			v6(p2.AbsoluteSize)
		end
	end, { props.verticalScrollingFrameRef })

	local v8 = useNormalizedVerticalProgress(props.verticalScrollingFrameRef, ref)

	local v9, v10 = React.useBinding(Vector2.new(0, 0))
	local v11 = React.useCallback(function(p2, p3, p4, p5, p6)
		ArgCheck.assert(p5 > 0)
		ArgCheck.assert(p6 > 0)

		local v12 = p2 - p3 + p4 * 2
		local v13 = p5 / p6 * v12
		return Vector2.new(v13, v12)
	end, {})
	local v12

	if props.foregroundAspectRatio == 1 then
		v12 = props.foregroundOverflow + props.tokens.Padding.Small
	else
		v12 = props.foregroundOverflow - props.tokens.Padding.Small
	end

	local v13 = props.backgroundOverflow * 2
	local backgroundOverflow = props.backgroundOverflow

	local v14 = -props.foregroundOverflow * (not (props.gradientHeightPercent and props.gradientHeightPercent > 0) and 1 or props.gradientHeightPercent) + (props.gradientHeightPercent >= 0.9 and 1 or 0)

	local createElement = React.createElement
	local v16 = {
		[React.Change.AbsoluteSize] = v7,
		ref = ref,
		BackgroundTransparency = 1,
		Size = props.Size,
		ZIndex = props.ZIndex,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		LayoutOrder = props.LayoutOrder,
		ClipsDescendants = true
	}

	local createElement2 = React.createElement
	local v18 = {
		AnchorPoint = Vector2.new(0.5, 1),
		Size = UDim2.new(1, 0, 1, -props.foregroundOverflow),
		Position = UDim2.new(0.5, 0, 1, 0),
		BackgroundTransparency = 0,
		BackgroundColor3 = props.tokens.Color.Surface.Surface_100.Color3,
		ZIndex = 0,
		Image = props.backgroundImage,
		ScaleType = Enum.ScaleType.Crop,
		[React.Tag] = fFlagLuaAppHomePageFirstImageLoadObserver and "observed-image data-testid=--hero-unit-background-image" or "data-testid=--hero-unit-background-image"
	}
	local v19

	if props.enableBackgroundAnimation then
		v19 = React.joinBindings({
			normalizedPosition = v8,
			imageSize = v9,
			frameSize = v5
		}):map(function(data)
			if ref2.current == nil then
				ref2.current = getNormalizedTopPosition(
					props.verticalScrollingFrameRef.current,
					ref.current
				)
			end

			local current = props.verticalScrollingFrameRef.current
			local y = data.frameSize.Y
			local v20

			if current ~= nil then
				local y2 = current.AbsoluteWindowSize.Y

				if not (y2 <= 0) then
					v20 = y / y2
				end
			end

			local v21 = data.normalizedPosition
			local current2 = ref2.current

			if v21 < 0 and v20 and v20 > 0 then
				v21 = math.clamp(v21 / v20, -1, 0)
			elseif current2 ~= nil and not (current2 <= 0 or current2 >= 1) then
				v21 = math.clamp(v21 / current2, 0, 1)
			end

			local yPositionOffsetForMotion = getYPositionOffsetForMotion(v21, 0, v13, backgroundOverflow)
			local imageSize = data.imageSize

			if imageSize.X > 0 and imageSize.Y > 0 and ref and ref.current then
				local frameSize = data.frameSize
				local v22 = v11(
					frameSize.Y,
					props.foregroundOverflow,
					props.backgroundOverflow,
					imageSize.X,
					imageSize.Y
				)

				return Vector2.new(
					(1 - frameSize.X / v22.X) * imageSize.X * 0.5,
					yPositionOffsetForMotion * (imageSize.Y / v22.Y)
				)
			end

			return Vector2.new(0, 0)
		end)
	end

	v18.ImageRectOffset = v19
	local v20

	if props.enableBackgroundAnimation then
		v20 = React.joinBindings({ imageSize = v9, frameSize = v5 }):map(function(p2)
			local imageSize = p2.imageSize

			if not (imageSize.X > 0 and imageSize.Y > 0 and ref and ref.current) then
				return Vector2.new(0, 0)
			end

			local frameSize = p2.frameSize
			local v21 = v11(
				frameSize.Y,
				props.foregroundOverflow,
				props.backgroundOverflow,
				imageSize.X,
				imageSize.Y
			)

			local v22 = frameSize.X / v21.X * imageSize.X
			local v23 = imageSize.Y - props.backgroundOverflow * 2 / v21.Y * imageSize.Y
			return Vector2.new(v22, v23)
		end)
	end

	v18.ImageRectSize = v20

	v18[React.Change.ContentImageSize] = function(p2)
		if p2 then
			v10(p2.ContentImageSize)
		end
	end

	local children = {
		BackgroundImage = createElement2("ImageLabel", v18, {
			CornerRadius = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, props.cornerRadius)
			})
		}),
		ForegroundImage = 0,
		HeroGradientFrame = 0
	}

	local createElement3 = React.createElement
	local v22 = {}
	v22.AnchorPoint = Vector2.new(0.5, 0)
	v22.Size = UDim2.new(
		1,
		-props.foregroundOverflow,
		1 / props.foregroundAspectRatio,
		-props.foregroundOverflow / props.foregroundAspectRatio
	)

	v22.SizeConstraint = Enum.SizeConstraint.RelativeYY
	local v23

	if props.enableForegroundAnimation then
		v23 = React.joinBindings({ normalizedPosition = v8, frameSize = v5 }):map(function(p2)
			if ref2.current == nil then
				ref2.current = getNormalizedTopPosition(
					props.verticalScrollingFrameRef.current,
					ref.current
				)
			end

			local current = props.verticalScrollingFrameRef.current
			local y = p2.frameSize.Y
			local v24

			if current ~= nil then
				local y2 = current.AbsoluteWindowSize.Y

				if not (y2 <= 0) then
					v24 = y / y2
				end
			end

			local v25 = p2.normalizedPosition
			local current2 = ref2.current

			if v25 < 0 and v24 and v24 > 0 then
				v25 = math.clamp(v25 / v24, -1, 0)
			elseif current2 ~= nil and not (current2 <= 0 or current2 >= 1) then
				v25 = math.clamp(v25 / current2, 0, 1)
			end

			local y2 = p2.frameSize.Y
			local v26 = -((y2 - props.foregroundOverflow) / props.foregroundAspectRatio - y2)

			if props.foregroundAspectRatio == 1 then
				v26 -= props.tokens.Size.Size_1500
			end

			local yPositionOffsetForMotion = getYPositionOffsetForMotion(v25, v26, v12, 0)

			return UDim2.new(0.5, 0, 0, yPositionOffsetForMotion)
		end)
	else
		v23 = UDim2.new(0.5, 0, 0, 0)
	end

	v22.Position = v23

	v22.Image = props.foregroundImage
	v22.ZIndex = 1
	v22.BackgroundTransparency = 1
	v22[React.Tag] = fFlagLuaAppHomePageFirstImageLoadObserver
		and "observed-image data-testid=--hero-unit-foreground-image"
		or "data-testid=--hero-unit-foreground-image"
	children.ForegroundImage = createElement3("ImageLabel", v22)

	children.HeroGradientFrame = props.gradient and React.createElement("Frame", {
		ZIndex = 2,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 1),
		Size = UDim2.new(props.gradientWidthPercent, 0, props.gradientHeightPercent, v14),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0,
		BorderSizePixel = 0
	}, {
		HeroGradient = React.createElement("UIGradient", {
			Rotation = props.gradient.degree,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, props.gradient.startOpacity),
				NumberSequenceKeypoint.new(1, props.gradient.endOpacity)
			}),
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, props.gradient.startColor),
				ColorSequenceKeypoint.new(1, props.gradient.endColor)
			})
		}),
		CornerRadius = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, props.cornerRadius)
		})
	}) or nil
	return createElement("Frame", v16, children)
end

return React.memo(HeroImages)
