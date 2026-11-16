local parent = script:FindFirstAncestor("Moments").Parent

require(parent.ViewRecycler)

local function createCommentsListRevealTracker(data)
	local schedule = data.schedule or function(callback)
		task.defer(callback)
	end
	local itemKeySet = {}
	local v = nil
	local flag = false
	local flag2 = false

	local function reveal() -- 1 equivalent call inferred from this helper
		if flag then
			return
		end

		flag = true
		data.onReady()
	end

	local function isVisibleRangeMeasured(): boolean
		local v2 = v

		if v2 == nil or v2.lastIndex < v2.firstIndex then
			return false
		end

		for i = v2.firstIndex, v2.lastIndex do
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
			reveal() -- inferred equivalent call
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
	function layout.updateItemMeasurement(p)
		local v2 = updateItemMeasurement(p)

		if not v2.accepted or flag then
			return v2
		end

		itemKeySet[p.itemKey] = true

		if flag or flag2 then
			return v2
		end

		flag2 = true
		schedule(check)

		return v2
	end

	return {
		onVisibleRangeChanged = function(p)
			v = p

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
