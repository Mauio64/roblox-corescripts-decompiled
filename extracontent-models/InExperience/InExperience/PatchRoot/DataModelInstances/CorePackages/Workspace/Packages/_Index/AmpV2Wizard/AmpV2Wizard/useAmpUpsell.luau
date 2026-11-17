local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)

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

local useAmpUpsellLauncher = require(AmpV2Wizard.useAmpUpsellLauncher)

if not FFlagAmpV2WizardSharedLauncher then
	require(AmpV2Wizard.useWizardWalker)
end

local function fragmentHasEntry(p): boolean -- 1 equivalent call inferred from this helper
	return p.entry ~= nil and p.entry ~= ""
end

local function useAmpUpsell(data)
	local v

	if FFlagAmpV2WizardSharedLauncher then
		v = require(AmpV2Wizard.FlowApiProvider)
	else
		v = FlowApiProvider
	end

	local v2

	if FFlagAmpV2WizardSharedLauncher then
		v2 = require(AmpV2Wizard.ComponentRegistry)
	else
		v2 = ComponentRegistry
	end

	local api = data.api or v
	local registry = data.registry or v2.default
	local surface = data.surface
	local target = data.target
	local flow = data.flow
	local extraProps = data.extraProps

	local state, setState = React.useState({ available = false, isLoading = true })

	local v3 = React.useCallback(function()
		local v3

		if FFlagAmpV2WizardSharedLauncher then
			v3 = require(AmpV2Wizard.buildEntrypointRequest)
		else
			v3 = buildEntrypointRequest
		end

		setState({ available = false, isLoading = true })
		api.entrypoint(v3(target, flow, surface, registry, extraProps)):andThen(function(p)
			local v4 = { available = fragmentHasEntry(p), isLoading = false, chosenFlow = 0 } -- inferred equivalent call
			local chosenFlow

			if p.chosenFlow ~= "" then
				chosenFlow = p.chosenFlow
			end

			v4.chosenFlow = chosenFlow
			setState(v4)
		end):catch(function()
			setState({ available = false, isLoading = false })
		end)
	end, { api, target, flow, surface, registry, extraProps })

	React.useEffect(function()
		v3()
	end, { v3 })

	local onComplete = React.useCallback(function()
		v3()
	end, { v3 })

	local v4 = useAmpUpsellLauncher({
		surface = surface,
		registry = registry,
		api = api,
		onEvent = data.onEvent,
		onComplete = onComplete
	})

	return {
		availability = state,
		start = React.useCallback(function()
			return v4({ target = target, flow = flow, extraProps = extraProps })
		end, { v4, target, flow, extraProps })
	}
end

return useAmpUpsell
