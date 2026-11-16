local Foundation = script:FindFirstAncestor("Foundation")

local PaginationDirection = require(Foundation.Enums.PaginationDirection)

local v = {
	[PaginationDirection.First] = "first",
	[PaginationDirection.Backward] = "back",
	[PaginationDirection.Forward] = "forward",
	[PaginationDirection.Last] = "last"
}

local function getPageSlotId(pageSlot: number) -- 1 equivalent call inferred from this helper
	return `page-{pageSlot}`
end

local PaginationSlotsUtils = {}
PaginationSlotsUtils.NAV_SLOT_IDS = v
PaginationSlotsUtils.getPageSlotId = getPageSlotId

function PaginationSlotsUtils.getPaginationSelectableSlotOrder(data)
	local paginationSelectableSlotOrder = {}

	if data.hasFirstLastButtons and not data.isFirstDisabled then
		table.insert(paginationSelectableSlotOrder, v[PaginationDirection.First])
	end

	if not data.isBackDisabled then
		table.insert(paginationSelectableSlotOrder, v[PaginationDirection.Backward])
	end

	if data.pageSlots then
		for _, pageSlot in data.pageSlots do
			if pageSlot ~= "ellipsis" and pageSlot ~= data.currentPage then
				table.insert(paginationSelectableSlotOrder, getPageSlotId(pageSlot)) -- inferred equivalent call
			end
		end
	end

	if not data.isForwardDisabled then
		table.insert(paginationSelectableSlotOrder, v[PaginationDirection.Forward])
	end

	if data.hasFirstLastButtons and not data.isLastDisabled then
		table.insert(paginationSelectableSlotOrder, v[PaginationDirection.Last])
	end

	return paginationSelectableSlotOrder
end

function PaginationSlotsUtils.getVisiblePageSlots(p: number, p2: number)
	if p2 <= 7 then
		local result = {}

		for i = 1, p2 do
			table.insert(result, i)
		end

		return result
	else
		local result = {}

		if p <= 4 then
			table.insert(result, 1)
			table.insert(result, 2)
			table.insert(result, 3)
			table.insert(result, 4)
			table.insert(result, 5)

			table.insert(result, "ellipsis")
			table.insert(result, p2)
		elseif p2 - 4 + 1 <= p then
			table.insert(result, 1)
			table.insert(result, "ellipsis")

			for i = p2 - 4, p2 do
				table.insert(result, i)
			end
		else
			table.insert(result, 1)
			table.insert(result, "ellipsis")

			for i = p - 1, p + 1 do
				table.insert(result, i)
			end

			table.insert(result, "ellipsis")
			table.insert(result, p2)
		end

		return result
	end
end

return PaginationSlotsUtils
