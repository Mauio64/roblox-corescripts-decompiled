local defineFastInt = game:DefineFastInt("EdpFallbackActionBarPlayButtonWidth", 236)
local defineFastInt2 = game:DefineFastInt("EdpFallbackIconSize", 140)

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Foundation")
local view = Foundation.View
local image = Foundation.Image
local text = Foundation.Text
local icon = Foundation.Icon
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius
local buttonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens
local playButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/GamePlayButton").PlayButton
local useImageLoadFade = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/useImageLoadFade")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Responsive")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SduiSharedUtilities")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SharedFlags")
local fFlagLuaAppEdpFallbackPrimaryActivation = SharedFlags.FFlagLuaAppEdpFallbackPrimaryActivation
local fFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local fFlagLuaAppLaunchWhenLoadingEdp = SharedFlags.FFlagLuaAppLaunchWhenLoadingEdp
local fFlagLuaAppSduiEdpFallbackAttributionFromCache = SharedFlags.FFlagLuaAppSduiEdpFallbackAttributionFromCache
local fFlagSduiScalePlayButtonAndImageSizes = SharedFlags.FFlagSduiScalePlayButtonAndImageSizes
local fFlagEnableGameJoinEarlyAccess = SharedFlags.FFlagEnableGameJoinEarlyAccess

local function VerifiedBadgeIcon()
	local v5 = useTokens()
	return React.createElement(view, { LayoutOrder = 2, tag = "auto-xy" }, {
		Backplate = React.createElement(icon, {
			name = Foundation.Enums.IconName.VerifiedBackplate,
			style = v5.Color.System.Emphasis,
			size = Foundation.Enums.IconSize.Small,
			ZIndex = 1
		}),
		Check = React.createElement(icon, {
			name = Foundation.Enums.IconName.VerifiedCheck,
			size = Foundation.Enums.IconSize.Small,
			variant = Foundation.Enums.IconVariant.Filled,
			style = v5.Color.Extended.White.White_100,
			ZIndex = 2
		})
	})
end

