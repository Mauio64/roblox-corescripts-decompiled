local DiscoveryHeroUnit = script:FindFirstAncestor("DiscoveryHeroUnit")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local parent = DiscoveryHeroUnit.Parent
local ArgCheck = require(parent.ArgCheck)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Image = Foundation.Image
local React = require(parent.React)
local Responsive = require(parent.Responsive)

local HeroImages = require(DiscoveryHeroUnit.HeroImages)
local HeroUnitTypes = require(DiscoveryHeroUnit.HeroUnitTypes)
local HeroNarrowLayout = HeroUnitTypes.HeroNarrowLayout

local CollectionViews = require(parent.CollectionViews)
local CollectionHeader = CollectionViews.CollectionHeader
local maybeForceDarkTheme = CollectionViews.maybeForceDarkTheme

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableHeroUnitV2 = SharedFlags.FFlagLuaAppEnableHeroUnitV2
local FFlagLuaAppHomePageFirstImageLoadObserver = SharedFlags.FFlagLuaAppHomePageFirstImageLoadObserver

local v = { Compact = 0.5625, Square = 1, Tall = 1.25 }

local v2 = { Color3 = Color3.new(1, 1, 1), Transparency = 0 }

local function scaleSizeForPlatform(p: number, data) -- 3 equivalent calls inferred from this helper
	return p * data.Stroke.Standard
end

local function useHeroConfiguration(props, data)
	local v3 = Responsive.useResponsive({
		{ Key = "Small", maxWidth = 413 },
		{ Key = "Medium", maxWidth = 600 }
	})

	local aspectRatio = nil
	local backgroundImageFrameHeight = nil
	local titleTypography, subtitleTypography, hideSubtitle, contentPadding, foregroundOverflow, titleImageHeightPercentage

	if v3 == "Small" or v3 == "Medium" then
		local narrowLayout = props.narrowLayout or HeroNarrowLayout.Compact
		aspectRatio = v[narrowLayout] or v[HeroNarrowLayout.Compact]

		if v3 == "Small" then
			titleTypography = data.Typography.HeadingMedium
		else
			titleTypography = data.Typography.HeadingLarge
		end

		subtitleTypography = data.Typography.BodyMedium
		hideSubtitle = props.titleImage == nil and narrowLayout == HeroNarrowLayout.Compact or props.subtitle == nil
		contentPadding = data.Padding.Large
		foregroundOverflow = data.Gap.Large

		if FFlagLuaAppEnableHeroUnitV2 then
			if props.titleImageAspectRatio == 1 then
				titleImageHeightPercentage = 0.26
			else
				titleImageHeightPercentage = 0.16
			end
		else
			titleImageHeightPercentage = 0.25
		end
	else
		backgroundImageFrameHeight = scaleSizeForPlatform(336, data) -- inferred equivalent call
		titleTypography = data.Typography.DisplaySmall
		subtitleTypography = data.Typography.BodyLarge
		hideSubtitle = props.subtitle == nil
		contentPadding = data.Padding.XLarge
		foregroundOverflow = data.Gap.XXLarge

		if FFlagLuaAppEnableHeroUnitV2 then
			if props.titleImageAspectRatio == 1 then
				titleImageHeightPercentage = 0.3
			else
				titleImageHeightPercentage = 0.2
			end
		else
			titleImageHeightPercentage = 0.3
		end
	end

	local gradientWidthPercent, gradientHeightPercent

	if props.gradient == nil or props.gradient.degree == 270 then
		gradientWidthPercent = 1
		gradientHeightPercent = 0.5
	elseif props.gradient.degree == 0 then
		gradientWidthPercent = 0.5
		gradientHeightPercent = 1
	else
		gradientWidthPercent = 1
		gradientHeightPercent = 0.5
	end

	return Cryo.Dictionary.join({
		cornerRadius = data.Radius.Medium,
		titleTypography = titleTypography,
		subtitleTypography = subtitleTypography,
		aspectRatio = aspectRatio,
		backgroundImageFrameHeight = backgroundImageFrameHeight,
		hideSubtitle = hideSubtitle,
		foregroundOverflow = foregroundOverflow,
		backgroundOverflow = scaleSizeForPlatform(50, data), -- inferred equivalent call
		foregroundAspectRatio = 1,
		gradientWidthPercent = gradientWidthPercent,
		gradientHeightPercent = gradientHeightPercent,
		contentPadding = contentPadding,
		enableBackgroundAnimation = not UserGameSettings.ReducedMotion,
		enableForegroundAnimation = not UserGameSettings.ReducedMotion,
		sideMargin = 0,
		titleImageAspectRatio = 3,
		titleImageHeightPercentage = titleImageHeightPercentage,
		minCardHeight = scaleSizeForPlatform(262, data) -- inferred equivalent call
	}, props)
end

