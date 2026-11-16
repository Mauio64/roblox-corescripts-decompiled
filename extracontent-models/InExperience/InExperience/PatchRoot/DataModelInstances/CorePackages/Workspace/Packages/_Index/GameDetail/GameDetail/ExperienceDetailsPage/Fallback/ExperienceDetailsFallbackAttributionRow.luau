local defineFastInt = game:DefineFastInt("EdpFallbackActionBarPlayButtonWidth", 236)
local defineFastInt2 = game:DefineFastInt("EdpFallbackIconSize", 140)

local parent = script:FindFirstAncestor("GameDetail").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Image = Foundation.Image
local Text = Foundation.Text
local Icon = Foundation.Icon
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius
local ButtonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens
local GamePlayButton = require(parent.GamePlayButton)
local PlayButton = GamePlayButton.PlayButton
local useImageLoadFade = require(script.Parent.Parent.useImageLoadFade)
local Responsive = require(parent.Responsive)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEdpFallbackPrimaryActivation = SharedFlags.FFlagLuaAppEdpFallbackPrimaryActivation
local FFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local FFlagLuaAppLaunchWhenLoadingEdp = SharedFlags.FFlagLuaAppLaunchWhenLoadingEdp
local FFlagLuaAppSduiEdpFallbackAttributionFromCache = SharedFlags.FFlagLuaAppSduiEdpFallbackAttributionFromCache
local FFlagSduiScalePlayButtonAndImageSizes = SharedFlags.FFlagSduiScalePlayButtonAndImageSizes
local FFlagEnableGameJoinEarlyAccess = SharedFlags.FFlagEnableGameJoinEarlyAccess

local function VerifiedBadgeIcon()
	local v = useTokens()
	return React.createElement(View, { LayoutOrder = 2, tag = "auto-xy" }, {
		Backplate = React.createElement(Icon, {
			name = Foundation.Enums.IconName.VerifiedBackplate,
			style = v.Color.System.Emphasis,
			size = Foundation.Enums.IconSize.Small,
			ZIndex = 1
		}),
		Check = React.createElement(Icon, {
			name = Foundation.Enums.IconName.VerifiedCheck,
			size = Foundation.Enums.IconSize.Small,
			variant = Foundation.Enums.IconVariant.Filled,
			style = v.Color.Extended.White.White_100,
			ZIndex = 2
		})
	})
end

