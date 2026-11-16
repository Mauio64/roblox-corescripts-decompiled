local DiscoveryHeroUnit = script:FindFirstAncestor("DiscoveryHeroUnit")

local parent = DiscoveryHeroUnit.Parent
local React = require(parent.React)
require(parent.Foundation)
local ArgCheck = require(parent.ArgCheck)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppHomePageFirstImageLoadObserver = SharedFlags.FFlagLuaAppHomePageFirstImageLoadObserver

local ParallaxUtils = require(DiscoveryHeroUnit.ParallaxUtils)
local useNormalizedVerticalProgress = ParallaxUtils.useNormalizedVerticalProgress
local getYPositionOffsetForMotion = ParallaxUtils.getYPositionOffsetForMotion
local getNormalizedTopPosition = ParallaxUtils.getNormalizedTopPosition
require(DiscoveryHeroUnit.HeroUnitTypes)

local function calculateModifiedNormalizedPosition(normalizedPosition: number, current: number?, p: number?) -- 2 equivalent calls inferred from this helper
	if normalizedPosition < 0 and p and p > 0 then
		return (math.clamp(normalizedPosition / p, -1, 0))
	end

	if current == nil or current <= 0 or current >= 1 then
		return normalizedPosition
	end

	return (math.clamp(normalizedPosition / current, 0, 1))
end

local function computeNormalizedHeroUnitHeight(current, y: number) -- 2 equivalent calls inferred from this helper
	if current == nil then
		return nil
	end

	local y2 = current.AbsoluteWindowSize.Y

	if y2 <= 0 then
		return nil
	end

	return y / y2
end

