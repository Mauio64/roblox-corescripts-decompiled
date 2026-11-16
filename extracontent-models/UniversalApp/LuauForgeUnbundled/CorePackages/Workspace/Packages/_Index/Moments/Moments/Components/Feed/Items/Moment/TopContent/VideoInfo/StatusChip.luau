local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local fFlagMomentsRenderAvatarPostsInFeed = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsRenderAvatarPostsInFeed

local badge = Foundation.Badge
local chip = Foundation.Chip
local view = Foundation.View

local badgeShape = Foundation.Enums.BadgeShape
local badgeSize = Foundation.Enums.BadgeSize
local badgeVariant = Foundation.Enums.BadgeVariant
local chipSize = Foundation.Enums.ChipSize
local chipVariant = Foundation.Enums.ChipVariant

local useLocalization = Localization.Hooks.useLocalization

local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")

local v5 = { partnerContent = "Feature.Moments.Label.RobloxPartnerContent" }

local function noop() end

local function StatusChip(p2)
	local v6 = useLocalization(v5)
	local data = MomentContext.useMoment().store.getData(false)

	if data.kind == "ad" then
		return React.createElement(
			view,
			{ LayoutOrder = p2.LayoutOrder, tag = "row align-x-left auto-xy" },
			{
				Chip = React.createElement(chip, {
					text = "Ad",
					size = chipSize.Small,
					variant = chipVariant.Standard,
					trailing = { iconName = BuilderIcons.Icon.CircleI, onActivated = noop },
					onActivated = noop
				})
			}
		)
	end

	if data.kind == "experience" and data.isOfficialContent then
		return nil
	end

	local v7

	if fFlagMomentsRenderAvatarPostsInFeed then
		v7 = data.kind == "experience" and data.isSponsored
	else
		v7 = data.isSponsored == true
	end

	if not v7 then
		return nil
	end

	local partnerContent = v6.partnerContent
	local v8 = (partnerContent == nil or partnerContent == "") and "Roblox Partner Content"
		or partnerContent
	return React.createElement(view, {
		LayoutOrder = p2.LayoutOrder,
		tag = "row align-x-left auto-xy"
	}, {
		Badge = React.createElement(badge, {
			text = v8,
			variant = badgeVariant.Neutral,
			size = badgeSize.Small,
			shape = badgeShape.Box
		})
	})
end

return React.memo(StatusChip)
