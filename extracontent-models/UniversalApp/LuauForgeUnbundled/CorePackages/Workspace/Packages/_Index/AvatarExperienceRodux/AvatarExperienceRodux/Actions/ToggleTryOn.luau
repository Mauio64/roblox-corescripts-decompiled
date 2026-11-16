local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Rodux")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/AvatarExperienceCommon")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/AvatarExperienceModel")
local fFlagAXDurablesForMIS = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/AvatarExperienceFlags").FFlagAXDurablesForMIS

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Types/OutfitTryOn")

return Rodux.makeActionCreator(
	"ToggleTryOn",
	function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, selectedTimedOptionIndex)
		if not fFlagAXDurablesForMIS then
			selectedTimedOptionIndex = nil
		end

		return {
			itemType = p2,
			itemSubType = p3,
			itemId = p4,
			selectedInTryOnManager = p5,
			overrideOrder = p6,
			bundleInfo = p7,
			widgetInfo = p8,
			receivedBundleInfo = p9,
			isRecolorable = p10,
			bundleItems = p11,
			resetTryOnsBeforeToggleOn = p12,
			selectedTimedOptionIndex = selectedTimedOptionIndex
		}
	end
)
