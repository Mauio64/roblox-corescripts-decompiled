local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local GameConfigurationActions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/GameConfigurationActions")

local function useArchiveGameFlow()
	local state, setState = React.useState(nil)

	local v5 = React.useCallback(function(p2)
		setState(p2)
	end, {})

	local v6 = React.useCallback(function()
		setState(nil)
	end, {})

	local v7 = React.useCallback(function()
		if state ~= nil then
			GameConfigurationActions.archiveGame(state)
		end

		setState(nil)
	end, { state })

	return {
		isOpen = state ~= nil,
		requestArchive = v5,
		confirm = v7,
		cancel = v6
	}
end

return useArchiveGameFlow
