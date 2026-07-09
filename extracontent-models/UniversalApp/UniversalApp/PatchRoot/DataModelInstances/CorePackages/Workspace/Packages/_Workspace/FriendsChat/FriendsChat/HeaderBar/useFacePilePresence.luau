local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)
local Foundation = require(Parent.Foundation)
local DataHydration = require(Parent.DataHydration)
local UserPresence = Foundation.Enums.UserPresence
local PresenceType = DataHydration.Presence.PresenceEnums.PresenceType
local v9 = DataHydration.Presence.PresenceStore.get()

local function toUserPresence(p1) -- line: 26
	-- upvalues: PresenceType (copy), UserPresence (copy)
	if p1 == PresenceType.InGame then
		return UserPresence.InExperience
	end

	if p1 == PresenceType.InStudio or p1 == PresenceType.Online then
		return UserPresence.Active
	end

	return UserPresence.None
end
local function useFacePilePresence(t1: {[any]: any}) -- line: 38
	-- upvalues: React (copy), Signals (copy), UserPresence (copy), v9 (copy), PresenceType (copy), SignalsReact (copy)
	local v14 = t1[1]
	local v15 = v14 == nil and "" or tostring(v14)
	local v16 = React.useMemo(function() -- line: 48
		-- upvalues: Signals (copy), v14 (copy), UserPresence (copy), v9 (copy), PresenceType (copy)
		return Signals.createComputed(function(p2) -- line: 49
			-- upvalues: v14 (copy), UserPresence (copy), v9 (copy), PresenceType (copy)
			if v14 == nil then
				return UserPresence.None
			end

			local v18 = v9.GetPresenceByUserId((tostring(v14))).data(p2)
			local v19 = if not v18 then nil else v18.userPresenceType

			if v19 == PresenceType.InGame then
				return UserPresence.InExperience
			end

			if v19 == PresenceType.InStudio or v19 == PresenceType.Online then
				return UserPresence.Active
			end

			return UserPresence.None
		end)
	end, { v15 })

	return (SignalsReact.useSignalState(v16))
end

return useFacePilePresence
