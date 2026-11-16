local Motion = script:FindFirstAncestor("Motion")
local parent = Motion.Parent
local React = require(parent.React)
local PresenceContext = require(Motion.AnimatePresence.PresenceContext)
local utils = require(Motion.AnimatePresence.utils)
local useIdFallback = utils.useIdFallback

local function PresenceProvider(props)
	if props == nil then
		error("PresenceProvider: props cannot be nil")
	end

	local children = props.children
	local isPresent = props.isPresent
	local isPresent2 = isPresent == nil or isPresent

	local passThroughData = props.passThroughData

	local id = nil
	local success, result = pcall(function()
		id = useIdFallback()
	end)

	if not success then
		warn("PresenceProvider: Error generating ID:", result)
		id = "presence-" .. useIdFallback()
	end

	local v = nil
	local success2, result2 = pcall(function()
		v = React.useRef({})
	end)

	if not success2 then
		warn("PresenceProvider: Error creating childrenPresence ref:", result2)
		v = { current = {} }
	end

	local function onExitComplete(p)
		if v.current then
			v.current[p] = true
		end

		local v2 = true

		for _, v3 in pairs(v.current) do
			if not v3 then
				v2 = false
				break
			end
		end

		if v2 and props.onExitComplete then
			props.onExitComplete()
		end
	end

	local function register(p)
		v.current[p] = false

		return function()
			v.current[p] = nil
		end
	end

	local v2 = {
		id = id,
		isPresent = isPresent2,
		register = register,
		onExitComplete = onExitComplete,
		passThroughData = passThroughData
	}

	local v3 = nil
	local success3, result3 = pcall(function()
		v3 = React.createElement(PresenceContext.Provider, { value = v2 }, children)
	end)

	if not success3 then
		warn("PresenceProvider: Error creating PresenceContext.Provider:", result3)
	end

	return v3 or React.createElement(React.Fragment, {}, children)
end

return PresenceProvider
