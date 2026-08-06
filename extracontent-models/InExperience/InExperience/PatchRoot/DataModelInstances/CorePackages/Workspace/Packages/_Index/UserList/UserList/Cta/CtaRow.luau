local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)
local FriendsCommon = require(UserListParent.FriendsCommon)
local SocialExperienceJoin = require(UserListParent.SocialExperienceJoin)

require(UserList.Common.Types)

local useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
local useJoinUserInExperience = SocialExperienceJoin.useJoinUserInExperience
local useCtaForRow = require(UserList.Hooks.useCtaForRow)
local useProfileCta = require(UserList.Hooks.useProfileCta)

local function CtaRow(t1: {[any]: any}) -- line: 32
	-- upvalues: useProfileCta (copy), useGetPresenceByUserId (copy), useJoinUserInExperience (copy), useCtaForRow (copy)
	local id = t1.entity.id
	local v13, v14 = useProfileCta(id)
	local v15 = useGetPresenceByUserId(id)
	local v16 = useJoinUserInExperience(id, {
		presence = v15
	})
	local v17 = useCtaForRow(v13, v14, t1.actionHandlers, id, t1.ctaConfig, v16)
	local ctaConfig = t1.ctaConfig
	local v19 = ctaConfig ~= nil and (ctaConfig.showLoadingPlaceholder ~= false and ctaConfig.primaryCtaMinWidth ~= nil)
	local v20 = if not v17.isLoading or (not v19 or not ctaConfig) then nil else {
		minWidth = ctaConfig.primaryCtaMinWidth,
		maxWidth = ctaConfig.primaryCtaMaxWidth
	}

	return t1.createRow({
		presence = if not v15 then nil else v15.userPresenceType,
		primaryCta = v17.primaryCta,
		secondaryCta = v17.secondaryCta,
		ctaLoading = v20
	})
end

return React.memo(CtaRow)