local function FallbackAttributionRow(props)
	local v5 = useTokens()
	local isSmallScreen = props.isSmallScreen
	local isLoading = props.isLoading == true
	local v6

	if fFlagLuaAppEdpFallbackPrimaryActivation then
		v6 = React.useCallback(function(p2)
			return SduiSharedUtilities.getSduiFocusActivationStore().register(SduiSharedUtilities.SduiFocusTags.PrimaryAction, p2)
		end, {})
	end

	local v7

	if fFlagLuaAppMediaGalleryGamepadSupport then
		v7 = Responsive.useLastInput() == Responsive.Input.Directional
	else
		v7 = false
	end

	local v8

	if isSmallScreen then
		v8 = v5.Size.Size_1400
	elseif fFlagLuaAppMediaGalleryGamepadSupport and v7 and defineFastInt2 > 0 then
		if fFlagSduiScalePlayButtonAndImageSizes then
			v8 = defineFastInt2 * v5.Config.UI.Scale
		else
			v8 = defineFastInt2
		end
	else
		v8 = v5.Size.Size_2500 * 2
	end

	local v9 = isSmallScreen and 150 or fFlagSduiScalePlayButtonAndImageSizes and v8 > 256 and 512 or 256
	local v10 = string.format("rbxthumb://type=GameIcon&id=%s&w=%d&h=%d", props.universeId, v9, v9)
	local v11 = useImageLoadFade()

	local createElement = React.createElement
	local v13 = {
		LayoutOrder = 1,
		Size = UDim2.fromOffset(v8, v8),
		testId = "--edp-fallback-attribution-icon"
	}

	local v14 = {
		GameIcon = React.createElement(image, {
			tag = "radius-medium",
			Image = v10,
			Size = UDim2.fromScale(1, 1),
			onLoaded = v11.onLoaded
		}),
		SkeletonOverlay = 0
	}

	local v15 = if v11.skeletonVisible then React.createElement(view, {
		tag = "radius-medium",
		Size = UDim2.fromScale(1, 1),
		ZIndex = 2,
		ClipsDescendants = true,
		GroupTransparency = v11.overlayTransparency
	}, {
		Skeleton = React.createElement(skeleton, { Size = UDim2.fromScale(1, 1) })
	}) else nil
	v14.SkeletonOverlay = v15
	local element = createElement(view, v13, v14)
	local v16

	if isSmallScreen then
		v16 = v5.Typography.CaptionLarge.LineHeight * v5.Typography.CaptionLarge.FontSize
	else
		v16 = v5.Typography.BodyMedium.LineHeight * v5.Typography.BodyMedium.FontSize
	end

	local v17 = nil

	if props.gameName then
		v17 = React.createElement(text, {
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
		local v18

		if isSmallScreen then
			v18 = v16
		else
			v18 = v5.Typography.HeadingMedium.LineHeight * v5.Typography.HeadingMedium.FontSize
		end

		v17 = React.createElement(skeleton, {
			Size = UDim2.fromOffset(v5.Size.Size_2800 * 2, v18),
			radius = radius.Small,
			LayoutOrder = 1
		})
	end

	local v18 = nil

	if props.creatorName then
		local createElement2 = React.createElement

		local v21 = {
			CreatorName = React.createElement(text, {
				tag = "auto-xy text-body-medium content-default",
				Text = props.creatorName,
				TextTruncate = Enum.TextTruncate.None,
				LayoutOrder = 1,
				testId = "--edp-fallback-attribution-creator"
			}),
			Badge = 0
		}

		local v22 = if props.hasVerifiedBadge then React.createElement(VerifiedBadgeIcon) else nil
		v21.Badge = v22
		v18 = createElement2(view, {
			tag = "row align-y-center gap-xsmall auto-xy",
			LayoutOrder = 2
		}, v21)
	elseif isLoading then
		local v19

		if fFlagLuaAppSduiEdpFallbackAttributionFromCache then
			v19 = v5.Typography.BodyLarge.FontSize * v5.Typography.BodyLarge.LineHeight
		else
			v19 = v16
		end

		v18 = React.createElement(skeleton, {
			Size = UDim2.fromOffset(v5.Size.Size_2800 * 2, v19),
			radius = radius.Small,
			LayoutOrder = 2,
			testId = "--edp-fallback-attribution-creator-skeleton"
		})
	end

	local v19 = nil

	if props.ageRecDisplayName then
		v19 = React.createElement(text, {
			tag = "auto-xy text-body-medium content-default",
			Text = props.ageRecDisplayName,
			LayoutOrder = 3,
			testId = "--edp-fallback-attribution-age-rating"
		})
	elseif isLoading then
		if fFlagLuaAppSduiEdpFallbackAttributionFromCache then
			v16 = v5.Typography.BodyMedium.FontSize

			if not isSmallScreen then
				v16 += v5.Padding.XSmall
			end
		end

		local createElement2 = React.createElement
		local fromOffset = UDim2.fromOffset
		local v22 = if isSmallScreen then v5.Size.Size_2400 else v5.Size.Size_2800
		v19 = createElement2(skeleton, {
			Size = fromOffset(v22, v16),
			radius = radius.Small,
			LayoutOrder = 3,
			testId = "--edp-fallback-attribution-age-rating-skeleton"
		})
	end

	local v20

	if not isSmallScreen then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local v25 = {
			universeId = props.universeId,
			referralSource = props.referralSource,
			launchSource = props.launchSource,
			experienceJoinData = props.experienceJoinData,
			placeId = props.placeIdOverride,
			useUIBloxButton = true,
			buttonSize = buttonSize.Large,
			width = 0,
			launchWhenLoading = 0,
			launchOnReleaseAfterUnmount = true,
			onRegisterActivation = 0,
			enableEarlyAccessPlusTooltip = 0,
			expandWidthForSecondaryPlayButton = true,
			LayoutOrder = 1,
			testId = "--edp-fallback-feed-play-button"
		}
		local newUDim = UDim.new
		local v27

		if fFlagSduiScalePlayButtonAndImageSizes then
			v27 = defineFastInt * v5.Config.UI.Scale
		else
			v27 = defineFastInt
		end

		v25.width = newUDim(0, v27)

		v25.launchWhenLoading = fFlagLuaAppLaunchWhenLoadingEdp and true or nil

		if not fFlagLuaAppEdpFallbackPrimaryActivation then
			v6 = nil
		end

		v25.onRegisterActivation = v6
		v25.enableEarlyAccessPlusTooltip = fFlagEnableGameJoinEarlyAccess and true or nil
		local v23 = {
			PlayBtn = createElement3(playButton, v25),
			OverflowSkeleton1 = 0,
			OverflowSkeleton2 = 0
		}

		local v28 = if isLoading then React.createElement(skeleton, {
			Size = UDim2.fromOffset(v5.Size.Size_1200, v5.Size.Size_1200),
			radius = radius.Medium,
			LayoutOrder = 2
		}) else nil
		v23.OverflowSkeleton1 = v28

		local v29 = if isLoading then React.createElement(skeleton, {
			Size = UDim2.fromOffset(v5.Size.Size_1200, v5.Size.Size_1200),
			radius = radius.Medium,
			LayoutOrder = 3
		}) else nil
		v23.OverflowSkeleton2 = v29
		v20 = createElement2(view, {
			tag = "row align-y-center gap-small auto-xy",
			LayoutOrder = 4
		}, v23)
	end

	return React.createElement(view, {
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
		ContentColumn = React.createElement(view, {
			tag = {
				["col fill gap-xsmall auto-xy"] = fFlagLuaAppSduiEdpFallbackAttributionFromCache,
				["col fill gap-small auto-xy"] = not fFlagLuaAppSduiEdpFallbackAttributionFromCache
			},
			LayoutOrder = 2,
			testId = "--edp-fallback-attribution-content-column"
		}, { Title = v17, Creator = v18, AgeRating = v19, ActionRow = v20 })
	})
end

return React.memo(FallbackAttributionRow)
