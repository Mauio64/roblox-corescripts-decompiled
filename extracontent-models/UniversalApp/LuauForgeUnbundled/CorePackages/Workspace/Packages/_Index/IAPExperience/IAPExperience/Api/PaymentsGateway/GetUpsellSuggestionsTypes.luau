require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/BadgeType")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/VirtualItemBadgeType")

local v5 = { PlusPromotion = "plusPromotion" }

return {
	ExperimentVariant = v5,
	normalizeExperimentVariant = function(p2): nil | string
		if p2 == v5.PlusPromotion then
			return "plusPromotion"
		end

		return nil
	end
}
