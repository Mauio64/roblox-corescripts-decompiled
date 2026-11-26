local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Promise")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Navigation").useNavigation
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/RobloxAppEnums").AppPage

require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")
local FFlagAmpV2WizardSharedLauncher = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FFlagAmpV2WizardSharedLauncher")

local v5 = if not FFlagAmpV2WizardSharedLauncher then require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FlowApiProvider") else nil

local v6 = if not FFlagAmpV2WizardSharedLauncher then require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/ComponentRegistry") else nil

local v7 = if not FFlagAmpV2WizardSharedLauncher then require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/buildEntrypointRequest") else nil

if not FFlagAmpV2WizardSharedLauncher then
	require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/useWizardWalker")
end

local FFlagAmpV2WizardRateLimitedOutcome = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FFlagAmpV2WizardRateLimitedOutcome")
local FFlagAmpV2WizardTerminalOutcome = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FFlagAmpV2WizardTerminalOutcome")

local function fragmentHasEntry(p2): boolean
	return p2.entry ~= nil and p2.entry ~= ""
end

local function useAmpUpsellLauncher(data)
	if FFlagAmpV2WizardSharedLauncher then
		local v8 = useNavigation()
		local api = data.api
		local registry = data.registry
		local surface = data.surface
		local onEvent = data.onEvent
		local onComplete = data.onComplete
		local odpEventContext = data.odpEventContext
		local odpEventUniverseId = data.odpEventUniverseId
		return React.useCallback(function(p2)
			return require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/startAmpUpsell")({
				api = api,
				registry = registry,
				surface = surface,
				onEvent = onEvent,
				onComplete = onComplete,
				odpEventContext = odpEventContext,
				odpEventUniverseId = odpEventUniverseId
			}, p2, function(p3)
				return v8.push(appPage.AmpV2Wizard, { extraProps = p3 })
			end, true)
		end, {
			api,
			v8,
			onComplete,
			onEvent,
			registry,
			surface,
			odpEventContext,
			odpEventUniverseId
		})
	else
		local api = data.api or v5
		local registry = data.registry or v6.default
		local surface = data.surface
		local odpEventContext = data.odpEventContext
		local odpEventUniverseId = data.odpEventUniverseId
		local onEvent = data.onEvent
		local onComplete = data.onComplete

		local v8 = useNavigation()

		return (React.useCallback(function(data2)
			local target = data2.target
			local flow = data2.flow
			local extraProps = data2.extraProps

			return Promise.new(function(callback)
				api.entrypoint(v7(target, flow, surface, registry, extraProps)):andThen(function(data3)
					local v9 = data3.outcome == "Error"
					local v10 = FFlagAmpV2WizardRateLimitedOutcome and data3.outcome == "RateLimited" and true or v9
					local v11 = not (data3.entry == nil) and data3.entry ~= ""

					if v11 or v10 then
						v8.push(appPage.AmpV2Wizard, {
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

					local v13 = {
						reason = "Completed",
						flowId = data3.flowId,
						outcome = 0
					}
					local v14 = if FFlagAmpV2WizardTerminalOutcome then data3.outcome else nil
					v13.outcome = v14
					callback(v13)
				end):catch(function()
					callback({ reason = "Error", flowId = "" })
				end)
			end)
		end, {
			api,
			v8,
			onComplete,
			onEvent,
			registry,
			surface,
			odpEventContext,
			odpEventUniverseId
		}))
	end
end

return useAmpUpsellLauncher
