local module = require("@luauforge/bundled/gvb")
local module2 = require("@luauforge/bundled/gvg")
local useNavigation = require("@luauforge/bundled/gvO").useNavigation
local appPage = require("@luauforge/bundled/gvP").AppPage

require("@luauforge/bundled/gvc")
local module3 = require("@luauforge/bundled/gvd")
local module4 = require("@luauforge/bundled/gvh")
local module5 = require("@luauforge/bundled/gwj")
require("@luauforge/bundled/gwl")
local module6 = require("@luauforge/bundled/gwn")
local module7 = require("@luauforge/bundled/gwo")

local function fragmentHasEntry(p2): boolean
	return p2.entry ~= nil and p2.entry ~= ""
end

local function useAmpUpsellLauncher(data)
	local api = data.api or module3
	local registry = data.registry or module4.default
	local surface = data.surface
	local odpEventContext = data.odpEventContext
	local odpEventUniverseId = data.odpEventUniverseId
	local onEvent = data.onEvent
	local onComplete = data.onComplete

	local v5 = useNavigation()

	return (module.useCallback(function(data2)
		local target = data2.target
		local flow = data2.flow
		local extraProps = data2.extraProps

		return module2.new(function(callback)
			api.entrypoint(module5(target, flow, surface, registry, extraProps)):andThen(function(data3)
				local v6 = data3.outcome == "Error"
				local v7 = module6 and data3.outcome == "RateLimited" and true or v6
				local v8 = not (data3.entry == nil) and data3.entry ~= ""

				if v8 or v7 then
					v5.push(appPage.AmpV2Wizard, {
						extraProps = {
							initialFragment = data3,
							target = target,
							flow = flow,
							surface = surface,
							odpEventContext = odpEventContext,
							odpEventUniverseId = odpEventUniverseId,
							api = api,
							registry = registry,
							onEvent = onEvent,
							onExit = function(p2)
								callback(p2)

								if onComplete then
									onComplete(p2)
								end
							end
						}
					})

					return
				end

				local v10 = { reason = "Completed", flowId = data3.flowId, outcome = 0 }
				local v11 = if module7 then data3.outcome else nil
				v10.outcome = v11
				callback(v10)
			end):catch(function()
				callback({ reason = "Error", flowId = "" })
			end)
		end)
	end, {
		api,
		v5,
		onComplete,
		onEvent,
		registry,
		surface,
		odpEventContext,
		odpEventUniverseId
	}))
end

return useAmpUpsellLauncher
