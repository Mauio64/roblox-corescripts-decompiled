local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Localization").Hooks.useLocalization
local useEarlyIsFocused = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Navigation").useEarlyIsFocused

local axTooltip = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceUIKit").AXTooltipComponents.AXTooltip

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags")
local fFlagAXMarketplaceLicensingItemDetails = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemDetails
local fFlagAXMarketplaceLicensingItemCards = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemCards

local itemLicenseType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceModel").Enums.ItemLicenseType

local badgeVariant = Foundation.Enums.BadgeVariant
local badgeSize = Foundation.Enums.BadgeSize
local badgeShape = Foundation.Enums.BadgeShape

local v5 = {
	[itemLicenseType.FirstParty] = {
		label = "Feature.Catalog.Label.LicensingOfficial",
		info = "Feature.Catalog.Label.LicensingOfficialInfo",
		passiveVariant = badgeVariant.Contrast
	},
	[itemLicenseType.ThirdParty] = {
		label = "Feature.Catalog.Label.LicensingLicensed",
		info = "Feature.Catalog.Label.LicensingLicensedInfo",
		passiveVariant = badgeVariant.OverMedia
	}
}

local function PassiveLicensingBadge(props)
	local v6 = useLocalization({ label = props.config.label })

	return React.createElement(Foundation.Badge, {
		text = v6.label,
		variant = props.config.passiveVariant,
		size = props.passiveSize or badgeSize.Small,
		LayoutOrder = props.LayoutOrder,
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
		testId = "LicensingBadge"
	})
end

local function InteractiveLicensingBadge(props)
	local v6 = useTokens()
	local state, setState = React.useState(false)

	local v7 = useLocalization({ label = props.config.label, info = props.config.info })

	local v8 = React.useCallback(function()
		setState(function(p2): boolean
			return not p2
		end)
	end, {})

	local v9 = React.useCallback(function()
		setState(false)
	end, {})

	React.useImperativeHandle(props.dismissTooltipRef, function()
		return v9
	end, { v9 })

	if fFlagAXMarketplaceLicensingItemDetails then
		local v10 = useEarlyIsFocused()

		React.useEffect(function()
			if not v10 then
				v9()
			end
		end, { v10, v9 })
	end

	return React.createElement(Foundation.View, {
		tag = "auto-xy",
		LayoutOrder = props.LayoutOrder,
		onActivated = v8,
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
		testId = "LicensingBadge"
	}, {
		Badge = React.createElement(Foundation.Badge, {
			text = v7.label,
			variant = badgeVariant.Standard,
			size = badgeSize.Small,
			shape = badgeShape.Box
		}),
		Tooltip = React.createElement(axTooltip, {
			isOpen = state,
			popoverSide = props.popoverSide or "Bottom",
			tooltipText = v7.info,
			maxWidth = v6.Size.Size_1200 * 3,
			onTooltipActivated = v9
		})
	})
end

local function LicensingBadge(p2)
	local clone = table.clone(p2)
	clone.config = v5[p2.itemLicensingInfo.licenseType]

	if fFlagAXMarketplaceLicensingItemCards and p2.isInteractive == false then
		return (React.createElement(PassiveLicensingBadge, clone))
	end

	return (React.createElement(InteractiveLicensingBadge, clone))
end

return React.memo(LicensingBadge)
