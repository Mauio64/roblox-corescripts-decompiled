local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Navigation = require(parent.Navigation)
local useEarlyIsFocused = Navigation.useEarlyIsFocused

local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local AXTooltip = AvatarExperienceUIKit.AXTooltipComponents.AXTooltip

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMarketplaceLicensingItemDetails = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemDetails
local FFlagAXMarketplaceLicensingItemCards = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemCards

local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local ItemLicenseType = AvatarExperienceModel.Enums.ItemLicenseType

local BadgeVariant = Foundation.Enums.BadgeVariant
local BadgeSize = Foundation.Enums.BadgeSize
local BadgeShape = Foundation.Enums.BadgeShape

local v = {
	[ItemLicenseType.FirstParty] = {
		label = "Feature.Catalog.Label.LicensingOfficial",
		info = "Feature.Catalog.Label.LicensingOfficialInfo",
		passiveVariant = BadgeVariant.Contrast
	},
	[ItemLicenseType.ThirdParty] = {
		label = "Feature.Catalog.Label.LicensingLicensed",
		info = "Feature.Catalog.Label.LicensingLicensedInfo",
		passiveVariant = BadgeVariant.OverMedia
	}
}

local function PassiveLicensingBadge(props)
	local v2 = useLocalization({ label = props.config.label })

	return React.createElement(Foundation.Badge, {
		text = v2.label,
		variant = props.config.passiveVariant,
		size = props.passiveSize or BadgeSize.Small,
		LayoutOrder = props.LayoutOrder,
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
		testId = "LicensingBadge"
	})
end

local function InteractiveLicensingBadge(props)
	local v2 = useTokens()
	local state, setState = React.useState(false)

	local v3 = useLocalization({ label = props.config.label, info = props.config.info })

	local onActivated = React.useCallback(function()
		setState(function(p): boolean
			return not p
		end)
	end, {})

	local onTooltipActivated = React.useCallback(function()
		setState(false)
	end, {})

	React.useImperativeHandle(props.dismissTooltipRef, function()
		return onTooltipActivated
	end, { onTooltipActivated })

	if FFlagAXMarketplaceLicensingItemDetails then
		local v4 = useEarlyIsFocused()

		React.useEffect(function()
			if not v4 then
				onTooltipActivated()
			end
		end, { v4, onTooltipActivated })
	end

	return React.createElement(Foundation.View, {
		tag = "auto-xy",
		LayoutOrder = props.LayoutOrder,
		onActivated = onActivated,
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
		testId = "LicensingBadge"
	}, {
		Badge = React.createElement(Foundation.Badge, {
			text = v3.label,
			variant = BadgeVariant.Standard,
			size = BadgeSize.Small,
			shape = BadgeShape.Box
		}),
		Tooltip = React.createElement(AXTooltip, {
			isOpen = state,
			popoverSide = props.popoverSide or "Bottom",
			tooltipText = v3.info,
			maxWidth = v2.Size.Size_1200 * 3,
			onTooltipActivated = onTooltipActivated
		})
	})
end

local function LicensingBadge(p)
	local clone = table.clone(p)
	clone.config = v[p.itemLicensingInfo.licenseType]

	if FFlagAXMarketplaceLicensingItemCards and p.isInteractive == false then
		return (React.createElement(PassiveLicensingBadge, clone))
	end

	return (React.createElement(InteractiveLicensingBadge, clone))
end

return React.memo(LicensingBadge)
