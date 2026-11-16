require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ViewRecyclerReact")

local function createCommentsListRevealTracker(data)
	local schedule = data.schedule or function(callback)
		task.defer(callback)
	end
	local itemKeySet = {}
	local v5 = nil
	local flag = false
	local flag2 = false

	local function reveal()
		if flag then
			return
		end

		flag = true
		data.onReady()
	end

	local function isVisibleRangeMeasured(): boolean
		local v6 = v5

		if v6 == nil or v6.lastIndex < v6.firstIndex then
			return false
		end

		for i = v6.firstIndex, v6.lastIndex do
			local itemKey = data.getItemKey(i)

			if itemKey == nil or not itemKeySet[itemKey] then
				return false
			end
		end

		return true
	end

	local function check()
		flag2 = false

		if not flag and isVisibleRangeMeasured() then
			if flag then
				return
			end

			flag = true
			data.onReady()
		end
	end

	local function scheduleCheck()
		if flag or flag2 then
			return
		end

		flag2 = true
		schedule(check)
	end

	local layout = data.layout
	local updateItemMeasurement = layout.updateItemMeasurement
	function layout.updateItemMeasurement(p2)
		local v6 = updateItemMeasurement(p2)

		if not v6.accepted or flag then
			return v6
		end

		itemKeySet[p2.itemKey] = true

		if flag or flag2 then
			return v6
		end

		flag2 = true
		schedule(check)

		return v6
	end

	return {
		onVisibleRangeChanged = function(p2)
			v5 = p2

			if not flag then
				if flag2 then
					return
				end

				flag2 = true
				schedule(check)
			end
		end,
		reveal = reveal,
		destroy = function()
			flag = true
		end
	}
end

return createCommentsListRevealTracker
