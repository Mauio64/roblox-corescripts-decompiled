local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Foundation = require(ParentParentParent.Foundation)
local React = require(ParentParentParent.React)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local Icon = Foundation.Icon
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local useSafeZoneOffsets = require(ParentParent.Hooks.useSafeZoneOffsets)
local useScreenSize = RobloxAppHooks.useScreenSize

return function(t1: {[any]: any}) -- line: 27
	-- upvalues: useSafeZoneOffsets (copy), useScreenSize (copy), React (copy), View (copy), Skeleton (copy), EnumsRadius (copy), Icon (copy)
	local v13 = useSafeZoneOffsets()
	local v14 = useScreenSize()

	return React.createElement(View, {
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, v14.Y)
	}, {
		ContentFeedImage = React.createElement(Skeleton, {
			ZIndex = 1,
			Size = UDim2.fromScale(1, 1)
		}),
		FeedPlayerActions = React.createElement(View, {
			tag = "auto-y anchor-bottom-center position-bottom-center bg-action-subtle size-full-0 col align-x-left align-y-bottom",
			ZIndex = 2
		}, {
			InfoFrame = React.createElement(View, {
				tag = "align-x-left align-y-bottom padding-xlarge row position-bottom-center size-full-0 items-end bg-action-subtle anchor-bottom-center auto-y gap-medium items-center",
				LayoutOrder = 1
			}, {
				CreatorThumbnail = React.createElement(Skeleton, {
					LayoutOrder = 1,
					radius = EnumsRadius.Circle,
					Size = UDim2.fromOffset(30, 30)
				}),
				CreatorName = React.createElement(Skeleton, {
					LayoutOrder = 2,
					Size = UDim2.fromOffset(160, 16)
				})
			}),
			ExperienceInfo = React.createElement(View, {
				tag = "bg-surface-100 auto-y size-full-0 row align-x-left align-y-center gap-small",
				LayoutOrder = 2
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 20),
					PaddingRight = UDim.new(0, 20),
					PaddingTop = UDim.new(0, 20),
					PaddingBottom = UDim.new(0, 20 + v13.bottom)
				}),
				ExperienceThumbnail = React.createElement(Skeleton, {
					LayoutOrder = 1,
					radius = EnumsRadius.Medium,
					Size = UDim2.fromOffset(40, 40)
				}),
				ExperienceMetadata = React.createElement(View, {
					LayoutOrder = 2,
					tag = "auto-y bg-action-subtle grow col align-x-left align-y-center gap-xsmall"
				}, {
					ExperienceNameShimmerPanel = React.createElement(Skeleton, {
						LayoutOrder = 1,
						Size = UDim2.fromOffset(160, 16)
					}),
					ExperienceRatingShimmerPanel = React.createElement(Skeleton, {
						LayoutOrder = 2,
						Size = UDim2.fromOffset(160, 16)
					})
				}),
				JoinCTAContainer = React.createElement(View, {
					LayoutOrder = 3,
					tag = "bg-action-emphasis size-2000-1000 radius-medium",
					isDisabled = true
				}, {
					PlayIcon = React.createElement(Icon, {
						name = "icons/common/play",
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5)
					})
				})
			})
		})
	})
end
