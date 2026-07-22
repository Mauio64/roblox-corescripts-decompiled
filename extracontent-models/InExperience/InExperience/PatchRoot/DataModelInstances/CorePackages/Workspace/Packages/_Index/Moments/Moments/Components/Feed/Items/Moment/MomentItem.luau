local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local AppComposition = require(MomentsParent.AppComposition)
local Foundation = require(MomentsParent.Foundation)
local MomentsCommon = require(MomentsParent.MomentsCommon)

require(MomentsParent.MomentsTypes)

local React = require(MomentsParent.React)
local ReactUtils = require(MomentsParent.ReactUtils)
local FoundationText = Foundation.Text
local View = Foundation.View
local useCompositionLayout = AppComposition.useCompositionLayout
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local useTokens = Foundation.Hooks.useTokens
local FormFactor = MomentsCommon.Enums.FormFactor
local GradientBackdrop = MomentsCommon.Components.GradientBackdrop
local momentLayout = require(script.Parent.momentLayout)
local MomentContext = require(script.Parent.MomentContext)
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
local FFlagMomentsImmersiveChrome = require(Moments.Flags.FFlagMomentsImmersiveChrome)
local FFlagMomentsUseCompositionLibrary = require(Moments.Flags.FFlagMomentsUseCompositionLibrary)
local GetFFlagMomentsPushedFeedSafeArea = require(Moments.Flags.GetFFlagMomentsPushedFeedSafeArea)

local function OverlayInfoFrame(t1: {[any]: any}) -- line: 99
	-- upvalues: useTokens (copy), MomentOverlayInsetContext (copy), FFlagMomentsUseCompositionLibrary (copy), React (copy), View (copy)
	local v34 = useTokens()
	local v35 = MomentOverlayInsetContext.useMomentOverlayInset()
	local horizontalPadding = t1.horizontalPadding
	local verticalPadding = t1.verticalPadding
	local safeAreaInsets = t1.safeAreaInsets
	local v39 = safeAreaInsets == nil and 0 or safeAreaInsets.left
	local v40 = safeAreaInsets == nil and 0 or safeAreaInsets.right
	local v41 = math.max(verticalPadding, safeAreaInsets == nil and 0 or safeAreaInsets.bottom) + v35

	if FFlagMomentsUseCompositionLibrary and v35 > 0 then
		v41 = v34.Padding.Medium + v35
	end

	local t2 = {
		top = UDim.new(0, verticalPadding),
		left = UDim.new(0, (math.max(horizontalPadding, v39))),
		right = UDim.new(0, (math.max(horizontalPadding, v40))),
		bottom = UDim.new(0, v41)
	}

	return React.createElement(View, {
		tag = "col align-x-center align-y-bottom gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y",
		testId = "--moments-info-frame-overlay",
		ZIndex = 2,
		padding = t2,
		sizeConstraint = {
			MaxSize = t1.maxSize
		},
		onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged
	}, t1.children)
