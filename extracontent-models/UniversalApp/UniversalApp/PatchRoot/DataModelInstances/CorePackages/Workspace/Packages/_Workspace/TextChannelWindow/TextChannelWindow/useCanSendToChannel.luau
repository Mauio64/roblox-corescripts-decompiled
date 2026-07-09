local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local useEventConnection = require(ParentParent.ReactUtils).useEventConnection
local findLocalTextSource = require(script.Parent.findLocalTextSource)

return {
	useCanSendToChannel = function(p1, s1: string?) -- line: 8
		-- upvalues: React (copy), findLocalTextSource (copy), useEventConnection (copy)
		local v7, v8 = React.useState(function() -- line: 9
			-- upvalues: findLocalTextSource (copy), p1 (copy), s1 (copy)
			return findLocalTextSource(p1, s1)
		end)
		local v9 = React.useCallback(function() -- line: 13
			-- upvalues: v8 (copy), findLocalTextSource (copy), p1 (copy), s1 (copy)
			v8(findLocalTextSource(p1, s1))
		end, {
			p1,
			s1
		})

		React.useEffect(v9, { v9 })
		useEventConnection(if not p1 then nil else p1.ChildAdded, v9, { v9 })
		useEventConnection(if not p1 then nil else p1.ChildRemoved, v9, { v9 })

		local function evaluateCanSend() -- line: 23
			-- upvalues: p1 (copy), s1 (copy), v7 (copy)
			if p1 == nil or s1 == nil then
				return true
			end

			return v7 ~= nil and v7.CanSend
		end

		local v11, v12 = React.useState(evaluateCanSend)

		React.useEffect(function() -- line: 32
			-- upvalues: v12 (copy), p1 (copy), s1 (copy), v7 (copy)
			v12(p1 == nil or (s1 == nil or v7 ~= nil and v7.CanSend))
		end, {
			p1,
			s1,
			v7
		})
		useEventConnection(if not v7 then nil else v7:GetPropertyChangedSignal("CanSend"), function() -- line: 36
			-- upvalues: v12 (copy), p1 (copy), s1 (copy), v7 (copy)
			v12(p1 == nil or (s1 == nil or v7 ~= nil and v7.CanSend))
		end, {
			p1,
			s1,
			v7
		})

		return v11
	end
}
