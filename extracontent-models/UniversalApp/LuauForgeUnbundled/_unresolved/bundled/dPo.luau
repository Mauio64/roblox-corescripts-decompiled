local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dwM")
require("@luauforge/bundled/dMc")
local module2 = require("@luauforge/bundled/dCn")
local getMessageFadeSequence = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsChat/FriendsChat/ConversationWindow/getMessageFadeSequence")

return Rodux.makeActionCreator("SetRangeIdToBodyPartsToSliderAndColor3Values", function(p2, p3, p4, p5)
	module.isType(p2, "string", "rangeId")
	module.isType(p3, "string", "bodyPartForSkinColoringId")
	module.isType(p4, "number", "sliderValue")

	local clampBetween0And1, v5 = getMessageFadeSequence.clampBetween0And1(p4)

	if v5 then
		module2(string.format(
			"getColor3AtValueInRange: value %s should be between 0 and 1 inclusive",
			(tostring(p4))
		))
	end

	module.isType(p5, "Color3", "color3")
	return {
		rangeId = p2,
		bodyPartForSkinColoringId = p3,
		sliderValue = clampBetween0And1,
		color3 = p5
	}
end)
