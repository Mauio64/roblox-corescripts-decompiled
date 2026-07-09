local Parent = script:FindFirstAncestor("Moments").Parent
local Foundation = require(Parent.Foundation)
local MomentsCommon = require(Parent.MomentsCommon)
local React = require(Parent.React)
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local EnumsRadius = Foundation.Enums.Radius
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local useTokens = Foundation.Hooks.useTokens
local FormFactor = MomentsCommon.Enums.FormFactor
local GradientBackdrop = MomentsCommon.Components.GradientBackdrop
local momentLayout = require(script.Parent.momentLayout)

local function MomentItemSkeleton(t1: {[any]: any}) -- line: 44
	-- upvalues: useTokens (copy), useFormFactor (copy), FormFactor (copy), React (copy), View (copy), Skeleton (copy), GradientBackdrop (copy), momentLayout (copy), EnumsRadius (copy)
	local v15 = useTokens()
	local v16 = useFormFactor() == FormFactor.Wide
	local v17, v18 = React.useBinding(UDim2.fromScale(1, 0))
	local v19 = 2 * v15.Padding.XLarge
	local v20 = React.useCallback(function(p1) -- line: 52
		-- upvalues: v18 (copy), v19 (copy)
		v18(UDim2.new(1, 0, 0, p1.AbsoluteSize.Y + v19))
	end, { v19 })

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
				color3 = v15.Color.Common.Scrim.Color3,
				size = v17
			}),
			InfoFrame = React.createElement(View, {
				tag = "col align-x-left align-y-bottom gap-medium position-bottom-center anchor-bottom-center size-full-0 auto-y padding-xlarge",
				ZIndex = 2,
				sizeConstraint = {
					MaxSize = if not v16 then nil else momentLayout.BOTTOM_UI_MAX_SIZE
				},
				onAbsoluteSizeChanged = v20
			}, {
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
					Size = UDim2.fromOffset(not v16 and 200 or 280, 14)
				}),
				Experience = React.createElement(Skeleton, {
					LayoutOrder = 3,
					radius = EnumsRadius.Medium,
					Size = UDim2.fromOffset(v15.Size.Size_1000, v15.Size.Size_1000)
				})
			})
		})
	})
end

return MomentItemSkeleton
