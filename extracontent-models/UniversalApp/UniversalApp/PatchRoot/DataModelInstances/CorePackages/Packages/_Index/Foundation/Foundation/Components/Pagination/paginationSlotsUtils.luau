local Foundation = script:FindFirstAncestor("Foundation")
local PaginationDirection = require(Foundation.Enums.PaginationDirection)
local t1 = {
	[PaginationDirection.First] = "first",
	[PaginationDirection.Backward] = "back",
	[PaginationDirection.Forward] = "forward",
	[PaginationDirection.Last] = "last"
}

return {
	NAV_SLOT_IDS = t1,
	getPageSlotId = function(n1: number) -- line: 71
		return `page-{ n1 }`
	end,
	getPaginationSelectableSlotOrder = function(t2: {[any]: any}) -- line: 76
		-- upvalues: t1 (copy), PaginationDirection (copy)
		local t3 = {}

		if t2.hasFirstLastButtons and not t2.isFirstDisabled then
			table.insert(t3, t1[PaginationDirection.First])
		end

		if not t2.isBackDisabled then
			table.insert(t3, t1[PaginationDirection.Backward])
		end

		if t2.pageSlots then
			for _, v15 in t2.pageSlots do
				if v15 ~= "ellipsis" and v15 ~= t2.currentPage then
					table.insert(t3, `page-{ v15 }`)
				end
			end
		end

		if not t2.isForwardDisabled then
			table.insert(t3, t1[PaginationDirection.Forward])
		end

		if t2.hasFirstLastButtons and not t2.isLastDisabled then
			table.insert(t3, t1[PaginationDirection.Last])
		end

		return t3
	end,
	getVisiblePageSlots = function(n2: number, n3: number) -- line: 30
		if n3 <= 7 then
			local t4 = {}

			for i = 1, n3 do
				table.insert(t4, i)
			end

			return t4
		end

		local t5 = {}

		if n2 <= 4 then
			table.insert(t5, 1)
			table.insert(t5, 2)
			table.insert(t5, 3)
			table.insert(t5, 4)
			table.insert(t5, 5)
			table.insert(t5, "ellipsis")
			table.insert(t5, n3)

			return t5
		end

		if n2 >= n3 - 4 + 1 then
			table.insert(t5, 1)
			table.insert(t5, "ellipsis")

			for i = n3 - 4, n3 do
				table.insert(t5, i)
			end

			return t5
		end

		table.insert(t5, 1)
		table.insert(t5, "ellipsis")

		for i = n2 - 1, n2 + 1 do
			table.insert(t5, i)
		end

		table.insert(t5, "ellipsis")
		table.insert(t5, n3)

		return t5
	end
}
