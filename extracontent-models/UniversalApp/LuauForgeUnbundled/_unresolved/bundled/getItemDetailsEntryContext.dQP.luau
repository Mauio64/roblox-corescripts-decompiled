local avatarScreen = require("@luauforge/bundled/dQv").Enums.AvatarScreen
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/AvatarExperienceFlags")
local fFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local fFlagAXItemDetailsSduiTryOnSimpleView = AvatarExperienceFlags.FFlagAXItemDetailsSduiTryOnSimpleView

local function getItemDetailsEntryContext(p2, p3, p4): nil | string
	if p3 then
		if fFlagAXDurables2Option and p2.getParam("isFirstItemDetails") == false then
			return "NestedItemDetails"
		end
	else
		if p2.state.routeName ~= avatarScreen.TryOnItem then
			return "OutsideAvatarExperience"
		end

		if fFlagAXItemDetailsSduiTryOnSimpleView and p4 then
			return "TryOnSimpleView"
		end
	end

	return nil
end

return getItemDetailsEntryContext
