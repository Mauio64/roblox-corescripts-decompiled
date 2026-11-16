local v = {
	View = { ids = "signal_view_item_ids", values = "signal_view_duration_seconds" },
	AddReaction = { ids = "signal_add_reaction_item_ids", values = "signal_add_reaction_values" },
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

function class:recordSignal(p: string, p2: string, value: string?)
	local v2 = v[p2]

	if v2 == nil then
		return
	end

	local payload = self._payload
	local counts = self._counts

	local ids = v2.ids
	local v3 = payload[ids]

	if not v3 then
		v3 = {}
		payload[ids] = v3
	end

	local values = v2.values
	local v4

	if values then
		v4 = payload[values]
	end

	if values and not v4 then
		v4 = {}
		payload[values] = v4
	end

	local v5 = counts[ids] or 0

	if v5 >= 25 then
		table.remove(v3, 1)

		if v4 then
			table.remove(v4, 1)
		end
	else
		counts[ids] = v5 + 1
		self._totalCount += 1
	end

	table.insert(v3, p)

	if v4 then
		table.insert(v4, value or "")
	end
end

function class:getSignalsPayload()
	return if self._totalCount ~= 0 then self._payload else nil
end

function class:getSignalCount()
	return self._totalCount
end

return createSignalTracker
