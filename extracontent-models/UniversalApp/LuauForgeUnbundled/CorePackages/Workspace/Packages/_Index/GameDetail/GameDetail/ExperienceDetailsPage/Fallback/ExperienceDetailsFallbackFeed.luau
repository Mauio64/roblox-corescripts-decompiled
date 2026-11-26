local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Foundation")
local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local skeleton = Foundation.Skeleton
local button = Foundation.Button
local radius = Foundation.Enums.Radius
local buttonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Localization").Hooks.useLocalization
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/DataHydration")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SignalsReact")
local compositionTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/AppComposition").CompositionTags

local ExperienceDetailsFallbackAttributionRow = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/Fallback/ExperienceDetailsFallbackAttributionRow")
local useGameInfo = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/useGameInfo")

local fFlagLuaAppSduiEdpFallbackAttributionFromCache = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SharedFlags").FFlagLuaAppSduiEdpFallbackAttributionFromCache

local function ExperienceDetailsFeedSkeleton(props)
	local universeId = props.universeId
	local v5 = useTokens()
	local isSmallScreen = props.isSmallScreen

	local v6 = if fFlagLuaAppSduiEdpFallbackAttributionFromCache then useGameInfo(universeId) else nil

	return React.createElement(view, {
		tag = {
			["col size-full auto-y"] = true,
			["gap-xlarge"] = isSmallScreen,
			["gap-xxlarge"] = not isSmallScreen,
			["padding-x-xlarge"] = isSmallScreen,
			["align-x-left"] = not isSmallScreen,
			[compositionTags.ContentRegion.Body] = true
		},
		testId = "--edp-fallback-feed-skeleton"
	}, {
		AttributionRow = React.createElement(ExperienceDetailsFallbackAttributionRow, {
			universeId = universeId,
			isLoading = true,
			gameName = v6 and v6.name,
			isSmallScreen = isSmallScreen,
			launchSource = props.launchSource,
			referralSource = props.referralSource,
			experienceJoinData = props.experienceJoinData,
			placeIdOverride = props.placeIdOverride
		}),
		MediaGallerySkeleton = React.createElement(view, {
			tag = "size-full-0",
			LayoutOrder = isSmallScreen and 2 or 3,
			aspectRatio = {
				AspectRatio = 16 / 9,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Width
			}
		}, {
			Skeleton = React.createElement(skeleton, {
				Size = UDim2.fromScale(1, 1),
				radius = radius.Medium
			})
		}),
		ActionModuleSkeleton = React.createElement(view, {
			tag = "row gap-small size-full-0 auto-y",
			LayoutOrder = isSmallScreen and 3 or 2
		}, {
			Chip1 = React.createElement(skeleton, {
				Size = UDim2.fromOffset(v5.Size.Size_2800, v5.Size.Size_800),
				radius = radius.Large,
				LayoutOrder = 1
			}),
			Chip2 = React.createElement(skeleton, {
				Size = UDim2.fromOffset(v5.Size.Size_2800, v5.Size.Size_800),
				radius = radius.Large,
				LayoutOrder = 2
			}),
			Chip3 = React.createElement(skeleton, {
				Size = UDim2.fromOffset(v5.Size.Size_2800, v5.Size.Size_800),
				radius = radius.Large,
				LayoutOrder = 3
			}),
			Chip4 = React.createElement(skeleton, {
				Size = UDim2.fromOffset(v5.Size.Size_2800, v5.Size.Size_800),
				radius = radius.Large,
				LayoutOrder = 4
			}),
			Chip5 = React.createElement(skeleton, {
				Size = UDim2.fromOffset(v5.Size.Size_2800, v5.Size.Size_800),
				radius = radius.Large,
				LayoutOrder = 5
			})
		}),
		DescriptionSkeleton = React.createElement(
			view,
			{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = 4 },
			{
				HeaderSkeleton = React.createElement(skeleton, {
					Size = UDim2.fromOffset(
						v5.Size.Size_2800 * 2,
						v5.Typography.HeadingSmall.LineHeight * v5.Typography.HeadingSmall.FontSize
					),
					radius = radius.Small,
					LayoutOrder = 1
				}),
				TextSkeleton = React.createElement(skeleton, {
					Size = UDim2.new(
						1,
						0,
						0,
						v5.Typography.BodyLarge.LineHeight * v5.Typography.BodyLarge.FontSize * 3
					),
					radius = radius.Small,
					LayoutOrder = 2
				})
			}
		)
	})
