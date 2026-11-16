local AppComposition = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/AppComposition")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactUtils")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local text = Foundation.Text
local view = Foundation.View

local useCompositionLayout = AppComposition.useCompositionLayout
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens

local gradientBackdrop = MomentsCommon.Components.GradientBackdrop

local momentLayout = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/momentLayout")
local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
local MomentImpressionMemory = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentImpressionMemory")
local useMomentsHost = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/MomentsHostContext").useMomentsHost
local AvatarActionBar = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/AvatarActionBar")
local module13 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/CallToAction")
local module14 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Scrubber")
local module15 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/TopContent")
local VideoScrim = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/VideoScrim")
local PlaybackToggleIndicator = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/PlaybackToggleIndicator")
local MomentOverlayInsetContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentOverlayInsetContext")
local MomentPushedFeedSafeAreaContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentPushedFeedSafeAreaContext")
local ReactionEffectsContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Reactions/ReactionEffectsContext")
local MomentGestureLayer = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Reactions/MomentGestureLayer")
local module22 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Reactions/ReactionExplosionLayer")
local FFlagMomentsFeedAboveNavBar = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFeedAboveNavBar")
local GetFFlagMomentsRenderPostAssets = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsCommon/GetFFlagMomentsRenderPostAssets")
local fFlagMomentsAvatarLookTryOn = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsAvatarLookTryOn
local fFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed
local GetFFlagMomentsDisplayWakeLock = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/GetFFlagMomentsDisplayWakeLock")
local FFlagMomentsFixOverlayRemountImpressions = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFixOverlayRemountImpressions")
local FFlagMomentsRecommendationContentType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsRecommendationContentType")
local useDisplayWakeLock = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useDisplayWakeLock")
local useIsPlaying = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useIsPlaying")
local useMomentsSession = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/MomentsSessionContext").useMomentsSession
local deriveMomentFromPost = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/deriveMomentFromPost")
local MomentsGetPostAssetStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetPostAssetStore")
local fFlagMomentsComments = SharedFlags.FFlagMomentsComments
local v5 = if fFlagMomentsComments then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/VideoLift/VideoLiftContainer") else nil

local v6 = if fFlagMomentsComments then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/useCommentsChromeTransparency") else nil

local v7 = if fFlagMomentsComments then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/useCommentsEvents") else nil

local function DisplayWakeLockEffect(): nil
	useDisplayWakeLock((useIsPlaying()))
	return nil
end

local function OverlayInfoFrame(props)
	local v8 = useTokens()
	local v9 = MomentOverlayInsetContext.useMomentOverlayInset()
	local horizontalPadding = props.horizontalPadding
	local verticalPadding = props.verticalPadding
	local safeAreaInsets = props.safeAreaInsets
	local v10 = safeAreaInsets == nil and 0 or safeAreaInsets.left
	local v11 = safeAreaInsets == nil and 0 or safeAreaInsets.right
	local v12 = safeAreaInsets == nil and 0 or safeAreaInsets.bottom
	local v13 = FFlagMomentsFeedAboveNavBar and 0 or v9
	local v14 = math.max(verticalPadding, v12) + v13

	if v9 > 0 then
		v14 = v8.Padding.Medium + v13
	end

	local v15 = {
		top = UDim.new(0, verticalPadding),
		left = UDim.new(0, (math.max(horizontalPadding, v10))),
		right = UDim.new(0, (math.max(horizontalPadding, v11))),
		bottom = UDim.new(0, v14)
	}

	return React.createElement(view, {
		tag = "col align-x-center align-y-bottom gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y",
		testId = "--moments-info-frame-overlay",
		padding = v15,
		sizeConstraint = { MaxSize = props.maxSize },
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
		ZIndex = 2
	}, props.children)
end

