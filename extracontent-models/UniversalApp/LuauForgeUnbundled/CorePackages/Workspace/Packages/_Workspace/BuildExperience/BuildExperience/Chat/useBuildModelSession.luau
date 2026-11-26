local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local GetBuildModelSelectionStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildModelSelectionStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildModelSelectionStore/createBuildModelSelectionStore")

local function useBuildModelSession(p2, p3, p4)
	local v5 = GetBuildModelSelectionStore(false)
	local v6 = React.useMemo(function()
		return Signals.createComputed(function(p5)
			if p2 ~= nil and p2 > 0 then
				return v5.getUniverse(p2, p5)
			end

			if p3 == nil then
				return nil
			end

			return (v5.getDraft(p3, p5))
		end)
	end, { v5, p2, p3 })
	local v7 = SignalsReact.useSignalState(v6)
	local v8 = React.useMemo(function()
		return Signals.createComputed(function(p5)
			if v7 == nil or v7.getSelection(p5) == nil or p4 == nil then
				return nil
			end

			return (p4.getModels(p5))
		end)
	end, { v7, p4 })
	local v9 = SignalsReact.useSignalState(v8)
	local v10 = React.useMemo(function()
		return Signals.createComputed(function(p5)
			local v11 = if v7 ~= nil then v7.getSelection(p5) else nil
			return v11 ~= nil and v11.isBusy
		end)
	end, { v7 })
	local v11 = SignalsReact.useSignalState(v10)
	local v12 = React.useMemo(function()
		return Signals.createComputed(function(p5)
			return p4 ~= nil and p4.hasObservedModels(p5)
		end)
	end, { p4 })
	local v13 = SignalsReact.useSignalState(v12)
	React.useEffect(function()
		if v7 ~= nil and v9 ~= nil then
			v7.restoreTier(v9.current)
		end
	end, { v7, v9 })
	return React.useMemo(function()
		return { entry = v7, models = v9, isBusy = v11, hasObservedModels = v13 }
	end, { v7, v9, v11, v13 })
end

return useBuildModelSession
