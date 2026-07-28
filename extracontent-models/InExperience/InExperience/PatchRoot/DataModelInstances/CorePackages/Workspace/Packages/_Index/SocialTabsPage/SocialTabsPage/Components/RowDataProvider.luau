local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local React = require(SocialTabsPageParent.React)
local useJoinUserInExperience = require(SocialTabsPageParent.SocialExperienceJoin).useJoinUserInExperience
local useSelector = require(SocialTabsPageParent.RoactUtils).Hooks.RoactRodux.useSelector
local convertUserPresenceTypeToString = require(SocialTabsPageParent.SocialCommon).Utils.convertUserPresenceTypeToString
local DataHydration = require(SocialTabsPageParent.DataHydration)
local useCTAForRow = require(SocialTabsPage.Hooks.useCTAForRow)
local RoduxPresence = require(SocialTabsPage.Rodux.RoduxPresence)

require(SocialTabsPage.Common.Types)

local FFlagSocialTabsPagePresenceSignalsMigration = require(SocialTabsPage.Flags.FFlagSocialTabsPagePresenceSignalsMigration)
local v11 = if not FFlagSocialTabsPagePresenceSignalsMigration then nil else require(SocialTabsPageParent.FriendsCommon).Hooks.useGetPresenceByUserId
local t1 = {
	lastLocation = "",
	userPresenceType = RoduxPresence.Enums.PresenceType.Offline
}
local v13 = if not FFlagSocialTabsPagePresenceSignalsMigration then nil else {
	lastLocation = "",
	userPresenceType = DataHydration.Presence.PresenceEnums.PresenceType.Offline
}

local function RowDataProvider(t2: {[any]: any}) -- line: 49
	-- upvalues: FFlagSocialTabsPagePresenceSignalsMigration (copy), v11 (copy), v13 (copy), useSelector (copy), RoduxPresence (copy), t1 (copy), convertUserPresenceTypeToString (copy), useJoinUserInExperience (copy), useCTAForRow (copy)
	local v16 = if not FFlagSocialTabsPagePresenceSignalsMigration then useSelector(function(p1) -- line: 55
		-- upvalues: RoduxPresence (copy), t2 (copy), t1 (copy)
		return RoduxPresence.Selectors.getUserPresenceByUserId(p1, t2.entity.id) or t1
	end) else v11(t2.entity.id) or v13
	local v17 = if not FFlagSocialTabsPagePresenceSignalsMigration then convertUserPresenceTypeToString(v16.userPresenceType) else v16.userPresenceType
	local v18 = useJoinUserInExperience(t2.entity.id, {
		presence = v16
	})
	local v19 = useCTAForRow(t2.ctaResult, t2.actionHandlers, t2.entity.id, v18)

	return t2.createRow({
		presence = v17,
		primaryCta = v19
	})
end

return React.memo(RowDataProvider)
