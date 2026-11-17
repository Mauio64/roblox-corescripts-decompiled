local parent = script:FindFirstAncestor("GameDetail").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local Skeleton = Foundation.Skeleton
local Button = Foundation.Button
local Radius = Foundation.Enums.Radius
local ButtonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local DataHydration = require(parent.DataHydration)
local SignalsReact = require(parent.SignalsReact)
local AppComposition = require(parent.AppComposition)
local CompositionTags = AppComposition.CompositionTags

local ExperienceDetailsFallbackAttributionRow = require(script.Parent.ExperienceDetailsFallbackAttributionRow)
local useGameInfo = require(script.Parent.Parent.useGameInfo)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiEdpFallbackAttributionFromCache = SharedFlags.FFlagLuaAppSduiEdpFallbackAttributionFromCache

local function ExperienceDetailsFeedSkeleton(props)
	local universeId = props.universeId
	local v = useTokens()
	local isSmallScreen = props.isSmallScreen
	local v2

	if FFlagLuaAppSduiEdpFallbackAttributionFromCache then
		v2 = useGameInfo(universeId)
	end

	return React.createElement(View, {
		tag = {
			["col size-full auto-y"] = true,
			["gap-xlarge"] = isSmallScreen,
			["gap-xxlarge"] = not isSmallScreen,
			["padding-x-xlarge"] = isSmallScreen,
			["align-x-left"] = not isSmallScreen,
			[CompositionTags.ContentRegion.Body] = true
		},
		testId = "--edp-fallback-feed-skeleton"
	}, {
		AttributionRow = React.createElement(ExperienceDetailsFallbackAttributionRow, {
			universeId = universeId,
			isLoading = true,
			gameName = v2 and v2.name,
			isSmallScreen = isSmallScreen,
			launchSource = props.launchSource,
			referralSource = props.referralSource,
			experienceJoinData = props.experienceJoinData,
			placeIdOverride = props.placeIdOverride
		}),
		MediaGallerySkeleton = React.createElement(View, {
			tag = "size-full-0",
			LayoutOrder = isSmallScreen and 2 or 3,
			aspectRatio = {
				AspectRatio = 16 / 9,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Width
			}
		}, {
			Skeleton = React.createElement(Skeleton, {
				Size = UDim2.fromScale(1, 1),
				radius = Radius.Medium
			})
		}),
		ActionModuleSkeleton = React.createElement(View, {
			tag = "row gap-small size-full-0 auto-y",
			LayoutOrder = isSmallScreen and 3 or 2
		}, {
			Chip1 = React.createElement(Skeleton, {
				Size = UDim2.fromOffset(v.Size.Size_2800, v.Size.Size_800),
				radius = Radius.Large,
				LayoutOrder = 1
			}),
			Chip2 = React.createElement(Skeleton, {
				Size = UDim2.fromOffset(v.Size.Size_2800, v.Size.Size_800),
				radius = Radius.Large,
				LayoutOrder = 2
			}),
			Chip3 = React.createElement(Skeleton, {
				Size = UDim2.fromOffset(v.Size.Size_2800, v.Size.Size_800),
				radius = Radius.Large,
				LayoutOrder = 3
			}),
			Chip4 = React.createElement(Skeleton, {
				Size = UDim2.fromOffset(v.Size.Size_2800, v.Size.Size_800),
				radius = Radius.Large,
				LayoutOrder = 4
			}),
			Chip5 = React.createElement(Skeleton, {
				Size = UDim2.fromOffset(v.Size.Size_2800, v.Size.Size_800),
				radius = Radius.Large,
				LayoutOrder = 5
			})
		}),
		DescriptionSkeleton = React.createElement(
			View,
			{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = 4 },
			{
				HeaderSkeleton = React.createElement(Skeleton, {
					Size = UDim2.fromOffset(
						v.Size.Size_2800 * 2,
						v.Typography.HeadingSmall.LineHeight * v.Typography.HeadingSmall.FontSize
					),
					radius = Radius.Small,
					LayoutOrder = 1
				}),
				TextSkeleton = React.createElement(Skeleton, {
					Size = UDim2.new(1, 0, 0, v.Typography.BodyLarge.LineHeight * v.Typography.BodyLarge.FontSize * 3),
					radius = Radius.Small,
					LayoutOrder = 2
				})
			}
		)
	})
