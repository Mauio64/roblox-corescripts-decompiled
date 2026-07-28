local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local useSelector = require(SocialTabsPageParent.RoactUtils).Hooks.RoactRodux.useSelector
local convertUserPresenceTypeToString = require(SocialTabsPageParent.SocialCommon).Utils.convertUserPresenceTypeToString
local RoduxPresence = require(SocialTabsPage.Rodux.RoduxPresence)
local PresenceType = RoduxPresence.Enums.PresenceType

if require(SocialTabsPage.Flags.FFlagSocialTabsPagePresenceSignalsMigration) then
	return nil
end

return function(s1: string) -- line: 19
	-- upvalues: useSelector (copy), RoduxPresence (copy), PresenceType (copy), convertUserPresenceTypeToString (copy)
	local v8 = useSelector(function(p1) -- line: 20
		-- upvalues: s1 (copy), RoduxPresence (copy)
		if not s1 or s1 == "" then
			return nil
		end

		return RoduxPresence.Selectors.getUserPresenceByUserId(p1, s1)
	end)
	local v9 = if not v8 then PresenceType.Offline else v8.userPresenceType

	return (convertUserPresenceTypeToString(v9))
end
