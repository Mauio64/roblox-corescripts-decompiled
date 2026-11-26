local UserGameSettings = UserSettings():GetService("UserGameSettings")

local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryHeroUnit/ArgCheck")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryHeroUnit/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryHeroUnit/Foundation")
local useTokens = Foundation.Hooks.useTokens
local image = Foundation.Image
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryHeroUnit/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryHeroUnit/Responsive")

local HeroImages = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryHeroUnit/DiscoveryHeroUnit/HeroImages")
local heroNarrowLayout = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryHeroUnit/DiscoveryHeroUnit/HeroUnitTypes").HeroNarrowLayout

local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryHeroUnit/CollectionViews")
local collectionHeader = CollectionViews.CollectionHeader
local maybeForceDarkTheme = CollectionViews.maybeForceDarkTheme

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryHeroUnit/SharedFlags")
local fFlagLuaAppEnableHeroUnitV2 = SharedFlags.FFlagLuaAppEnableHeroUnitV2
local fFlagLuaAppHomePageFirstImageLoadObserver = SharedFlags.FFlagLuaAppHomePageFirstImageLoadObserver

local v5 = { Compact = 0.5625, Square = 1, Tall = 1.25 }

local v6 = { Color3 = Color3.new(1, 1, 1), Transparency = 0 }

local function scaleSizeForPlatform(p2, p3)
	return p2 * p3.Stroke.Standard
end

local function useHeroConfiguration(props, data)
	local v7 = Responsive.useResponsive({
		{ Key = "Small", maxWidth = 413 },
		{ Key = "Medium", maxWidth = 600 }
	})

	local v8 = nil
	local v9 = nil
	local v10, v11, v12, v13, v14, v15

	if v7 == "Small" or v7 == "Medium" then
		local narrowLayout = props.narrowLayout or heroNarrowLayout.Compact
		v8 = v5[narrowLayout] or v5[heroNarrowLayout.Compact]

		v10 = if v7 == "Small" then data.Typography.HeadingMedium else data.Typography.HeadingLarge

		v11 = data.Typography.BodyMedium
		v12 = props.titleImage == nil and narrowLayout == heroNarrowLayout.Compact or props.subtitle == nil
		v13 = data.Padding.Large
		v14 = data.Gap.Large

		if fFlagLuaAppEnableHeroUnitV2 then
			v15 = if props.titleImageAspectRatio == 1 then 0.26 else 0.16
		else
			v15 = 0.25
		end
	else
		v9 = 336 * data.Stroke.Standard

		v10 = data.Typography.DisplaySmall
		v11 = data.Typography.BodyLarge
		v12 = props.subtitle == nil
		v13 = data.Padding.XLarge
		v14 = data.Gap.XXLarge

		if fFlagLuaAppEnableHeroUnitV2 then
			v15 = if props.titleImageAspectRatio == 1 then 0.3 else 0.2
		else
			v15 = 0.3
		end
	end

	local v16, v17

	if props.gradient == nil or props.gradient.degree == 270 then
		v16 = 1
		v17 = 0.5
	elseif props.gradient.degree == 0 then
		v16 = 0.5
		v17 = 1
	else
		v16 = 1
		v17 = 0.5
	end

	return Cryo.Dictionary.join({
		cornerRadius = data.Radius.Medium,
		titleTypography = v10,
		subtitleTypography = v11,
		aspectRatio = v8,
		backgroundImageFrameHeight = v9,
		hideSubtitle = v12,
		foregroundOverflow = v14,
		backgroundOverflow = 50 * data.Stroke.Standard,
		foregroundAspectRatio = 1,
		gradientWidthPercent = v16,
		gradientHeightPercent = v17,
		contentPadding = v13,
		enableBackgroundAnimation = not UserGameSettings.ReducedMotion,
		enableForegroundAnimation = not UserGameSettings.ReducedMotion,
		sideMargin = 0,
		titleImageAspectRatio = 3,
		titleImageHeightPercentage = v15,
		minCardHeight = 262 * data.Stroke.Standard
	}, props)
end

