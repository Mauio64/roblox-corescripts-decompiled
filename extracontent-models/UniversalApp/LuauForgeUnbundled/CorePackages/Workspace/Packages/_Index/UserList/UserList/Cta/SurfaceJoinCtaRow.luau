local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local FriendsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/FriendsCommon")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/DataHydration")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")

local useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
local inGame = DataHydration.Presence.PresenceEnums.PresenceType.InGame
local useCtaForRow = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useCtaForRow")
local useProfileCta = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useProfileCta")
local composeCtaRow = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Cta/composeCtaRow")
local FFlagUserListCanonicalCtaAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListCanonicalCtaAnalytics")

local function SurfaceJoinCtaRow(data)
	local id = data.entity.id
	local ctaConfig = data.ctaConfig
	local join = ctaConfig.join
	local v5, v6 = useProfileCta(id)
	local v7 = useGetPresenceByUserId(id)

	local universeId = if v7 then v7.universeId else nil

	local v8 = not (v7 == nil or v7.userPresenceType ~= inGame or universeId == nil) and universeId ~= ""

	local onActivated = join.onActivated
	local v9 = React.useMemo(function()
		return {
			joinExperience = function()
				onActivated(id)
			end,
			isInExperience = v8,
			isLoading = false
		}
	end, { id, v8, onActivated })

	local actionHandlers = data.actionHandlers

	local v11 = if FFlagUserListCanonicalCtaAnalytics then data.index else nil
	local v12 = useCtaForRow(v5, v6, actionHandlers, id, ctaConfig, v9, v11)

	local primaryCta = v12.primaryCta

	if
		primaryCta
		and primaryCta.type == Enums.ButtonTypes.Join
		and join.isVisible
		and not join.isVisible(v7)
	then
		primaryCta = nil
	end

	local v13 = v12.isLoading

	if v13 and join.isJoinExpected and not join.isJoinExpected(id, v7) then
		v13 = false
	end

	return composeCtaRow(data, ctaConfig, v7, {
		primaryCta = primaryCta,
		secondaryCta = v12.secondaryCta,
		isLoading = v13
	})
end

return React.memo(SurfaceJoinCtaRow)