end

local function ExperienceDetailsFeedError(props)
	local universeId = props.universeId
	local isSmallScreen = props.isSmallScreen
	local v5 = useTokens()

	local v6 = useGameInfo(universeId)
	local v7 = SignalsReact.useSignalState(DataHydration.Game.getAgeRecommendationStore(false).getAgeRecommendation(universeId).data)

	local v8 = useLocalization({
		somethingWentWrongMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
		experienceUnavailableMessage = "Feature.GamePage.QuickLaunch.LaunchError.TemporarilyUnavailable",
		retryButtonText = "InGame.CommonUI.Button.Retry"
	})

	if v6 == nil then
		return React.createElement(ExperienceDetailsFeedSkeleton, {
			universeId = universeId,
			isSmallScreen = isSmallScreen,
			launchSource = props.launchSource,
			referralSource = props.referralSource,
			experienceJoinData = props.experienceJoinData,
			placeIdOverride = props.placeIdOverride
		})
	end

	local creator = v6.creator
	local name = v6.name
	local name2 = creator and creator.name
	local v9 = if creator then creator.hasVerifiedBadge == true else false
	local displayNameWithHeaderShort = v7 and v7.displayNameWithHeaderShort

	if v6.isUnavailable == true then
		return React.createElement(
			view,
			{
				tag = "col align-x-center align-y-center size-full-0 auto-y",
				testId = "--edp-fallback-feed-unavailable"
			},
			{
				ErrorIcon = React.createElement(icon, {
					size = v5.Size.Size_2500,
					name = Foundation.Enums.IconName.TriangleExclamation,
					LayoutOrder = 1
				}),
				ErrorText = React.createElement(text, {
					tag = "auto-xy padding-top-medium text-body-large text-align-x-center content-default",
					Text = v8.experienceUnavailableMessage,
					LayoutOrder = 2
				})
			}
		)
	end

	return React.createElement(view, {
		tag = {
			["col size-full auto-y"] = true,
			["gap-xlarge"] = isSmallScreen,
			["gap-xxlarge"] = not isSmallScreen,
			["padding-x-xlarge"] = isSmallScreen,
			["align-x-left"] = not isSmallScreen,
			[compositionTags.ContentRegion.Body] = true
		},
		testId = "--edp-fallback-feed-error"
	}, {
		AttributionRow = React.createElement(ExperienceDetailsFallbackAttributionRow, {
			universeId = universeId,
			gameName = name,
			creatorName = name2,
			hasVerifiedBadge = v9,
			ageRecDisplayName = displayNameWithHeaderShort,
			isSmallScreen = isSmallScreen,
			launchSource = props.launchSource,
			referralSource = props.referralSource,
			experienceJoinData = props.experienceJoinData,
			placeIdOverride = props.placeIdOverride
		}),
		ErrorBlock = React.createElement(
			view,
			{
				tag = "col align-x-center size-full-0 auto-y padding-top-xxlarge",
				LayoutOrder = 2,
				testId = "--edp-fallback-error-state"
			},
			{
				ErrorIcon = React.createElement(icon, {
					size = v5.Size.Size_2500,
					name = Foundation.Enums.IconName.TriangleExclamation,
					LayoutOrder = 1
				}),
				ErrorText = React.createElement(text, {
					tag = "auto-xy padding-bottom-medium text-body-large text-align-x-center content-default",
					Text = v8.somethingWentWrongMessage,
					LayoutOrder = 2
				}),
				RetryButton = React.createElement(button, {
					text = v8.retryButtonText,
					onActivated = props.refresh,
					variant = buttonVariant.Standard,
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
