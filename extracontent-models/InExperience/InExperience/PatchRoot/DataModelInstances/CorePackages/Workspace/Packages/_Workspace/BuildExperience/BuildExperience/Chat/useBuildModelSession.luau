local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
require(parent.DataHydration.CreatorAgentChat)
local GetBuildModelSelectionStore = require(BuildExperience.Stores.GetBuildModelSelectionStore)
require(BuildExperience.Stores.GetBuildModelSelectionStore.createBuildModelSelectionStore)

local function useBuildModelSession(p: number?, p2: string?, p3)
	local buildModelSelectionStore = GetBuildModelSelectionStore(false)
	local v = React.useMemo(function()
		return Signals.createComputed(function(p4)
			if p ~= nil and p > 0 then
				return buildModelSelectionStore.getUniverse(p, p4)
			end

			if p2 == nil then
				return nil
			end

			return (buildModelSelectionStore.getDraft(p2, p4))
		end)
	end, { buildModelSelectionStore, p, p2 })
	local entry = SignalsReact.useSignalState(v)
	local v2 = React.useMemo(function()
		return Signals.createComputed(function(p4)
			if entry == nil or entry.getSelection(p4) == nil or p3 == nil then
				return nil
			end

			return (p3.getModels(p4))
		end)
	end, { entry, p3 })
	local models = SignalsReact.useSignalState(v2)
	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p4)
			local v3

			if entry ~= nil then
				v3 = entry.getSelection(p4)
			end

			return v3 ~= nil and v3.isBusy
		end)
	end, { entry })
	local isBusy = SignalsReact.useSignalState(v3)
	local v4 = React.useMemo(function()
		return Signals.createComputed(function(p4)
			return p3 ~= nil and p3.hasObservedModels(p4)
		end)
	end, { p3 })
	local hasObservedModels = SignalsReact.useSignalState(v4)
	React.useEffect(function()
		if entry ~= nil and models ~= nil then
			entry.restoreTier(models.current)
		end
	end, { entry, models })
	return React.useMemo(function()
		return {
			entry = entry,
			models = models,
			isBusy = isBusy,
			hasObservedModels = hasObservedModels
		}
	end, { entry, models, isBusy, hasObservedModels })
end

return useBuildModelSession
