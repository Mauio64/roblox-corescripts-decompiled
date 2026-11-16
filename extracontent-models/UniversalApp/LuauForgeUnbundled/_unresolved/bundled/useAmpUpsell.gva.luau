local module = require("@luauforge/bundled/gvb")

require("@luauforge/bundled/gvc")
local module2 = require("@luauforge/bundled/gvd")
local module3 = require("@luauforge/bundled/gvh")
local module4 = require("@luauforge/bundled/gwj")
local module5 = require("@luauforge/bundled/gwk")
require("@luauforge/bundled/gwl")

local function fragmentHasEntry(p2): boolean
	return p2.entry ~= nil and p2.entry ~= ""
end

local function useAmpUpsell(data)
	local api = data.api or module2
	local registry = data.registry or module3.default
	local surface = data.surface
	local target = data.target
	local flow = data.flow
	local extraProps = data.extraProps

	local state, setState = module.useState({ available = false, isLoading = true })

	local v5 = module.useCallback(function()
		setState({ available = false, isLoading = true })
		api.entrypoint(module4(target, flow, surface, registry, extraProps)):andThen(function(p2)
			local v7 = {
				available = p2.entry ~= nil and p2.entry ~= "",
				isLoading = false,
				chosenFlow = 0
			}

			local v9 = if p2.chosenFlow ~= "" then p2.chosenFlow else nil
			v7.chosenFlow = v9
			setState(v7)
		end):catch(function()
			setState({ available = false, isLoading = false })
		end)
	end, { api, target, flow, surface, registry, extraProps })

	module.useEffect(function()
		v5()
	end, { v5 })

	local v6 = module.useCallback(function()
		v5()
	end, { v5 })

	local v7 = module5({
		surface = surface,
		registry = registry,
		api = api,
		onEvent = data.onEvent,
		onComplete = v6
	})

	return {
		availability = state,
		start = module.useCallback(function()
			return v7({ target = target, flow = flow, extraProps = extraProps })
		end, { v7, target, flow, extraProps })
	}
end

return useAmpUpsell
