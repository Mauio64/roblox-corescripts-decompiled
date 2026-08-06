local Parent = script:FindFirstAncestor("GameDetail").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local Skeleton = Foundation.Skeleton
local Button = Foundation.Button
local EnumsRadius = Foundation.Enums.Radius
local ButtonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local DataHydration = require(Parent.DataHydration)
local SignalsReact = require(Parent.SignalsReact)
local CompositionTags = require(Parent.AppComposition).CompositionTags
local ExperienceDetailsFallbackAttributionRow = require(script.Parent.ExperienceDetailsFallbackAttributionRow)
local useGameInfo = require(script.Parent.Parent.useGameInfo)
local useGameInfosSelector = require(Parent.GameInfosRodux).useGameInfosSelector
local FFlagLuaAppSduiEdpFallbackAttributionFromCache = require(Parent.SharedFlags).FFlagLuaAppSduiEdpFallbackAttributionFromCache

local function ExperienceDetailsFeedSkeleton(t1: {[any]: any}) -- line: 45
	-- upvalues: useTokens (copy), FFlagLuaAppSduiEdpFallbackAttributionFromCache (copy), useGameInfosSelector (copy), React (copy), View (copy), CompositionTags (copy), ExperienceDetailsFallbackAttributionRow (copy), Skeleton (copy), EnumsRadius (copy)
	local universeId = t1.universeId
	local v24 = useTokens()
	local isSmallScreen = t1.isSmallScreen
	local v26 = nil

	if FFlagLuaAppSduiEdpFallbackAttributionFromCache then
		v26 = useGameInfosSelector(universeId)
	end

	return React.createElement(View, {
		testId = "--edp-fallback-feed-skeleton",
		tag = {
			["col size-full auto-y"] = true,
			["gap-xlarge"] = isSmallScreen,
			["gap-xxlarge"] = not isSmallScreen,
			["padding-x-xlarge"] = isSmallScreen,
			["align-x-left"] = not isSmallScreen,
			[CompositionTags.ContentRegion.Body] = true
		}
	}, {
		AttributionRow = React.createElement(ExperienceDetailsFallbackAttributionRow, {
			isLoading = true,
			universeId = universeId,
			gameName = v26 and v26.name,
			isSmallScreen = isSmallScreen,
			launchSource = t1.launchSource,
			referralSource = t1.referralSource,
			experienceJoinData = t1.experienceJoinData,
			placeIdOverride = t1.placeIdOverride
		}),
		MediaGallerySkeleton = React.createElement(View, {
			tag = "size-full-0",
			LayoutOrder = not isSmallScreen and 3 or 2,
			aspectRatio = {
				AspectRatio = 1.7777777777777777,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Width
			}
		}, {
			Skeleton = React.createElement(Skeleton, {
				Size = UDim2.fromScale(1, 1),
				radius = EnumsRadius.Medium
			})
		}),
		ActionModuleSkeleton = React.createElement(View, {
			tag = "row gap-small size-full-0 auto-y",
			LayoutOrder = not isSmallScreen and 2 or 3
		}, {
			Chip1 = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v24.Size.Size_2800, v24.Size.Size_800),
				radius = EnumsRadius.Large
			}),
			Chip2 = React.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.fromOffset(v24.Size.Size_2800, v24.Size.Size_800),
				radius = EnumsRadius.Large
			}),
			Chip3 = React.createElement(Skeleton, {
				LayoutOrder = 3,
				Size = UDim2.fromOffset(v24.Size.Size_2800, v24.Size.Size_800),
				radius = EnumsRadius.Large
			}),
			Chip4 = React.createElement(Skeleton, {
				LayoutOrder = 4,
				Size = UDim2.fromOffset(v24.Size.Size_2800, v24.Size.Size_800),
				radius = EnumsRadius.Large
			}),
			Chip5 = React.createElement(Skeleton, {
				LayoutOrder = 5,
				Size = UDim2.fromOffset(v24.Size.Size_2800, v24.Size.Size_800),
				radius = EnumsRadius.Large
			})
		}),
		DescriptionSkeleton = React.createElement(View, {
			tag = "col gap-medium size-full-0 auto-y",
			LayoutOrder = 4
		}, {
			HeaderSkeleton = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v24.Size.Size_2800 * 2, v24.Typography.HeadingSmall.LineHeight * v24.Typography.HeadingSmall.FontSize),
				radius = EnumsRadius.Small
			}),
			TextSkeleton = React.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, v24.Typography.BodyLarge.LineHeight * v24.Typography.BodyLarge.FontSize * 3),
				radius = EnumsRadius.Small
			})
		})
	})
