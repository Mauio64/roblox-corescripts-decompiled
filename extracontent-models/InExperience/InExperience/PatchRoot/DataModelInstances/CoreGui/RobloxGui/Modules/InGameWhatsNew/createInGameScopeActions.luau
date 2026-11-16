local CorePackages = game:GetService("CorePackages")

local WhatsNew = require(CorePackages.Workspace.Packages.WhatsNew)
local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)

local function createInGameScopeActions()
	local toggleSideSheet = InExperienceSideSheet.toggleSideSheet
	local scopeActions = WhatsNew.scopeActions.createScopeActions()

	scopeActions:register("OpenTiltMenu", function()
		toggleSideSheet(true)
	end)
	scopeActions:register("CloseTiltMenu", function()
		toggleSideSheet(false)
	end)
	scopeActions:bindOpenState({
		openActionKey = "OpenTiltMenu",
		closeActionKey = "CloseTiltMenu",
		getIsOpen = InExperienceSideSheet.getSideSheetVisibility
	})

	return scopeActions
end

return createInGameScopeActions
