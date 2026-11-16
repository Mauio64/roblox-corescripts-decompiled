local parent = script:FindFirstAncestor("IAPExperience").Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Checkbox = Foundation.Checkbox
local Badge = Foundation.Badge
local BadgeVariant = Foundation.Enums.BadgeVariant
local BadgeShape = Foundation.Enums.BadgeShape
local IconVariant = Foundation.Enums.IconVariant
local IconPosition = Foundation.Enums.IconPosition
local useTokens = Foundation.Hooks.useTokens

local BuilderIcons = require(parent.BuilderIcons)

local InExperienceOffers = require(parent.InExperienceOffers)
local useRemainingTimeText = InExperienceOffers.Hooks.useRemainingTimeText

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableInExperienceOfferExpiryBadge = SharedFlags.FFlagEnableInExperienceOfferExpiryBadge
local defineFastFlag = game:DefineFastFlag("UpdateOfferExpiryBadgeBoxShape", false)

local function OfferCheckboxRow(props)
	local v = useTokens()
	local v2 = useRemainingTimeText(props.expirationTimeUtc)

	local v3 = useLocalization({
		endTime = {
			"Feature.InExperienceShop.Label.EndTime",
			timeRemaining = v2 or ""
		}
	})

	local layoutOrder = props.LayoutOrder or 0

	local createElement = React.createElement
	local v4 = {
		tag = "row wrap align-x-left items-center gap-small size-full-0 auto-y",
		LayoutOrder = props.LayoutOrder,
		padding = {
			right = UDim.new(0, v.Size.Size_400 + v.Gap.Medium)
		}
	}
	local v5 = {
		Checkbox = React.createElement(Checkbox, {
			LayoutOrder = layoutOrder,
			size = Foundation.Enums.InputSize.XSmall,
			label = props.label,
			isChecked = props.isChecked,
			isDisabled = props.isDisabled,
			onActivated = props.onActivated
		}),
		ExpiryBadge = 0
	}
	local expiryBadge

	if FFlagEnableInExperienceOfferExpiryBadge and v2 ~= nil then
		local createElement2 = React.createElement
		local v6 = {
			LayoutOrder = layoutOrder + 1,
			icon = {
				name = BuilderIcons.Icon.Clock,
				variant = IconVariant.Filled,
				position = IconPosition.Left
			},
			text = v3.endTime,
			variant = BadgeVariant.Standard,
			shape = 0
		}
		local shape

		if defineFastFlag then
			shape = BadgeShape.Box
		end

		v6.shape = shape
		expiryBadge = createElement2(Badge, v6)
	end

	v5.ExpiryBadge = expiryBadge
	return createElement(View, v4, v5)
end

return OfferCheckboxRow
