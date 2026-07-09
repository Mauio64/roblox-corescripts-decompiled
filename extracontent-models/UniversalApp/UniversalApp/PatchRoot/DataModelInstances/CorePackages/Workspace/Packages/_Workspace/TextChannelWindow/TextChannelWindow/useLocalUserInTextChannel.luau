local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local useEventConnection = require(ParentParent.ReactUtils).useEventConnection
local isLocalUserInTextChannel = require(script.Parent.isLocalUserInTextChannel)

local function useLocalUserInTextChannel(p1, s1: string) -- line: 12
	-- upvalues: React (copy), isLocalUserInTextChannel (copy), useEventConnection (copy)
	local v8, v9 = React.useState(function() -- line: 13
		-- upvalues: isLocalUserInTextChannel (copy), p1 (copy), s1 (copy)
		return isLocalUserInTextChannel(p1, s1)
	end)

	React.useEffect(function() -- line: 18
		-- upvalues: v9 (copy), isLocalUserInTextChannel (copy), p1 (copy), s1 (copy)
		v9(isLocalUserInTextChannel(p1, s1))
	end, {
		p1,
		s1
	})

	local function onMembershipChanged() -- line: 22
		-- upvalues: v9 (copy), isLocalUserInTextChannel (copy), p1 (copy), s1 (copy)
		v9(isLocalUserInTextChannel(p1, s1))
	end

	useEventConnection(if not p1 then nil else p1.ChildAdded, onMembershipChanged, {
		p1,
		s1
	})
	useEventConnection(if not p1 then nil else p1.ChildRemoved, onMembershipChanged, {
		p1,
		s1
	})

	return v8
end

return useLocalUserInTextChannel
