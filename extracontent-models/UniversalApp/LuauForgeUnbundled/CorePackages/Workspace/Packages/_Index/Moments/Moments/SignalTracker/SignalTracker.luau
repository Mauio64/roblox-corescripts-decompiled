local v5 = {
	View = { ids = "signal_view_item_ids", values = "signal_view_duration_seconds" },
	AddReaction = {
		ids = "signal_add_reaction_item_ids",
		values = "signal_add_reaction_values"
	},
	RemoveReaction = {
		ids = "signal_remove_reaction_item_ids",
		values = "signal_remove_reaction_values"
	},
	AddFollow = { ids = "signal_add_follow_item_ids", values = nil },
	RemoveFollow = { ids = "signal_remove_follow_item_ids", values = nil },
	Share = { ids = "signal_share_item_ids", values = nil },
	Report = { ids = "signal_report_item_ids", values = nil },
	Join = { ids = "signal_join_item_ids", values = nil }
}

local class = {}
class.__index = class

local function createSignalTracker()
	return (setmetatable({ _payload = {}, _counts = {}, _totalCount = 0 }, class))
end

function class:recordSignal(p2, p3, value)
	local v6 = v5[p3]

	if v6 == nil then
		return
	end

	local payload = self._payload
	local counts = self._counts

	local ids = v6.ids
	local v7 = payload[ids]

	if not v7 then
		v7 = {}
		payload[ids] = v7
	end

	local values = v6.values
	local v8 = if values then payload[values] else nil

	if values and not v8 then
		v8 = {}
		payload[values] = v8
	end

	local v9 = counts[ids] or 0

	if v9 >= 25 then
		table.remove(v7, 1)

		if v8 then
			table.remove(v8, 1)
		end
	else
		counts[ids] = v9 + 1
		self._totalCount += 1
	end

	table.insert(v7, p2)

	if v8 then
		table.insert(v8, value or "")
	end
end

function class:getSignalsPayload()
	if self._totalCount == 0 then
		return nil
	end

	return self._payload
end

function class:getSignalCount()
	return self._totalCount
end

return createSignalTracker
