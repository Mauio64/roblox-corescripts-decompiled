local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")

local parent = AvatarExperienceRodux.Parent
local Rodux = require(parent.Rodux)

require(parent.AvatarExperienceCommon)
require(parent.AvatarExperienceModel)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS

require(AvatarExperienceRodux.Types.OutfitTryOn)

return Rodux.makeActionCreator(
	script.Name,
	function(itemType, itemSubType: string, itemId: string, selectedInTryOnManager: boolean, overrideOrder: number?, bundleInfo, widgetInfo, receivedBundleInfo: boolean, isRecolorable: boolean?, bundleItems, resetTryOnsBeforeToggleOn: boolean?, selectedTimedOptionIndex: number?)
		if not FFlagAXDurablesForMIS then
			selectedTimedOptionIndex = nil
		end

		return {
			itemType = itemType,
			itemSubType = itemSubType,
			itemId = itemId,
			selectedInTryOnManager = selectedInTryOnManager,
			overrideOrder = overrideOrder,
			bundleInfo = bundleInfo,
			widgetInfo = widgetInfo,
			receivedBundleInfo = receivedBundleInfo,
			isRecolorable = isRecolorable,
			bundleItems = bundleItems,
			resetTryOnsBeforeToggleOn = resetTryOnsBeforeToggleOn,
			selectedTimedOptionIndex = selectedTimedOptionIndex
		}
	end
)
