local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local React = require(PeopleReactViewParent.React)
local ReactIs = require(PeopleReactViewParent.ReactIs)
local Signals = require(PeopleReactViewParent.Signals)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)
local Foundation = require(PeopleReactViewParent.Foundation)
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local PeopleService = require(PeopleReactViewParent.PeopleService)

require(PeopleReactView.Stores.GetScrollingFrameStore)

local PersonCard = require(PeopleReactView.Components.Card.PersonCard)
local LazyScrollingComponent = require(PeopleReactView.Components.Common.LazyScrollingComponent)
local v15 = PeopleService.getService("Flags")
local GetFFlagPeoplePageEnablePersonSignalStore = v15.GetFFlagPeoplePageEnablePersonSignalStore
local FFlagPeoplePageRemoveSkeletons = v15.FFlagPeoplePageRemoveSkeletons
local FFlagPeoplePageRemoveUseMemoElements = v15.FFlagPeoplePageRemoveUseMemoElements
local v19 = React.memo(function(t1: {[any]: any}) -- line: 33
	-- upvalues: useTokens (copy), FFlagPeoplePageRemoveSkeletons (copy), React (copy), View (copy), Skeleton (copy), EnumsRadius (copy)
	local v21 = useTokens()

	if FFlagPeoplePageRemoveSkeletons then
		return React.createElement(View, {
			tag = "bg-surface-100 radius-medium",
			Size = t1.size
		})
	end

	return React.createElement(View, {
		tag = "col bg-surface-100 radius-medium",
		Size = t1.size
	}, {
		ThumbnailContainer = React.createElement(View, {
			tag = "size-full aspect-1-1 padding-small",
			LayoutOrder = 1
		}, {
			ThumbnailSkeleton = React.createElement(Skeleton, {
				Size = UDim2.fromScale(1, 1),
				radius = EnumsRadius.Small
			})
		}),
		Details = React.createElement(View, {
			tag = "size-full-1400 col align-y-center gap-xsmall padding-x-small",
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
end)

return React.memo(function(t2: {[any]: any}) -- line: 86
	-- upvalues: useTokens (copy), GetFFlagPeoplePageEnablePersonSignalStore (copy), SignalsReact (copy), Signals (copy), ReactIs (copy), FFlagPeoplePageRemoveUseMemoElements (copy), React (copy), PersonCard (copy), v19 (copy), FFlagPeoplePageRemoveSkeletons (copy), View (copy), Skeleton (copy), EnumsRadius (copy), LazyScrollingComponent (copy)
	local v23 = useTokens()
	local v24 = if not GetFFlagPeoplePageEnablePersonSignalStore() then nil else SignalsReact.useSignalBinding(Signals.createComputed(function(p1) -- line: 90
		-- upvalues: t2 (copy)
		if type(t2.layoutOrder) == "function" then
			return t2.layoutOrder(p1)
		end

		return t2.layoutOrder or 0
	end))
	local u25 = if not ReactIs.isBinding(t2.width) then UDim2.new(0, t2.width, 0, t2.width + v23.Size.Size_1400) else t2.width:map(function(n1: number) -- line: 100
		-- upvalues: v23 (copy)
		return UDim2.new(0, n1, 0, n1 + v23.Size.Size_1400)
	end)
	local v26 = if not FFlagPeoplePageRemoveUseMemoElements then React.useMemo(function() -- line: 117
		-- upvalues: React (copy), PersonCard (copy), t2 (copy)
		return React.createElement(PersonCard, {
			width = t2.width,
			person = t2.person,
			showTooltip = t2.showTooltip,
			onDismissTooltip = t2.onDismissTooltip,
			shouldShowMenu = t2.shouldShowMenu,
			layoutOrder = t2.layoutOrder
		})
	end, {
		t2.width,
		t2.person,
		t2.showTooltip,
		t2.onDismissTooltip,
		t2.shouldShowMenu,
		t2.layoutOrder
	}) else React.createElement(PersonCard, {
		width = t2.width,
		person = t2.person,
		showTooltip = t2.showTooltip,
		onDismissTooltip = t2.onDismissTooltip,
		shouldShowMenu = t2.shouldShowMenu,
		layoutOrder = t2.layoutOrder
	})
	local v27 = if not FFlagPeoplePageRemoveUseMemoElements then React.useMemo(function() -- line: 141
		-- upvalues: FFlagPeoplePageRemoveSkeletons (copy), React (copy), View (copy), u25 (ref), Skeleton (copy), EnumsRadius (copy), v23 (copy)
		if FFlagPeoplePageRemoveSkeletons then
			return React.createElement(View, {
				tag = "bg-surface-100 radius-medium",
				Size = u25
			})
		end

		return React.createElement(View, {
			tag = "col bg-surface-100 radius-medium",
			Size = u25
		}, {
			ThumbnailContainer = React.createElement(View, {
				tag = "size-full aspect-1-1 padding-small",
				LayoutOrder = 1
			}, {
				ThumbnailSkeleton = React.createElement(Skeleton, {
					Size = UDim2.fromScale(1, 1),
					radius = EnumsRadius.Small
				})
			}),
			Details = React.createElement(View, {
				tag = "size-full-1400 col align-y-center gap-xsmall padding-x-small",
				LayoutOrder = 2
			}, {
				NameSkeleton = React.createElement(Skeleton, {
					LayoutOrder = 1,
					Size = UDim2.new(0.9, 0, 0, v23.Size.Size_350),
					radius = EnumsRadius.Small
				}),
				HandleSkeleton = React.createElement(Skeleton, {
					LayoutOrder = 2,
					Size = UDim2.new(0.6, 0, 0, v23.Size.Size_350),
					radius = EnumsRadius.Small
				})
			})
		})
	end, {
		u25,
		v23
	}) else React.createElement(v19, {
		size = u25
	})

	if t2.scrollingFrameStore then
		return React.createElement(LazyScrollingComponent, {
			scrollingFrameAbsolutePositionY = t2.scrollingFrameStore.getAbsolutePositionY,
			scrollingFrameAbsoluteSizeY = t2.scrollingFrameStore.getAbsoluteSizeY,
			scrollingFrameCanvasPositionY = t2.scrollingFrameStore.getCanvasPositionY,
			placeholder = v27,
			placeholderLayoutOrder = if not GetFFlagPeoplePageEnablePersonSignalStore() then t2.layoutOrder else v24
		}, {
			PersonCard = v26
		})
	end

	return v26
end)
