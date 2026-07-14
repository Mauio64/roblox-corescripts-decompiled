local Parent = script:FindFirstAncestor("FriendsCommon").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)
local v5 = require(Parent.DataHydration).Presence.PresenceStore.get()

local function useGetPresenceByUserId(s1: string?, p1) -- line: 13
	-- upvalues: React (copy), Signals (copy), v5 (copy), SignalsReact (copy)
	local v9 = not s1 and "" or tostring(s1)
	local v10 = React.useMemo(function() -- line: 16
		-- upvalues: Signals (copy), v9 (copy), v5 (copy), p1 (copy)
		return Signals.createComputed(function(p2) -- line: 17
			-- upvalues: v9 (copy), v5 (copy), p1 (copy)
			if v9 == "" then
				return nil
			end

			return v5.GetPresenceByUserId(v9, p1).data(p2)
		end)
	end, {
		v9,
		p1
	})

	return SignalsReact.useSignalState(v10)
end

return useGetPresenceByUserId
