local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local FriendsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/FriendsCommon")
local SocialExperienceJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SocialExperienceJoin")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")

local useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
local useJoinUserInExperience = SocialExperienceJoin.useJoinUserInExperience
local useCtaForRow = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useCtaForRow")
local useProfileCta = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useProfileCta")
local composeCtaRow = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Cta/composeCtaRow")
local FFlagUserListCanonicalCtaAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListCanonicalCtaAnalytics")
local fFlagUserListComposeRenderRowWithCta = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListComposeRenderRowWithCta
local fFlagUserListSurfaceExtensions = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListSurfaceExtensions
local fFlagUserListSurfacePresenceWins = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListSurfacePresenceWins

local function CtaRow(data)
	local id = data.entity.id
	local v5, v6 = useProfileCta(id)
	local v7 = useGetPresenceByUserId(id)
	local v8 = useJoinUserInExperience(id, { presence = v7 })

	local actionHandlers = data.actionHandlers

	local ctaConfig = data.ctaConfig

	local v10 = if FFlagUserListCanonicalCtaAnalytics then data.index else nil
	local v11 = useCtaForRow(v5, v6, actionHandlers, id, ctaConfig, v8, v10)

	if fFlagUserListSurfaceExtensions then
		return composeCtaRow(data, data.ctaConfig, v7, v11)
	end

	local ctaConfig2 = data.ctaConfig

	local v12 = ctaConfig2 ~= nil
		and ctaConfig2.showLoadingPlaceholder ~= false
		and ctaConfig2.primaryCtaMinWidth ~= nil
	local v13 = v11.isLoading
		and v12
		and ctaConfig2
		and {
			minWidth = ctaConfig2.primaryCtaMinWidth,
			maxWidth = ctaConfig2.primaryCtaMaxWidth
		}
		or nil

	local renderRow = data.renderRow

	if fFlagUserListComposeRenderRowWithCta and renderRow then
		local createRow = data.createRow
		return renderRow(function(p2)
			local clone = table.clone(p2)
			local v14 = if v7 then v7.userPresenceType else nil
			clone.presence = v14

			if fFlagUserListSurfacePresenceWins and p2.presence ~= nil then
				clone.presence = p2.presence
			end

			clone.primaryCta = v11.primaryCta
			clone.secondaryCta = v11.secondaryCta
			clone.ctaLoading = v13
			return createRow(clone)
		end, data.entity, data.index or 0)
	end

	local createRow = data.createRow
	local v15 = if v7 then v7.userPresenceType else nil
	return createRow({
		presence = v15,
		primaryCta = v11.primaryCta,
		secondaryCta = v11.secondaryCta,
		ctaLoading = v13
	})
end

return React.memo(CtaRow)
