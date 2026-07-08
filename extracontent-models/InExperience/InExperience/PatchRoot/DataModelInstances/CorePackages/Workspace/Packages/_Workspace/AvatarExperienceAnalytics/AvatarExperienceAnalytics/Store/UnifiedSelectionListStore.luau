local UnifiedEventLogConstants = require(script.Parent.Parent.UnifiedEventLogConstants)
local t1 = {}

return {
	addToSelectionList = function(t2: {[any]: any}) -- line: 5
		-- upvalues: t1 (ref)
		table.insert(t1, t2)
	end,
	removeFromSelectionList = function(t3: {[any]: any}) -- line: 9
		-- upvalues: UnifiedEventLogConstants (copy), t1 (ref)
		local v5 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemId"
		local v6 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemType"

		for v7, v8 in t1 do
			if v8[v5] == t3[v5] and v8[v6] == t3[v6] then
				table.remove(t1, v7)

				return
			end
		end
	end,
	getSelectionList = function() -- line: 21
		-- upvalues: t1 (ref)
		return t1
	end,
	clearSelectionList = function() -- line: 25
		-- upvalues: t1 (ref)
		t1 = {}
	end
}
