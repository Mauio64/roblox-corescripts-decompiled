local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/LuauPolyfill")
require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")
local FFlagAmpV2WizardRateLimitedOutcome = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FFlagAmpV2WizardRateLimitedOutcome")
local FFlagAmpV2WizardTerminalOutcome = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FFlagAmpV2WizardTerminalOutcome")

local function errorResult()
	return { reason = "Error", flowId = "" }
end

return function(data, data2, callback, p2)
	return Promise.new(function(callback2)
		local flag = false
		local function finish(p3, p4)
			if flag then
				return
			end

			flag = true
			callback2(p3)

			if p4 and data.onComplete then
				data.onComplete(p3)
			end
		end
		local v5 = {
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
		local v6 = if not p2 then data2.extraProps else nil
		v5.extraProps = v6
		v5.onEvent = data.onEvent
		function v5.onExit(p3)
			if flag then
				return
			end

			flag = true
			callback2(p3)

			if data.onComplete then
				data.onComplete(p3)
			end
		end

		local function open(initialFragment)
			v5.initialFragment = initialFragment

			if callback(v5) == false then
				if flag then
					return
				end

				flag = true
				callback2({ reason = "Error", flowId = "" })
			end
		end

		if p2 then
			local api = data.api or require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FlowApiProvider")
			local registry = data.registry or require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/ComponentRegistry").default
			local buildEntrypointRequest = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/buildEntrypointRequest")
			v5.api = api
			v5.registry = registry
			api.entrypoint(buildEntrypointRequest(data2.target, data2.flow, data.surface, registry, data2.extraProps)):andThen(function(initialFragment)
				local v7 = initialFragment.outcome == "Error"
				local v8 = FFlagAmpV2WizardRateLimitedOutcome and initialFragment.outcome == "RateLimited" and true or v7

				if (initialFragment.entry == nil or initialFragment.entry == "") and not v8 then
					local v9 = {
						reason = "Completed",
						flowId = initialFragment.flowId,
						outcome = 0
					}
					local v10 = if FFlagAmpV2WizardTerminalOutcome then initialFragment.outcome else nil
					v9.outcome = v10

					if flag then
						return
					end

					flag = true
					callback2(v9)
				else
					v5.initialFragment = initialFragment

					if callback(v5) == false then
						if flag then
							return
						end

						flag = true
						callback2({ reason = "Error", flowId = "" })
					end
				end
			end):catch(function()
				if flag then
					return
				end

				flag = true
				callback2({ reason = "Error", flowId = "" })
			end)
		else
			v5.initialFragment = nil

			if callback(v5) == false then
				local v7 = { reason = "Error", flowId = "" }

				if not flag then
					flag = true
					callback2(v7)
				end
			end
		end
	end):catch(errorResult)
end
