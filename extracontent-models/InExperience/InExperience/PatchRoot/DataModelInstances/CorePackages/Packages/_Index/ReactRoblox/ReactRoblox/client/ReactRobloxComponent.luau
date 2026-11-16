local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object

local RobloxComponentProps = require(script.Parent.roblox.RobloxComponentProps)

require(script.Parent["ReactRobloxHostTypes.roblox"])

return {
	["setInitialProperties"] = RobloxComponentProps.setInitialProperties,
	diffProperties = function(_, _: string, items, items2, _)
		local result = nil

		for k, _ in items do
			if items2[k] ~= nil then
				continue
			end

			result = result or table.create(2)
			table.insert(result, k)
			table.insert(result, Object.None)
		end

		for k, item in items2 do
			local v

			if items ~= nil then
				v = items[k]
			end

			if item == v then
				continue
			end

			result = result or table.create(2)
			table.insert(result, k)
			table.insert(result, item)
		end

		return result
	end,
	updateProperties = RobloxComponentProps.updateProperties,
	cleanupHostComponent = RobloxComponentProps.cleanupHostComponent
}
