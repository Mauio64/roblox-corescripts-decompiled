local parent = script.Parent.Parent.Parent
local React = require(parent.React)
local PresenceContext = require(script.Parent.PresenceContext)
local PresenceUtils = require(script.Parent.PresenceUtils)
local isPresent = PresenceUtils.isPresent

local function usePresence()
	local v = React.useContext(PresenceContext)

	local id = v.id
	local _isPresent = v.isPresent
	local onExitComplete = v.onExitComplete
	local passThroughData = v.passThroughData

	local onExitComplete2 = React.useCallback(function()
		if onExitComplete then
			onExitComplete(id)
		end
	end, { onExitComplete, id })

	return {
		isPresent = isPresent(v),
		id = id,
		onExitComplete = onExitComplete2,
		passThroughData = passThroughData
	}
end

return usePresence
