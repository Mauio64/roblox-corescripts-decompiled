local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")
local AvatarExperienceRoduxParent = AvatarExperienceRodux.Parent
local Rodux = require(AvatarExperienceRoduxParent.Rodux)

require(AvatarExperienceRoduxParent.AvatarExperienceCommon)

local AvatarExperienceFlags = require(AvatarExperienceRoduxParent.AvatarExperienceFlags)
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS

require(AvatarExperienceRodux.Types.OutfitTryOn)

return Rodux.makeActionCreator(script.Name, function(p1, s1: string, s2: string, b1: boolean, n1: number?, p2, p3, b2: boolean, b3: boolean?, t1: {[any]: any}?, b4: boolean?, n2: number?) -- line: 40
	-- upvalues: FFlagAXMISEnableMultiShopping (copy), FFlagAXDurablesForMIS (copy)
	return {
		itemType = p1,
		itemSubType = s1,
		itemId = s2,
		selectedInTryOnManager = b1,
		overrideOrder = n1,
		bundleInfo = p2,
		widgetInfo = p3,
		receivedBundleInfo = b2,
		isRecolorable = b3,
		bundleItems = if not FFlagAXMISEnableMultiShopping then nil else t1,
		resetTryOnsBeforeToggleOn = if not FFlagAXMISEnableMultiShopping then nil else b4,
		selectedTimedOptionIndex = if not FFlagAXDurablesForMIS then nil else n2
	}
end)
