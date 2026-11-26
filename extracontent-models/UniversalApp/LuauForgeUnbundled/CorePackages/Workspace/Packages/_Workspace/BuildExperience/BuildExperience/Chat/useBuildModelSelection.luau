local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local GetBuildModelSelectionStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildModelSelectionStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildModelSelectionStore/createBuildModelSelectionStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/ModelPickerTypes")

local function useBuildModelSelection(p2, p3, p4, p5, p6, p7)
	local v5 = GetBuildModelSelectionStore(false)
	local v6 = React.useMemo(function()
		return Signals.createComputed(function(p8)
			if p4 ~= nil then
				return nil
			end

			if p2 ~= nil and p2 > 0 then
				return v5.getUniverse(p2, p8)
			end

			if p3 == nil then
				return nil
			end

			return (v5.getDraft(p3, p8))
		end)
	end, { v5, p2, p3, p4 })
	local v7 = SignalsReact.useSignalState(v6)
	local v8 = React.useMemo(function()
		return Signals.createComputed(function(p8)
			if v7 == nil then
				return nil
			end

			return (v7.getSelection(p8))
		end)
	end, { v7 })
	local v9 = SignalsReact.useSignalState(v8)
	local v10 = React.useCallback(function(p8)
		if
			v7 ~= nil
			and (p8 == "default" or p8 == "advanced")
			and v7.selectTier(p8)
			and p7 ~= nil
			and p7.onExit ~= nil
		then
			p7.onExit()
		end
	end, { v7, p7 })

	local v11 = React.useMemo(function()
		local v12 = {}

		for k, v13 in { "default", "advanced" } do
			local v14 = {
				id = v13,
				model = v13 == "default" and "Default" or "Advanced",
				isAvailable = p5 == nil and (v13 == "default" or p6 ~= true),
				isAvailabilityConfirmed = p5 ~= nil or p6 == true
			}

			if p5 ~= nil then
				for k2, v16 in p5.available do
					if v16.id ~= v13 then
						continue
					end

					v14.isAvailable = true
					v14.rateMultiplier = v16.rateMultiplier
				end
			end

			table.insert(v12, v14)
		end

		return { options = v12 }
	end, { p5, p6 })

	return React.useMemo(function()
		if p4 ~= nil then
			return p4
		end

		if v9 == nil then
			return nil
		end

		return {
			internalTesting = p7,
			data = v11,
			selectedId = v9.intendedTier,
			isDisabled = v9.isBusy,
			onSelect = v10
		}
	end, { p4, v9, v10, v11, p7 })
end

return useBuildModelSelection
