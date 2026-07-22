local Parent = script:FindFirstAncestor("FriendsCommon").Parent
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local v4 = require(Parent.DataHydration).Presence.PresenceStore.get()
local t1 = {
	skipFetch = true
}

local function useGetPresenceByUserId(s1: string?, p1) -- line: 16
	-- upvalues: React (copy), t1 (copy), v4 (copy), SignalsReact (copy)
	local v9 = not s1 and "" or tostring(s1)
	local v10 = React.useMemo(function() -- line: 22
		-- upvalues: v9 (copy), t1 (copy), p1 (copy), v4 (copy)
		local v11 = if v9 ~= "" then p1 else t1

		return v4.GetPresenceByUserId(v9, v11)
	end, {
		v9,
		p1
	})

	return SignalsReact.useSignalState(v10.data), (SignalsReact.useSignalState(v10.status))
end

return useGetPresenceByUserId