end
local function MomentItem(t3: {[any]: any}) -- line: 137
	-- upvalues: useTokens (copy), FFlagMomentsUseCompositionLibrary (copy), useCompositionLayout (copy), useDeviceInsets (copy), useFormFactor (copy), ReactUtils (copy), MomentPushedFeedSafeAreaContext (copy), GetFFlagMomentsPushedFeedSafeArea (copy), FFlagMomentsImmersiveChrome (copy), React (copy), TopContent (copy), Scrubber (copy), CallToAction (copy), momentLayout (copy), FormFactor (copy), OverlayInfoFrame (copy), View (copy), MomentContext (copy), FoundationText (copy), VideoScrim (copy), MomentGestureLayer (copy), GradientBackdrop (copy), PlaybackToggleIndicator (copy), ReactionExplosionLayer (copy), ReactionEffectsContext (copy)
	local v44 = useTokens()
	local v45 = nil
	local v46 = nil

	if FFlagMomentsUseCompositionLibrary then
		v45 = useCompositionLayout()
		v46 = useDeviceInsets()
	end

	local v47 = nil

	if not FFlagMomentsUseCompositionLibrary then
		v47 = useFormFactor()
	end

	local v48 = ReactUtils.createNextOrder()
	local v49 = MomentPushedFeedSafeAreaContext.useMomentPushedFeedSafeArea()
	local v50 = if not GetFFlagMomentsPushedFeedSafeArea() or v49 == nil then v46 else v49
	local v51 = if v45 == nil then v44.Padding.XLarge else v45.margin
	local v52 = FFlagMomentsImmersiveChrome
	local v53, v54 = React.useBinding(UDim2.fromScale(1, 0))
	local v55 = 2 * v44.Padding.XLarge
	local v56 = React.useCallback(function(p1) -- line: 167
		-- upvalues: v54 (copy), v55 (copy)
		v54(UDim2.new(1, 0, 0, p1.AbsoluteSize.Y + v55))
	end, { v55 })
	local t4 = {
		TopContent = React.createElement(TopContent, {
			LayoutOrder = v48(),
			moment = t3.moment
		}),
		Scrubber = React.createElement(Scrubber, {
			LayoutOrder = v48()
		}),
		CallToAction = React.createElement(CallToAction, {
			LayoutOrder = v48()
		})
	}
	local v58 = if not FFlagMomentsUseCompositionLibrary then if v47 == FormFactor.Wide then momentLayout.BOTTOM_UI_MAX_SIZE else nil else momentLayout.BOTTOM_UI_MAX_SIZE
	local v59

	if v52 then
		v59 = React.createElement(OverlayInfoFrame, {
			horizontalPadding = v51,
			verticalPadding = v44.Padding.XLarge,
			safeAreaInsets = v50,
			maxSize = v58,
			onAbsoluteSizeChanged = v56
		}, t4)
	elseif v50 ~= nil then
		local t5 = {
			top = UDim.new(0, v44.Padding.XLarge),
			left = UDim.new(0, (math.max(v51, v50.left))),
			right = UDim.new(0, (math.max(v51, v50.right))),
			bottom = UDim.new(0, (math.max(v44.Padding.XLarge, v50.bottom)))
		}

		v59 = React.createElement(View, {
			tag = "col align-x-center align-y-bottom gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y",
			testId = "--moments-info-frame-inset",
			ZIndex = 2,
			padding = t5,
			sizeConstraint = {
				MaxSize = v58
			},
			onAbsoluteSizeChanged = v56
		}, t4)
	else
		v59 = React.createElement(View, {
			tag = "col align-x-center align-y-bottom gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y",
			testId = "--moments-info-frame-inset",
			ZIndex = 2,
			padding = {
				top = UDim.new(0, v44.Padding.XLarge),
				left = UDim.new(0, v51),
				right = UDim.new(0, v51),
				bottom = UDim.new(0, v44.Padding.XLarge)
			},
			sizeConstraint = {
				MaxSize = v58
			},
			onAbsoluteSizeChanged = v56
		}, t4)
	end

	local v61 = React.createElement(MomentContext.Provider, {
		data = t3.data
	}, {
		Root = React.createElement(View, {
			tag = "size-full clip bg-surface-0",
			testId = "--moments-item-root",
			LayoutOrder = t3.layoutOrder
		}, {
			Video = React.createElement(View, {
				tag = "size-full",
				testId = "--moments-item-video",
				ZIndex = 1
			}, {
				Surface = if t3.mediaSurface == nil then React.createElement(View, {
					tag = "size-full bg-surface-100"
				}, {
					Label = React.createElement(FoundationText, {
						tag = "size-full text-body-large text-align-x-center text-align-y-center content-emphasis",
						Text = "[ video ]"
					})
				}) else t3.mediaSurface,
				Scrim = React.createElement(VideoScrim, {
					ZIndex = 2
				}),
				GestureLayer = React.createElement(MomentGestureLayer, {
					ZIndex = 3
				})
			}),
			Overlay = React.createElement(View, {
				tag = "position-bottom-center anchor-bottom-center size-full-0 auto-y",
				testId = "--moments-item-overlay",
				ZIndex = 2
			}, {
				Backdrop = React.createElement(GradientBackdrop, {
					rotation = 270,
					color3 = v44.Color.Common.Scrim.Color3,
					size = v53
				}),
				InfoFrame = v59
			}),
			PlaybackIndicator = React.createElement(PlaybackToggleIndicator),
			ReactionExplosionLayer = React.createElement(ReactionExplosionLayer)
		})
	})

	return React.createElement(ReactionEffectsContext.Provider, nil, v61)
end

return MomentItem
