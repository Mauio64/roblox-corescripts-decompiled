local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local Button = Foundation.Button
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View

local IconSize = Foundation.Enums.IconSize
local Radius = Foundation.Enums.Radius
local getRbxThumb = Foundation.Utility.getRbxThumb
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue
local useLocalization = Localization.Hooks.useLocalization
local useSignalState = SignalsReact.useSignalState

local useExperienceDetails = require(Moments.Hooks.useExperienceDetails)
local RoactUtils = require(parent.RoactUtils)
local useIsTvRemoteDevice = RoactUtils.Hooks.useIsTvRemoteDevice

local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
local GetFFlagMomentsAndroidTvEnabled = require(Moments.Flags.GetFFlagMomentsAndroidTvEnabled)

local ImageWithSkeleton = require(Moments.Components.ImageWithSkeleton)
local FeedContext = require(Moments.Components.Feed.FeedContext)
require(Moments.Components.Feed.FeedTypes)
local MomentContext = require(script.Parent.Parent.MomentContext)

local getExperienceDetailsSheetStore = require(Moments.ExperienceDetailsSheet.Sheet.getExperienceDetailsSheetStore)
local JoinButton = require(Moments.ExperienceDetailsSheet.Join.JoinButton)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsServeEDPVideos = SharedFlags.FFlagMomentsServeEDPVideos

local defineFastFlag = game:DefineFastFlag("MomentsFixExperienceHandleVerifiedSpacing", false)

local FFlagMomentsFixRecommendationImpressionLifecycle = require(Moments.Flags.FFlagMomentsFixRecommendationImpressionLifecycle)
local FFlagMomentsUpdateExperienceActionLabelText = require(Moments.Flags.FFlagMomentsUpdateExperienceActionLabelText)
local FFlagMomentsJoinImpression = require(Moments.Flags.FFlagMomentsJoinImpression)
local FFlagMomentsFollowingFeed = require(Moments.Flags.FFlagMomentsFollowingFeed)
local VerifiedBadge

if defineFastFlag then
	VerifiedBadge = require(parent.VerifiedBadges.VerifiedBadge)
else
	VerifiedBadge = nil
end

local v = {
	join = FFlagMomentsUpdateExperienceActionLabelText and "Feature.Moments.Action.Play" or "Feature.Moments.Action.Join"
}

local v2 = utf8.char(57344)

