local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local AppComposition = require(parent.AppComposition)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Skeleton = Foundation.Skeleton
local View = Foundation.View

local Radius = Foundation.Enums.Radius

local useCompositionLayout = AppComposition.useCompositionLayout
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local useTokens = Foundation.Hooks.useTokens

local FormFactor = MomentsCommon.Enums.FormFactor
local GradientBackdrop = MomentsCommon.Components.GradientBackdrop

local momentLayout = require(script.Parent.momentLayout)
local MomentOverlayInsetContext = require(script.Parent.MomentOverlayInsetContext)
local MomentPushedFeedSafeAreaContext = require(script.Parent.MomentPushedFeedSafeAreaContext)
local FFlagMomentsFeedAboveNavBar = require(Moments.Flags.FFlagMomentsFeedAboveNavBar)

local function MomentItemSkeleton(p)
	local v = useTokens()
	local v2 = useFormFactor()
	local v3 = useCompositionLayout()
	local v4 = useDeviceInsets()
	local v5 = v2 == FormFactor.Wide
	local margin = v3.margin
	local size, v6 = React.useBinding(UDim2.fromScale(1, 0))

	local v7 = 2 * v.Padding.XLarge
	local onAbsoluteSizeChanged = React.useCallback(function(p2)
		v6(UDim2.new(1, 0, 0, p2.AbsoluteSize.Y + v7))
	end, { v7 })

	local v8 = MomentPushedFeedSafeAreaContext.useMomentPushedFeedSafeArea()

	if v8 == nil then
		v8 = v4
	end

	local v9 = MomentOverlayInsetContext.useMomentOverlayInset()
	local v10 = v9 > 0
	local v11

	if FFlagMomentsFeedAboveNavBar then
		v11 = 0
		v10 = v9 > 0
	else
		v11 = v9
	end

	local v12 = v8 == nil and 0 or v8.bottom

	local v13 = math.max(v.Padding.XLarge, v12)
	local v14

	if v10 then
		v14 = v.Padding.Medium + v11
	else
		v14 = v13 + v11
	end

	local v15 = {
		CreatorRow = React.createElement(
			View,
			{ LayoutOrder = 1, tag = "row align-x-left align-y-center gap-small auto-xy" },
			{
				Avatar = React.createElement(Skeleton, {
					LayoutOrder = 1,
					radius = Radius.Circle,
					Size = UDim2.fromOffset(momentLayout.AVATAR_SIZE, momentLayout.AVATAR_SIZE)
				}),
				Username = React.createElement(Skeleton, {
					LayoutOrder = 2,
					radius = Radius.Medium,
					Size = UDim2.fromOffset(momentLayout.USERNAME_SHIMMER.X, momentLayout.USERNAME_SHIMMER.Y)
				})
			}
		),
		Description = React.createElement(Skeleton, {
			LayoutOrder = 2,
			radius = Radius.Medium,
			Size = UDim2.fromOffset(v5 and 280 or 200, 14)
		}),
		Experience = React.createElement(Skeleton, {
			LayoutOrder = 3,
			radius = Radius.Medium,
			Size = UDim2.fromOffset(v.Size.Size_1000, v.Size.Size_1000)
		})
	}

	local BOTTOM_UI_MAX_SIZE = momentLayout.BOTTOM_UI_MAX_SIZE
	local infoFrame

	if v8 == nil then
		infoFrame = React.createElement(View, {
			tag = "col align-x-left align-y-bottom gap-medium position-bottom-center anchor-bottom-center size-full-0 auto-y",
			padding = {
				top = UDim.new(0, v.Padding.XLarge),
				left = UDim.new(0, margin),
				right = UDim.new(0, margin),
				bottom = UDim.new(0, v14)
			},
			testId = "--moments-moment-item-skeleton-info-frame",
			sizeConstraint = { MaxSize = BOTTOM_UI_MAX_SIZE },
			onAbsoluteSizeChanged = onAbsoluteSizeChanged,
			ZIndex = 2
		}, v15)
	else
		local padding = {
			top = UDim.new(0, v.Padding.XLarge),
			left = UDim.new(0, (math.max(margin, v8.left))),
			right = UDim.new(0, (math.max(margin, v8.right))),
			bottom = UDim.new(0, v14)
		}

		infoFrame = React.createElement(View, {
			tag = "col align-x-left align-y-bottom gap-medium position-bottom-center anchor-bottom-center size-full-0 auto-y",
			padding = padding,
			testId = "--moments-moment-item-skeleton-info-frame",
			sizeConstraint = { MaxSize = BOTTOM_UI_MAX_SIZE },
			onAbsoluteSizeChanged = onAbsoluteSizeChanged,
			ZIndex = 2
		}, v15)
	end

	return React.createElement(View, {
		LayoutOrder = p.layoutOrder,
		tag = "size-full clip bg-surface-0"
	}, {
		Media = React.createElement(View, { tag = "size-full", ZIndex = 1 }, {
			Shimmer = React.createElement(Skeleton, { Size = UDim2.fromScale(1, 1) })
		}),
		Overlay = React.createElement(
			View,
			{ tag = "position-bottom-center anchor-bottom-center size-full-0 auto-y", ZIndex = 2 },
			{
				Backdrop = React.createElement(GradientBackdrop, {
					color3 = v.Color.Common.Scrim.Color3,
					rotation = 270,
					size = size
				}),
				InfoFrame = infoFrame
			}
		)
	})
end

return MomentItemSkeleton
