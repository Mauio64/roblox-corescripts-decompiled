local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed

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

local v = { partnerContent = "Feature.Moments.Label.RobloxPartnerContent" }

local function noop() end

local function StatusChip(p)
	local v2 = useLocalization(v)
	local data = MomentContext.useMoment().store.getData(false)

	if data.kind == "ad" then
		return React.createElement(View, {
			LayoutOrder = p.LayoutOrder,
			tag = "row align-x-left auto-xy"
		}, {
			Chip = React.createElement(Chip, {
				text = "Ad",
				size = ChipSize.Small,
				variant = ChipVariant.Standard,
				trailing = { iconName = BuilderIcons.Icon.CircleI, onActivated = noop },
				onActivated = noop
			})
		})
	end

	if data.kind == "experience" and data.isOfficialContent then
		return nil
	end

	local v3

	if FFlagMomentsRenderAvatarPostsInFeed then
		v3 = data.kind == "experience" and data.isSponsored
	else
		v3 = data.isSponsored == true
	end

	if not v3 then
		return nil
	end

	local partnerContent = v2.partnerContent
	local text = (partnerContent == nil or partnerContent == "") and "Roblox Partner Content" or partnerContent
	return React.createElement(View, {
		LayoutOrder = p.LayoutOrder,
		tag = "row align-x-left auto-xy"
	}, {
		Badge = React.createElement(Badge, {
			text = text,
			variant = BadgeVariant.Neutral,
			size = BadgeSize.Small,
			shape = BadgeShape.Box
		})
	})
end

return React.memo(StatusChip)