local function MomentItem(props)
	local v8 = useTokens()
	local v9 = useCompositionLayout()
	local v10 = useDeviceInsets()
	local nextOrder = ReactUtils.createNextOrder()
	local v11 = MomentPushedFeedSafeAreaContext.useMomentPushedFeedSafeArea()

	if v11 == nil then
		v11 = v10
	end

	local margin = v9.margin
	local v12 = props.moment
	local v13 = props.data

	local v14 = props.mediaSurface
	local v15 = fFlagMomentsRenderAvatarPostsInFeed and props.isStaticMedia == true
	local v16 = fFlagMomentsRenderAvatarPostsInFeed and props.isWorkspaceRendered == true
	local v17

	if GetFFlagMomentsRenderPostAssets() then
		local postAssetId

		if props.moment == nil or props.moment.postAsset == nil then
			postAssetId = nil
		else
			postAssetId = props.moment.postAsset.postAssetId
		end

		local v18 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				if postAssetId == nil then
					return nil
				end

				return MomentsGetPostAssetStore(false).getCachedPostAsset(postAssetId).data(p2)
			end)
		end, { postAssetId or false })
		local v19 = SignalsReact.useSignalState(v18)
		local v20 = React.useMemo(function()
			if props.moment == nil or v19 == nil then
				return nil
			end

			return deriveMomentFromPost(props.moment, v19)
		end, { props.moment, v19 or false })
		v12 = v20 or props.moment

		if v12 ~= nil and props.renderMediaSurface ~= nil then
			v14 = props.renderMediaSurface(v12)
		end

		v13 = React.useMemo(function()
			if v20 == nil then
				return props.data
			end

			local clone = table.clone(props.data)
			clone.description = v20.metadata.description or clone.description

			if clone.kind == "experience" then
				clone.placeId = v20.metadata.placeId or clone.placeId
				clone.universeId = v20.metadata.universeId or clone.universeId

				if fFlagMomentsAvatarLookTryOn then
					clone.outfitId = v20.metadata.outfitId or clone.outfitId
				end

				if v20.metadata.hasAuthoritativePartnerUploadType then
					clone.isSponsored = v20.metadata.partnerUploadType == "influencer"
				end
			end

			local v21

			if clone.description == props.data.description then
				if clone.kind == "experience" and props.data.kind == "experience" then
					v21 = clone.placeId ~= props.data.placeId
						or clone.universeId ~= props.data.universeId
						or clone.isSponsored ~= props.data.isSponsored
						or fFlagMomentsAvatarLookTryOn and clone.outfitId ~= props.data.outfitId
				else
					v21 = false
				end
			else
				v21 = true
			end

			if v21 then
				return clone
			end

			return props.data
		end, { props.data, v19 or false })

		if v13 ~= props.data then
			v17 = `post:{postAssetId}`
		end
	end

	local v18

	if fFlagMomentsAvatarLookTryOn then
		local openAvatarLookTryOn = useMomentsHost().openAvatarLookTryOn
		local v19

		if v13.kind == "experience" then
			v19 = v13.outfitId
		elseif
			fFlagMomentsRenderAvatarPostsInFeed
			and v13.kind == "avatar"
			and v13.outfit.source.type == "outfit"
		then
			v19 = v13.outfit.source.id
		end

		local id

		if
			fFlagMomentsRenderAvatarPostsInFeed
			and v13.kind == "avatar"
			and v13.outfit.source.type == "look"
		then
			id = v13.outfit.source.id
		end

		v18 = not (openAvatarLookTryOn == nil or v19 == nil) and v19 > 0

		if not v18 then
			v18 = not (openAvatarLookTryOn == nil) and id ~= nil
		end
	else
		v18 = false
	end

	if fFlagMomentsComments and v5 ~= nil and v14 ~= nil then
		v14 = React.createElement(v5, { feedItemId = v13.feedItemId }, v14)
	end

	local v19 = if fFlagMomentsComments and v6 ~= nil then v6(v13.feedItemId) else nil
	local v20

	if fFlagMomentsComments and v7 ~= nil then
		local v21 = useMomentsSession()

		local recommendationMetadata = if v12 ~= nil then v12.recommendationMetadata else nil
		local getMomentsSessionId = v21.getMomentsSessionId
		local v23 = if FFlagMomentsRecommendationContentType then v13.contentType else nil
		v20 = v7(recommendationMetadata, getMomentsSessionId, v23)
	end

	local v21, v22 = React.useBinding(UDim2.fromScale(1, 0))

	local v23 = 2 * v8.Padding.XLarge
	local v24 = React.useCallback(function(p2)
		v22(UDim2.new(1, 0, 0, p2.AbsoluteSize.Y + v23))
	end, { v23 })

	local v25 = {
		TopContent = React.createElement(module15, {
			LayoutOrder = nextOrder(),
			moment = v12,
			onOpenComments = v20
		}),
		Scrubber = 0,
		CallToAction = 0
	}

	local v26 = if not v15 then React.createElement(module14, {
		LayoutOrder = nextOrder()
	}) else nil
	v25.Scrubber = v26
	local v27

	if not (fFlagMomentsRenderAvatarPostsInFeed and v13.kind == "avatar" and not v18) then
		local createElement = React.createElement
		local v28 = if v18 then AvatarActionBar else module13
		v27 = createElement(v28, { LayoutOrder = nextOrder() })
	end

	v25.CallToAction = v27

	local BOTTOM_UI_MAX_SIZE = momentLayout.BOTTOM_UI_MAX_SIZE

	local element = React.createElement(OverlayInfoFrame, {
		horizontalPadding = margin,
		verticalPadding = v8.Padding.XLarge,
		safeAreaInsets = v11,
		maxSize = BOTTOM_UI_MAX_SIZE,
		onAbsoluteSizeChanged = v24
	}, v25)

	local createElement = React.createElement
	local provider = MomentContext.Provider

	local createElement2 = React.createElement
	local v31 = {
		LayoutOrder = props.layoutOrder,
		backgroundStyle = v16 and { Transparency = 1 } or nil,
		tag = {
			["size-full clip"] = true,
			["bg-surface-0"] = not v16
		},
		testId = "--moments-item-root"
	}

	local createElement3 = React.createElement

	if v14 == nil then
		v14 = React.createElement(view, { tag = "size-full bg-surface-100" }, {
			Label = React.createElement(text, {
				tag = "size-full text-body-large text-align-x-center text-align-y-center content-emphasis",
				Text = "[ video ]"
			})
		})
	end

	local children = {
		Video = createElement3(view, {
			tag = "size-full",
			testId = "--moments-item-video",
			ZIndex = 1
		}, {
			Surface = v14,
			Scrim = React.createElement(VideoScrim, { ZIndex = 2 }),
			GestureLayer = React.createElement(MomentGestureLayer, { ZIndex = 3 })
		}),
		Overlay = React.createElement(
			view,
			{
				tag = "position-bottom-center anchor-bottom-center size-full-0 auto-y",
				testId = "--moments-item-overlay",
				ZIndex = 2,
				GroupTransparency = v19
			},
			{
				Backdrop = React.createElement(gradientBackdrop, {
					color3 = v8.Color.Common.Scrim.Color3,
					rotation = 270,
					size = v21
				}),
				InfoFrame = element
			}
		),
		PlaybackIndicator = 0,
		ReactionExplosionLayer = 0
	}

	local v34 = if not v15 then React.createElement(PlaybackToggleIndicator) else nil
	children.PlaybackIndicator = v34

	children.ReactionExplosionLayer = React.createElement(module22)
	local v29 = {
		Root = createElement2(view, v31, children),
		DisplayWakeLock = 0
	}

	local v35 = if GetFFlagMomentsDisplayWakeLock() and not v15 then React.createElement(DisplayWakeLockEffect) else nil
	v29.DisplayWakeLock = v35
	local element2 = createElement(provider, { data = v13, dataVersion = v17 }, v29)

	if FFlagMomentsFixOverlayRemountImpressions then
		element2 = React.createElement(MomentImpressionMemory.Provider, nil, element2)
	end

	return React.createElement(ReactionEffectsContext.Provider, nil, element2)
end

return MomentItem
