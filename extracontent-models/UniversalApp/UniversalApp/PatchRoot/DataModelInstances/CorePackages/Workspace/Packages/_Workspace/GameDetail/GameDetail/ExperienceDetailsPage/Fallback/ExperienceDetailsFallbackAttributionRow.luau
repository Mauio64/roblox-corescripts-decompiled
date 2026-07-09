local v1 = game:DefineFastInt("EdpFallbackActionBarPlayButtonWidth", 236)
local Parent = script:FindFirstAncestor("GameDetail").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local FoundationImage = Foundation.Image
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local ButtonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens
local PlayButton = require(Parent.GamePlayButton).PlayButton
local useImageLoadFade = require(script.Parent.Parent.useImageLoadFade)
local SharedFlags = require(Parent.SharedFlags)
local FFlagLuaAppSduiEdpFallbackPlayButtonPassUiBlox = SharedFlags.FFlagLuaAppSduiEdpFallbackPlayButtonPassUiBlox
local FFlagLuaAppSduiEdpFallbackPlayButtonUseUiBlox = SharedFlags.FFlagLuaAppSduiEdpFallbackPlayButtonUseUiBlox
local FFlagLuaAppLaunchWhenLoadingEdp = SharedFlags.FFlagLuaAppLaunchWhenLoadingEdp
local FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp = SharedFlags.FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp

local function VerifiedBadgeIcon() -- line: 61
	-- upvalues: useTokens (copy), React (copy), View (copy), Icon (copy), Foundation (copy)
	local v22 = useTokens()

	return React.createElement(View, {
		LayoutOrder = 2,
		tag = "auto-xy"
	}, {
		Backplate = React.createElement(Icon, {
			ZIndex = 1,
			name = Foundation.Enums.IconName.VerifiedBackplate,
			style = v22.Color.System.Emphasis,
			size = Foundation.Enums.IconSize.Small
		}),
		Check = React.createElement(Icon, {
			ZIndex = 2,
			name = Foundation.Enums.IconName.VerifiedCheck,
			size = Foundation.Enums.IconSize.Small,
			variant = Foundation.Enums.IconVariant.Filled,
			style = v22.Color.Extended.White.White_100
		})
	})
