local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")

local v = nil
local v2 = nil
local RegisterInGameMenuPeoplePageActions = {}

function RegisterInGameMenuPeoplePageActions.registerOpenPeoplePage(callback)
	v = callback
end
function RegisterInGameMenuPeoplePageActions.registerClosePeoplePage(callback)
	v2 = callback
end
function RegisterInGameMenuPeoplePageActions.openPeoplePage()
	if v then
		v()
	end
end

function RegisterInGameMenuPeoplePageActions.closePeoplePage(p: number?)
	if p ~= nil and require(InExperienceSideSheet.Flags.FFlagClosePeoplePageWhenNoRoomBesideSideSheet) then
		local getHasRoomForPeoplePage = require(InExperienceSideSheet.Utils.getHasRoomForPeoplePage)

		if not getHasRoomForPeoplePage(false, p) then
			local GetSideSheetConfigStore = require(InExperienceSideSheet.Stores.GetSideSheetConfigStore)
			GetSideSheetConfigStore(false).setDidSideSheetOpenWithPeoplePage(false)
		end
	end

	if v2 then
		v2()
	end
end

return RegisterInGameMenuPeoplePageActions
