local DiscoveryHeroUnit = script:FindFirstAncestor("DiscoveryHeroUnit")
local DiscoveryHeroUnitParent = DiscoveryHeroUnit.Parent
local React = require(DiscoveryHeroUnitParent.React)

require(DiscoveryHeroUnitParent.Foundation)

local ArgCheck = require(DiscoveryHeroUnitParent.ArgCheck)
local FFlagLuaAppHeroUnitParallaxUpdates = require(DiscoveryHeroUnitParent.SharedFlags).FFlagLuaAppHeroUnitParallaxUpdates
local FFlagLuaAppHomePageFirstImageLoadObserver = require(DiscoveryHeroUnitParent.SharedFlags).FFlagLuaAppHomePageFirstImageLoadObserver
local ParallaxUtils = require(DiscoveryHeroUnit.ParallaxUtils)
local useNormalizedVerticalProgress = ParallaxUtils.useNormalizedVerticalProgress
local getYPositionOffsetForMotion = ParallaxUtils.getYPositionOffsetForMotion
local getNormalizedCenterPosition = ParallaxUtils.getNormalizedCenterPosition
local v11 = if not FFlagLuaAppHeroUnitParallaxUpdates then nil else ParallaxUtils.getNormalizedTopPosition

require(DiscoveryHeroUnit.HeroUnitTypes)

local function calculateModifiedNormalizedPosition(n1: number, n2: number?, n3: number?) -- line: 75
	-- upvalues: FFlagLuaAppHeroUnitParallaxUpdates (copy)
	if FFlagLuaAppHeroUnitParallaxUpdates and (n1 < 0 and n3 and n3 > 0) then
		return (math.clamp(n1 / n3, -1, 0))
	end

	if n2 == nil or n2 <= 0 or n2 >= 1 then
		return n1
	end

	return (math.clamp(n1 / n2, 0, 1))
end
local function computeNormalizedHeroUnitHeight(p1, n4: number) -- line: 93
	if p1 == nil then
		return nil
	end

	local AbsoluteWindowSizeY = p1.AbsoluteWindowSize.Y

	if AbsoluteWindowSizeY <= 0 then
		return nil
	end

	return n4 / AbsoluteWindowSizeY
