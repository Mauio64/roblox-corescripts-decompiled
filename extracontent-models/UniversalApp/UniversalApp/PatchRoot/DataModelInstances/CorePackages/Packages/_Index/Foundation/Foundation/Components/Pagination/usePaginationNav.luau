local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Components.Types)

local PaginationDirection = require(Foundation.Enums.PaginationDirection)

require(Foundation.Enums.PaginationSize)

local withCommonProps = require(Foundation.Utility.withCommonProps)

local NavPaginationLayout = require(script.Parent.Nav.NavPaginationLayout)

local paginationSlotsUtils = require(script.Parent.paginationSlotsUtils)

local usePaginationSelectionChain = require(script.Parent.usePaginationSelectionChain)

local function useNavCallbacks(data, p)
	return {
		onDirectionActivated = React.useCallback(function(p2)
			if p2 == PaginationDirection.First then
				data.onActivated(1)
			elseif p2 == PaginationDirection.Last then
				if data.count ~= nil then
					data.onActivated(data.count)
				end
			elseif p2 == PaginationDirection.Backward then
				data.onActivated(data.page - 1)
			else
				data.onActivated(data.page + 1)
			end
		end, { data.count, data.onActivated, data.page }),
		isFirstDisabled = p.isFirstDisabled or p.isBackDisabled
	}
end

local function mergeNavPaginationLayoutProps(data, p, ref) -- 1 equivalent call inferred from this helper
	local v = withCommonProps(data, p)
	v.ref = ref
	return v
end

local function usePaginationNav(data, data2, callback)
	local disabledState = data2.disabledState

	local selection = usePaginationSelectionChain(React.useMemo(function()
		return paginationSlotsUtils.getPaginationSelectableSlotOrder({
			hasFirstLastButtons = data2.hasFirstLastButtons,
			isFirstDisabled = disabledState.isFirstDisabled,
			isBackDisabled = disabledState.isBackDisabled,
			isForwardDisabled = disabledState.isForwardDisabled,
			isLastDisabled = disabledState.isLastDisabled,
			pageSlots = data2.pageSlots,
			currentPage = data2.currentPage
		})
	end, {
		data2.hasFirstLastButtons,
		data2.currentPage,
		data2.pageSlots,
		disabledState.isBackDisabled,
		disabledState.isFirstDisabled,
		disabledState.isForwardDisabled,
		disabledState.isLastDisabled
	}), { NextSelectionUp = data.NextSelectionUp, NextSelectionDown = data.NextSelectionDown }, callback)

	local v = useNavCallbacks(data, {
		isBackDisabled = disabledState.isBackDisabled,
		isFirstDisabled = disabledState.isFirstDisabled
	})

	return {
		selection = selection,
		createLayout = React.useCallback(function(pageContent, ref)
			return React.createElement(NavPaginationLayout, mergeNavPaginationLayoutProps(data, { -- inferred equivalent call
				pageContent = pageContent,
				size = data.size,
				isBackDisabled = disabledState.isBackDisabled,
				isFirstDisabled = v.isFirstDisabled,
				isForwardDisabled = disabledState.isForwardDisabled,
				isLastDisabled = disabledState.isLastDisabled,
				onDirectionActivated = v.onDirectionActivated,
				selection = selection,
				hasFirstLastButtons = data2.hasFirstLastButtons,
				testId = data.testId
			}, ref))
		end, {
			data2.hasFirstLastButtons,
			disabledState.isBackDisabled,
			disabledState.isForwardDisabled,
			disabledState.isLastDisabled,
			v.isFirstDisabled,
			v.onDirectionActivated,
			data,
			selection
		})
	}
end

return usePaginationNav
