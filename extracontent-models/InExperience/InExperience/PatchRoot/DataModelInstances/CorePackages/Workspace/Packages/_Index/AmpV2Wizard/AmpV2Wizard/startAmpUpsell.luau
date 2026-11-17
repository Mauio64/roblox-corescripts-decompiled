local parent = script.Parent
local Promise = require(parent.Parent.Promise)
require(parent.Parent.LuauPolyfill)
require(parent.Types)
local FFlagAmpV2WizardRateLimitedOutcome = require(parent.FFlagAmpV2WizardRateLimitedOutcome)
local FFlagAmpV2WizardTerminalOutcome = require(parent.FFlagAmpV2WizardTerminalOutcome)

local function errorResult() -- 2 equivalent calls inferred from this helper
	return { reason = "Error", flowId = "" }
end

return function(data, data2, callback, flag: boolean)
	return Promise.new(function(callback2)
		local flag2 = false
		local function finish(p, flag3: boolean) -- 4 equivalent calls inferred from this helper
			if flag2 then
				return
			end

			flag2 = true
			callback2(p)

			if flag3 and data.onComplete then
				data.onComplete(p)
			end
		end
		local v = {
			target = data2.target,
			flow = data2.flow,
			surface = data.surface,
			odpEventContext = data.odpEventContext,
			odpEventUniverseId = data.odpEventUniverseId,
			api = data.api,
			registry = data.registry,
			extraProps = 0,
			onEvent = 0,
			onExit = 0
		}
		local extraProps

		if not flag then
			extraProps = data2.extraProps
		end

		v.extraProps = extraProps
		v.onEvent = data.onEvent
		function v.onExit(p)
			finish(p, true) -- inferred equivalent call
		end

		local function open(initialFragment) -- 2 equivalent calls inferred from this helper
			v.initialFragment = initialFragment

			if callback(v) == false then
				finish(errorResult(), false) -- inferred equivalent call
			end
		end

		if flag then
			local api = data.api or require(parent.FlowApiProvider)
			local registry = data.registry

			if not registry then
				local ComponentRegistry = require(parent.ComponentRegistry)
				registry = ComponentRegistry.default
			end

			local buildEntrypointRequest = require(parent.buildEntrypointRequest)
			v.api = api
			v.registry = registry
			api.entrypoint(buildEntrypointRequest(data2.target, data2.flow, data.surface, registry, data2.extraProps)):andThen(function(data3)
				local v2 = data3.outcome == "Error"
				local v3 = FFlagAmpV2WizardRateLimitedOutcome and data3.outcome == "RateLimited" and true or v2

				if (data3.entry == nil or data3.entry == "") and not v3 then
					local v4 = { reason = "Completed", flowId = data3.flowId, outcome = 0 }
					local outcome

					if FFlagAmpV2WizardTerminalOutcome then
						outcome = data3.outcome
					end

					v4.outcome = outcome
					finish(v4, false) -- inferred equivalent call
				else
					open(data3) -- inferred equivalent call
				end
			end):catch(function()
				finish(errorResult(), false) -- inferred equivalent call
			end)
		else
			open(nil) -- inferred equivalent call
		end
	end):catch(errorResult)
end