end
local function HeroImages(t1: {[any]: any}) -- line: 105
	-- upvalues: ArgCheck (copy), React (copy), FFlagLuaAppHeroUnitParallaxUpdates (copy), v11 (copy), getNormalizedCenterPosition (copy), useNormalizedVerticalProgress (copy), FFlagLuaAppHomePageFirstImageLoadObserver (copy), getYPositionOffsetForMotion (copy)
	ArgCheck.assert(t1.foregroundAspectRatio > 0, "HeroImages: foregroundAspectRatio must be > 0")

	local v22 = React.useRef(nil)
	local v23 = React.useRef(nil)
	local v24, v25 = React.useBinding(Vector2.new(0, 0))

	React.useEffect(function() -- line: 113
		-- upvalues: v22 (copy), v25 (copy)
		if v22 and v22.current then
			v25(v22.current.AbsoluteSize)
		end
	end, {})

	local v26 = React.useCallback(function(p2) -- line: 119
		-- upvalues: v23 (copy), FFlagLuaAppHeroUnitParallaxUpdates (copy), v11 (copy), t1 (copy), getNormalizedCenterPosition (copy), v25 (copy)
		if p2 then
			v23.current = if not FFlagLuaAppHeroUnitParallaxUpdates then getNormalizedCenterPosition(t1.verticalScrollingFrameRef.current, p2) else v11(t1.verticalScrollingFrameRef.current, p2)
			v25(p2.AbsoluteSize)
		end
	end, { t1.verticalScrollingFrameRef })
	local v27 = useNormalizedVerticalProgress(t1.verticalScrollingFrameRef, v22)
	local v28, v29 = React.useBinding(Vector2.new(0, 0))
	local v30 = React.useCallback(function(n5: number, n6: number, n7: number, n8: number, n9: number) -- line: 132
		-- upvalues: ArgCheck (copy)
		ArgCheck.assert(n8 > 0)
		ArgCheck.assert(n9 > 0)

		local v45 = n5 - n6 + n7 * 2
		local v46 = n8 / n9 * v45

		return Vector2.new(v46, v45)
	end, {})
	local v31 = t1.foregroundOverflow * 2
	local v32 = t1.backgroundOverflow * 2
	local n10 = 0
	local n11 = 0
	local n12 = 0
	local n13 = 0
	local n14 = 0

	if FFlagLuaAppHeroUnitParallaxUpdates then
		n10 = if t1.foregroundAspectRatio ~= 1 then t1.foregroundOverflow - t1.tokens.Padding.Small else t1.foregroundOverflow + t1.tokens.Padding.Small
		n11 = 0
		n12 = 0
		n13 = t1.backgroundOverflow * 2
		n14 = t1.backgroundOverflow
	end

	local v38 = -t1.foregroundOverflow * ((not t1.gradientHeightPercent or not (t1.gradientHeightPercent > 0)) and 1 or t1.gradientHeightPercent) + (not (t1.gradientHeightPercent >= 0.9) and 0 or 1)

	return React.createElement("Frame", {
		[React.Change.AbsoluteSize] = v26,
		ref = v22,
		BackgroundTransparency = 1,
		Size = t1.Size,
		ZIndex = t1.ZIndex,
		Position = t1.Position,
		AnchorPoint = t1.AnchorPoint,
		LayoutOrder = t1.LayoutOrder,
		ClipsDescendants = true
	}, {
		BackgroundImage = React.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 1),
			Size = UDim2.new(1, 0, 1, -t1.foregroundOverflow),
			Position = UDim2.new(0.5, 0, 1, 0),
			BackgroundTransparency = 0,
			BackgroundColor3 = t1.tokens.Color.Surface.Surface_100.Color3,
			ZIndex = 0,
			Image = t1.backgroundImage,
			ScaleType = Enum.ScaleType.Crop,
			[React.Tag] = not FFlagLuaAppHomePageFirstImageLoadObserver and "data-testid=--hero-unit-background-image" or "observed-image data-testid=--hero-unit-background-image",
			ImageRectOffset = if not t1.enableBackgroundAnimation then nil else React.joinBindings({
				normalizedPosition = v27,
				imageSize = v28,
				frameSize = v24
			}):map(function(t2: {[any]: any}) -- line: 212
				-- upvalues: v23 (copy), FFlagLuaAppHeroUnitParallaxUpdates (copy), v11 (copy), t1 (copy), v22 (copy), getNormalizedCenterPosition (copy), getYPositionOffsetForMotion (copy), n12 (ref), v32 (copy), n13 (ref), n14 (ref), v30 (copy)
				if v23.current == nil then
					v23.current = if not FFlagLuaAppHeroUnitParallaxUpdates then getNormalizedCenterPosition(t1.verticalScrollingFrameRef.current, v22.current) else v11(t1.verticalScrollingFrameRef.current, v22.current)
				end

				local v48 = nil

				if FFlagLuaAppHeroUnitParallaxUpdates then
					local current = t1.verticalScrollingFrameRef.current
					local frameSizeY = t2.frameSize.Y

					if current == nil then
						v48 = nil
					else
						local AbsoluteWindowSizeY = current.AbsoluteWindowSize.Y

						v48 = if not (AbsoluteWindowSizeY <= 0) then frameSizeY / AbsoluteWindowSizeY else nil
					end
				end

				local normalizedPosition = t2.normalizedPosition
				local current = v23.current
				local v54 = if not FFlagLuaAppHeroUnitParallaxUpdates then nil else v48
				local v55 = if not FFlagLuaAppHeroUnitParallaxUpdates or (not (normalizedPosition < 0) or (not v54 or not (v54 > 0))) then if current ~= nil and (not (current <= 0) and not (current >= 1)) then math.clamp(normalizedPosition / current, 0, 1) else normalizedPosition else math.clamp(normalizedPosition / v54, -1, 0)
				local v56 = getYPositionOffsetForMotion(v55, if not FFlagLuaAppHeroUnitParallaxUpdates then v32 else n12, not FFlagLuaAppHeroUnitParallaxUpdates and 0 or n13, if not FFlagLuaAppHeroUnitParallaxUpdates then nil else n14)
				local imageSize = t2.imageSize

				if imageSize.X > 0 and imageSize.Y > 0 and v22 and v22.current then
					local frameSize = t2.frameSize
					local v59 = v30(frameSize.Y, t1.foregroundOverflow, t1.backgroundOverflow, imageSize.X, imageSize.Y)

					return Vector2.new((1 - frameSize.X / v59.X) * imageSize.X * 0.5, if not FFlagLuaAppHeroUnitParallaxUpdates then (v32 - v56) * (imageSize.Y / v59.Y) else v56 * (imageSize.Y / v59.Y))
				end

				return Vector2.new(0, 0)
			end),
			ImageRectSize = if not t1.enableBackgroundAnimation then nil else React.joinBindings({
				imageSize = v28,
				frameSize = v24
			}):map(function(t3: {[any]: any}) -- line: 267
				-- upvalues: v22 (copy), v30 (copy), t1 (copy)
				local imageSize = t3.imageSize

				if imageSize.X > 0 and (imageSize.Y > 0 and v22 and v22.current) then
					local frameSize = t3.frameSize
					local v63 = v30(frameSize.Y, t1.foregroundOverflow, t1.backgroundOverflow, imageSize.X, imageSize.Y)
					local v64 = frameSize.X / v63.X * imageSize.X
					local v65 = imageSize.Y - t1.backgroundOverflow * 2 / v63.Y * imageSize.Y

					return Vector2.new(v64, v65)
				end

				return Vector2.new(0, 0)
			end),
			[React.Change.ContentImageSize] = function(p3) -- line: 296
				-- upvalues: v29 (copy)
				if p3 then
					v29(p3.ContentImageSize)
				end
			end
		}, {
			CornerRadius = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, t1.cornerRadius)
			})
		}),
		ForegroundImage = if not FFlagLuaAppHeroUnitParallaxUpdates then React.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0),
			Size = t1.foregroundHeightPercent:map(function(n15: number) -- line: 370
				-- upvalues: t1 (copy)
				return UDim2.new(1, 0, n15, -t1.foregroundOverflow * n15)
			end),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			Position = if not t1.enableForegroundAnimation then UDim2.new(0.5, 0, 0, 0) else v27:map(function(n16: number) -- line: 381
				-- upvalues: v23 (copy), getNormalizedCenterPosition (copy), t1 (copy), v22 (copy), FFlagLuaAppHeroUnitParallaxUpdates (copy), getYPositionOffsetForMotion (copy), v31 (copy)
				if v23.current == nil then
					v23.current = getNormalizedCenterPosition(t1.verticalScrollingFrameRef.current, v22.current)
				end

				local current = v23.current

				if FFlagLuaAppHeroUnitParallaxUpdates then
					if not (n16 < 0) then
					end
				end

				local v81 = if current ~= nil and (not (current <= 0) and not (current >= 1)) then math.clamp(n16 / current, 0, 1) else n16
				local v82 = getYPositionOffsetForMotion(v81, 0, v31, nil)

				return UDim2.new(0.5, 0, 0, v82)
			end),
			Image = t1.foregroundImage,
			ZIndex = 1,
			BackgroundTransparency = 1,
			[React.Tag] = not FFlagLuaAppHomePageFirstImageLoadObserver and "data-testid=--hero-unit-foreground-image" or "observed-image data-testid=--hero-unit-foreground-image"
		}, {
			UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = t1.foregroundAspectRatio,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Height
			})
		}) else React.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.new(1, -t1.foregroundOverflow, 1 / t1.foregroundAspectRatio, -t1.foregroundOverflow / t1.foregroundAspectRatio),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			Position = if not t1.enableForegroundAnimation then UDim2.new(0.5, 0, 0, 0) else React.joinBindings({
				normalizedPosition = v27,
				frameSize = v24
			}):map(function(t4: {[any]: any}) -- line: 322
				-- upvalues: v23 (copy), v11 (copy), t1 (copy), v22 (copy), FFlagLuaAppHeroUnitParallaxUpdates (copy), getYPositionOffsetForMotion (copy), n10 (ref), n11 (ref)
				if v23.current == nil then
					v23.current = v11(t1.verticalScrollingFrameRef.current, v22.current)
				end

				local current = t1.verticalScrollingFrameRef.current
				local frameSizeY = t4.frameSize.Y
				local v70

				if current == nil then
					v70 = nil
				else
					local AbsoluteWindowSizeY = current.AbsoluteWindowSize.Y

					v70 = if not (AbsoluteWindowSizeY <= 0) then frameSizeY / AbsoluteWindowSizeY else nil
				end

				local normalizedPosition = t4.normalizedPosition
				local current2 = v23.current
				local v74 = if not FFlagLuaAppHeroUnitParallaxUpdates or (not (normalizedPosition < 0) or (not v70 or not (v70 > 0))) then if current2 ~= nil and (not (current2 <= 0) and not (current2 >= 1)) then math.clamp(normalizedPosition / current2, 0, 1) else normalizedPosition else math.clamp(normalizedPosition / v70, -1, 0)
				local frameSizeY2 = t4.frameSize.Y
				local v76 = -((frameSizeY2 - t1.foregroundOverflow) / t1.foregroundAspectRatio - frameSizeY2)

				if t1.foregroundAspectRatio == 1 then
					v76 -= t1.tokens.Size.Size_1500
				end

				local v77 = getYPositionOffsetForMotion(v74, v76, n10, n11)

				return UDim2.new(0.5, 0, 0, v77)
			end),
			Image = t1.foregroundImage,
			ZIndex = 1,
			BackgroundTransparency = 1,
			[React.Tag] = not FFlagLuaAppHomePageFirstImageLoadObserver and "data-testid=--hero-unit-foreground-image" or "observed-image data-testid=--hero-unit-foreground-image"
		}),
		HeroGradientFrame = t1.gradient and React.createElement("Frame", {
			ZIndex = 2,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 1),
			Size = UDim2.new(t1.gradientWidthPercent, 0, t1.gradientHeightPercent, v38),
			BackgroundColor3 = Color3.new(1, 1, 1)
		}, {
			HeroGradient = React.createElement("UIGradient", {
				Rotation = t1.gradient.degree,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, t1.gradient.startOpacity),
					NumberSequenceKeypoint.new(1, t1.gradient.endOpacity)
				}),
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, t1.gradient.startColor),
					ColorSequenceKeypoint.new(1, t1.gradient.endColor)
				})
			}),
			CornerRadius = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, t1.cornerRadius)
			})
		}) or nil
	})
end

return React.memo(HeroImages)
