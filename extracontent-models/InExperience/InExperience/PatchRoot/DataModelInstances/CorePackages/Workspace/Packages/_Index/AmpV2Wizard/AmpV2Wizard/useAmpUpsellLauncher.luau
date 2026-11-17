local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)
local Promise = require(parent.Promise)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

require(AmpV2Wizard.Types)
local FFlagAmpV2WizardSharedLauncher = require(AmpV2Wizard.FFlagAmpV2WizardSharedLauncher)
local FlowApiProvider

if FFlagAmpV2WizardSharedLauncher then
	FlowApiProvider = nil
else
	FlowApiProvider = require(AmpV2Wizard.FlowApiProvider)
end

local ComponentRegistry

if FFlagAmpV2WizardSharedLauncher then
	ComponentRegistry = nil
else
	ComponentRegistry = require(AmpV2Wizard.ComponentRegistry)
end

local buildEntrypointRequest

if FFlagAmpV2WizardSharedLauncher then
	buildEntrypointRequest = nil
else
	buildEntrypointRequest = require(AmpV2Wizard.buildEntrypointRequest)
end

if not FFlagAmpV2WizardSharedLauncher then
	require(AmpV2Wizard.useWizardWalker)
end

local FFlagAmpV2WizardRateLimitedOutcome = require(AmpV2Wizard.FFlagAmpV2WizardRateLimitedOutcome)
local FFlagAmpV2WizardTerminalOutcome = require(AmpV2Wizard.FFlagAmpV2WizardTerminalOutcome)

local function fragmentHasEntry(p): boolean -- 1 equivalent call inferred from this helper
	return p.entry ~= nil and p.entry ~= ""
end

local function useAmpUpsellLauncher(data)
	if FFlagAmpV2WizardSharedLauncher then
		local v = useNavigation()
		local api = data.api
		local registry = data.registry
		local surface = data.surface
		local onEvent = data.onEvent
		local onComplete = data.onComplete
		local odpEventContext = data.odpEventContext
		local odpEventUniverseId = data.odpEventUniverseId
		return React.useCallback(function(p)
			local startAmpUpsell = require(AmpV2Wizard.startAmpUpsell)
			return startAmpUpsell({
				api = api,
				registry = registry,
				surface = surface,
				onEvent = onEvent,
				onComplete = onComplete,
				odpEventContext = odpEventContext,
				odpEventUniverseId = odpEventUniverseId
			}, p, function(extraProps)
				return v.push(AppPage.AmpV2Wizard, { extraProps = extraProps })
			end, true)
		end, { api, v, onComplete, onEvent, registry, surface, odpEventContext, odpEventUniverseId })
	else
		local api = data.api or FlowApiProvider
		local registry = data.registry or ComponentRegistry.default
		local surface = data.surface
		local odpEventContext = data.odpEventContext
		local odpEventUniverseId = data.odpEventUniverseId
		local onEvent = data.onEvent
		local onComplete = data.onComplete

		local v = useNavigation()

		return (React.useCallback(function(data2)
			local target = data2.target
			local flow = data2.flow
			local extraProps = data2.extraProps

			return Promise.new(function(callback)
				api.entrypoint(buildEntrypointRequest(target, flow, surface, registry, extraProps)):andThen(function(initialFragment)
					local v2 = initialFragment.outcome == "Error"
					local v3 = FFlagAmpV2WizardRateLimitedOutcome
						and initialFragment.outcome == "RateLimited"
						and true
						or v2

					if fragmentHasEntry(initialFragment) or v3 then -- inferred equivalent call
						v.push(AppPage.AmpV2Wizard, {
							extraProps = {
								initialFragment = initialFragment,
								target = target,
								flow = flow,
								surface = surface,
								odpEventContext = odpEventContext,
								odpEventUniverseId = odpEventUniverseId,
								api = api,
								registry = registry,
								onEvent = onEvent,
								onExit = function(p)
									callback(p)

									if onComplete then
										onComplete(p)
									end
								end
							}
						})

						return
					end

					local v4 = {
						reason = "Completed",
						flowId = initialFragment.flowId,
						outcome = 0
					}
					local outcome

					if FFlagAmpV2WizardTerminalOutcome then
						outcome = initialFragment.outcome
					end

					v4.outcome = outcome
					callback(v4)
				end):catch(function()
					callback({ reason = "Error", flowId = "" })
				end)
			end)
		end, { api, v, onComplete, onEvent, registry, surface, odpEventContext, odpEventUniverseId }))
	end
end

return useAmpUpsellLauncher
