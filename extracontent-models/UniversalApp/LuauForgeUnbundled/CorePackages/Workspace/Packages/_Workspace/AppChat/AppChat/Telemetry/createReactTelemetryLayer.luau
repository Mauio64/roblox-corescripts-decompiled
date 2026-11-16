local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")

local function createReactTelemetryLayer(p2, p3)
	local context = React.createContext(function()
		return Cryo.Dictionary.union({}, p3)
	end)

	local function Provider(p4)
		local v5 = React.useContext(p2)
		local v6 = React.useCallback(function()
			local v7 = p4.value

			if typeof(v7) == "function" then
				v7 = v7()
			end

			return Cryo.Dictionary.union(v5(), v7)
		end, { v5, p4.value })

		return React.createElement(context.Provider, { value = v6 }, p4.children)
	end

	return { Context = context, Provider = Provider }
end

return createReactTelemetryLayer
