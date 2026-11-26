local AppComposition = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/AppComposition")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local skeleton = Foundation.Skeleton
local view = Foundation.View

local radius = Foundation.Enums.Radius

local useCompositionLayout = AppComposition.useCompositionLayout
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local useTokens = Foundation.Hooks.useTokens

local formFactor = MomentsCommon.Enums.FormFactor
local gradientBackdrop = MomentsCommon.Components.GradientBackdrop

local momentLayout = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/momentLayout")
local MomentOverlayInsetContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentOverlayInsetContext")
local MomentPushedFeedSafeAreaContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentPushedFeedSafeAreaContext")
local FFlagMomentsFeedAboveNavBar = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFeedAboveNavBar")

local function MomentItemSkeleton(p2)
	local v5 = useTokens()
	local v6 = useFormFactor()
	local v7 = useCompositionLayout()
	local v8 = useDeviceInsets()
	local v9 = v6 == formFactor.Wide
	local margin = v7.margin
	local v10, v11 = React.useBinding(UDim2.fromScale(1, 0))

	local v12 = 2 * v5.Padding.XLarge
	local v13 = React.useCallback(function(p3)
		v11(UDim2.new(1, 0, 0, p3.AbsoluteSize.Y + v12))
	end, { v12 })

	local v14 = MomentPushedFeedSafeAreaContext.useMomentPushedFeedSafeArea()

	if v14 == nil then
		v14 = v8
	end

	local v15 = MomentOverlayInsetContext.useMomentOverlayInset()
	local v16 = v15 > 0
	local v17

	if FFlagMomentsFeedAboveNavBar then
		v17 = 0
		v16 = v15 > 0
	else
		v17 = v15
	end

	local v18 = v14 == nil and 0 or v14.bottom

	local v19 = math.max(v5.Padding.XLarge, v18)

	local v20 = if v16 then v5.Padding.Medium + v17 else v19 + v17

	local v21 = {
		CreatorRow = React.createElement(
			view,
			{
				LayoutOrder = 1,
				tag = "row align-x-left align-y-center gap-small auto-xy"
			},
			{
				Avatar = React.createElement(skeleton, {
					LayoutOrder = 1,
					radius = radius.Circle,
					Size = UDim2.fromOffset(momentLayout.AVATAR_SIZE, momentLayout.AVATAR_SIZE)
				}),
				Username = React.createElement(skeleton, {
					LayoutOrder = 2,
					radius = radius.Medium,
					Size = UDim2.fromOffset(momentLayout.USERNAME_SHIMMER.X, momentLayout.USERNAME_SHIMMER.Y)
				})
			}
		),
		Description = React.createElement(skeleton, {
			LayoutOrder = 2,
			radius = radius.Medium,
			Size = UDim2.fromOffset(v9 and 280 or 200, 14)
		}),
		Experience = React.createElement(skeleton, {
			LayoutOrder = 3,
			radius = radius.Medium,
			Size = UDim2.fromOffset(v5.Size.Size_1000, v5.Size.Size_1000)
		})
	}

	local BOTTOM_UI_MAX_SIZE = momentLayout.BOTTOM_UI_MAX_SIZE
	local v22

	if v14 == nil then
		v22 = React.createElement(view, {
			tag = "col align-x-left align-y-bottom gap-medium position-bottom-center anchor-bottom-center size-full-0 auto-y",
			padding = {
				top = UDim.new(0, v5.Padding.XLarge),
				left = UDim.new(0, margin),
				right = UDim.new(0, margin),
				bottom = UDim.new(0, v20)
			},
			testId = "--moments-moment-item-skeleton-info-frame",
			sizeConstraint = { MaxSize = BOTTOM_UI_MAX_SIZE },
			onAbsoluteSizeChanged = v13,
			ZIndex = 2
		}, v21)
	else
		local v23 = {
			top = UDim.new(0, v5.Padding.XLarge),
			left = UDim.new(0, (math.max(margin, v14.left))),
			right = UDim.new(0, (math.max(margin, v14.right))),
			bottom = UDim.new(0, v20)
		}

		v22 = React.createElement(view, {
			tag = "col align-x-left align-y-bottom gap-medium position-bottom-center anchor-bottom-center size-full-0 auto-y",
			padding = v23,
			testId = "--moments-moment-item-skeleton-info-frame",
			sizeConstraint = { MaxSize = BOTTOM_UI_MAX_SIZE },
			onAbsoluteSizeChanged = v13,
			ZIndex = 2
		}, v21)
	end

	return React.createElement(
		view,
		{ LayoutOrder = p2.layoutOrder, tag = "size-full clip bg-surface-0" },
		{
			Media = React.createElement(view, { tag = "size-full", ZIndex = 1 }, {
				Shimmer = React.createElement(skeleton, {
					Size = UDim2.fromScale(1, 1)
				})
			}),
			Overlay = React.createElement(
				view,
				{
					tag = "position-bottom-center anchor-bottom-center size-full-0 auto-y",
					ZIndex = 2
				},
				{
					Backdrop = React.createElement(gradientBackdrop, {
						color3 = v5.Color.Common.Scrim.Color3,
						rotation = 270,
						size = v10
					}),
					InfoFrame = v22
				}
			)
		}
	)
end

return MomentItemSkeleton
