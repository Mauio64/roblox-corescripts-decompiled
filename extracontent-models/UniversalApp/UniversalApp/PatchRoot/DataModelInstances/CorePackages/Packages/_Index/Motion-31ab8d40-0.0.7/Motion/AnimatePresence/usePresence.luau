local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local PresenceContext = require(script.Parent.PresenceContext)
local isPresent = require(script.Parent.PresenceUtils).isPresent

local function usePresence() -- line: 37
	-- upvalues: React (copy), PresenceContext (copy), isPresent (copy)
	local v6 = React.useContext(PresenceContext)
	local id = v6.id
	local _ = v6.isPresent
	local onExitComplete = v6.onExitComplete
	local passThroughData = v6.passThroughData
	local v11 = React.useCallback(function() -- line: 49
		-- upvalues: onExitComplete (copy), id (copy)
		if onExitComplete then
			onExitComplete(id)
		end
	end, {
		onExitComplete,
		id
	})

	return {
		isPresent = isPresent(v6),
		id = id,
		onExitComplete = v11,
		passThroughData = passThroughData
	}
end

return usePresence
