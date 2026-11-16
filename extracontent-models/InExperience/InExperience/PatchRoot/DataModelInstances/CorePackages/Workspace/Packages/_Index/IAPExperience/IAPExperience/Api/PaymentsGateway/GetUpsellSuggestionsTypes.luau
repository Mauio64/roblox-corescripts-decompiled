require(script.Parent.Parent.Parent.Enums.BadgeType)
require(script.Parent.Parent.Parent.Enums.VirtualItemBadgeType)

local experimentVariant = { PlusPromotion = "plusPromotion" }

return {
	ExperimentVariant = experimentVariant,
	normalizeExperimentVariant = function(p): nil | string
		if p == experimentVariant.PlusPromotion then
			return "plusPromotion"
		end

		return nil
	end
}
