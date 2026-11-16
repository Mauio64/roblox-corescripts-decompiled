local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local React = require(parent.React)

local RobloxAppEnums = require(parent.RobloxAppEnums)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation

local Foundation = require(parent.Foundation)
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local Skeleton = Foundation.Skeleton
local View = Foundation.View

local PeopleService = require(parent.PeopleService)
local FFlagPeopleListButtonOverflow = require(PeopleReactView.Flags.FFlagPeopleListButtonOverflow)

require(PeopleReactView.Stores.GetScrollingFrameStore)

local PersonRow = require(PeopleReactView.Components.List.PersonRow)
local PeoplePageLayoutContext = require(PeopleReactView.PeoplePageLayoutContext)
local LazyScrollingComponent = require(PeopleReactView.Components.Common.LazyScrollingComponent)

local service = PeopleService.getService("Flags")
local fFlagPeoplePageRemoveSkeletons = service.FFlagPeoplePageRemoveSkeletons
local fFlagPeoplePageRemoveUseMemoElements = service.FFlagPeoplePageRemoveUseMemoElements

local memo = React.memo(function(p)
	local v = useTokens()

	if fFlagPeoplePageRemoveSkeletons then
		return React.createElement(View, {
			tag = {
				["bg-surface-200 radius-medium"] = true,
				["size-full-2600"] = p.isPortrait,
				["size-full-1500"] = not p.isPortrait
			}
		})
	end

	return React.createElement(View, {
		tag = {
			["row bg-surface-200 gap-medium padding-small radius-medium"] = true,
			["size-full-2600"] = p.isPortrait,
			["size-full-1500"] = not p.isPortrait
		}
	}, {
		ThumbnailContainer = React.createElement(View, { tag = "size-1200", LayoutOrder = 1 }, {
			ThumbnailSkeleton = React.createElement(Skeleton, {
				Size = UDim2.fromScale(1, 1),
				radius = Radius.Circle
			})
		}),
		Details = React.createElement(View, {
			tag = "col grow size-0-full gap-medium",
			LayoutOrder = 2
		}, {
			NameSkeleton = React.createElement(Skeleton, {
				Size = UDim2.new(0.9, 0, 0, v.Size.Size_350),
				radius = Radius.Small,
				LayoutOrder = 1
			}),
			HandleSkeleton = React.createElement(Skeleton, {
				Size = UDim2.new(0.6, 0, 0, v.Size.Size_350),
				radius = Radius.Small,
				LayoutOrder = 2
			})
		})
	})
end)

return React.memo(function(props)
	local v = useTokens()

	local v2 = useDeviceOrientation() == RobloxAppEnums.DeviceOrientationMode.Portrait
	local v3 = React.useContext(PeoplePageLayoutContext)
	local v4 = v2 or FFlagPeopleListButtonOverflow and v3.isCompact
	local personRow

	if fFlagPeoplePageRemoveUseMemoElements then
		personRow = React.createElement(PersonRow, {
			person = props.person,
			layoutOrder = props.layoutOrder
		})
	else
		personRow = React.useMemo(function()
			return React.createElement(PersonRow, {
				person = props.person,
				layoutOrder = props.layoutOrder
			})
		end, { props.person, props.layoutOrder })
	end

	local placeholder

	if fFlagPeoplePageRemoveUseMemoElements then
		placeholder = React.createElement(memo, { isPortrait = v4 })
	else
		placeholder = React.useMemo(function()
			if fFlagPeoplePageRemoveSkeletons then
				return React.createElement(View, {
					tag = {
						["bg-surface-200 radius-medium"] = true,
						["size-full-2600"] = v4,
						["size-full-1500"] = not v4
					}
				})
			end

			return React.createElement(View, {
				tag = {
					["row bg-surface-200 gap-medium padding-small radius-medium"] = true,
					["size-full-2600"] = v4,
					["size-full-1500"] = not v4
				}
			}, {
				ThumbnailContainer = React.createElement(View, {
					tag = "size-1200",
					LayoutOrder = 1
				}, {
					ThumbnailSkeleton = React.createElement(Skeleton, {
						Size = UDim2.fromScale(1, 1),
						radius = Radius.Circle
					})
				}),
				Details = React.createElement(View, {
					tag = "col grow size-0-full gap-medium",
					LayoutOrder = 2
				}, {
					NameSkeleton = React.createElement(Skeleton, {
						Size = UDim2.new(0.9, 0, 0, v.Size.Size_350),
						radius = Radius.Small,
						LayoutOrder = 1
					}),
					HandleSkeleton = React.createElement(Skeleton, {
						Size = UDim2.new(0.6, 0, 0, v.Size.Size_350),
						radius = Radius.Small,
						LayoutOrder = 2
					})
				})
			})
		end, { v4, v })
	end

	if props.scrollingFrameStore then
		return React.createElement(LazyScrollingComponent, {
			scrollingFrameAbsolutePositionY = props.scrollingFrameStore.getAbsolutePositionY,
			scrollingFrameAbsoluteSizeY = props.scrollingFrameStore.getAbsoluteSizeY,
			scrollingFrameCanvasPositionY = props.scrollingFrameStore.getCanvasPositionY,
			placeholder = placeholder,
			placeholderLayoutOrder = props.layoutOrder
		}, { PersonRow = personRow })
	end

	return personRow
end)