local function HeroUnitContainer(props)
	local v7, v8 = React.useBinding(0)
	local v9 = React.useCallback(function(p2)
		if p2 then
			v8(p2.AbsoluteSize.X)
		end
	end, {})

	local v10 = useTokens()

	local v11 = useHeroConfiguration(props, v10)
	local v12

	if v11.backgroundImageFrameHeight and v11.foregroundOverflow then
		v12 = v11.backgroundImageFrameHeight + v11.foregroundOverflow
	else
		v12 = v11.backgroundImageFrameHeight
	end

	if fFlagLuaAppEnableHeroUnitV2 then
		assert(v11.minCardHeight ~= nil, "minCardHeight is required")
		assert(v11.titleImageAspectRatio ~= nil, "titleImageAspectRatio is required")
	end

	local v13 = React.useCallback(function()
		if props.titleImage then
			return React.createElement(image, {
				Image = props.titleImage,
				Size = v7:map(function(p2)
					local v14 = v12

					if v11.aspectRatio then
						v14 = math.max(v11.minCardHeight, p2 * v11.aspectRatio + v11.foregroundOverflow)
					end

					return UDim2.new(0, p2, 0, v14 * v11.titleImageHeightPercentage)
				end),
				aspectRatio = v11.titleImageAspectRatio,
				Position = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				ZIndex = 0,
				tag = fFlagLuaAppHomePageFirstImageLoadObserver and "observed-image" or nil
			})
		end

		ArgCheck.assert(false, "The path should never be called")
		return React.createElement(React.Fragment)
	end, {
		v7,
		v12,
		props.titleImage,
		v11.titleImageAspectRatio,
		v11.minCardHeight,
		v11.aspectRatio,
		v11.foregroundOverflow,
		v11.titleImageHeightPercentage
	})

	local v14 = props.headerComponent

	if not v14 then
		local createElement = React.createElement
		local v16 = {
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

		if fFlagLuaAppEnableHeroUnitV2 then
			v13 = props.title
		elseif not props.titleImage then
			v13 = props.title
		end

		v16.title = v13

		v16.AnchorPoint = Vector2.new(0, 0.5)
		local v17 = if not v11.hideSubtitle then props.subtitle else nil
		v16.subtitle = v17

		v16.titleColor = v6
		v16.subtitleColor = v6
		v16.titleTypography = v11.titleTypography
		v16.subtitleTypography = v11.subtitleTypography

		v16.Position = UDim2.new(0, 0, 0.5, 0)
		v14 = createElement(collectionHeader, v16)
	end

	local createElement = React.createElement
	local v16 = {
		["ref"] = nil,
		["ref"] = nil,
		["ref"] = nil,
		["ref"] = nil,
		["ref"] = nil,
		["ref"] = nil,
		ref = v9,
		[React.Change.AbsoluteSize] = v9,
		Position = UDim2.new(0, v11.sideMargin, 0, 0)
	}
	local v17

	if v11.aspectRatio then
		v17 = v7:map(function(p2)
			return UDim2.new(
				1,
				-2 * v11.sideMargin,
				0,
				(math.max(v11.minCardHeight, p2 * v11.aspectRatio + v11.foregroundOverflow))
			)
		end)
	else
		v17 = UDim2.new(1, -2 * v11.sideMargin, 0, v12)
	end

	v16.Size = v17

	v16.BackgroundTransparency = 1
	v16.BorderSizePixel = 0
	v16.Text = ""
	v16[React.Event.Activated] = props.onActivated
	v16.SelectionOrder = props.SelectionOrder
	local tag = React.Tag
	local v18 = if props.testId then `data-testid={props.testId}` else nil
	v16[tag] = v18
	local v19 = {
		HeroBackground = props.backgroundComponent or React.createElement(HeroImages, {
			ZIndex = 0,
			Size = UDim2.new(1, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			verticalScrollingFrameRef = props.verticalScrollingFrameRef,
			foregroundImage = props.foregroundImage,
			backgroundImage = props.backgroundImage,
			foregroundAspectRatio = v11.foregroundAspectRatio,
			foregroundOverflow = v11.foregroundOverflow,
			backgroundOverflow = v11.backgroundOverflow,
			cornerRadius = v11.cornerRadius,
			enableBackgroundAnimation = v11.enableBackgroundAnimation and not UserGameSettings.ReducedMotion,
			enableForegroundAnimation = v11.enableForegroundAnimation and not UserGameSettings.ReducedMotion,
			gradient = v11.gradient,
			gradientHeightPercent = v11.gradientHeightPercent,
			gradientWidthPercent = v11.gradientWidthPercent,
			tokens = v10
		}),
		HeroForeground = 0
	}

	local createElement2 = React.createElement
	local v22 = {
		Size = UDim2.new(1, 0, 1, -v11.foregroundOverflow),
		Position = UDim2.new(0, 0, 0, v11.foregroundOverflow),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 2
	}

	local children = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v11.contentPadding),
			PaddingRight = UDim.new(0, v11.contentPadding),
			PaddingTop = UDim.new(0, v11.contentPadding),
			PaddingBottom = UDim.new(0, v11.contentPadding)
		}),
		HeroLogo = 0,
		HeroHeaderFrame = 0,
		HeroBottomRowFrame = 0,
		HeroOverlay = 0
	}
	local v23

	if fFlagLuaAppEnableHeroUnitV2 and props.titleImage then
		v23 = React.createElement(image, {
			Image = props.titleImage,
			Size = v7:map(function(p2)
				local v24 = v12 or 0

				if v11.aspectRatio then
					v24 = math.max(v11.minCardHeight, p2 * v11.aspectRatio + v11.foregroundOverflow)
				end

				return UDim2.new(0, p2, 0, v24 * v11.titleImageHeightPercentage)
			end),
			aspectRatio = v11.titleImageAspectRatio,
			Position = UDim2.new(1, 0, 0, 0),
			AnchorPoint = Vector2.new(1, 0)
		})
	end

	children.HeroLogo = v23

	children.HeroHeaderFrame = React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}, { HeroHeader = v14 })

	children.HeroBottomRowFrame = React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}, { HeroBottomRow = props.bottomRowComponent })

	children.HeroOverlay = props.overlayComponent
	v19.HeroForeground = maybeForceDarkTheme(createElement2("Frame", v22, children), true)
	return createElement("TextButton", v16, v19)
end

return React.memo(HeroUnitContainer)