end

local function ExperienceDetailsFeedError(props)
	local universeId = props.universeId
	local isSmallScreen = props.isSmallScreen
	local v = useTokens()

	local v2 = useGameInfo(universeId)
	local v3 = SignalsReact.useSignalState(DataHydration.Game.getAgeRecommendationStore(false).getAgeRecommendation(universeId).data)

	local v4 = useLocalization({
		somethingWentWrongMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
		experienceUnavailableMessage = "Feature.GamePage.QuickLaunch.LaunchError.TemporarilyUnavailable",
		retryButtonText = "InGame.CommonUI.Button.Retry"
	})

	if v2 == nil then
		return React.createElement(ExperienceDetailsFeedSkeleton, {
			universeId = universeId,
			isSmallScreen = isSmallScreen,
			launchSource = props.launchSource,
			referralSource = props.referralSource,
			experienceJoinData = props.experienceJoinData,
			placeIdOverride = props.placeIdOverride
		})
	end

	local creator = v2.creator
	local name = v2.name
	local name2 = creator and creator.name
	local hasVerifiedBadge

	if creator then
		hasVerifiedBadge = creator.hasVerifiedBadge == true
	else
		hasVerifiedBadge = false
	end

	local displayNameWithHeaderShort = v3 and v3.displayNameWithHeaderShort

	if v2.isUnavailable == true then
		return React.createElement(
			View,
			{
				tag = "col align-x-center align-y-center size-full-0 auto-y",
				testId = "--edp-fallback-feed-unavailable"
			},
			{
				ErrorIcon = React.createElement(Icon, {
					size = v.Size.Size_2500,
					name = Foundation.Enums.IconName.TriangleExclamation,
					LayoutOrder = 1
				}),
				ErrorText = React.createElement(Text, {
					tag = "auto-xy padding-top-medium text-body-large text-align-x-center content-default",
					Text = v4.experienceUnavailableMessage,
					LayoutOrder = 2
				})
			}
		)
	end

	return React.createElement(View, {
		tag = {
			["col size-full auto-y"] = true,
			["gap-xlarge"] = isSmallScreen,
			["gap-xxlarge"] = not isSmallScreen,
			["padding-x-xlarge"] = isSmallScreen,
			["align-x-left"] = not isSmallScreen,
			[CompositionTags.ContentRegion.Body] = true
		},
		testId = "--edp-fallback-feed-error"
	}, {
		AttributionRow = React.createElement(ExperienceDetailsFallbackAttributionRow, {
			universeId = universeId,
			gameName = name,
			creatorName = name2,
			hasVerifiedBadge = hasVerifiedBadge,
			ageRecDisplayName = displayNameWithHeaderShort,
			isSmallScreen = isSmallScreen,
			launchSource = props.launchSource,
			referralSource = props.referralSource,
			experienceJoinData = props.experienceJoinData,
			placeIdOverride = props.placeIdOverride
		}),
		ErrorBlock = React.createElement(
			View,
			{
				tag = "col align-x-center size-full-0 auto-y padding-top-xxlarge",
				LayoutOrder = 2,
				testId = "--edp-fallback-error-state"
			},
			{
				ErrorIcon = React.createElement(Icon, {
					size = v.Size.Size_2500,
					name = Foundation.Enums.IconName.TriangleExclamation,
					LayoutOrder = 1
				}),
				ErrorText = React.createElement(Text, {
					tag = "auto-xy padding-bottom-medium text-body-large text-align-x-center content-default",
					Text = v4.somethingWentWrongMessage,
					LayoutOrder = 2
				}),
				RetryButton = React.createElement(Button, {
					text = v4.retryButtonText,
					onActivated = props.refresh,
					variant = ButtonVariant.Standard,
					LayoutOrder = 3,
					testId = "--edp-fallback-error-state-retry"
				})
			}
		)
	})
end

return {
	Skeleton = React.memo(ExperienceDetailsFeedSkeleton),
	Error = React.memo(ExperienceDetailsFeedError)
}
