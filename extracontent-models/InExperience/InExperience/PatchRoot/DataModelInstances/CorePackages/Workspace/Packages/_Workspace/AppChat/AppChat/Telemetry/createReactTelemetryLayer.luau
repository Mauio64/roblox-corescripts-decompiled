local parent = script:FindFirstAncestor("AppChat").Parent
local React = require(parent.React)
local Cryo = require(parent.Cryo)

local function createReactTelemetryLayer(p, p2)
	local context = React.createContext(function()
		return Cryo.Dictionary.union({}, p2)
	end)

	local function Provider(p3)
		local v = React.useContext(p)
		local v2 = React.useCallback(function()
			local v2 = p3.value

			if typeof(v2) == "function" then
				v2 = v2()
			end

			return Cryo.Dictionary.union(v(), v2)
		end, { v, p3.value })

		return React.createElement(context.Provider, { value = v2 }, p3.children)
	end

	return { Context = context, Provider = Provider }
end

return createReactTelemetryLayer
