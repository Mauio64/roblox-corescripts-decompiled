local Motion = script:FindFirstAncestor("Motion")
local MotionParent = Motion.Parent
local React = require(MotionParent.React)
local PresenceContext = require(Motion.AnimatePresence.PresenceContext)
local useIdFallback = require(Motion.AnimatePresence.utils).useIdFallback

local function PresenceProvider(t1: {[any]: any}) -- line: 30
	-- upvalues: useIdFallback (copy), React (copy), PresenceContext (copy)
	if t1 == nil then
		error("PresenceProvider: props cannot be nil")
	end

	local children = t1.children
	local isPresent = t1.isPresent

	if isPresent == nil then
		isPresent = true
	end

	local passThroughData = t1.passThroughData
	local u11 = nil
	local ok, result = pcall(function() -- line: 53
		-- upvalues: u11 (ref), useIdFallback (copy)
		u11 = useIdFallback()
	end)

	if not ok then
		warn("PresenceProvider: Error generating ID:", result)
		u11 = "presence-" .. useIdFallback()
	end

	local u14 = nil
	local ok2, result2 = pcall(function() -- line: 64
		-- upvalues: u14 (ref), React (copy)
		u14 = React.useRef({})
	end)

	if not ok2 then
		warn("PresenceProvider: Error creating childrenPresence ref:", result2)
		u14 = {
			current = {}
		}
	end

	local t2 = {
		id = u11,
		isPresent = isPresent,
		register = function(p1) -- line: 95
			-- upvalues: u14 (ref)
			u14.current[p1] = false

			return function() -- line: 99
				-- upvalues: u14 (ref), p1 (copy)
				u14.current[p1] = nil
			end
		end,
		onExitComplete = function(p2) -- line: 74
			-- upvalues: u14 (ref), t1 (copy)
			if u14.current then
				u14.current[p2] = true
			end

			local v22 = true

			for _, v in pairs(u14.current) do
				if not v then
					v22 = false

					break
				end
			end

			if v22 and t1.onExitComplete then
				t1.onExitComplete()
			end
		end,
		passThroughData = passThroughData
	}
	local u18 = nil
	local ok3, result3 = pcall(function() -- line: 114
		-- upvalues: u18 (ref), React (copy), PresenceContext (copy), t2 (copy), children (copy)
		u18 = React.createElement(PresenceContext.Provider, {
			value = t2
		}, children)
	end)

	if not ok3 then
		warn("PresenceProvider: Error creating PresenceContext.Provider:", result3)
	end

	return u18 or React.createElement(React.Fragment, {}, children)
end

return PresenceProvider
