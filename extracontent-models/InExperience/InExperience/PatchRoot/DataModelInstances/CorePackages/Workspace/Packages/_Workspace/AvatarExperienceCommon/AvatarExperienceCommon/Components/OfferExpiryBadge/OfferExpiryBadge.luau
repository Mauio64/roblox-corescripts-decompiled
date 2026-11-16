local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local BuilderIcons = require(parent.BuilderIcons)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useRemainingTimeText = require(AvatarExperienceCommon.Hooks.useRemainingTimeText)

local BadgeVariant = Foundation.Enums.BadgeVariant
local BadgeShape = Foundation.Enums.BadgeShape
local IconVariant = Foundation.Enums.IconVariant
local IconPosition = Foundation.Enums.IconPosition

local function OfferExpiryBadge(p)
	local v = useRemainingTimeText(p.expirationTimeInUTC)
	local v2 = useLocalization({
		endTime = {
			"Feature.InExperienceShop.Label.EndTime",
			timeRemaining = v or ""
		}
	})

	if v == nil then
		return nil
	end

	return (React.createElement(Foundation.Badge, {
		LayoutOrder = p.layoutOrder,
		icon = {
			name = BuilderIcons.Icon.Clock,
			variant = IconVariant.Filled,
			position = IconPosition.Left
		},
		text = v2.endTime,
		variant = BadgeVariant.Standard,
		shape = BadgeShape.Box
	}))
end

return OfferExpiryBadge
