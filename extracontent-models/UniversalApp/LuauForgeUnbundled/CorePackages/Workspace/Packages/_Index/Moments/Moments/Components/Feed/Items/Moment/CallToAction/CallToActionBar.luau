local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local button = Foundation.Button
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local view = Foundation.View

local iconSize = Foundation.Enums.IconSize
local radius = Foundation.Enums.Radius
local getRbxThumb = Foundation.Utility.getRbxThumb
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue
local useLocalization = Localization.Hooks.useLocalization
local useSignalState = SignalsReact.useSignalState

local useExperienceDetails = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useExperienceDetails")
local useIsTvRemoteDevice = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/RoactUtils").Hooks.useIsTvRemoteDevice

local GetMomentsPreferencesStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsPreferencesStore")
local GetFFlagMomentsAndroidTvEnabled = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/GetFFlagMomentsAndroidTvEnabled")

local ImageWithSkeleton = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/ImageWithSkeleton")
local FeedContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedContext")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")

local getExperienceDetailsSheetStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/ExperienceDetailsSheet/Sheet/getExperienceDetailsSheetStore")
local JoinButton = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/ExperienceDetailsSheet/Join/JoinButton")
local PostStatusRowContainer = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/PostStatusRow/PostStatusRowContainer")
local usePendingMomentRecord = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/usePendingMomentRecord")
local fFlagMomentsServeEDPVideos = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsServeEDPVideos
local fFlagMomentsPostFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsPostFeedback

local defineFastFlag = game:DefineFastFlag("MomentsFixExperienceHandleVerifiedSpacing", false)

local FFlagMomentsFixRecommendationImpressionLifecycle = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFixRecommendationImpressionLifecycle")
local FFlagMomentsUpdateExperienceActionLabelText = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsUpdateExperienceActionLabelText")
local FFlagMomentsJoinImpression = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsJoinImpression")
local FFlagMomentsFollowingFeed = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFollowingFeed")
local FFlagMomentsRecommendationFeedType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsRecommendationFeedType")

local v5 = if defineFastFlag then require("@game/CorePackages/Workspace/Packages/_Index/Moments/VerifiedBadges/VerifiedBadge") else nil

local v6 = {
	join = FFlagMomentsUpdateExperienceActionLabelText and "Feature.Moments.Action.Play" or "Feature.Moments.Action.Join"
}

local v7 = utf8.char(57344)

