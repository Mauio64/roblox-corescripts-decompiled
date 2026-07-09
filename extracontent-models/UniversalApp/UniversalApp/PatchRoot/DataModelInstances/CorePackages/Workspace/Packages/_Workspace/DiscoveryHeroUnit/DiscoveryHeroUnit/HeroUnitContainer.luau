local DiscoveryHeroUnit = script:FindFirstAncestor("DiscoveryHeroUnit")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local DiscoveryHeroUnitParent = DiscoveryHeroUnit.Parent
local ArgCheck = require(DiscoveryHeroUnitParent.ArgCheck)
local Cryo = require(DiscoveryHeroUnitParent.Cryo)
local Foundation = require(DiscoveryHeroUnitParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FoundationImage = Foundation.Image
local React = require(DiscoveryHeroUnitParent.React)
local Responsive = require(DiscoveryHeroUnitParent.Responsive)
local HeroImages = require(DiscoveryHeroUnit.HeroImages)
local HeroNarrowLayout = require(DiscoveryHeroUnit.HeroUnitTypes).HeroNarrowLayout
local CollectionViews = require(DiscoveryHeroUnitParent.CollectionViews)
local CollectionHeader = CollectionViews.CollectionHeader
local maybeForceDarkTheme = CollectionViews.maybeForceDarkTheme
local SharedFlags = require(DiscoveryHeroUnitParent.SharedFlags)
local FFlagLuaAppEnableHeroUnitV2 = SharedFlags.FFlagLuaAppEnableHeroUnitV2
local FFlagLuaAppHeroUnitParallaxUpdates = SharedFlags.FFlagLuaAppHeroUnitParallaxUpdates
local FFlagLuaAppHomePageFirstImageLoadObserver = SharedFlags.FFlagLuaAppHomePageFirstImageLoadObserver
local t1 = {
	Compact = 0.5625,
	Square = 1,
	Tall = 1.25
}
local t2 = {
	Transparency = 0,
	Color3 = Color3.new(1, 1, 1)
}

local function scaleSizeForPlatform(n1: number, p1) -- line: 138
	return n1 * p1.Stroke.Standard
end
local function useHeroConfiguration(t3: {[any]: any}, p2) -- line: 143
	-- upvalues: Responsive (copy), HeroNarrowLayout (copy), t1 (copy), FFlagLuaAppEnableHeroUnitV2 (copy), Cryo (copy), UserGameSettings (copy)
	local v29 = Responsive.useResponsive({
		{
			Key = "Small",
			maxWidth = 413
		},
		{
			Key = "Medium",
			maxWidth = 600
		}
	})
	local v30 = nil
	local v31 = nil
	local v33, BodyMedium, v35, Large, Large2, n2

	if v29 == "Small" or v29 == "Medium" then
		local v32 = t3.narrowLayout or HeroNarrowLayout.Compact

		v30 = t1[v32] or t1[HeroNarrowLayout.Compact]
		v33 = if v29 ~= "Small" then p2.Typography.HeadingLarge else p2.Typography.HeadingMedium
		BodyMedium = p2.Typography.BodyMedium
		v35 = t3.titleImage == nil and v32 == HeroNarrowLayout.Compact or t3.subtitle == nil
		Large = p2.Padding.Large
		Large2 = p2.Gap.Large

		if FFlagLuaAppEnableHeroUnitV2 then
			n2 = 0.16

			if t3.titleImageAspectRatio == 1 then
				n2 = 0.26
			end
		else
			n2 = 0.25
		end
	else
		v31 = 336 * p2.Stroke.Standard
		v33 = p2.Typography.DisplaySmall
		BodyMedium = p2.Typography.BodyLarge
		v35 = t3.subtitle == nil
		Large = p2.Padding.XLarge
		Large2 = p2.Gap.XXLarge

		if FFlagLuaAppEnableHeroUnitV2 then
			n2 = 0.2

			if t3.titleImageAspectRatio == 1 then
				n2 = 0.3
			end
		else
			n2 = 0.3
		end
	end

	local n3, n4

	if t3.gradient ~= nil then
		if t3.gradient.degree == 270 then
			n3 = 0.5
			n4 = 1
		elseif t3.gradient.degree == 0 then
			n3 = 1
			n4 = 0.5
		else
			n3 = 0.5
			n4 = 1
		end
	else
		n3 = 0.5
		n4 = 1
	end

	return Cryo.Dictionary.join({
		foregroundAspectRatio = 1,
		sideMargin = 0,
		minForegroundHeightPercent = 0.8,
		maxForegroundHeightPercent = 1,
		titleImageAspectRatio = 3,
		cornerRadius = p2.Radius.Medium,
		titleTypography = v33,
		subtitleTypography = BodyMedium,
		aspectRatio = v30,
		backgroundImageFrameHeight = v31,
		hideSubtitle = v35,
		foregroundOverflow = Large2,
		backgroundOverflow = 50 * p2.Stroke.Standard,
		gradientWidthPercent = n4,
		gradientHeightPercent = n3,
		contentPadding = Large,
		enableBackgroundAnimation = not UserGameSettings.ReducedMotion,
		enableForegroundAnimation = not UserGameSettings.ReducedMotion,
		titleImageHeightPercentage = n2,
		minCardHeight = 262 * p2.Stroke.Standard
	}, t3)
end
local function HeroUnitContainer(t4: {[any]: any}) -- line: 246
	-- upvalues: React (copy), useTokens (copy), useHeroConfiguration (copy), FFlagLuaAppEnableHeroUnitV2 (copy), ArgCheck (copy), FoundationImage (copy), FFlagLuaAppHomePageFirstImageLoadObserver (copy), CollectionHeader (copy), t2 (copy), HeroImages (copy), FFlagLuaAppHeroUnitParallaxUpdates (copy), UserGameSettings (copy), maybeForceDarkTheme (copy)
	local v42, v43 = React.useBinding(0)
	local v44 = React.useCallback(function(p3) -- line: 248
		-- upvalues: v43 (copy)
		if p3 then
			v43(p3.AbsoluteSize.X)
		end
	end, {})
	local v45 = useTokens()
	local v46 = useHeroConfiguration(t4, v45)
	local u47 = if not v46.backgroundImageFrameHeight or not v46.foregroundOverflow then v46.backgroundImageFrameHeight else v46.backgroundImageFrameHeight + v46.foregroundOverflow

	if FFlagLuaAppEnableHeroUnitV2 then
		assert(v46.minCardHeight ~= nil, "minCardHeight is required")
		assert(v46.titleImageAspectRatio ~= nil, "titleImageAspectRatio is required")
	end

	local v48 = React.useCallback(function() -- line: 270
		-- upvalues: t4 (copy), ArgCheck (copy), React (copy), FoundationImage (copy), v42 (copy), u47 (ref), v46 (copy), FFlagLuaAppHomePageFirstImageLoadObserver (copy)
		if not t4.titleImage then
			ArgCheck.assert(false, "The path should never be called")

			return React.createElement(React.Fragment)
		end

		return React.createElement(FoundationImage, {
			ZIndex = 0,
			Image = t4.titleImage,
			Size = v42:map(function(n5: number) -- line: 278
				-- upvalues: u47 (ref), v46 (copy)
				local v59 = u47

				if v46.aspectRatio then
					v59 = math.max(v46.minCardHeight, n5 * v46.aspectRatio + v46.foregroundOverflow)
				end

				return UDim2.new(0, n5, 0, v59 * v46.titleImageHeightPercentage)
			end),
			aspectRatio = v46.titleImageAspectRatio,
			Position = UDim2.new(0, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			tag = if not FFlagLuaAppHomePageFirstImageLoadObserver then nil else "observed-image"
		})
	end, {
		v42,
		u47,
		t4.titleImage,
		v46.titleImageAspectRatio,
		v46.minCardHeight,
		v46.aspectRatio,
		v46.foregroundOverflow,
		v46.titleImageHeightPercentage
	})
	local v49 = t4.headerComponent or React.createElement(CollectionHeader, {
		LayoutOrder = 0,
		hideButton = true,
		forceUpdatedHeader = true,
		AutomaticSize = Enum.AutomaticSize.Y,
		title = if not FFlagLuaAppEnableHeroUnitV2 then if not t4.titleImage then t4.title else v48 else t4.title,
		AnchorPoint = Vector2.new(0, 0.5),
		subtitle = if not v46.hideSubtitle then t4.subtitle else nil,
		titleColor = t2,
		subtitleColor = t2,
		titleTypography = v46.titleTypography,
		subtitleTypography = v46.subtitleTypography,
		Position = UDim2.new(0, 0, 0.5, 0)
	})

	return React.createElement("TextButton", {
		ref = v44,
		[React.Change.AbsoluteSize] = v44,
		Position = UDim2.new(0, v46.sideMargin, 0, 0),
		Size = if not v46.aspectRatio then UDim2.new(1, -2 * v46.sideMargin, 0, u47) else v42:map(function(n6: number) -- line: 327
			-- upvalues: v46 (copy)
			return UDim2.new(1, -2 * v46.sideMargin, 0, (math.max(v46.minCardHeight, n6 * v46.aspectRatio + v46.foregroundOverflow)))
		end),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		[React.Event.Activated] = t4.onActivated,
		SelectionOrder = t4.SelectionOrder,
		[React.Tag] = if not t4.testId then nil else `data-testid={ t4.testId }`
	}, {
		HeroBackground = t4.backgroundComponent or React.createElement(HeroImages, {
			ZIndex = 0,
			Size = UDim2.new(1, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			verticalScrollingFrameRef = t4.verticalScrollingFrameRef,
			foregroundImage = t4.foregroundImage,
			backgroundImage = t4.backgroundImage,
			foregroundAspectRatio = v46.foregroundAspectRatio,
			foregroundHeightPercent = if not FFlagLuaAppHeroUnitParallaxUpdates then v42:map(function(n7: number) -- line: 358
				-- upvalues: v46 (copy)
				local minForegroundHeightPercent = v46.minForegroundHeightPercent
				local maxForegroundHeightPercent = v46.maxForegroundHeightPercent

				if n7 < 600 then
					return minForegroundHeightPercent
				end

				if n7 > 1140 then
					return maxForegroundHeightPercent
				end

				local v55 = (n7 - 600) / 540

				return v55 * maxForegroundHeightPercent + (1 - v55) * minForegroundHeightPercent
			end) else nil,
			foregroundOverflow = v46.foregroundOverflow,
			backgroundOverflow = v46.backgroundOverflow,
			cornerRadius = v46.cornerRadius,
			enableBackgroundAnimation = v46.enableBackgroundAnimation and not UserGameSettings.ReducedMotion,
			enableForegroundAnimation = v46.enableForegroundAnimation and not UserGameSettings.ReducedMotion,
			gradient = v46.gradient,
			gradientHeightPercent = v46.gradientHeightPercent,
			gradientWidthPercent = v46.gradientWidthPercent,
			tokens = v45
		}),
		HeroForeground = maybeForceDarkTheme(React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 2,
			Size = UDim2.new(1, 0, 1, -v46.foregroundOverflow),
			Position = UDim2.new(0, 0, 0, v46.foregroundOverflow)
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v46.contentPadding),
				PaddingRight = UDim.new(0, v46.contentPadding),
				PaddingTop = UDim.new(0, v46.contentPadding),
				PaddingBottom = UDim.new(0, v46.contentPadding)
			}),
			HeroLogo = if not FFlagLuaAppEnableHeroUnitV2 or not t4.titleImage then nil else React.createElement(FoundationImage, {
				Image = t4.titleImage,
				Size = v42:map(function(n8: number) -- line: 401
					-- upvalues: u47 (ref), v46 (copy)
					local v57 = u47 or 0

					if v46.aspectRatio then
						v57 = math.max(v46.minCardHeight, n8 * v46.aspectRatio + v46.foregroundOverflow)
					end

					return UDim2.new(0, n8, 0, v57 * v46.titleImageHeightPercentage)
				end),
				aspectRatio = v46.titleImageAspectRatio,
				Position = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(1, 0)
			}),
			HeroHeaderFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Position = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5)
			}, {
				HeroHeader = v49
			}),
			HeroBottomRowFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Position = UDim2.new(0, 0, 1, 0),
				AnchorPoint = Vector2.new(0, 1)
			}, {
				HeroBottomRow = t4.bottomRowComponent
			}),
			HeroOverlay = t4.overlayComponent
		}), true)
	})
end

return React.memo(HeroUnitContainer)
