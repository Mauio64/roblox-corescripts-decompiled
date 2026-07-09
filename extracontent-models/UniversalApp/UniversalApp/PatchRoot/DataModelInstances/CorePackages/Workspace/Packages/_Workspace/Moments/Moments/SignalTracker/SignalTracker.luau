local t1 = {
	View = {
		ids = "signal_view_item_ids",
		values = "signal_view_duration_seconds"
	},
	AddReaction = {
		ids = "signal_add_reaction_item_ids",
		values = "signal_add_reaction_values"
	},
	RemoveReaction = {
		ids = "signal_remove_reaction_item_ids",
		values = "signal_remove_reaction_values"
	},
	Share = {
		ids = "signal_share_item_ids",
		values = nil
	},
	Report = {
		ids = "signal_report_item_ids",
		values = nil
	},
	Join = {
		ids = "signal_join_item_ids",
		values = nil
	}
}
local t2 = {}

t2.__index = t2

local function createSignalTracker() -- line: 32
	-- upvalues: t2 (copy)
	return (setmetatable({
		_totalCount = 0,
		_payload = {},
		_counts = {}
	}, t2))
end

function t2.recordSignal(t3: {[any]: any}, s1: string, s2: string, s3: string?) -- line: 41
	-- upvalues: t1 (copy)
	local v8 = t1[s2]

	if v8 == nil then
		return
	end

	local _payload = t3._payload
	local _counts = t3._counts
	local ids = v8.ids
	local v12 = _payload[ids]

	if not v12 then
		v12 = {}
		_payload[ids] = v12
	end

	local values = v8.values
	local v14 = if not values then nil else _payload[values]

	if values and not v14 then
		v14 = {}
		_payload[values] = v14
	end

	local v15 = _counts[ids] or 0

	if v15 >= 25 then
		table.remove(v12, 1)

		if v14 then
			table.remove(v14, 1)
		end
	else
		_counts[ids] = v15 + 1
		t3._totalCount = t3._totalCount + 1
	end

	table.insert(v12, s1)

	if v14 then
		table.insert(v14, s3 or "")
	end
end
function t2.getSignalsPayload(t4: {[any]: any}) -- line: 82
	if t4._totalCount == 0 then
		return nil
	end

	return t4._payload
end
function t2.getSignalCount(t5: {[any]: any}) -- line: 90
	return t5._totalCount
end

return createSignalTracker
