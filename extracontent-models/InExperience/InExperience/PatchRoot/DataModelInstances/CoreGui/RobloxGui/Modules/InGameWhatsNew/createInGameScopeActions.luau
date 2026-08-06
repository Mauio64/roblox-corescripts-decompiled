local CorePackages = game:GetService("CorePackages")
local WhatsNew = require(CorePackages.Workspace.Packages.WhatsNew)
local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)

local function createInGameScopeActions() -- line: 17
	-- upvalues: InExperienceSideSheet (copy), WhatsNew (copy)
	local toggleSideSheet = InExperienceSideSheet.toggleSideSheet
	local v6 = WhatsNew.scopeActions.createScopeActions()

	v6:register("OpenTiltMenu", function() -- line: 21
		-- upvalues: toggleSideSheet (copy)
		toggleSideSheet(true)
	end)
	v6:register("CloseTiltMenu", function() -- line: 24
		-- upvalues: toggleSideSheet (copy)
		toggleSideSheet(false)
	end)
	v6:bindOpenState({
		openActionKey = "OpenTiltMenu",
		closeActionKey = "CloseTiltMenu",
		getIsOpen = InExperienceSideSheet.getSideSheetVisibility
	})

	return v6
end

return createInGameScopeActions
