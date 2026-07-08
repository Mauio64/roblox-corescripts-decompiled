local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local useIdFallback = require(script.Parent.utils).useIdFallback
local PresenceContext = require(script.Parent.PresenceContext)

local function newChildrenMap() -- line: 36
	return {}
end
local function PresenceChild(t1: {[any]: any}) -- line: 40
	-- upvalues: React (copy), useIdFallback (copy), PresenceContext (copy)
	if not t1.children or typeof(t1.children) == "string" then
		error("PresenceChild: children must be a React.Element")
	end

	if not t1.children.type then
		error("PresenceChild: children must be a React.Element")
	end

	if t1.onExitComplete and typeof(t1.onExitComplete) ~= "function" and not t1.onExitComplete._isMockFunction then
		error("PresenceChild: onExitComplete must be a function")
	end

	local children = t1.children
	local isPresent = t1.isPresent
	local onExitComplete = t1.onExitComplete
	local passThroughData = t1.passThroughData
	local presenceId = t1.presenceId
	local current = React.useRef({}).current
	local v14 = presenceId or useIdFallback()

	local function handleExitComplete(s1: string) -- line: 76
		-- upvalues: current (copy), onExitComplete (copy)
		current[s1] = true

		local v21 = true

		for _, v in pairs(current) do
			if not v then
				v21 = false

				break
			end
		end

		if v21 and onExitComplete then
			onExitComplete()
		end
	end

	local v16 = isPresent ~= false
	local t2 = {
		id = v14,
		isPresent = v16,
		passThroughData = passThroughData,
		onExitComplete = handleExitComplete
	}

	if isPresent ~= nil then
		for k, _ in pairs(current) do
			current[k] = false
		end
	end

	return React.createElement(PresenceContext.Provider, {
		value = t2
	}, children)
end

return PresenceChild