local function HeroUnitContainer(props)
	local v3, v4 = React.useBinding(0)
	local ref = React.useCallback(function(p)
		if p then
			v4(p.AbsoluteSize.X)
		end
	end, {})

	local tokens = useTokens()

	local v5 = useHeroConfiguration(props, tokens)
	local v6

	if v5.backgroundImageFrameHeight and v5.foregroundOverflow then
		v6 = v5.backgroundImageFrameHeight + v5.foregroundOverflow
	else
		v6 = v5.backgroundImageFrameHeight
	end

	if FFlagLuaAppEnableHeroUnitV2 then
		assert(v5.minCardHeight ~= nil, "minCardHeight is required")
		assert(v5.titleImageAspectRatio ~= nil, "titleImageAspectRatio is required")
	end

	local title = React.useCallback(function()
		if props.titleImage then
			return React.createElement(Image, {
				Image = props.titleImage,
				Size = v3:map(function(p: number)
					local v7 = v6

					if v5.aspectRatio then
						v7 = math.max(v5.minCardHeight, p * v5.aspectRatio + v5.foregroundOverflow)
					end

					return UDim2.new(0, p, 0, v7 * v5.titleImageHeightPercentage)
				end),
				aspectRatio = v5.titleImageAspectRatio,
				Position = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				ZIndex = 0,
				tag = FFlagLuaAppHomePageFirstImageLoadObserver and "observed-image" or nil
			})
		end

		ArgCheck.assert(false, "The path should never be called")
		return React.createElement(React.Fragment)
	end, {
		v3,
		v6,
		props.titleImage,
		v5.titleImageAspectRatio,
		v5.minCardHeight,
		v5.aspectRatio,
		v5.foregroundOverflow,
		v5.titleImageHeightPercentage
	})

	local heroHeader = props.headerComponent

	if not heroHeader then
		local createElement = React.createElement
		local v7 = {
			LayoutOrder = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			title = 0,
			AnchorPoint = 0,
			subtitle = 0,
			hideButton = true,
			titleColor = 0,
			subtitleColor = 0,
			titleTypography = 0,
			subtitleTypography = 0,
			forceUpdatedHeader = true,
			Position = 0
		}

		if FFlagLuaAppEnableHeroUnitV2 then
			title = props.title
		elseif not props.titleImage then
			title = props.title
		end

		v7.title = title

		v7.AnchorPoint = Vector2.new(0, 0.5)
		local subtitle

		if not v5.hideSubtitle then
			subtitle = props.subtitle
		end

		v7.subtitle = subtitle

		v7.titleColor = v2
		v7.subtitleColor = v2
		v7.titleTypography = v5.titleTypography
		v7.subtitleTypography = v5.subtitleTypography

		v7.Position = UDim2.new(0, 0, 0.5, 0)
		heroHeader = createElement(CollectionHeader, v7)
	end

	local createElement = React.createElement
	local v7 = {
		["ref"] = nil,
		["ref"] = nil,
		["ref"] = nil,
		["ref"] = nil,
		["ref"] = nil,
		["ref"] = nil,
		ref = ref,
		[React.Change.AbsoluteSize] = ref,
		Position = UDim2.new(0, v5.sideMargin, 0, 0)
	}
	local size

	if v5.aspectRatio then
		size = v3:map(function(p: number)
			return UDim2.new(
				1,
				-2 * v5.sideMargin,
				0,
				(math.max(v5.minCardHeight, p * v5.aspectRatio + v5.foregroundOverflow))
			)
		end)
	else
		size = UDim2.new(1, -2 * v5.sideMargin, 0, v6)
	end

	v7.Size = size

	v7.BackgroundTransparency = 1
	v7.BorderSizePixel = 0
	v7.Text = ""
	v7[React.Event.Activated] = props.onActivated
	v7.SelectionOrder = props.SelectionOrder
	local tag = React.Tag
	local v8

	if props.testId then
		v8 = `data-testid={props.testId}`
	end

	v7[tag] = v8
	local v9 = {
		HeroBackground = props.backgroundComponent or React.createElement(HeroImages, {
			ZIndex = 0,
			Size = UDim2.new(1, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			verticalScrollingFrameRef = props.verticalScrollingFrameRef,
			foregroundImage = props.foregroundImage,
			backgroundImage = props.backgroundImage,
			foregroundAspectRatio = v5.foregroundAspectRatio,
			foregroundOverflow = v5.foregroundOverflow,
			backgroundOverflow = v5.backgroundOverflow,
			cornerRadius = v5.cornerRadius,
			enableBackgroundAnimation = v5.enableBackgroundAnimation and not UserGameSettings.ReducedMotion,
			enableForegroundAnimation = v5.enableForegroundAnimation and not UserGameSettings.ReducedMotion,
			gradient = v5.gradient,
			gradientHeightPercent = v5.gradientHeightPercent,
			gradientWidthPercent = v5.gradientWidthPercent,
			tokens = tokens
		}),
		HeroForeground = 0
	}

	local createElement2 = React.createElement
	local v10 = {
		Size = UDim2.new(1, 0, 1, -v5.foregroundOverflow),
		Position = UDim2.new(0, 0, 0, v5.foregroundOverflow),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 2
	}

	local children = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v5.contentPadding),
			PaddingRight = UDim.new(0, v5.contentPadding),
			PaddingTop = UDim.new(0, v5.contentPadding),
			PaddingBottom = UDim.new(0, v5.contentPadding)
		}),
		HeroLogo = 0,
		HeroHeaderFrame = 0,
		HeroBottomRowFrame = 0,
		HeroOverlay = 0
	}
	local heroLogo

	if FFlagLuaAppEnableHeroUnitV2 and props.titleImage then
		heroLogo = React.createElement(Image, {
			Image = props.titleImage,
			Size = v3:map(function(p: number)
				local v11 = v6 or 0

				if v5.aspectRatio then
					v11 = math.max(v5.minCardHeight, p * v5.aspectRatio + v5.foregroundOverflow)
				end

				return UDim2.new(0, p, 0, v11 * v5.titleImageHeightPercentage)
			end),
			aspectRatio = v5.titleImageAspectRatio,
			Position = UDim2.new(1, 0, 0, 0),
			AnchorPoint = Vector2.new(1, 0)
		})
	end

	children.HeroLogo = heroLogo

	children.HeroHeaderFrame = React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}, { HeroHeader = heroHeader })

	children.HeroBottomRowFrame = React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}, { HeroBottomRow = props.bottomRowComponent })

	children.HeroOverlay = props.overlayComponent
	v9.HeroForeground = maybeForceDarkTheme(createElement2("Frame", v10, children), true)
	return createElement("TextButton", v7, v9)
end

return React.memo(HeroUnitContainer)
