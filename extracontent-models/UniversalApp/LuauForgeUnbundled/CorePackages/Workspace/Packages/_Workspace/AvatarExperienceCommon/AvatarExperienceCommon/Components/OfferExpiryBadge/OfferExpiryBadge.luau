local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")
local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/BuilderIcons")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Localization").Hooks.useLocalization

local useRemainingTimeText = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useRemainingTimeText")

local badgeVariant = Foundation.Enums.BadgeVariant
local badgeShape = Foundation.Enums.BadgeShape
local iconVariant = Foundation.Enums.IconVariant
local iconPosition = Foundation.Enums.IconPosition

local function OfferExpiryBadge(p2)
	local v5 = useRemainingTimeText(p2.expirationTimeInUTC)
	local v6 = useLocalization({
		endTime = {
			"Feature.InExperienceShop.Label.EndTime",
			timeRemaining = v5 or ""
		}
	})

	if v5 == nil then
		return nil
	end

	return (React.createElement(Foundation.Badge, {
		LayoutOrder = p2.layoutOrder,
		icon = {
			name = BuilderIcons.Icon.Clock,
			variant = iconVariant.Filled,
			position = iconPosition.Left
		},
		text = v6.endTime,
		variant = badgeVariant.Standard,
		shape = badgeShape.Box
	}))
end

return OfferExpiryBadge
