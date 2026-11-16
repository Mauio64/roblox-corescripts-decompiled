local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local React = require(parent.React)
local ReactIs = require(parent.ReactIs)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local Foundation = require(parent.Foundation)
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local Skeleton = Foundation.Skeleton
local View = Foundation.View

local PeopleService = require(parent.PeopleService)

require(PeopleReactView.Stores.GetScrollingFrameStore)

local PersonCard = require(PeopleReactView.Components.Card.PersonCard)
local LazyScrollingComponent = require(PeopleReactView.Components.Common.LazyScrollingComponent)

local service = PeopleService.getService("Flags")
local getFFlagPeoplePageEnablePersonSignalStore = service.GetFFlagPeoplePageEnablePersonSignalStore
local fFlagPeoplePageRemoveSkeletons = service.FFlagPeoplePageRemoveSkeletons
local fFlagPeoplePageRemoveUseMemoElements = service.FFlagPeoplePageRemoveUseMemoElements

local memo = React.memo(function(p)
	local v = useTokens()

	if fFlagPeoplePageRemoveSkeletons then
		return React.createElement(View, { tag = "bg-surface-100 radius-medium", Size = p.size })
	end

	return React.createElement(View, { tag = "col bg-surface-100 radius-medium", Size = p.size }, {
		ThumbnailContainer = React.createElement(
			View,
			{ tag = "size-full aspect-1-1 padding-small", LayoutOrder = 1 },
			{
				ThumbnailSkeleton = React.createElement(Skeleton, {
					Size = UDim2.fromScale(1, 1),
					radius = Radius.Small
				})
			}
		),
		Details = React.createElement(
			View,
			{
				tag = "size-full-1400 col align-y-center gap-xsmall padding-x-small",
				LayoutOrder = 2
			},
			{
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
			}
		)
	})
end)

return React.memo(function(props)
	local v = useTokens()
	local placeholderLayoutOrder

	if getFFlagPeoplePageEnablePersonSignalStore() then
		placeholderLayoutOrder = SignalsReact.useSignalBinding(Signals.createComputed(function(p)
			if type(props.layoutOrder) == "function" then
				return props.layoutOrder(p)
			end

			return props.layoutOrder or 0
		end))
	end

	local size

	if ReactIs.isBinding(props.width) then
		size = props.width:map(function(p: number)
			return UDim2.new(0, p, 0, p + v.Size.Size_1400)
		end)
	else
		size = UDim2.new(0, props.width, 0, props.width + v.Size.Size_1400)
	end

	local personCard

	if fFlagPeoplePageRemoveUseMemoElements then
		personCard = React.createElement(PersonCard, {
			width = props.width,
			person = props.person,
			showTooltip = props.showTooltip,
			onDismissTooltip = props.onDismissTooltip,
			shouldShowMenu = props.shouldShowMenu,
			layoutOrder = props.layoutOrder,
			isCompactCardLayout = props.isCompactCardLayout
		})
	else
		personCard = React.useMemo(function()
			return React.createElement(PersonCard, {
				width = props.width,
				person = props.person,
				showTooltip = props.showTooltip,
				onDismissTooltip = props.onDismissTooltip,
				shouldShowMenu = props.shouldShowMenu,
				layoutOrder = props.layoutOrder,
				isCompactCardLayout = props.isCompactCardLayout
			})
		end, {
			props.width,
			props.person,
			props.showTooltip,
			props.onDismissTooltip,
			props.shouldShowMenu,
			props.layoutOrder,
			props.isCompactCardLayout
		})
	end

	local placeholder

	if fFlagPeoplePageRemoveUseMemoElements then
		placeholder = React.createElement(memo, { size = size })
	else
		placeholder = React.useMemo(function()
			if fFlagPeoplePageRemoveSkeletons then
				return React.createElement(View, {
					tag = "bg-surface-100 radius-medium",
					Size = size
				})
			end

			return React.createElement(View, {
				tag = "col bg-surface-100 radius-medium",
				Size = size
			}, {
				ThumbnailContainer = React.createElement(
					View,
					{ tag = "size-full aspect-1-1 padding-small", LayoutOrder = 1 },
					{
						ThumbnailSkeleton = React.createElement(Skeleton, {
							Size = UDim2.fromScale(1, 1),
							radius = Radius.Small
						})
					}
				),
				Details = React.createElement(
					View,
					{
						tag = "size-full-1400 col align-y-center gap-xsmall padding-x-small",
						LayoutOrder = 2
					},
					{
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
					}
				)
			})
		end, { size, v })
	end

	if not props.scrollingFrameStore then
		return personCard
	end

	local createElement = React.createElement
	local v2 = {
		scrollingFrameAbsolutePositionY = props.scrollingFrameStore.getAbsolutePositionY,
		scrollingFrameAbsoluteSizeY = props.scrollingFrameStore.getAbsoluteSizeY,
		scrollingFrameCanvasPositionY = props.scrollingFrameStore.getCanvasPositionY,
		placeholder = placeholder,
		placeholderLayoutOrder = 0
	}

	if not getFFlagPeoplePageEnablePersonSignalStore() then
		placeholderLayoutOrder = props.layoutOrder
	end

	v2.placeholderLayoutOrder = placeholderLayoutOrder
	return createElement(LazyScrollingComponent, v2, { PersonCard = personCard })
end)
