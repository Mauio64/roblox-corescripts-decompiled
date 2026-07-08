local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local React = require(SocialTabsPageParent.React)
local useJoinUserInExperience = require(SocialTabsPageParent.SocialExperienceJoin).useJoinUserInExperience
local useSelector = require(SocialTabsPageParent.RoactUtils).Hooks.RoactRodux.useSelector
local convertUserPresenceTypeToString = require(SocialTabsPageParent.SocialCommon).Utils.convertUserPresenceTypeToString

require(SocialTabsPageParent.DataHydration)

local useCTAForRow = require(SocialTabsPage.Hooks.useCTAForRow)
local RoduxPresence = require(SocialTabsPage.Rodux.RoduxPresence)

require(SocialTabsPage.Common.Types)

local t1 = {
	lastLocation = "",
	userPresenceType = RoduxPresence.Enums.PresenceType.Offline
}

local function RowDataProvider(t2: {[any]: any}) -- line: 35
	-- upvalues: useSelector (copy), RoduxPresence (copy), t1 (copy), convertUserPresenceTypeToString (copy), useJoinUserInExperience (copy), useCTAForRow (copy)
	local v12 = useSelector(function(p1) -- line: 36
		-- upvalues: RoduxPresence (copy), t2 (copy), t1 (copy)
		return RoduxPresence.Selectors.getUserPresenceByUserId(p1, t2.entity.id) or t1
	end)
	local v13 = convertUserPresenceTypeToString(v12.userPresenceType)
	local v14 = useJoinUserInExperience(t2.entity.id, {
		presence = v12
	})
	local v15 = useCTAForRow(t2.ctaResult, t2.actionHandlers, t2.entity.id, v14)

	return t2.createRow({
		presence = v13,
		primaryCta = v15
	})
end

return React.memo(RowDataProvider)
