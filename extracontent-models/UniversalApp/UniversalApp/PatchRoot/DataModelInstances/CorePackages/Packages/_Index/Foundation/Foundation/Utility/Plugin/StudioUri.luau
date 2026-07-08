local Parent = script:FindFirstAncestor("Foundation").Parent
local join = require(Parent.Dash).join
local t1 = {}
local t4 = {
	equals = function(t2: {[any]: any}, t3: {[any]: any}) -- line: 26
		if rawequal(t2, t3) then
			return true
		end

		return t2.DataModel == t3.DataModel and (t2.PluginType == t3.PluginType and (t2.PluginId == t3.PluginId and (t2.Category == t3.Category and t2.ItemId == t3.ItemId)))
	end
}

t4.RESTRICTED_Mt = table.freeze({
	__eq = function(t5: {[any]: any}, t6: {[any]: any}) -- line: 39
		-- upvalues: t4 (copy)
		return t4.equals(t5, t6)
	end
})

function t4.wrap(t7: {[any]: any}) -- line: 45
	-- upvalues: t4 (copy)
	if table.isfrozen(t7) and getmetatable(t7) == t4.RESTRICTED_Mt then
		return t7
	end

	if table.isfrozen(t7) then
		t7 = table.clone(t7)
	end

	return table.freeze((setmetatable(t7, t4.RESTRICTED_Mt)))
end
function t4.join(t8: {[any]: any}, t9: {[any]: any}) -- line: 57
	-- upvalues: t4 (copy), join (copy)
	return t4.wrap(join(t8, t9))
end
function t4.toString(t10: {[any]: any}?) -- line: 61
	-- upvalues: t1 (copy)
	local t11 = table.create(5)
	local v14 = t10 or t1

	if not v14 then
		return ""
	end

	if v14.DataModel then
		table.insert(t11, `DataModel:{ v14.DataModel }`)
	end

	if v14.PluginType then
		table.insert(t11, `PluginType:{ v14.PluginType }`)
	end

	if v14.PluginId then
		table.insert(t11, `PluginId:{ v14.PluginId }`)
	end

	if v14.Category then
		table.insert(t11, `Category:{ v14.Category }`)
	end

	if v14.ItemId then
		table.insert(t11, `ItemId:{ v14.ItemId }`)
	end

	return table.concat(t11, ", ")
end
function t4.child(t12: {[any]: any}, s1: string) -- line: 89
	-- upvalues: t4 (copy)
	return t4.join(t12, {
		ItemId = if not t12.ItemId then s1 else `{ t12.ItemId }/{ s1 }`
	})
end
function t4.isNull(t13: {[any]: any}) -- line: 95
	return t13.DataModel == "Null"
end
function t4.isValid(p1) -- line: 99
	return type(p1) == "table"
end
function t4.isStudioUri(p2) -- line: 105
	if type(p2) ~= "table" then
		return false
	end

	return p2.DataModel ~= nil or (p2.PluginType ~= nil or (p2.PluginId ~= nil or (p2.Category ~= nil or p2.ItemId ~= nil)))
end
function t4.fromAction(s2: string, s3: string) -- line: 116
	-- upvalues: t4 (copy)
	return t4.wrap({
		DataModel = "Standalone",
		Category = "Actions",
		PluginId = s2,
		ItemId = s3
	})
end
function t4.fromSetting(s4: string, s5: string) -- line: 125
	-- upvalues: t4 (copy)
	return t4.wrap({
		DataModel = "Standalone",
		Category = "Settings",
		PluginId = s4,
		ItemId = s5
	})
end
function t4.fromWidget(s6: string, s7: string) -- line: 134
	-- upvalues: t4 (copy)
	return t4.wrap({
		DataModel = "Standalone",
		Category = "Widgets",
		PluginId = s6,
		ItemId = s7
	})
end
function t4.fromPanel(s8: string, s9: string) -- line: 143
	-- upvalues: t4 (copy)
	return t4.wrap({
		DataModel = "Standalone",
		Category = "Panels",
		PluginId = s8,
		ItemId = s9
	})
end

return t4
