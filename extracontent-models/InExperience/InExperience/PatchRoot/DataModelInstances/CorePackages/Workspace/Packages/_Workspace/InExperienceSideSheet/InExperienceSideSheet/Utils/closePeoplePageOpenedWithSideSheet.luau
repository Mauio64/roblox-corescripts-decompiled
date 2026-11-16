local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")

local getDidSideSheetOpenWithPeoplePage = require(InExperienceSideSheet.Utils.getDidSideSheetOpenWithPeoplePage)
local registerInGameMenuPeoplePageActions = require(InExperienceSideSheet.Utils.registerInGameMenuPeoplePageActions)

return function()
	if getDidSideSheetOpenWithPeoplePage() then
		registerInGameMenuPeoplePageActions.closePeoplePage()
	end
end
