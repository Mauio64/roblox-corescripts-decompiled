local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)

local function useArchiveGameFlow() -- line: 15
	-- upvalues: React (copy), GameConfigurationActions (copy)
	local v6, v7 = React.useState(nil)
	local v8 = React.useCallback(function(n1: number) -- line: 18
		-- upvalues: v7 (copy)
		v7(n1)
	end, {})
	local v9 = React.useCallback(function() -- line: 22
		-- upvalues: v7 (copy)
		v7(nil)
	end, {})
	local v10 = React.useCallback(function() -- line: 26
		-- upvalues: v6 (copy), GameConfigurationActions (copy), v7 (copy)
		if v6 ~= nil then
			GameConfigurationActions.archiveGame(v6)
		end

		v7(nil)
	end, { v6 })

	return {
		isOpen = v6 ~= nil,
		requestArchive = v8,
		confirm = v10,
		cancel = v9
	}
end

return useArchiveGameFlow
