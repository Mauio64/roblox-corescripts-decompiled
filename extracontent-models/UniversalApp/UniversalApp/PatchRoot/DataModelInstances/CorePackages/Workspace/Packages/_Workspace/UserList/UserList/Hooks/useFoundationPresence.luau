local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)
local useSelector = require(UserListParent.RoactUtils).Hooks.RoactRodux.useSelector
local RoduxPresence = require(UserList.Rodux.RoduxPresence)
local SocialCommon = require(UserListParent.SocialCommon)
local convertUserPresenceTypeToString = SocialCommon.Utils.convertUserPresenceTypeToString
local convertToFoundationPresenceEnum = SocialCommon.Utils.convertToFoundationPresenceEnum
local Foundation = require(UserListParent.Foundation)

require(UserList.Common.Types)

local PresenceType = RoduxPresence.Enums.PresenceType

local function useFoundationPresence(s1: string) -- line: 17
	-- upvalues: React (copy), Foundation (copy), useSelector (copy), RoduxPresence (copy), PresenceType (copy), convertUserPresenceTypeToString (copy), convertToFoundationPresenceEnum (copy)
	local v13, v14 = React.useState(Foundation.Enums.UserPresence.None)
	local v15 = useSelector(function(p1) -- line: 20
		-- upvalues: s1 (copy), RoduxPresence (copy)
		if not s1 or s1 == "" then
			return nil
		end

		return RoduxPresence.Selectors.getUserPresenceByUserId(p1, s1)
	end)

	React.useEffect(function() -- line: 27
		-- upvalues: PresenceType (copy), v15 (copy), convertUserPresenceTypeToString (copy), convertToFoundationPresenceEnum (copy), v14 (copy)
		local Offline = PresenceType.Offline

		if v15 then
			Offline = v15.userPresenceType
		end

		local v18 = convertUserPresenceTypeToString(Offline)
		local v19 = convertToFoundationPresenceEnum(v18)

		v14(v19)
	end, { v15 })

	return v13
end

return useFoundationPresence
