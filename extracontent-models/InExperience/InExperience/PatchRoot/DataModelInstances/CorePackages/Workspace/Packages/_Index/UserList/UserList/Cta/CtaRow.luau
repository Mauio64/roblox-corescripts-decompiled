local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
local FriendsCommon = require(parent.FriendsCommon)
local SocialExperienceJoin = require(parent.SocialExperienceJoin)
require(UserList.Common.Types)

local useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
local useJoinUserInExperience = SocialExperienceJoin.useJoinUserInExperience
local useCtaForRow = require(UserList.Hooks.useCtaForRow)
local useProfileCta = require(UserList.Hooks.useProfileCta)
local composeCtaRow = require(script.Parent.composeCtaRow)
local FFlagUserListCanonicalCtaAnalytics = require(UserList.Flags.FFlagUserListCanonicalCtaAnalytics)
local SharedFlags = require(parent.SharedFlags)
local FFlagUserListSurfaceExtensions = SharedFlags.FFlagUserListSurfaceExtensions
local SharedFlags2 = require(parent.SharedFlags)
local FFlagUserListSurfacePresenceWins = SharedFlags2.FFlagUserListSurfacePresenceWins

local function CtaRow(data)
	local id = data.entity.id
	local v, v2 = useProfileCta(id)
	local presence = useGetPresenceByUserId(id)
	local v3 = useJoinUserInExperience(id, { presence = presence })

	local actionHandlers = data.actionHandlers

	local ctaConfig = data.ctaConfig
	local v4

	if FFlagUserListCanonicalCtaAnalytics then
		v4 = data.index
	end

	local v5 = useCtaForRow(v, v2, actionHandlers, id, ctaConfig, v3, v4)

	if FFlagUserListSurfaceExtensions then
		return composeCtaRow(data, data.ctaConfig, presence, v5)
	end

	local ctaConfig2 = data.ctaConfig

	local v6 = ctaConfig2 ~= nil and ctaConfig2.showLoadingPlaceholder ~= false and ctaConfig2.primaryCtaMinWidth ~= nil
	local ctaLoading = v5.isLoading
		and v6
		and ctaConfig2
		and { minWidth = ctaConfig2.primaryCtaMinWidth, maxWidth = ctaConfig2.primaryCtaMaxWidth }
		or nil

	local renderRow = data.renderRow

	if renderRow then
		local createRow = data.createRow
		return renderRow(function(p)
			local clone = table.clone(p)
			local presence2

			if presence then
				presence2 = presence.userPresenceType
			end

			clone.presence = presence2

			if FFlagUserListSurfacePresenceWins and p.presence ~= nil then
				clone.presence = p.presence
			end

			clone.primaryCta = v5.primaryCta
			clone.secondaryCta = v5.secondaryCta
			clone.ctaLoading = ctaLoading
			return createRow(clone)
		end, data.entity, data.index or 0)
	end

	local createRow = data.createRow
	local presence2

	if presence then
		presence2 = presence.userPresenceType
	end

	return createRow({
		presence = presence2,
		primaryCta = v5.primaryCta,
		secondaryCta = v5.secondaryCta,
		ctaLoading = ctaLoading
	})
end

return React.memo(CtaRow)
