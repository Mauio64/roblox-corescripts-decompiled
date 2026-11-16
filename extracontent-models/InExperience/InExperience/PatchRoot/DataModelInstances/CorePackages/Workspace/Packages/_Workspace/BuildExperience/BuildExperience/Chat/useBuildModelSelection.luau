local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local GetBuildModelSelectionStore = require(BuildExperience.Stores.GetBuildModelSelectionStore)
require(BuildExperience.Stores.GetBuildModelSelectionStore.createBuildModelSelectionStore)
require(parent.DataHydration.CreatorAgentChat)
require(BuildExperience.Components.ModelPicker.ModelPickerTypes)

local function useBuildModelSelection(p: number?, p2: string?, p3, p4, flag: boolean?, internalTesting)
	local buildModelSelectionStore = GetBuildModelSelectionStore(false)
	local v = React.useMemo(function()
		return Signals.createComputed(function(p5)
			if p3 ~= nil then
				return nil
			end

			if p ~= nil and p > 0 then
				return buildModelSelectionStore.getUniverse(p, p5)
			end

			if p2 == nil then
				return nil
			end

			return (buildModelSelectionStore.getDraft(p2, p5))
		end)
	end, { buildModelSelectionStore, p, p2, p3 })
	local v2 = SignalsReact.useSignalState(v)
	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p5)
			if v2 == nil then
				return nil
			end

			return (v2.getSelection(p5))
		end)
	end, { v2 })
	local v4 = SignalsReact.useSignalState(v3)
	local onSelect = React.useCallback(function(p5: string)
		if
			v2 ~= nil
			and (p5 == "default" or p5 == "advanced")
			and v2.selectTier(p5)
			and internalTesting ~= nil
			and internalTesting.onExit ~= nil
		then
			internalTesting.onExit()
		end
	end, { v2, internalTesting })

	local v5 = React.useMemo(function()
		local options = {}

		for _, id in { "default", "advanced" } do
			local v5 = {
				id = id,
				model = id == "default" and "Default" or "Advanced",
				isAvailable = p4 == nil and (id == "default" or flag ~= true),
				isAvailabilityConfirmed = p4 ~= nil or flag == true
			}

			if p4 ~= nil then
				for _, v6 in p4.available do
					if v6.id ~= id then
						continue
					end

					v5.isAvailable = true
					v5.rateMultiplier = v6.rateMultiplier
				end
			end

			table.insert(options, v5)
		end

		return { options = options }
	end, { p4, flag })

	return React.useMemo(function()
		if p3 ~= nil then
			return p3
		end

		if v4 == nil then
			return nil
		end

		return {
			internalTesting = internalTesting,
			data = v5,
			selectedId = v4.intendedTier,
			isDisabled = v4.isBusy,
			onSelect = onSelect
		}
	end, { p3, v4, onSelect, v5, internalTesting })
end

return useBuildModelSelection
