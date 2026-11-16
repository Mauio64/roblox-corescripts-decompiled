local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local parent = InExperienceSideSheet.Parent
local Display = require(parent.Display)
require(parent.Signals)

local Constants = require(InExperienceSideSheet.Common.Constants)
local Flags = require(InExperienceSideSheet.Flags)
local getSideSheetDrawerWidth = require(script.Parent.getSideSheetDrawerWidth)
local hasRoomForPeoplePage = require(script.Parent.hasRoomForPeoplePage)

local FFlagClosePeoplePageWhenNoRoomBesideSideSheet = Flags.FFlagClosePeoplePageWhenNoRoomBesideSideSheet

return function(p, p2: number?)
	if p == nil then
		p = false
	end

	if not FFlagClosePeoplePageWhenNoRoomBesideSideSheet or p2 == nil then
		local displayStore = Display.GetDisplayStore(p)
		local deviceSafePadding = displayStore.getDeviceSafePadding(p)
		p2 = displayStore.getViewportSize(p).X - deviceSafePadding.left - deviceSafePadding.right
	end

	local v = getSideSheetDrawerWidth(p)

	if v <= 0 then
		v = Constants.NominalSideSheetWidth
	end

	return hasRoomForPeoplePage(p2, v)
end
