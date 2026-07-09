local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local useSelector = require(SocialTabsPageParent.RoactUtils).Hooks.RoactRodux.useSelector
local convertUserPresenceTypeToString = require(SocialTabsPageParent.SocialCommon).Utils.convertUserPresenceTypeToString
local RoduxPresence = require(SocialTabsPage.Rodux.RoduxPresence)
local PresenceType = RoduxPresence.Enums.PresenceType

local function useUserPresence(s1: string) -- line: 14
	-- upvalues: useSelector (copy), RoduxPresence (copy), PresenceType (copy), convertUserPresenceTypeToString (copy)
	local v9 = useSelector(function(p1) -- line: 15
		-- upvalues: s1 (copy), RoduxPresence (copy)
		if not s1 or s1 == "" then
			return nil
		end

		return RoduxPresence.Selectors.getUserPresenceByUserId(p1, s1)
	end)
	local v10 = if not v9 then PresenceType.Offline else v9.userPresenceType

	return (convertUserPresenceTypeToString(v10))
end

return useUserPresence
