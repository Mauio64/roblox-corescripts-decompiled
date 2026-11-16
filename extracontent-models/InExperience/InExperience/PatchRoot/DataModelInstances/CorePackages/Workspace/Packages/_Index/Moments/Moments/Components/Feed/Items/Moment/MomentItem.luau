local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local AppComposition = require(parent.AppComposition)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local Text = Foundation.Text
local View = Foundation.View

local useCompositionLayout = AppComposition.useCompositionLayout
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens

local GradientBackdrop = MomentsCommon.Components.GradientBackdrop

local momentLayout = require(script.Parent.momentLayout)
local MomentContext = require(script.Parent.MomentContext)
local MomentImpressionMemory = require(script.Parent.MomentImpressionMemory)
local MomentsHostContext = require(Moments.MomentsHostContext)
local useMomentsHost = MomentsHostContext.useMomentsHost
local AvatarActionBar = require(script.Parent.AvatarActionBar)
local CallToAction = require(script.Parent.CallToAction)
local Scrubber = require(script.Parent.Scrubber)
local TopContent = require(script.Parent.TopContent)
local VideoScrim = require(script.Parent.VideoScrim)
local PlaybackToggleIndicator = require(script.Parent.PlaybackToggleIndicator)
local MomentOverlayInsetContext = require(script.Parent.MomentOverlayInsetContext)
local MomentPushedFeedSafeAreaContext = require(script.Parent.MomentPushedFeedSafeAreaContext)
local ReactionEffectsContext = require(script.Parent.Reactions.ReactionEffectsContext)
local MomentGestureLayer = require(script.Parent.Reactions.MomentGestureLayer)
local ReactionExplosionLayer = require(script.Parent.Reactions.ReactionExplosionLayer)
local FFlagMomentsFeedAboveNavBar = require(Moments.Flags.FFlagMomentsFeedAboveNavBar)
local GetFFlagMomentsRenderPostAssets = require(parent.MomentsCommon.GetFFlagMomentsRenderPostAssets)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagMomentsAvatarLookTryOn = SharedFlags2.FFlagMomentsAvatarLookTryOn
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed
local GetFFlagMomentsDisplayWakeLock = require(Moments.Flags.GetFFlagMomentsDisplayWakeLock)
local FFlagMomentsFixOverlayRemountImpressions = require(Moments.Flags.FFlagMomentsFixOverlayRemountImpressions)
local FFlagMomentsRecommendationContentType = require(Moments.Flags.FFlagMomentsRecommendationContentType)
local useDisplayWakeLock = require(Moments.Hooks.useDisplayWakeLock)
local useIsPlaying = require(Moments.Hooks.useIsPlaying)
local MomentsSessionContext = require(Moments.Stores.GetMomentsStore.MomentsSessionContext)
local useMomentsSession = MomentsSessionContext.useMomentsSession
local deriveMomentFromPost = require(Moments.Utils.deriveMomentFromPost)
local MomentsGetPostAssetStore = require(parent.DataHydration.MomentsGetPostAssetStore)
local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
local VideoLiftContainer

if FFlagMomentsComments then
	VideoLiftContainer = require(script.Parent.VideoLift.VideoLiftContainer)
else
	VideoLiftContainer = nil
end

local useCommentsChromeTransparency

if FFlagMomentsComments then
	useCommentsChromeTransparency = require(script.Parent.useCommentsChromeTransparency)
else
	useCommentsChromeTransparency = nil
end

local useCommentsEvents

if FFlagMomentsComments then
	useCommentsEvents = require(Moments.Components.Comments.useCommentsEvents)
else
	useCommentsEvents = nil
end

local function DisplayWakeLockEffect(): nil
	useDisplayWakeLock((useIsPlaying()))
	return nil
end

local function OverlayInfoFrame(props)
	local v = useTokens()
	local v2 = MomentOverlayInsetContext.useMomentOverlayInset()
	local horizontalPadding = props.horizontalPadding
	local verticalPadding = props.verticalPadding
	local safeAreaInsets = props.safeAreaInsets
	local v3 = safeAreaInsets == nil and 0 or safeAreaInsets.left
	local v4 = safeAreaInsets == nil and 0 or safeAreaInsets.right
	local v5 = FFlagMomentsFeedAboveNavBar and 0 or v2
	local v6 = math.max(verticalPadding, safeAreaInsets == nil and 0 or safeAreaInsets.bottom) + v5

	if v2 > 0 then
		v6 = v.Padding.Medium + v5
	end

	local padding = {
		top = UDim.new(0, verticalPadding),
		left = UDim.new(0, (math.max(horizontalPadding, v3))),
		right = UDim.new(0, (math.max(horizontalPadding, v4))),
		bottom = UDim.new(0, v6)
	}

	return React.createElement(View, {
		tag = "col align-x-center align-y-bottom gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y",
		testId = "--moments-info-frame-overlay",
		padding = padding,
		sizeConstraint = { MaxSize = props.maxSize },
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
		ZIndex = 2
	}, props.children)
