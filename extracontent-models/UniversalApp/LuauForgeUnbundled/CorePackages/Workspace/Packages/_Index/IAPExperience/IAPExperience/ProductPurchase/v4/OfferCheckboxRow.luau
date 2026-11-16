local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local view = Foundation.View
local checkbox = Foundation.Checkbox
local badge = Foundation.Badge
local badgeVariant = Foundation.Enums.BadgeVariant
local badgeShape = Foundation.Enums.BadgeShape
local iconVariant = Foundation.Enums.IconVariant
local iconPosition = Foundation.Enums.IconPosition
local useTokens = Foundation.Hooks.useTokens

local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/BuilderIcons")

local useRemainingTimeText = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/InExperienceOffers").Hooks.useRemainingTimeText

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization").Hooks.useLocalization

local fFlagEnableInExperienceOfferExpiryBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagEnableInExperienceOfferExpiryBadge
local defineFastFlag = game:DefineFastFlag("UpdateOfferExpiryBadgeBoxShape", false)

local function OfferCheckboxRow(props)
	local v5 = useTokens()
	local v6 = useRemainingTimeText(props.expirationTimeUtc)

	local v7 = useLocalization({
		endTime = {
			"Feature.InExperienceShop.Label.EndTime",
			timeRemaining = v6 or ""
		}
	})

	local layoutOrder = props.LayoutOrder or 0

	local createElement = React.createElement
	local v9 = {
		tag = "row wrap align-x-left items-center gap-small size-full-0 auto-y",
		LayoutOrder = props.LayoutOrder,
		padding = {
			right = UDim.new(0, v5.Size.Size_400 + v5.Gap.Medium)
		}
	}
	local v10 = {
		Checkbox = React.createElement(checkbox, {
			LayoutOrder = layoutOrder,
			size = Foundation.Enums.InputSize.XSmall,
			label = props.label,
			isChecked = props.isChecked,
			isDisabled = props.isDisabled,
			onActivated = props.onActivated
		}),
		ExpiryBadge = 0
	}
	local v11

	if fFlagEnableInExperienceOfferExpiryBadge and v6 ~= nil then
		local createElement2 = React.createElement
		local v13 = {
			LayoutOrder = layoutOrder + 1,
			icon = {
				name = BuilderIcons.Icon.Clock,
				variant = iconVariant.Filled,
				position = iconPosition.Left
			},
			text = v7.endTime,
			variant = badgeVariant.Standard,
			shape = 0
		}
		local v14 = if defineFastFlag then badgeShape.Box else nil
		v13.shape = v14
		v11 = createElement2(badge, v13)
	end

	v10.ExpiryBadge = v11
	return createElement(view, v9, v10)
end

return OfferCheckboxRow
