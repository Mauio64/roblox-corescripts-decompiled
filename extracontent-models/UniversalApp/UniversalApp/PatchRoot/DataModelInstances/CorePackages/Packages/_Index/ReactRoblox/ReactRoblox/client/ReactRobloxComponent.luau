local ParentParent = script.Parent.Parent.Parent
local Object = require(ParentParent.LuauPolyfill).Object
local RobloxComponentProps = require(script.Parent.roblox.RobloxComponentProps)

require(script.Parent["ReactRobloxHostTypes.roblox"])

return {
	setInitialProperties = RobloxComponentProps.setInitialProperties,
	diffProperties = function(_, _: string, t1: {[any]: any}, t2: {[any]: any}, _) -- line: 32
		-- upvalues: Object (copy)
		local v9 = nil

		for v10, _ in t1 do
			if t2[v10] == nil then
				v9 = v9 or table.create(2)
				table.insert(v9, v10)
				table.insert(v9, Object.None)
			end
		end

		for v12, v13 in t2 do
			if v13 ~= if t1 == nil then nil else t1[v12] then
				v9 = v9 or table.create(2)
				table.insert(v9, v12)
				table.insert(v9, v13)
			end
		end

		return v9
	end,
	updateProperties = RobloxComponentProps.updateProperties,
	cleanupHostComponent = RobloxComponentProps.cleanupHostComponent
}
