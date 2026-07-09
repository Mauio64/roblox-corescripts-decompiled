local Parent = script:FindFirstAncestor("FriendsCommon").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)
local v5 = require(Parent.DataHydration).Presence.PresenceStore.get()

local function useGetPresenceByUserId(s1: string?) -- line: 12
	-- upvalues: React (copy), Signals (copy), v5 (copy), SignalsReact (copy)
	local v8 = not s1 and "" or tostring(s1)
	local v9 = React.useMemo(function() -- line: 15
		-- upvalues: Signals (copy), v8 (copy), v5 (copy)
		return Signals.createComputed(function(p1) -- line: 16
			-- upvalues: v8 (copy), v5 (copy)
			if v8 == "" then
				return nil
			end

			return v5.GetPresenceByUserId(v8).data(p1)
		end)
	end, { v8 })

	return SignalsReact.useSignalState(v9)
end

return useGetPresenceByUserId
