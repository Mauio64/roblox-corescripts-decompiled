local WhatsNew = script:FindFirstAncestor("WhatsNew")
local ScopeActions = require(WhatsNew.registry.ScopeActions)

local function createPilotScopeActions() -- line: 8
	-- upvalues: ScopeActions (copy)
	local v4 = ScopeActions.createScopeActions()

	v4:register("OpenExperienceMenu", function() -- line: 10
	end)
	v4:register("CloseExperienceMenu", function() -- line: 11
	end)

	return v4
end

return createPilotScopeActions
