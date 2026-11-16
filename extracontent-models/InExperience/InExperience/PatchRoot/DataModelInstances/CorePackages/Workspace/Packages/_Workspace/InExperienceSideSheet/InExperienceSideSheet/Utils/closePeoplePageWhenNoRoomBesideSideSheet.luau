local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")

local getDidSideSheetOpenWithPeoplePage = require(InExperienceSideSheet.Utils.getDidSideSheetOpenWithPeoplePage)
local getHasRoomForPeoplePage = require(InExperienceSideSheet.Utils.getHasRoomForPeoplePage)
local getSideSheetVisibility = require(InExperienceSideSheet.Utils.getSideSheetVisibility)
local registerInGameMenuPeoplePageActions = require(InExperienceSideSheet.Utils.registerInGameMenuPeoplePageActions)

return function(p: number): boolean
	local sideSheetVisibility = getSideSheetVisibility(false)
	local didSideSheetOpenWithPeoplePage = getDidSideSheetOpenWithPeoplePage(false)

	if not (sideSheetVisibility and didSideSheetOpenWithPeoplePage) or getHasRoomForPeoplePage(false, p) then
		return false
	end

	registerInGameMenuPeoplePageActions.closePeoplePage(p)
	return true
end
