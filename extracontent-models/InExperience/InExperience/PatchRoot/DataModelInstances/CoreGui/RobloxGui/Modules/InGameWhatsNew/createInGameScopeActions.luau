local CorePackages = game:GetService("CorePackages")
local WhatsNew = require(CorePackages.Workspace.Packages.WhatsNew)
local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)

local function createInGameScopeActions() -- line: 16
	-- upvalues: InExperienceSideSheet (copy), WhatsNew (copy)
	local toggleSideSheet = InExperienceSideSheet.toggleSideSheet
	local v6 = WhatsNew.scopeActions.createScopeActions()

	v6:register("OpenTiltMenu", function() -- line: 20
		-- upvalues: toggleSideSheet (copy)
		toggleSideSheet(true)
	end)
	v6:register("CloseTiltMenu", function() -- line: 23
		-- upvalues: toggleSideSheet (copy)
		toggleSideSheet(false)
	end)

	return v6
end

return createInGameScopeActions