local function CallToActionBar(p2)
	local v8 = useLocalization(v6)
	local v9 = useTokens()
	local store = MomentContext.useMoment().store
	local data = store.getData(false)
	local v10 = data.kind == "ad"

	local advertiser = if data.kind == "ad" then data.advertiser else nil
	local v11 = data.kind ~= "experience" and 0 or data.placeId
	local v12 = data.kind ~= "experience" and 0 or data.universeId

	local v13 = useSignalState(GetMomentsPreferencesStore(false).getIsTeleporting)
	local v14 = useSignalState(store.getIsModerated)
	local v15 = GetFFlagMomentsAndroidTvEnabled()
	local v16 = useIsTvRemoteDevice()
	local v18 = if not v10 then v12 else nil
	local v19 = useExperienceDetails(v18)

	if fFlagMomentsServeEDPVideos and v11 == 0 and v19.rootPlaceId ~= nil then
		v11 = v19.rootPlaceId
	end

	local v20 = fFlagMomentsServeEDPVideos and not v10

	if v20 then
		v20 = not (v12 == 0) and v11 == 0
	end

	local v21 = useScaledValue(160)

	local v22 = if FFlagMomentsFixRecommendationImpressionLifecycle or FFlagMomentsFollowingFeed or FFlagMomentsRecommendationFeedType then FeedContext.useFeedOptional() else nil

	local recommendationSource = if (FFlagMomentsFollowingFeed or FFlagMomentsRecommendationFeedType) and v22 ~= nil then v22.recommendationSource else nil

	local v23 = if fFlagMomentsPostFeedback then usePendingMomentRecord(data.momentId) else nil
	local v24

	if v10 then
		if advertiser then
			v24 = advertiser.iconImage
		end
	elseif v12 == 0 then
		v24 = getRbxThumb(Foundation.Enums.ThumbnailType.Asset, v11)
	else
		v24 = getRbxThumb(Foundation.Enums.ThumbnailType.GameIcon, v12)
	end

	if v23 ~= nil and data.kind == "experience" and data.isPending then
		return React.createElement(PostStatusRowContainer, {
			momentId = data.momentId,
			LayoutOrder = p2.LayoutOrder
		})
	end

	if not v10 and v11 == 0 and not v20 then
		return nil
	end

	local v25

	if not (fFlagMomentsServeEDPVideos and v20) then
		if v10 then
			if advertiser then
				v25 = advertiser.title
			end
		else
			v25 = v19.name
		end
	end

	local v26

	if not (fFlagMomentsServeEDPVideos and v20) then
		if v10 then
			if advertiser then
				v26 = advertiser.subtitle
			end
		else
			v26 = v19.creatorName
		end
	end

	local v27

	if v10 then
		v27 = not (advertiser == nil) and advertiser.isVerified
	else
		v27 = v19.isCreatorVerified == true
	end

	local v28 = if v10 and advertiser then advertiser.ctaText else v8.join

	if not defineFastFlag and v26 and v27 then
		v26 = `{v26} {v7}`
	end

	local size_1000 = v9.Size.Size_1000

	local element = React.createElement(ImageWithSkeleton, {
		LayoutOrder = 1,
		Image = v24,
		Size = UDim2.fromOffset(size_1000, size_1000),
		radius = radius.Medium,
		backgroundStyle = v9.Color.Shift.Shift_300
	})

	local createElement = React.createElement

	local v32 = if v25 then React.createElement(text, {
		LayoutOrder = 1,
		tag = "size-full-0 auto-y text-title-medium text-align-x-left text-align-y-top text-truncate-end content-emphasis",
		Text = v25
	}) else React.createElement(skeleton, {
		LayoutOrder = 1,
		Size = UDim2.fromOffset(v21, v9.Size.Size_400),
		testId = fFlagMomentsServeEDPVideos and "moments-experience-title-skeleton" or nil
	})
	local v33

	if defineFastFlag and v26 then
		local createElement2 = React.createElement

		local v36 = {
			Handle = React.createElement(text, {
				LayoutOrder = 1,
				tag = "shrink auto-xy text-body-medium text-align-x-left text-align-y-center text-truncate-end content-default",
				Text = v26
			}),
			VerifiedBadge = 0
		}

		local v37 = if v27 then React.createElement(v5, {
			LayoutOrder = 2,
			size = iconSize.XSmall,
			testId = "moments-experience-verified-badge"
		}) else nil
		v36.VerifiedBadge = v37
		v33 = createElement2(
			view,
			{
				LayoutOrder = 2,
				tag = "row align-x-left align-y-center gap-xsmall size-full-0 auto-y",
				testId = "moments-experience-handle"
			},
			v36
		)
	elseif v26 then
		v33 = React.createElement(text, {
			LayoutOrder = 2,
			tag = "auto-xy text-body-medium text-align-x-left text-align-y-center text-truncate-end content-default",
			Text = v26
		})
	end

	local element2 = createElement(
		view,
		{
			LayoutOrder = 2,
			tag = "col align-x-left align-y-center grow gap-xsmall auto-y"
		},
		{ Title = v32, Subtitle = v33 }
	)

	local element3 = React.createElement(view, {
		LayoutOrder = 1,
		tag = "row align-x-left align-y-center grow gap-medium auto-y",
		testId = "moments-experience-row",
		onActivated = not v10 and not v14 and (not fFlagMomentsServeEDPVideos or v11 ~= 0) and function()
			local open = getExperienceDetailsSheetStore(false).open
			local v34 = {
				placeId = v11,
				universeId = v12,
				feedItemId = data.feedItemId,
				tracingId = data.feedSessionId,
				contentType = data.contentType,
				recommendationSource = recommendationSource,
				onBeforeJoin = 0
			}

			local v35 = if FFlagMomentsFixRecommendationImpressionLifecycle and v22 ~= nil then v22.flushView else nil
			v34.onBeforeJoin = v35
			open(v34)
		end or nil,
		stateLayer = not v10 and not v14 and (not fFlagMomentsServeEDPVideos or v11 ~= 0) and {
			affordance = Foundation.Enums.StateLayerAffordance.None
		} or nil,
		selection = v15 and v16 and { Selectable = false } or nil
	}, { Thumbnail = element, Metadata = element2 })

	local createElement2 = React.createElement
	local v35 = {
		LayoutOrder = p2.LayoutOrder,
		tag = "row align-x-left align-y-center gap-medium size-full-0 auto-y"
	}
	local v37

	if not (v15 and v16) then
		if v10 then
			v37 = React.createElement(button, {
				LayoutOrder = 2,
				isDisabled = v13 or v14,
				onActivated = function() end,
				size = Foundation.Enums.InputSize.Medium,
				text = v28,
				variant = Foundation.Enums.ButtonVariant.Emphasis
			})
		elseif not (fFlagMomentsServeEDPVideos and v11 == 0) then
			v37 = React.createElement(JoinButton, {
				LayoutOrder = 2,
				context = {
					placeId = v11,
					universeId = v12,
					feedItemId = data.feedItemId,
					tracingId = data.feedSessionId,
					contentType = data.contentType,
					recommendationSource = recommendationSource
				},
				text = v28,
				isDisabled = v14 or not fFlagMomentsServeEDPVideos and v11 == 0,
				reportsImpression = FFlagMomentsJoinImpression
			})
		end
	end

	return createElement2(view, v35, { MediaAndMetadata = element3, CtaButton = v37 })
end

return React.memo(CallToActionBar)
