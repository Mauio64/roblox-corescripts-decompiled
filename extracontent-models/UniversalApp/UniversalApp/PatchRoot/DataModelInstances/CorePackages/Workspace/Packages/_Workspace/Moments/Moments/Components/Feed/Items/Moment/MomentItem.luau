local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Foundation = require(MomentsParent.Foundation)
local MomentsCommon = require(MomentsParent.MomentsCommon)

require(MomentsParent.MomentsTypes)

local React = require(MomentsParent.React)
local ReactUtils = require(MomentsParent.ReactUtils)
local FoundationText = Foundation.Text
local View = Foundation.View
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
local ReactionEffectsContext = require(script.Parent.Reactions.ReactionEffectsContext)
local MomentGestureLayer = require(script.Parent.Reactions.MomentGestureLayer)
local ReactionExplosionLayer = require(script.Parent.Reactions.ReactionExplosionLayer)
local useChromeRatio = require(Moments.Hooks.useChromeRatio)
local GetFFlagMomentsImmersiveChrome = require(Moments.Flags.GetFFlagMomentsImmersiveChrome)
local GetFFlagMomentsImmersiveResizeViewport = require(Moments.Flags.GetFFlagMomentsImmersiveResizeViewport)

local function OverlayInfoFrame(t1: {[any]: any}) -- line: 93
	-- upvalues: MomentOverlayInsetContext (copy), useChromeRatio (copy), React (copy), View (copy)
	local v30 = MomentOverlayInsetContext.useMomentOverlayInset()
	local v31 = useChromeRatio()
	local inlinePadding = t1.inlinePadding
	local t2 = {
		top = UDim.new(0, inlinePadding),
		left = UDim.new(0, inlinePadding),
		right = UDim.new(0, inlinePadding),
		bottom = v31:map(function(n1: number) -- line: 104
			-- upvalues: inlinePadding (copy), v30 (copy)
			return UDim.new(0, inlinePadding + math.round(v30 * n1))
		end)
	}

	return React.createElement(View, {
		tag = "col align-x-center align-y-bottom gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y",
		ZIndex = 2,
		padding = t2,
		sizeConstraint = {
			MaxSize = t1.maxSize
		},
		onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged
	}, t1.children)
end
local function MomentItem(t3: {[any]: any}) -- line: 119
	-- upvalues: useTokens (copy), useFormFactor (copy), ReactUtils (copy), GetFFlagMomentsImmersiveChrome (copy), GetFFlagMomentsImmersiveResizeViewport (copy), React (copy), TopContent (copy), Scrubber (copy), CallToAction (copy), FormFactor (copy), momentLayout (copy), OverlayInfoFrame (copy), View (copy), MomentContext (copy), FoundationText (copy), VideoScrim (copy), MomentGestureLayer (copy), GradientBackdrop (copy), PlaybackToggleIndicator (copy), ReactionExplosionLayer (copy), ReactionEffectsContext (copy)
	local v35 = useTokens()
	local v36 = useFormFactor()
	local v37 = ReactUtils.createNextOrder()
	local v38 = GetFFlagMomentsImmersiveChrome() and not GetFFlagMomentsImmersiveResizeViewport()
	local v39, v40 = React.useBinding(UDim2.fromScale(1, 0))
	local v41 = 2 * v35.Padding.XLarge
	local v42 = React.useCallback(function(p1) -- line: 135
		-- upvalues: v40 (copy), v41 (copy)
		v40(UDim2.new(1, 0, 0, p1.AbsoluteSize.Y + v41))
	end, { v41 })
	local t4 = {
		TopContent = React.createElement(TopContent, {
			LayoutOrder = v37(),
			moment = t3.moment
		}),
		Scrubber = React.createElement(Scrubber, {
			LayoutOrder = v37()
		}),
		CallToAction = React.createElement(CallToAction, {
			LayoutOrder = v37()
		})
	}
	local v44 = if v36 == FormFactor.Wide then momentLayout.BOTTOM_UI_MAX_SIZE else nil
	local v45 = if not v38 then React.createElement(View, {
		tag = "col align-x-center align-y-bottom gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y padding-xlarge",
		ZIndex = 2,
		sizeConstraint = {
			MaxSize = v44
		},
		onAbsoluteSizeChanged = v42
	}, t4) else React.createElement(OverlayInfoFrame, {
		inlinePadding = v35.Padding.XLarge,
		maxSize = v44,
		onAbsoluteSizeChanged = v42
	}, t4)
	local v46 = React.createElement(MomentContext.Provider, {
		data = t3.data
	}, {
		Root = React.createElement(View, {
			tag = "size-full clip bg-surface-0",
			LayoutOrder = t3.layoutOrder
		}, {
			Video = React.createElement(View, {
				tag = "size-full",
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
				ZIndex = 2
			}, {
				Backdrop = React.createElement(GradientBackdrop, {
					rotation = 270,
					color3 = v35.Color.Common.Scrim.Color3,
					size = v39
				}),
				InfoFrame = v45
			}),
			PlaybackIndicator = React.createElement(PlaybackToggleIndicator),
			ReactionExplosionLayer = React.createElement(ReactionExplosionLayer)
		})
	})

	return React.createElement(ReactionEffectsContext.Provider, nil, v46)
end

return MomentItem
