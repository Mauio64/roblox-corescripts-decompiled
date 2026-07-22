local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local AppComposition = require(MomentsParent.AppComposition)
local Foundation = require(MomentsParent.Foundation)
local MomentsCommon = require(MomentsParent.MomentsCommon)
local React = require(MomentsParent.React)
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local EnumsRadius = Foundation.Enums.Radius
local useCompositionLayout = AppComposition.useCompositionLayout
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local useTokens = Foundation.Hooks.useTokens
local FormFactor = MomentsCommon.Enums.FormFactor
local GradientBackdrop = MomentsCommon.Components.GradientBackdrop
local momentLayout = require(script.Parent.momentLayout)
local MomentPushedFeedSafeAreaContext = require(script.Parent.MomentPushedFeedSafeAreaContext)
local FFlagMomentsUseCompositionLibrary = require(Moments.Flags.FFlagMomentsUseCompositionLibrary)
local GetFFlagMomentsPushedFeedSafeArea = require(Moments.Flags.GetFFlagMomentsPushedFeedSafeArea)

local function MomentItemSkeleton(t1: {[any]: any}) -- line: 54
	-- upvalues: useTokens (copy), useFormFactor (copy), FFlagMomentsUseCompositionLibrary (copy), useCompositionLayout (copy), useDeviceInsets (copy), FormFactor (copy), React (copy), MomentPushedFeedSafeAreaContext (copy), GetFFlagMomentsPushedFeedSafeArea (copy), View (copy), Skeleton (copy), EnumsRadius (copy), momentLayout (copy), GradientBackdrop (copy)
	local v22 = useTokens()
	local v23 = useFormFactor()
	local v24 = nil
	local v25 = nil

	if FFlagMomentsUseCompositionLibrary then
		v24 = useCompositionLayout()
		v25 = useDeviceInsets()
	end

	local v26 = v23 == FormFactor.Wide
	local v27 = if v24 == nil then v22.Padding.XLarge else v24.margin
	local v28, v29 = React.useBinding(UDim2.fromScale(1, 0))
	local v30 = 2 * v22.Padding.XLarge
	local v31 = React.useCallback(function(p1) -- line: 69
		-- upvalues: v29 (copy), v30 (copy)
		v29(UDim2.new(1, 0, 0, p1.AbsoluteSize.Y + v30))
	end, { v30 })
	local v32 = MomentPushedFeedSafeAreaContext.useMomentPushedFeedSafeArea()
	local v33 = if not GetFFlagMomentsPushedFeedSafeArea() or v32 == nil then v25 else v32
	local t2 = {
		CreatorRow = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-x-left align-y-center gap-small auto-xy"
		}, {
			Avatar = React.createElement(Skeleton, {
				LayoutOrder = 1,
				radius = EnumsRadius.Circle,
				Size = UDim2.fromOffset(momentLayout.AVATAR_SIZE, momentLayout.AVATAR_SIZE)
			}),
			Username = React.createElement(Skeleton, {
				LayoutOrder = 2,
				radius = EnumsRadius.Medium,
				Size = UDim2.fromOffset(momentLayout.USERNAME_SHIMMER.X, momentLayout.USERNAME_SHIMMER.Y)
			})
		}),
		Description = React.createElement(Skeleton, {
			LayoutOrder = 2,
			radius = EnumsRadius.Medium,
			Size = UDim2.fromOffset(not v26 and 200 or 280, 14)
		}),
		Experience = React.createElement(Skeleton, {
			LayoutOrder = 3,
			radius = EnumsRadius.Medium,
			Size = UDim2.fromOffset(v22.Size.Size_1000, v22.Size.Size_1000)
		})
	}
	local v35 = if not FFlagMomentsUseCompositionLibrary then if not v26 then nil else momentLayout.BOTTOM_UI_MAX_SIZE else momentLayout.BOTTOM_UI_MAX_SIZE
	local v37

	if v33 ~= nil then
		local t3 = {
			top = UDim.new(0, v22.Padding.XLarge),
			left = UDim.new(0, (math.max(v27, v33.left))),
			right = UDim.new(0, (math.max(v27, v33.right))),
			bottom = UDim.new(0, (math.max(v22.Padding.XLarge, v33.bottom)))
		}

		v37 = React.createElement(View, {
			tag = "col align-x-left align-y-bottom gap-medium position-bottom-center anchor-bottom-center size-full-0 auto-y",
			testId = "--moments-moment-item-skeleton-info-frame",
			ZIndex = 2,
			padding = t3,
			sizeConstraint = {
				MaxSize = v35
			},
			onAbsoluteSizeChanged = v31
		}, t2)
	else
		v37 = React.createElement(View, {
			tag = "col align-x-left align-y-bottom gap-medium position-bottom-center anchor-bottom-center size-full-0 auto-y",
			testId = "--moments-moment-item-skeleton-info-frame",
			ZIndex = 2,
			padding = {
				top = UDim.new(0, v22.Padding.XLarge),
				left = UDim.new(0, v27),
				right = UDim.new(0, v27),
				bottom = UDim.new(0, v22.Padding.XLarge)
			},
			sizeConstraint = {
				MaxSize = v35
			},
			onAbsoluteSizeChanged = v31
		}, t2)
	end

	return React.createElement(View, {
		tag = "size-full clip bg-surface-0",
		LayoutOrder = t1.layoutOrder
	}, {
		Media = React.createElement(View, {
			tag = "size-full",
			ZIndex = 1
		}, {
			Shimmer = React.createElement(Skeleton, {
				Size = UDim2.fromScale(1, 1)
			})
		}),
		Overlay = React.createElement(View, {
			tag = "position-bottom-center anchor-bottom-center size-full-0 auto-y",
			ZIndex = 2
		}, {
			Backdrop = React.createElement(GradientBackdrop, {
				rotation = 270,
				color3 = v22.Color.Common.Scrim.Color3,
				size = v28
			}),
			InfoFrame = v37
		})
	})
end

return MomentItemSkeleton
