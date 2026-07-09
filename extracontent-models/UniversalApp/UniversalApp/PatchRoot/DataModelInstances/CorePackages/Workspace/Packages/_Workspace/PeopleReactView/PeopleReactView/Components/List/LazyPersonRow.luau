local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local React = require(PeopleReactViewParent.React)
local RobloxAppEnums = require(PeopleReactViewParent.RobloxAppEnums)
local useDeviceOrientation = require(PeopleReactViewParent.RobloxAppHooks).useDeviceOrientation
local Foundation = require(PeopleReactViewParent.Foundation)
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local PeopleService = require(PeopleReactViewParent.PeopleService)

require(PeopleReactView.Stores.GetScrollingFrameStore)

local PersonRow = require(PeopleReactView.Components.List.PersonRow)
local LazyScrollingComponent = require(PeopleReactView.Components.Common.LazyScrollingComponent)
local v14 = PeopleService.getService("Flags")
local FFlagPeoplePageRemoveSkeletons = v14.FFlagPeoplePageRemoveSkeletons
local FFlagPeoplePageRemoveUseMemoElements = v14.FFlagPeoplePageRemoveUseMemoElements
local v17 = React.memo(function(t1: {[any]: any}) -- line: 33
	-- upvalues: useTokens (copy), FFlagPeoplePageRemoveSkeletons (copy), React (copy), View (copy), Skeleton (copy), EnumsRadius (copy)
	local v19 = useTokens()

	if FFlagPeoplePageRemoveSkeletons then
		return React.createElement(View, {
			tag = {
				["bg-surface-200 radius-medium"] = true,
				["size-full-2600"] = t1.isPortrait,
				["size-full-1500"] = not t1.isPortrait
			}
		})
	end

	return React.createElement(View, {
		tag = {
			["row bg-surface-200 gap-medium padding-small radius-medium"] = true,
			["size-full-2600"] = t1.isPortrait,
			["size-full-1500"] = not t1.isPortrait
		}
	}, {
		ThumbnailContainer = React.createElement(View, {
			tag = "size-1200",
			LayoutOrder = 1
		}, {
			ThumbnailSkeleton = React.createElement(Skeleton, {
				Size = UDim2.fromScale(1, 1),
				radius = EnumsRadius.Circle
			})
		}),
		Details = React.createElement(View, {
			tag = "col grow size-0-full gap-medium",
			LayoutOrder = 2
		}, {
			NameSkeleton = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.new(0.9, 0, 0, v19.Size.Size_350),
				radius = EnumsRadius.Small
			}),
			HandleSkeleton = React.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.new(0.6, 0, 0, v19.Size.Size_350),
				radius = EnumsRadius.Small
			})
		})
	})
end)

return React.memo(function(t2: {[any]: any}) -- line: 88
	-- upvalues: useTokens (copy), useDeviceOrientation (copy), RobloxAppEnums (copy), FFlagPeoplePageRemoveUseMemoElements (copy), React (copy), PersonRow (copy), v17 (copy), FFlagPeoplePageRemoveSkeletons (copy), View (copy), Skeleton (copy), EnumsRadius (copy), LazyScrollingComponent (copy)
	local v21 = useTokens()
	local v22 = useDeviceOrientation() == RobloxAppEnums.DeviceOrientationMode.Portrait
	local v23 = if not FFlagPeoplePageRemoveUseMemoElements then React.useMemo(function() -- line: 100
		-- upvalues: React (copy), PersonRow (copy), t2 (copy)
		return React.createElement(PersonRow, {
			person = t2.person,
			layoutOrder = t2.layoutOrder
		})
	end, {
		t2.person,
		t2.layoutOrder
	}) else React.createElement(PersonRow, {
		person = t2.person,
		layoutOrder = t2.layoutOrder
	})
	local v24 = if not FFlagPeoplePageRemoveUseMemoElements then React.useMemo(function() -- line: 116
		-- upvalues: FFlagPeoplePageRemoveSkeletons (copy), React (copy), View (copy), v22 (copy), Skeleton (copy), EnumsRadius (copy), v21 (copy)
		if FFlagPeoplePageRemoveSkeletons then
			return React.createElement(View, {
				tag = {
					["bg-surface-200 radius-medium"] = true,
					["size-full-2600"] = v22,
					["size-full-1500"] = not v22
				}
			})
		end

		return React.createElement(View, {
			tag = {
				["row bg-surface-200 gap-medium padding-small radius-medium"] = true,
				["size-full-2600"] = v22,
				["size-full-1500"] = not v22
			}
		}, {
			ThumbnailContainer = React.createElement(View, {
				tag = "size-1200",
				LayoutOrder = 1
			}, {
				ThumbnailSkeleton = React.createElement(Skeleton, {
					Size = UDim2.fromScale(1, 1),
					radius = EnumsRadius.Circle
				})
			}),
			Details = React.createElement(View, {
				tag = "col grow size-0-full gap-medium",
				LayoutOrder = 2
			}, {
				NameSkeleton = React.createElement(Skeleton, {
					LayoutOrder = 1,
					Size = UDim2.new(0.9, 0, 0, v21.Size.Size_350),
					radius = EnumsRadius.Small
				}),
				HandleSkeleton = React.createElement(Skeleton, {
					LayoutOrder = 2,
					Size = UDim2.new(0.6, 0, 0, v21.Size.Size_350),
					radius = EnumsRadius.Small
				})
			})
		})
	end, {
		v22,
		v21
	}) else React.createElement(v17, {
		isPortrait = v22
	})

	if t2.scrollingFrameStore then
		return React.createElement(LazyScrollingComponent, {
			scrollingFrameAbsolutePositionY = t2.scrollingFrameStore.getAbsolutePositionY,
			scrollingFrameAbsoluteSizeY = t2.scrollingFrameStore.getAbsoluteSizeY,
			scrollingFrameCanvasPositionY = t2.scrollingFrameStore.getCanvasPositionY,
			placeholder = v24,
			placeholderLayoutOrder = t2.layoutOrder
		}, {
			PersonRow = v23
		})
	end

	return v23
end)
