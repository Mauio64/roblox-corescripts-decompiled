local parent = script:FindFirstAncestor("InExperienceSideSheet").Parent
local SharedFlags = require(parent.SharedFlags)

return {
	FFlagClosePeoplePageWhenNoRoomBesideSideSheet = require(script.FFlagClosePeoplePageWhenNoRoomBesideSideSheet),
	FFlagMountUnmountSideSheet = require(script.FFlagMountUnmountSideSheet),
	FFlagSideSheetEmphasizeLeave = require(script.FFlagSideSheetEmphasizeLeave),
	FFlagSideSheetOpenPeoplePage = SharedFlags.FFlagSideSheetOpenPeoplePage,
	FFlagSideSheetOpenPeoplePageRestoreChat = game:DefineFastFlag("SideSheetOpenPeoplePageRestoreChat2", false),
	FFlagPioneerLogoutButtonLabel = game:DefineFastFlag("PioneerLogoutButtonLabel", false)
}
