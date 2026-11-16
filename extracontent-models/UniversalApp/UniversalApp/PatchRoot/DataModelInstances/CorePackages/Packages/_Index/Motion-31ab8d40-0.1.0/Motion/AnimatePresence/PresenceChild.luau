local parent = script.Parent.Parent.Parent
local React = require(parent.React)
local utils = require(script.Parent.utils)
local useIdFallback = utils.useIdFallback

local PresenceContext = require(script.Parent.PresenceContext)

local function newChildrenMap()
	return {}
end

local function PresenceChild(props)
	if not props.children or typeof(props.children) == "string" then
		error("PresenceChild: children must be a React.Element")
	end

	if not props.children.type then
		error("PresenceChild: children must be a React.Element")
	end

	if
		props.onExitComplete
		and typeof(props.onExitComplete) ~= "function"
		and not props.onExitComplete._isMockFunction
	then
		error("PresenceChild: onExitComplete must be a function")
	end

	local children = props.children
	local isPresent = props.isPresent
	local onExitComplete = props.onExitComplete
	local passThroughData = props.passThroughData
	local presenceId = props.presenceId
	local current = React.useRef({}).current

	local function handleExitComplete(p: string)
		current[p] = true
		local v = true

		for _, v2 in pairs(current) do
			if not v2 then
				v = false
				break
			end
		end

		if v and onExitComplete then
			onExitComplete()
		end
	end

	local v = {
		id = presenceId or useIdFallback(),
		isPresent = isPresent ~= false,
		passThroughData = passThroughData,
		onExitComplete = handleExitComplete
	}

	if isPresent ~= nil then
		for k, _ in pairs(current) do
			current[k] = false
		end
	end

	return React.createElement(PresenceContext.Provider, { value = v }, children)
end

return PresenceChild
