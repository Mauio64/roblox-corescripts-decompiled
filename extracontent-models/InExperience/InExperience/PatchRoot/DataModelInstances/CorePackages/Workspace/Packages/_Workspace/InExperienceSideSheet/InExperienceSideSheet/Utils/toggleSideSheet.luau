local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")

local parent = InExperienceSideSheet.Parent
local Drawer = require(parent.Drawer)
local GetDrawerVisibleStore = Drawer.Stores.GetDrawerVisibleStore

local Flags = require(InExperienceSideSheet.Flags)
local GetSideSheetConfigStore = require(InExperienceSideSheet.Stores.GetSideSheetConfigStore)
local getHasRoomForPeoplePage = require(InExperienceSideSheet.Utils.getHasRoomForPeoplePage)
local registerInGameMenuPeoplePageActions = require(InExperienceSideSheet.Utils.registerInGameMenuPeoplePageActions)

local FFlagSideSheetOpenPeoplePage = Flags.FFlagSideSheetOpenPeoplePage

return function(flag: boolean)
	local drawerVisibleStore = GetDrawerVisibleStore(false)
	local v = FFlagSideSheetOpenPeoplePage and flag and getHasRoomForPeoplePage()

	if FFlagSideSheetOpenPeoplePage and flag then
		GetSideSheetConfigStore(false).setDidSideSheetOpenWithPeoplePage(v)
	end

	drawerVisibleStore.setDrawerVisible(flag)

	if v then
		task.delay(0, function()
			if drawerVisibleStore.getDrawerVisible(false) then
				registerInGameMenuPeoplePageActions.openPeoplePage()
			end
		end)
	end
end