end
local function FallbackAttributionRow(t1: {[any]: any}) -- line: 83
	-- upvalues: useTokens (copy), useImageLoadFade (copy), React (copy), View (copy), FoundationImage (copy), Skeleton (copy), FoundationText (copy), EnumsRadius (copy), VerifiedBadgeIcon (copy), PlayButton (copy), FFlagLuaAppSduiEdpFallbackPlayButtonPassUiBlox (copy), FFlagLuaAppSduiEdpFallbackPlayButtonUseUiBlox (copy), ButtonSize (copy), v1 (copy), FFlagLuaAppLaunchWhenLoadingEdp (copy), FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp (copy)
	local v24 = useTokens()
	local isSmallScreen = t1.isSmallScreen
	local v26 = t1.isLoading == true
	local v27 = if not isSmallScreen then v24.Size.Size_2500 * 2 else v24.Size.Size_1400
	local v28 = not isSmallScreen and 256 or 150
	local v29 = string.format("rbxthumb://type=GameIcon&id=%s&w=%d&h=%d", t1.universeId, v28, v28)
	local v30 = useImageLoadFade()
	local v31 = React.createElement(View, {
		LayoutOrder = 1,
		Size = UDim2.fromOffset(v27, v27)
	}, {
		GameIcon = React.createElement(FoundationImage, {
			tag = "radius-medium",
			Image = v29,
			Size = UDim2.fromScale(1, 1),
			onLoaded = v30.onLoaded
		}),
		SkeletonOverlay = if not v30.skeletonVisible then nil else React.createElement(View, {
			tag = "radius-medium",
			ZIndex = 2,
			ClipsDescendants = true,
			Size = UDim2.fromScale(1, 1),
			GroupTransparency = v30.overlayTransparency
		}, {
			Skeleton = React.createElement(Skeleton, {
				Size = UDim2.fromScale(1, 1)
			})
		})
	})
	local v32 = if not isSmallScreen then v24.Typography.BodyMedium.LineHeight * v24.Typography.BodyMedium.FontSize else v24.Typography.CaptionLarge.LineHeight * v24.Typography.CaptionLarge.FontSize
	local v33 = nil

	if t1.gameName then
		v33 = React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = {
				["auto-xy text-wrap text-align-x-left text-truncate-none"] = true,
				["text-heading-small"] = isSmallScreen,
				["text-heading-large"] = not isSmallScreen
			},
			Text = t1.gameName
		})
	elseif v26 then
		local v34 = if not isSmallScreen then v24.Typography.HeadingMedium.LineHeight * v24.Typography.HeadingMedium.FontSize else v32

		v33 = React.createElement(Skeleton, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v24.Size.Size_2800 * 2, v34),
			radius = EnumsRadius.Small
		})
	end

	local v35 = nil

	if t1.creatorName then
		v35 = React.createElement(View, {
			tag = "row align-y-center gap-xsmall auto-xy",
			LayoutOrder = 2
		}, {
			CreatorName = React.createElement(FoundationText, {
				tag = "auto-xy text-body-medium content-default",
				LayoutOrder = 1,
				Text = t1.creatorName,
				TextTruncate = Enum.TextTruncate.None
			}),
			Badge = if not t1.hasVerifiedBadge then nil else React.createElement(VerifiedBadgeIcon)
		})
	elseif v26 then
		v35 = React.createElement(Skeleton, {
			LayoutOrder = 2,
			Size = UDim2.fromOffset(v24.Size.Size_2800 * 2, v32),
			radius = EnumsRadius.Small
		})
	end

	local v36 = nil

	if t1.ageRecDisplayName then
		v36 = React.createElement(FoundationText, {
			tag = "auto-xy text-body-medium content-default",
			LayoutOrder = 3,
			Text = t1.ageRecDisplayName
		})
	elseif v26 then
		v36 = React.createElement(Skeleton, {
			LayoutOrder = 3,
			Size = UDim2.fromOffset(if not isSmallScreen then v24.Size.Size_2800 else v24.Size.Size_2400, v32),
			radius = EnumsRadius.Small
		})
	end

	local v37 = nil

	if not isSmallScreen then
		v37 = React.createElement(View, {
			tag = "row align-y-center gap-small auto-xy",
			LayoutOrder = 4
		}, {
			PlayBtn = React.createElement(PlayButton, {
				LayoutOrder = 1,
				testId = "--edp-fallback-feed-play-button",
				universeId = t1.universeId,
				referralSource = t1.referralSource,
				launchSource = t1.launchSource,
				experienceJoinData = t1.experienceJoinData,
				placeId = t1.placeIdOverride,
				useUIBloxButton = not FFlagLuaAppSduiEdpFallbackPlayButtonPassUiBlox or FFlagLuaAppSduiEdpFallbackPlayButtonUseUiBlox,
				buttonSize = ButtonSize.Large,
				width = UDim.new(0, v1),
				launchWhenLoading = not not FFlagLuaAppLaunchWhenLoadingEdp or nil,
				launchOnReleaseAfterUnmount = not not FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp or nil
			}),
			OverflowSkeleton1 = if not v26 then nil else React.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.fromOffset(v24.Size.Size_1200, v24.Size.Size_1200),
				radius = EnumsRadius.Medium
			}),
			OverflowSkeleton2 = if not v26 then nil else React.createElement(Skeleton, {
				LayoutOrder = 3,
				Size = UDim2.fromOffset(v24.Size.Size_1200, v24.Size.Size_1200),
				radius = EnumsRadius.Medium
			})
		})
	end

	return React.createElement(View, {
		LayoutOrder = 1,
		tag = {
			["row size-full-0 auto-y"] = true,
			["gap-medium"] = isSmallScreen,
			["gap-xlarge"] = not isSmallScreen,
			["align-y-center"] = isSmallScreen,
			["align-y-bottom"] = not isSmallScreen
		}
	}, {
		Icon = v31,
		ContentColumn = React.createElement(View, {
			tag = "col fill gap-small auto-xy",
			LayoutOrder = 2
		}, {
			Title = v33,
			Creator = v35,
			AgeRating = v36,
			ActionRow = v37
		})
	})
end

return React.memo(FallbackAttributionRow)
