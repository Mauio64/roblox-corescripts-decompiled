local parent = script.Parent.Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local useEventConnection = ReactUtils.useEventConnection
local isLocalUserInTextChannel = require(script.Parent.isLocalUserInTextChannel)

local function useLocalUserInTextChannel(instance, p: string)
	local state, setState = React.useState(function()
		return isLocalUserInTextChannel(instance, p)
	end)

	React.useEffect(function()
		setState(isLocalUserInTextChannel(instance, p))
	end, { instance, p })

	local function onMembershipChanged()
		setState(isLocalUserInTextChannel(instance, p))
	end

	local v

	if instance then
		v = instance.ChildAdded
	end

	useEventConnection(v, onMembershipChanged, { instance, p })
	local v2

	if instance then
		v2 = instance.ChildRemoved
	end

	useEventConnection(v2, onMembershipChanged, { instance, p })

	return state
end

return useLocalUserInTextChannel