end

local function MomentItem(props)
	local v = useTokens()
	local v2 = useCompositionLayout()
	local v3 = useDeviceInsets()
	local nextOrder = ReactUtils.createNextOrder()
	local safeAreaInsets = MomentPushedFeedSafeAreaContext.useMomentPushedFeedSafeArea()

	if safeAreaInsets == nil then
		safeAreaInsets = v3
	end

	local margin = v2.margin
	local moment = props.moment
	local v4 = props.data

	local surface = props.mediaSurface
	local v5 = FFlagMomentsRenderAvatarPostsInFeed and props.isStaticMedia == true
	local v6 = FFlagMomentsRenderAvatarPostsInFeed and props.isWorkspaceRendered == true
	local dataVersion

	if GetFFlagMomentsRenderPostAssets() then
		local postAssetId

		if props.moment == nil or props.moment.postAsset == nil then
			postAssetId = nil
		else
			postAssetId = props.moment.postAsset.postAssetId
		end

		local v7 = React.useMemo(function()
			return Signals.createComputed(function(p)
				if postAssetId == nil then
					return nil
				end

				return MomentsGetPostAssetStore(false).getCachedPostAsset(postAssetId).data(p)
			end)
		end, { postAssetId or false })
		local v8 = SignalsReact.useSignalState(v7)
		local v9 = React.useMemo(function()
			if props.moment == nil or v8 == nil then
				return nil
			end

			return deriveMomentFromPost(props.moment, v8)
		end, { props.moment, v8 or false })
		moment = v9 or props.moment

		if moment ~= nil and props.renderMediaSurface ~= nil then
			surface = props.renderMediaSurface(moment)
		end

		v4 = React.useMemo(function()
			if v9 == nil then
				return props.data
			end

			local clone = table.clone(props.data)
			clone.description = v9.metadata.description or clone.description

			if clone.kind == "experience" then
				clone.placeId = v9.metadata.placeId or clone.placeId
				clone.universeId = v9.metadata.universeId or clone.universeId

				if FFlagMomentsAvatarLookTryOn then
					clone.outfitId = v9.metadata.outfitId or clone.outfitId
				end

				if v9.metadata.hasAuthoritativePartnerUploadType then
					clone.isSponsored = v9.metadata.partnerUploadType == "influencer"
				end
			end

			local v10

			if clone.description == props.data.description then
				if clone.kind == "experience" and props.data.kind == "experience" then
					v10 = clone.placeId ~= props.data.placeId
						or clone.universeId ~= props.data.universeId
						or clone.isSponsored ~= props.data.isSponsored
						or FFlagMomentsAvatarLookTryOn and clone.outfitId ~= props.data.outfitId
				else
					v10 = false
				end
			else
				v10 = true
			end

			return if v10 then clone else props.data
		end, { props.data, v8 or false })

		if v4 ~= props.data then
			dataVersion = `post:{postAssetId}`
		end
	end

	local v7

	if FFlagMomentsAvatarLookTryOn then
		local openAvatarLookTryOn = useMomentsHost().openAvatarLookTryOn
		local v8

		if v4.kind == "experience" then
			v8 = v4.outfitId
		elseif FFlagMomentsRenderAvatarPostsInFeed and v4.kind == "avatar" and v4.outfit.source.type == "outfit" then
			v8 = v4.outfit.source.id
		end

		local id

		if FFlagMomentsRenderAvatarPostsInFeed and v4.kind == "avatar" and v4.outfit.source.type == "look" then
			id = v4.outfit.source.id
		end

		if openAvatarLookTryOn == nil or v8 == nil then
			v7 = false
		else
			v7 = v8 > 0
		end

		if not v7 then
			if openAvatarLookTryOn == nil then
				v7 = false
			else
				v7 = id ~= nil
			end
		end
	else
		v7 = false
	end

	if FFlagMomentsComments and VideoLiftContainer ~= nil and surface ~= nil then
		surface = React.createElement(VideoLiftContainer, { feedItemId = v4.feedItemId }, surface)
	end

	local groupTransparency

	if FFlagMomentsComments and useCommentsChromeTransparency ~= nil then
		groupTransparency = useCommentsChromeTransparency(v4.feedItemId)
	end

	local onOpenComments

	if FFlagMomentsComments and useCommentsEvents ~= nil then
		local v8 = useMomentsSession()
		local recommendationMetadata

		if moment ~= nil then
			recommendationMetadata = moment.recommendationMetadata
		end

		local getMomentsSessionId = v8.getMomentsSessionId
		local v9

		if FFlagMomentsRecommendationContentType then
			v9 = v4.contentType
		end

		onOpenComments = useCommentsEvents(recommendationMetadata, getMomentsSessionId, v9)
	end

	local size, v8 = React.useBinding(UDim2.fromScale(1, 0))

	local v9 = 2 * v.Padding.XLarge
	local onAbsoluteSizeChanged = React.useCallback(function(p)
		v8(UDim2.new(1, 0, 0, p.AbsoluteSize.Y + v9))
	end, { v9 })

	local v10 = {
		TopContent = React.createElement(TopContent, {
			LayoutOrder = nextOrder(),
			moment = moment,
			onOpenComments = onOpenComments
		}),
		Scrubber = 0,
		CallToAction = 0
	}
	local scrubber

	if not v5 then
		scrubber = React.createElement(Scrubber, { LayoutOrder = nextOrder() })
	end

	v10.Scrubber = scrubber
	local callToAction

	if not (FFlagMomentsRenderAvatarPostsInFeed and v4.kind == "avatar" and not v7) then
		local createElement = React.createElement
		local v11 = if v7 then AvatarActionBar else CallToAction
		callToAction = createElement(v11, { LayoutOrder = nextOrder() })
	end

	v10.CallToAction = callToAction

	local BOTTOM_UI_MAX_SIZE = momentLayout.BOTTOM_UI_MAX_SIZE

	local element = React.createElement(OverlayInfoFrame, {
		horizontalPadding = margin,
		verticalPadding = v.Padding.XLarge,
		safeAreaInsets = safeAreaInsets,
		maxSize = BOTTOM_UI_MAX_SIZE,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged
	}, v10)

	local createElement = React.createElement
	local provider = MomentContext.Provider

	local createElement2 = React.createElement
	local v11 = {
		LayoutOrder = props.layoutOrder,
		backgroundStyle = v6 and { Transparency = 1 } or nil,
		tag = {
			["size-full clip"] = true,
			["bg-surface-0"] = not v6
		},
		testId = "--moments-item-root"
	}

	local createElement3 = React.createElement

	if surface == nil then
		surface = React.createElement(View, { tag = "size-full bg-surface-100" }, {
			Label = React.createElement(Text, {
				tag = "size-full text-body-large text-align-x-center text-align-y-center content-emphasis",
				Text = "[ video ]"
			})
		})
	end

	local children = {
		Video = createElement3(View, {
			tag = "size-full",
			testId = "--moments-item-video",
			ZIndex = 1
		}, {
			Surface = surface,
			Scrim = React.createElement(VideoScrim, { ZIndex = 2 }),
			GestureLayer = React.createElement(MomentGestureLayer, { ZIndex = 3 })
		}),
		Overlay = React.createElement(
			View,
			{
				tag = "position-bottom-center anchor-bottom-center size-full-0 auto-y",
				testId = "--moments-item-overlay",
				ZIndex = 2,
				GroupTransparency = groupTransparency
			},
			{
				Backdrop = React.createElement(GradientBackdrop, {
					color3 = v.Color.Common.Scrim.Color3,
					rotation = 270,
					size = size
				}),
				InfoFrame = element
			}
		),
		PlaybackIndicator = 0,
		ReactionExplosionLayer = 0
	}
	local playbackIndicator

	if not v5 then
		playbackIndicator = React.createElement(PlaybackToggleIndicator)
	end

	children.PlaybackIndicator = playbackIndicator

	children.ReactionExplosionLayer = React.createElement(ReactionExplosionLayer)
	local v12 = {
		Root = createElement2(View, v11, children),
		DisplayWakeLock = 0
	}
	local displayWakeLock

	if GetFFlagMomentsDisplayWakeLock() and not v5 then
		displayWakeLock = React.createElement(DisplayWakeLockEffect)
	end

	v12.DisplayWakeLock = displayWakeLock
	local element2 = createElement(provider, { data = v4, dataVersion = dataVersion }, v12)

	if FFlagMomentsFixOverlayRemountImpressions then
		element2 = React.createElement(MomentImpressionMemory.Provider, nil, element2)
	end

	return React.createElement(ReactionEffectsContext.Provider, nil, element2)
end

return MomentItem