local function FallbackAttributionRow(props)
	local v = useTokens()
	local isSmallScreen = props.isSmallScreen
	local isLoading = props.isLoading == true
	local onRegisterActivation

	if FFlagLuaAppEdpFallbackPrimaryActivation then
		onRegisterActivation = React.useCallback(function(callback)
			return SduiSharedUtilities.getSduiFocusActivationStore().register(
				SduiSharedUtilities.SduiFocusTags.PrimaryAction,
				callback
			)
		end, {})
	end

	local v2

	if FFlagLuaAppMediaGalleryGamepadSupport then
		v2 = Responsive.useLastInput() == Responsive.Input.Directional
	else
		v2 = false
	end

	local v3

	if isSmallScreen then
		v3 = v.Size.Size_1400
	elseif FFlagLuaAppMediaGalleryGamepadSupport and v2 and defineFastInt2 > 0 then
		if FFlagSduiScalePlayButtonAndImageSizes then
			v3 = defineFastInt2 * v.Config.UI.Scale
		else
			v3 = defineFastInt2
		end
	else
		v3 = v.Size.Size_2500 * 2
	end

	local v4 = isSmallScreen and 150 or FFlagSduiScalePlayButtonAndImageSizes and v3 > 256 and 512 or 256
	local image = string.format("rbxthumb://type=GameIcon&id=%s&w=%d&h=%d", props.universeId, v4, v4)
	local v5 = useImageLoadFade()

	local createElement = React.createElement
	local v6 = {
		LayoutOrder = 1,
		Size = UDim2.fromOffset(v3, v3),
		testId = "--edp-fallback-attribution-icon"
	}

	local v7 = {
		GameIcon = React.createElement(Image, {
			tag = "radius-medium",
			Image = image,
			Size = UDim2.fromScale(1, 1),
			onLoaded = v5.onLoaded
		}),
		SkeletonOverlay = 0
	}
	local skeletonOverlay

	if v5.skeletonVisible then
		skeletonOverlay = React.createElement(View, {
			tag = "radius-medium",
			Size = UDim2.fromScale(1, 1),
			ZIndex = 2,
			ClipsDescendants = true,
			GroupTransparency = v5.overlayTransparency
		}, {
			Skeleton = React.createElement(Skeleton, { Size = UDim2.fromScale(1, 1) })
		})
	end

	v7.SkeletonOverlay = skeletonOverlay
	local element = createElement(View, v6, v7)
	local v8

	if isSmallScreen then
		v8 = v.Typography.CaptionLarge.LineHeight * v.Typography.CaptionLarge.FontSize
	else
		v8 = v.Typography.BodyMedium.LineHeight * v.Typography.BodyMedium.FontSize
	end

	local title = nil

	if props.gameName then
		title = React.createElement(Text, {
			tag = {
				["auto-xy text-wrap text-align-x-left text-truncate-none"] = true,
				["text-heading-small"] = isSmallScreen,
				["text-heading-large"] = not isSmallScreen
			},
			Text = props.gameName,
			LayoutOrder = 1,
			testId = "--edp-fallback-attribution-title"
		})
	elseif isLoading then
		local v9

		if isSmallScreen then
			v9 = v8
		else
			v9 = v.Typography.HeadingMedium.LineHeight * v.Typography.HeadingMedium.FontSize
		end

		title = React.createElement(Skeleton, {
			Size = UDim2.fromOffset(v.Size.Size_2800 * 2, v9),
			radius = Radius.Small,
			LayoutOrder = 1
		})
	end

	local creator = nil

	if props.creatorName then
		local createElement2 = React.createElement

		local v9 = {
			CreatorName = React.createElement(Text, {
				tag = "auto-xy text-body-medium content-default",
				Text = props.creatorName,
				TextTruncate = Enum.TextTruncate.None,
				LayoutOrder = 1,
				testId = "--edp-fallback-attribution-creator"
			}),
			Badge = 0
		}
		local badge

		if props.hasVerifiedBadge then
			badge = React.createElement(VerifiedBadgeIcon)
		end

		v9.Badge = badge
		creator = createElement2(View, {
			tag = "row align-y-center gap-xsmall auto-xy",
			LayoutOrder = 2
		}, v9)
	elseif isLoading then
		local v9

		if FFlagLuaAppSduiEdpFallbackAttributionFromCache then
			v9 = v.Typography.BodyLarge.FontSize * v.Typography.BodyLarge.LineHeight
		else
			v9 = v8
		end

		creator = React.createElement(Skeleton, {
			Size = UDim2.fromOffset(v.Size.Size_2800 * 2, v9),
			radius = Radius.Small,
			LayoutOrder = 2,
			testId = "--edp-fallback-attribution-creator-skeleton"
		})
	end

	local ageRating = nil

	if props.ageRecDisplayName then
		ageRating = React.createElement(Text, {
			tag = "auto-xy text-body-medium content-default",
			Text = props.ageRecDisplayName,
			LayoutOrder = 3,
			testId = "--edp-fallback-attribution-age-rating"
		})
	elseif isLoading then
		if FFlagLuaAppSduiEdpFallbackAttributionFromCache then
			v8 = v.Typography.BodyMedium.FontSize

			if not isSmallScreen then
				v8 += v.Padding.XSmall
			end
		end

		local createElement2 = React.createElement
		local v9

		if isSmallScreen then
			v9 = v.Size.Size_2400
		else
			v9 = v.Size.Size_2800
		end

		ageRating = createElement2(Skeleton, {
			Size = UDim2.fromOffset(v9, v8),
			radius = Radius.Small,
			LayoutOrder = 3,
			testId = "--edp-fallback-attribution-age-rating-skeleton"
		})
	end

	local actionRow

	if not isSmallScreen then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local v9 = {
			universeId = props.universeId,
			referralSource = props.referralSource,
			launchSource = props.launchSource,
			experienceJoinData = props.experienceJoinData,
			placeId = props.placeIdOverride,
			useUIBloxButton = true,
			buttonSize = ButtonSize.Large,
			width = 0,
			launchWhenLoading = 0,
			launchOnReleaseAfterUnmount = true,
			onRegisterActivation = 0,
			enableEarlyAccessPlusTooltip = 0,
			expandWidthForSecondaryPlayButton = true,
			LayoutOrder = 1,
			testId = "--edp-fallback-feed-play-button"
		}
		local v10

		if FFlagSduiScalePlayButtonAndImageSizes then
			v10 = defineFastInt * v.Config.UI.Scale
		else
			v10 = defineFastInt
		end

		v9.width = UDim.new(0, v10)

		v9.launchWhenLoading = FFlagLuaAppLaunchWhenLoadingEdp and true or nil

		if not FFlagLuaAppEdpFallbackPrimaryActivation then
			onRegisterActivation = nil
		end

		v9.onRegisterActivation = onRegisterActivation
		v9.enableEarlyAccessPlusTooltip = FFlagEnableGameJoinEarlyAccess and true or nil
		local v11 = {
			PlayBtn = createElement3(PlayButton, v9),
			OverflowSkeleton1 = 0,
			OverflowSkeleton2 = 0
		}
		local overflowSkeleton

		if isLoading then
			overflowSkeleton = React.createElement(Skeleton, {
				Size = UDim2.fromOffset(v.Size.Size_1200, v.Size.Size_1200),
				radius = Radius.Medium,
				LayoutOrder = 2
			})
		end

		v11.OverflowSkeleton1 = overflowSkeleton
		local overflowSkeleton2

		if isLoading then
			overflowSkeleton2 = React.createElement(Skeleton, {
				Size = UDim2.fromOffset(v.Size.Size_1200, v.Size.Size_1200),
				radius = Radius.Medium,
				LayoutOrder = 3
			})
		end

		v11.OverflowSkeleton2 = overflowSkeleton2
		actionRow = createElement2(View, {
			tag = "row align-y-center gap-small auto-xy",
			LayoutOrder = 4
		}, v11)
	end

	return React.createElement(View, {
		tag = {
			["row size-full-0 auto-y"] = true,
			["gap-medium"] = isSmallScreen,
			["gap-xlarge"] = not isSmallScreen,
			["align-y-center"] = isSmallScreen,
			["align-y-bottom"] = not isSmallScreen
		},
		LayoutOrder = 1
	}, {
		Icon = element,
		ContentColumn = React.createElement(View, {
			tag = {
				["col fill gap-xsmall auto-xy"] = FFlagLuaAppSduiEdpFallbackAttributionFromCache,
				["col fill gap-small auto-xy"] = not FFlagLuaAppSduiEdpFallbackAttributionFromCache
			},
			LayoutOrder = 2,
			testId = "--edp-fallback-attribution-content-column"
		}, { Title = title, Creator = creator, AgeRating = ageRating, ActionRow = actionRow })
	})
end

return React.memo(FallbackAttributionRow)
