local parent = script:FindFirstAncestor("InExperienceSideSheet").Parent
local SharedFlags = require(parent.SharedFlags)

return {
	FFlagClosePeoplePageWhenNoRoomBesideSideSheet = require(script.FFlagClosePeoplePageWhenNoRoomBesideSideSheet),
	FFlagMountUnmountSideSheet = require(script.FFlagMountUnmountSideSheet),
	FFlagSideSheetOpenPeoplePage = SharedFlags.FFlagSideSheetOpenPeoplePage,
	FFlagSideSheetOpenPeoplePageRestoreChat = game:DefineFastFlag("SideSheetOpenPeoplePageRestoreChat", false) and SharedFlags.FFlagSideSheetOpenPeoplePage
}