local function CallToActionBar(p)
	local v3 = useLocalization(v)
	local v4 = useTokens()
	local store = MomentContext.useMoment().store
	local data = store.getData(false)
	local v5 = data.kind == "ad"
	local advertiser

	if data.kind == "ad" then
		advertiser = data.advertiser
	end

	local placeId = data.kind ~= "experience" and 0 or data.placeId
	local universeId = data.kind ~= "experience" and 0 or data.universeId

	local v6 = useSignalState(GetMomentsPreferencesStore(false).getIsTeleporting)
	local v7 = useSignalState(store.getIsModerated)
	local fFlagMomentsAndroidTvEnabled = GetFFlagMomentsAndroidTvEnabled()
	local v8 = useIsTvRemoteDevice()
	local v9

	if not v5 then
		v9 = universeId
	end

	local v10 = useExperienceDetails(v9)

	if FFlagMomentsServeEDPVideos and placeId == 0 and v10.rootPlaceId ~= nil then
		placeId = v10.rootPlaceId
	end

	local v11 = FFlagMomentsServeEDPVideos and not v5

	if v11 then
		if universeId == 0 then
			v11 = false
		else
			v11 = placeId == 0
		end
	end

	local v12 = useScaledValue(160)
	local v13

	if FFlagMomentsFixRecommendationImpressionLifecycle or FFlagMomentsFollowingFeed then
		v13 = FeedContext.useFeedOptional()
	else
		v13 = nil
	end

	local recommendationSource

	if FFlagMomentsFollowingFeed and v13 ~= nil then
		recommendationSource = v13.recommendationSource
	else
		recommendationSource = nil
	end

	local image

	if v5 then
		if advertiser then
			image = advertiser.iconImage
		end
	elseif universeId == 0 then
		image = getRbxThumb(Foundation.Enums.ThumbnailType.Asset, placeId)
	else
		image = getRbxThumb(Foundation.Enums.ThumbnailType.GameIcon, universeId)
	end

	if not v5 and placeId == 0 and not v11 then
		return nil
	end

	local text

	if not (FFlagMomentsServeEDPVideos and v11) then
		if v5 then
			if advertiser then
				text = advertiser.title
			end
		else
			text = v10.name
		end
	end

	local text2

	if not (FFlagMomentsServeEDPVideos and v11) then
		if v5 then
			if advertiser then
				text2 = advertiser.subtitle
			end
		else
			text2 = v10.creatorName
		end
	end

	local v14

	if v5 then
		v14 = not (advertiser == nil) and advertiser.isVerified
	else
		v14 = v10.isCreatorVerified == true
	end

	local text3

	if v5 and advertiser then
		text3 = advertiser.ctaText
	else
		text3 = v3.join
	end

	if not defineFastFlag and text2 and v14 then
		text2 = `{text2} {v2}`
	end

	local size_1000 = v4.Size.Size_1000

	local element = React.createElement(ImageWithSkeleton, {
		LayoutOrder = 1,
		Image = image,
		Size = UDim2.fromOffset(size_1000, size_1000),
		radius = Radius.Medium,
		backgroundStyle = v4.Color.Shift.Shift_300
	})

	local createElement = React.createElement
	local title

	if text then
		title = React.createElement(Text, {
			LayoutOrder = 1,
			tag = "size-full-0 auto-y text-title-medium text-align-x-left text-align-y-top text-truncate-end content-emphasis",
			Text = text
		})
	else
		title = React.createElement(Skeleton, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v12, v4.Size.Size_400),
			testId = FFlagMomentsServeEDPVideos and "moments-experience-title-skeleton" or nil
		})
	end

	local subtitle

	if defineFastFlag and text2 then
		local createElement2 = React.createElement

		local v15 = {
			Handle = React.createElement(Text, {
				LayoutOrder = 1,
				tag = "shrink auto-xy text-body-medium text-align-x-left text-align-y-center text-truncate-end content-default",
				Text = text2
			}),
			VerifiedBadge = 0
		}
		local verifiedBadge

		if v14 then
			verifiedBadge = React.createElement(VerifiedBadge, {
				LayoutOrder = 2,
				size = IconSize.XSmall,
				testId = "moments-experience-verified-badge"
			})
		end

		v15.VerifiedBadge = verifiedBadge
		subtitle = createElement2(
			View,
			{
				LayoutOrder = 2,
				tag = "row align-x-left align-y-center gap-xsmall size-full-0 auto-y",
				testId = "moments-experience-handle"
			},
			v15
		)
	elseif text2 then
		subtitle = React.createElement(Text, {
			LayoutOrder = 2,
			tag = "auto-xy text-body-medium text-align-x-left text-align-y-center text-truncate-end content-default",
			Text = text2
		})
	end

	local element2 = createElement(
		View,
		{ LayoutOrder = 2, tag = "col align-x-left align-y-center grow gap-xsmall auto-y" },
		{ Title = title, Subtitle = subtitle }
	)

	local element3 = React.createElement(View, {
		LayoutOrder = 1,
		tag = "row align-x-left align-y-center grow gap-medium auto-y",
		testId = "moments-experience-row",
		onActivated = not v5 and not v7 and (not FFlagMomentsServeEDPVideos or placeId ~= 0) and function()
			local open = getExperienceDetailsSheetStore(false).open
			local v15 = {
				placeId = placeId,
				universeId = universeId,
				feedItemId = data.feedItemId,
				tracingId = data.feedSessionId,
				contentType = data.contentType,
				recommendationSource = recommendationSource,
				onBeforeJoin = 0
			}
			local onBeforeJoin

			if FFlagMomentsFixRecommendationImpressionLifecycle and v13 ~= nil then
				onBeforeJoin = v13.flushView
			end

			v15.onBeforeJoin = onBeforeJoin
			open(v15)
		end or nil,
		stateLayer = not v5 and not v7 and (not FFlagMomentsServeEDPVideos or placeId ~= 0) and {
			affordance = Foundation.Enums.StateLayerAffordance.None
		} or nil,
		selection = fFlagMomentsAndroidTvEnabled and v8 and { Selectable = false } or nil
	}, { Thumbnail = element, Metadata = element2 })

	local createElement2 = React.createElement
	local v15 = {
		LayoutOrder = p.LayoutOrder,
		tag = "row align-x-left align-y-center gap-medium size-full-0 auto-y"
	}
	local ctaButton

	if not (fFlagMomentsAndroidTvEnabled and v8) then
		if v5 then
			ctaButton = React.createElement(Button, {
				LayoutOrder = 2,
				isDisabled = v6 or v7,
				onActivated = function() end,
				size = Foundation.Enums.InputSize.Medium,
				text = text3,
				variant = Foundation.Enums.ButtonVariant.Emphasis
			})
		elseif not (FFlagMomentsServeEDPVideos and placeId == 0) then
			ctaButton = React.createElement(JoinButton, {
				LayoutOrder = 2,
				context = {
					placeId = placeId,
					universeId = universeId,
					feedItemId = data.feedItemId,
					tracingId = data.feedSessionId,
					contentType = data.contentType,
					recommendationSource = recommendationSource
				},
				text = text3,
				isDisabled = v7 or not FFlagMomentsServeEDPVideos and placeId == 0,
				reportsImpression = FFlagMomentsJoinImpression
			})
		end
	end

	return createElement2(View, v15, { MediaAndMetadata = element3, CtaButton = ctaButton })
end

return React.memo(CallToActionBar)
