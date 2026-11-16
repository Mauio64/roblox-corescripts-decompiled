local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)

local function useArchiveGameFlow()
	local state, setState = React.useState(nil)

	local requestArchive = React.useCallback(function(p: number)
		setState(p)
	end, {})

	local cancel = React.useCallback(function()
		setState(nil)
	end, {})

	local confirm = React.useCallback(function()
		if state ~= nil then
			GameConfigurationActions.archiveGame(state)
		end

		setState(nil)
	end, { state })

	return {
		isOpen = state ~= nil,
		requestArchive = requestArchive,
		confirm = confirm,
		cancel = cancel
	}
end

return useArchiveGameFlow
