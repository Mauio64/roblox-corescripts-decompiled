local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")

require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")
local FFlagAmpV2WizardSharedLauncher = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FFlagAmpV2WizardSharedLauncher")

local v5 = if not FFlagAmpV2WizardSharedLauncher then require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FlowApiProvider") else nil

local v6 = if not FFlagAmpV2WizardSharedLauncher then require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/ComponentRegistry") else nil

local v7 = if not FFlagAmpV2WizardSharedLauncher then require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/buildEntrypointRequest") else nil

local useAmpUpsellLauncher = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/useAmpUpsellLauncher")

if not FFlagAmpV2WizardSharedLauncher then
	require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/useWizardWalker")
end

local function fragmentHasEntry(p2): boolean
	return p2.entry ~= nil and p2.entry ~= ""
end

local function useAmpUpsell(data)
	local v8 = if FFlagAmpV2WizardSharedLauncher then require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FlowApiProvider") else v5

	local v9 = if FFlagAmpV2WizardSharedLauncher then require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/ComponentRegistry") else v6

	local api = data.api or v8
	local registry = data.registry or v9.default
	local surface = data.surface
	local target = data.target
	local flow = data.flow
	local extraProps = data.extraProps

	local state, setState = React.useState({ available = false, isLoading = true })

	local v10 = React.useCallback(function()
		local v11 = if FFlagAmpV2WizardSharedLauncher then require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/buildEntrypointRequest") else v7

		setState({ available = false, isLoading = true })
		api.entrypoint(v11(target, flow, surface, registry, extraProps)):andThen(function(p2)
			local v13 = {
				available = p2.entry ~= nil and p2.entry ~= "",
				isLoading = false,
				chosenFlow = 0
			}

			local v15 = if p2.chosenFlow ~= "" then p2.chosenFlow else nil
			v13.chosenFlow = v15
			setState(v13)
		end):catch(function()
			setState({ available = false, isLoading = false })
		end)
	end, { api, target, flow, surface, registry, extraProps })

	React.useEffect(function()
		v10()
	end, { v10 })

	local v11 = React.useCallback(function()
		v10()
	end, { v10 })

	local v12 = useAmpUpsellLauncher({
		surface = surface,
		registry = registry,
		api = api,
		onEvent = data.onEvent,
		onComplete = v11
	})

	return {
		availability = state,
		start = React.useCallback(function()
			return v12({ target = target, flow = flow, extraProps = extraProps })
		end, { v12, target, flow, extraProps })
	}
end

return useAmpUpsell
