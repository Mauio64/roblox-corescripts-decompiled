local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
local FriendsCommon = require(parent.FriendsCommon)
local DataHydration = require(parent.DataHydration)
local Enums = require(UserList.Common.Enums)
require(UserList.Common.Types)

local useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
local InGame = DataHydration.Presence.PresenceEnums.PresenceType.InGame
local useCtaForRow = require(UserList.Hooks.useCtaForRow)
local useProfileCta = require(UserList.Hooks.useProfileCta)
local composeCtaRow = require(script.Parent.composeCtaRow)
local FFlagUserListCanonicalCtaAnalytics = require(UserList.Flags.FFlagUserListCanonicalCtaAnalytics)

local function SurfaceJoinCtaRow(data)
	local id = data.entity.id
	local ctaConfig = data.ctaConfig
	local join = ctaConfig.join
	local v, v2 = useProfileCta(id)
	local v3 = useGetPresenceByUserId(id)
	local universeId

	if v3 then
		universeId = v3.universeId
	end

	local isInExperience

	if v3 == nil or v3.userPresenceType ~= InGame or universeId == nil then
		isInExperience = false
	else
		isInExperience = universeId ~= ""
	end

	local onActivated = join.onActivated
	local v4 = React.useMemo(function()
		return {
			joinExperience = function()
				onActivated(id)
			end,
			isInExperience = isInExperience,
			isLoading = false
		}
	end, { id, isInExperience, onActivated })

	local actionHandlers = data.actionHandlers
	local v5

	if FFlagUserListCanonicalCtaAnalytics then
		v5 = data.index
	end

	local v6 = useCtaForRow(v, v2, actionHandlers, id, ctaConfig, v4, v5)

	local primaryCta = v6.primaryCta

	if primaryCta and primaryCta.type == Enums.ButtonTypes.Join and join.isVisible and not join.isVisible(v3) then
		primaryCta = nil
	end

	local isLoading = v6.isLoading

	if isLoading and join.isJoinExpected and not join.isJoinExpected(id, v3) then
		isLoading = false
	end

	return composeCtaRow(data, ctaConfig, v3, {
		primaryCta = primaryCta,
		secondaryCta = v6.secondaryCta,
		isLoading = isLoading
	})
end

return React.memo(SurfaceJoinCtaRow)
