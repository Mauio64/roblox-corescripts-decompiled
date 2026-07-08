local Parent = script:FindFirstAncestor("Moments").Parent
local React = require(Parent.React)
local BuilderIcons = require(Parent.BuilderIcons)
local Foundation = require(Parent.Foundation)
local Localization = require(Parent.Localization)
local Badge = Foundation.Badge
local Chip = Foundation.Chip
local View = Foundation.View
local BadgeShape = Foundation.Enums.BadgeShape
local BadgeSize = Foundation.Enums.BadgeSize
local BadgeVariant = Foundation.Enums.BadgeVariant
local ChipSize = Foundation.Enums.ChipSize
local ChipVariant = Foundation.Enums.ChipVariant
local useLocalization = Localization.Hooks.useLocalization
local MomentContext = require(script.Parent.Parent.Parent.MomentContext)
local t1 = {
	partnerContent = "Feature.Moments.Label.RobloxPartnerContent"
}

local function noop() -- line: 45
end
local function StatusChip(t2: {[any]: any}) -- line: 51
	-- upvalues: useLocalization (copy), t1 (copy), MomentContext (copy), React (copy), View (copy), Chip (copy), ChipSize (copy), ChipVariant (copy), BuilderIcons (copy), noop (copy), Badge (copy), BadgeVariant (copy), BadgeSize (copy), BadgeShape (copy)
	local v20 = useLocalization(t1)
	local v21 = MomentContext.useMoment().store.getData(false)

	if v21.kind == "ad" then
		return React.createElement(View, {
			tag = "row align-x-left auto-xy",
			LayoutOrder = t2.LayoutOrder
		}, {
			Chip = React.createElement(Chip, {
				text = "Ad",
				size = ChipSize.Small,
				variant = ChipVariant.Standard,
				trailing = {
					iconName = BuilderIcons.Icon.CircleI,
					onActivated = noop
				},
				onActivated = noop
			})
		})
	end

	if v21.isSponsored then
		local partnerContent = v20.partnerContent
		local v23 = (partnerContent == nil or partnerContent == "") and "Roblox Partner Content" or partnerContent

		return React.createElement(View, {
			tag = "row align-x-left auto-xy",
			LayoutOrder = t2.LayoutOrder
		}, {
			Badge = React.createElement(Badge, {
				text = v23,
				variant = BadgeVariant.Neutral,
				size = BadgeSize.Small,
				shape = BadgeShape.Box
			})
		})
	end

	return nil
end

return React.memo(StatusChip)
