local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Components.Types)

local PaginationDirection = require(Foundation.Enums.PaginationDirection)

require(Foundation.Enums.PaginationSize)

local withCommonProps = require(Foundation.Utility.withCommonProps)
local NavPaginationLayout = require(script.Parent.Nav.NavPaginationLayout)
local paginationSlotsUtils = require(script.Parent.paginationSlotsUtils)
local usePaginationSelectionChain = require(script.Parent.usePaginationSelectionChain)

local function useNavCallbacks(p1, t1: {[any]: any}) -- line: 60
	-- upvalues: React (copy), PaginationDirection (copy)
	return {
		onDirectionActivated = React.useCallback(function(p2) -- line: 64
			-- upvalues: PaginationDirection (copy), p1 (copy)
			if p2 == PaginationDirection.First then
				p1.onActivated(1)

				return
			end

			if p2 == PaginationDirection.Last then
				if p1.count ~= nil then
					p1.onActivated(p1.count)

					return
				end
			else
				if p2 == PaginationDirection.Backward then
					p1.onActivated(p1.page - 1)

					return
				end

				p1.onActivated(p1.page + 1)
			end
		end, {
			p1.count,
			p1.onActivated,
			p1.page
		}),
		isFirstDisabled = t1.isFirstDisabled or t1.isBackDisabled
	}
end
local function mergeNavPaginationLayoutProps(p3, p4, p5) -- line: 85
	-- upvalues: withCommonProps (copy)
	local v17 = withCommonProps(p3, p4)

	v17.ref = p5

	return v17
end
local function usePaginationNav(p6, t2: {[any]: any}, p7: ((...any) -> ...any)?) -- line: 95
	-- upvalues: React (copy), paginationSlotsUtils (copy), usePaginationSelectionChain (copy), useNavCallbacks (copy), NavPaginationLayout (copy), withCommonProps (copy)
	local disabledState = t2.disabledState
	local v22 = React.useMemo(function() -- line: 103
		-- upvalues: paginationSlotsUtils (copy), t2 (copy), disabledState (copy)
		return paginationSlotsUtils.getPaginationSelectableSlotOrder({
			hasFirstLastButtons = t2.hasFirstLastButtons,
			isFirstDisabled = disabledState.isFirstDisabled,
			isBackDisabled = disabledState.isBackDisabled,
			isForwardDisabled = disabledState.isForwardDisabled,
			isLastDisabled = disabledState.isLastDisabled,
			pageSlots = t2.pageSlots,
			currentPage = t2.currentPage
		})
	end, {
		t2.hasFirstLastButtons,
		t2.currentPage,
		t2.pageSlots,
		disabledState.isBackDisabled,
		disabledState.isFirstDisabled,
		disabledState.isForwardDisabled,
		disabledState.isLastDisabled
	})
	local v23 = usePaginationSelectionChain(v22, {
		NextSelectionUp = p6.NextSelectionUp,
		NextSelectionDown = p6.NextSelectionDown
	}, p7)
	local v24 = useNavCallbacks(p6, {
		isBackDisabled = disabledState.isBackDisabled,
		isFirstDisabled = disabledState.isFirstDisabled
	})
	local v25 = React.useCallback(function(p8, p9) -- line: 136
		-- upvalues: React (copy), NavPaginationLayout (copy), p6 (copy), disabledState (copy), v24 (copy), v23 (copy), t2 (copy), withCommonProps (copy)
		local createElement = React.createElement
		local v30 = NavPaginationLayout
		local v31 = p6
		local t3 = {
			pageContent = p8,
			size = p6.size,
			isBackDisabled = disabledState.isBackDisabled,
			isFirstDisabled = v24.isFirstDisabled,
			isForwardDisabled = disabledState.isForwardDisabled,
			isLastDisabled = disabledState.isLastDisabled,
			onDirectionActivated = v24.onDirectionActivated,
			selection = v23,
			hasFirstLastButtons = t2.hasFirstLastButtons,
			testId = p6.testId
		}
		local v33 = withCommonProps(v31, t3)

		v33.ref = p9

		return createElement(v30, v33)
	end, {
		t2.hasFirstLastButtons,
		disabledState.isBackDisabled,
		disabledState.isForwardDisabled,
		disabledState.isLastDisabled,
		v24.isFirstDisabled,
		v24.onDirectionActivated,
		p6,
		v23
	})

	return {
		selection = v23,
		createLayout = v25
	}
end

return usePaginationNav