end
local function ExperienceDetailsFeedError(t2: {[any]: any}) -- line: 161
	-- upvalues: useTokens (copy), useGameInfo (copy), SignalsReact (copy), DataHydration (copy), useLocalization (copy), React (copy), ExperienceDetailsFeedSkeleton (copy), View (copy), Icon (copy), Foundation (copy), FoundationText (copy), CompositionTags (copy), ExperienceDetailsFallbackAttributionRow (copy), Button (copy), ButtonVariant (copy)
	local universeId = t2.universeId
	local isSmallScreen = t2.isSmallScreen
	local v30 = useTokens()
	local v31 = useGameInfo(universeId)
	local v32 = SignalsReact.useSignalState(DataHydration.Game.getAgeRecommendationStore(false).getAgeRecommendation(universeId).data)
	local v33 = useLocalization({
		somethingWentWrongMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
		experienceUnavailableMessage = "Feature.GamePage.QuickLaunch.LaunchError.TemporarilyUnavailable",
		retryButtonText = "InGame.CommonUI.Button.Retry"
	})

	if v31 == nil then
		return React.createElement(ExperienceDetailsFeedSkeleton, {
			universeId = universeId,
			isSmallScreen = isSmallScreen,
			launchSource = t2.launchSource,
			referralSource = t2.referralSource,
			experienceJoinData = t2.experienceJoinData,
			placeIdOverride = t2.placeIdOverride
		})
	end

	local creator = v31.creator
	local name = v31.name
	local v36 = creator and creator.name
	local v37 = not not creator and creator.hasVerifiedBadge == true
	local v38 = v32 and v32.displayNameWithHeaderShort

	if v31.isUnavailable == true then
		return React.createElement(View, {
			tag = "col align-x-center align-y-center size-full-0 auto-y",
			testId = "--edp-fallback-feed-unavailable"
		}, {
			ErrorIcon = React.createElement(Icon, {
				LayoutOrder = 1,
				size = v30.Size.Size_2500,
				name = Foundation.Enums.IconName.TriangleExclamation
			}),
			ErrorText = React.createElement(FoundationText, {
				tag = "auto-xy padding-top-medium text-body-large text-align-x-center content-default",
				LayoutOrder = 2,
				Text = v33.experienceUnavailableMessage
			})
		})
	end

	return React.createElement(View, {
		testId = "--edp-fallback-feed-error",
		tag = {
			["col size-full auto-y"] = true,
			["gap-xlarge"] = isSmallScreen,
			["gap-xxlarge"] = not isSmallScreen,
			["padding-x-xlarge"] = isSmallScreen,
			["align-x-left"] = not isSmallScreen,
			[CompositionTags.ContentRegion.Body] = true
		}
	}, {
		AttributionRow = React.createElement(ExperienceDetailsFallbackAttributionRow, {
			universeId = universeId,
			gameName = name,
			creatorName = v36,
			hasVerifiedBadge = v37,
			ageRecDisplayName = v38,
			isSmallScreen = isSmallScreen,
			launchSource = t2.launchSource,
			referralSource = t2.referralSource,
			experienceJoinData = t2.experienceJoinData,
			placeIdOverride = t2.placeIdOverride
		}),
		ErrorBlock = React.createElement(View, {
			tag = "col align-x-center size-full-0 auto-y padding-top-xxlarge",
			LayoutOrder = 2,
			testId = "--edp-fallback-error-state"
		}, {
			ErrorIcon = React.createElement(Icon, {
				LayoutOrder = 1,
				size = v30.Size.Size_2500,
				name = Foundation.Enums.IconName.TriangleExclamation
			}),
			ErrorText = React.createElement(FoundationText, {
				tag = "auto-xy padding-bottom-medium text-body-large text-align-x-center content-default",
				LayoutOrder = 2,
				Text = v33.somethingWentWrongMessage
			}),
			RetryButton = React.createElement(Button, {
				LayoutOrder = 3,
				testId = "--edp-fallback-error-state-retry",
				text = v33.retryButtonText,
				onActivated = t2.refresh,
				variant = ButtonVariant.Standard
			})
		})
	})
end

return {
	Skeleton = React.memo(ExperienceDetailsFeedSkeleton),
	Error = React.memo(ExperienceDetailsFeedError)
}