local function HeroImages(props)
	ArgCheck.assert(props.foregroundAspectRatio > 0, "HeroImages: foregroundAspectRatio must be > 0")

	local ref = React.useRef(nil)

	local ref2 = React.useRef(nil)
	local frameSize2, v = React.useBinding(Vector2.new(0, 0))

	React.useEffect(function()
		if ref and ref.current then
			v(ref.current.AbsoluteSize)
		end
	end, {})

	local v2 = React.useCallback(function(p)
		if p then
			ref2.current = getNormalizedTopPosition(props.verticalScrollingFrameRef.current, p)
			v(p.AbsoluteSize)
		end
	end, { props.verticalScrollingFrameRef })

	local normalizedPosition = useNormalizedVerticalProgress(props.verticalScrollingFrameRef, ref)

	local imageSize2, v3 = React.useBinding(Vector2.new(0, 0))
	local v4 = React.useCallback(function(p: number, p2: number, p3: number, p4: number, p5: number)
		ArgCheck.assert(p4 > 0)
		ArgCheck.assert(p5 > 0)

		local v4 = p - p2 + p3 * 2
		local v5 = p4 / p5 * v4
		return Vector2.new(v5, v4)
	end, {})
	local v5

	if props.foregroundAspectRatio == 1 then
		v5 = props.foregroundOverflow + props.tokens.Padding.Small
	else
		v5 = props.foregroundOverflow - props.tokens.Padding.Small
	end

	local v6 = props.backgroundOverflow * 2
	local backgroundOverflow = props.backgroundOverflow

	local v7 = -props.foregroundOverflow * (not (props.gradientHeightPercent and props.gradientHeightPercent > 0) and 1 or props.gradientHeightPercent) + (props.gradientHeightPercent >= 0.9 and 1 or 0)

	local createElement = React.createElement
	local v8 = {
		[React.Change.AbsoluteSize] = v2,
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
	local v9 = {
		AnchorPoint = Vector2.new(0.5, 1),
		Size = UDim2.new(1, 0, 1, -props.foregroundOverflow),
		Position = UDim2.new(0.5, 0, 1, 0),
		BackgroundTransparency = 0,
		BackgroundColor3 = props.tokens.Color.Surface.Surface_100.Color3,
		ZIndex = 0,
		Image = props.backgroundImage,
		ScaleType = Enum.ScaleType.Crop,
		[React.Tag] = FFlagLuaAppHomePageFirstImageLoadObserver and "observed-image data-testid=--hero-unit-background-image" or "data-testid=--hero-unit-background-image"
	}
	local imageRectOffset

	if props.enableBackgroundAnimation then
		imageRectOffset = React.joinBindings({
			normalizedPosition = normalizedPosition,
			imageSize = imageSize2,
			frameSize = frameSize2
		}):map(function(data)
			if ref2.current == nil then
				ref2.current = getNormalizedTopPosition(props.verticalScrollingFrameRef.current, ref.current)
			end

			local normalizedHeroUnitHeight = computeNormalizedHeroUnitHeight( -- inferred equivalent call
				props.verticalScrollingFrameRef.current,
				data.frameSize.Y
			)

			local yPositionOffsetForMotion = getYPositionOffsetForMotion(
				calculateModifiedNormalizedPosition(data.normalizedPosition, ref2.current, normalizedHeroUnitHeight), -- inferred equivalent call
				0,
				v6,
				backgroundOverflow
			)
			local imageSize = data.imageSize

			if imageSize.X > 0 and imageSize.Y > 0 and ref and ref.current then
				local frameSize = data.frameSize
				local v10 = v4(
					frameSize.Y,
					props.foregroundOverflow,
					props.backgroundOverflow,
					imageSize.X,
					imageSize.Y
				)

				return Vector2.new(
					(1 - frameSize.X / v10.X) * imageSize.X * 0.5,
					yPositionOffsetForMotion * (imageSize.Y / v10.Y)
				)
			end

			return Vector2.new(0, 0)
		end)
	end

	v9.ImageRectOffset = imageRectOffset
	local imageRectSize

	if props.enableBackgroundAnimation then
		imageRectSize = React.joinBindings({ imageSize = imageSize2, frameSize = frameSize2 }):map(function(p)
			local imageSize = p.imageSize

			if not (imageSize.X > 0 and imageSize.Y > 0 and ref and ref.current) then
				return Vector2.new(0, 0)
			end

			local frameSize = p.frameSize
			local v10 = v4(frameSize.Y, props.foregroundOverflow, props.backgroundOverflow, imageSize.X, imageSize.Y)

			local v11 = frameSize.X / v10.X * imageSize.X
			local v12 = imageSize.Y - props.backgroundOverflow * 2 / v10.Y * imageSize.Y
			return Vector2.new(v11, v12)
		end)
	end

	v9.ImageRectSize = imageRectSize

	v9[React.Change.ContentImageSize] = function(p)
		if p then
			v3(p.ContentImageSize)
		end
	end

	local children = {
		BackgroundImage = createElement2("ImageLabel", v9, {
			CornerRadius = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, props.cornerRadius)
			})
		}),
		ForegroundImage = 0,
		HeroGradientFrame = 0
	}

	local createElement3 = React.createElement
	local v10 = {}
	v10.AnchorPoint = Vector2.new(0.5, 0)
	v10.Size = UDim2.new(
		1,
		-props.foregroundOverflow,
		1 / props.foregroundAspectRatio,
		-props.foregroundOverflow / props.foregroundAspectRatio
	)

	v10.SizeConstraint = Enum.SizeConstraint.RelativeYY
	local position

	if props.enableForegroundAnimation then
		position = React.joinBindings({
			normalizedPosition = normalizedPosition,
			frameSize = frameSize2
		}):map(function(p)
			if ref2.current == nil then
				ref2.current = getNormalizedTopPosition(props.verticalScrollingFrameRef.current, ref.current)
			end

			local normalizedHeroUnitHeight = computeNormalizedHeroUnitHeight( -- inferred equivalent call
				props.verticalScrollingFrameRef.current,
				p.frameSize.Y
			)

			local modifiedNormalizedPosition = calculateModifiedNormalizedPosition( -- inferred equivalent call
				p.normalizedPosition,
				ref2.current,
				normalizedHeroUnitHeight
			)

			local y = p.frameSize.Y
			local v11 = -((y - props.foregroundOverflow) / props.foregroundAspectRatio - y)

			if props.foregroundAspectRatio == 1 then
				v11 -= props.tokens.Size.Size_1500
			end

			local yPositionOffsetForMotion = getYPositionOffsetForMotion(modifiedNormalizedPosition, v11, v5, 0)

			return UDim2.new(0.5, 0, 0, yPositionOffsetForMotion)
		end)
	else
		position = UDim2.new(0.5, 0, 0, 0)
	end

	v10.Position = position

	v10.Image = props.foregroundImage
	v10.ZIndex = 1
	v10.BackgroundTransparency = 1
	v10[React.Tag] = FFlagLuaAppHomePageFirstImageLoadObserver
		and "observed-image data-testid=--hero-unit-foreground-image"
		or "data-testid=--hero-unit-foreground-image"
	children.ForegroundImage = createElement3("ImageLabel", v10)

	children.HeroGradientFrame = props.gradient and React.createElement("Frame", {
		ZIndex = 2,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 1),
		Size = UDim2.new(props.gradientWidthPercent, 0, props.gradientHeightPercent, v7),
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
	return createElement("Frame", v8, children)
end

return React.memo(HeroImages)
