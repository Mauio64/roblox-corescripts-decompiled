local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local useStore = require(Parent.RoactUtils).Hooks.RoactRodux.useStore

local function v5(p1, p2) -- line: 16
	return p1 == p2
end
local function useSelectorSignal(p3: ((...any) -> ...any), p4: ((...any) -> ...any)?) -- line: 20
	-- upvalues: useStore (copy), React (copy), Signals (copy), v5 (copy)
	local v11 = useStore()
	local v12 = v11:getState()
	local v13, v14 = React.useMemo(function() -- line: 24
		-- upvalues: Signals (copy), v12 (copy)
		return Signals.createSignal(v12)
	end, {})

	React.useEffect(function() -- line: 28
		-- upvalues: v11 (copy), v14 (copy)
		local v15 = v11:getState()

		v14(v15)

		local v16 = v11.changed:connect(v14)

		return function() -- line: 32
			-- upvalues: v16 (copy)
			v16:disconnect()
		end
	end, { v11 })

	return React.useMemo(function() -- line: 37
		-- upvalues: Signals (copy), p3 (copy), v13 (copy), p4 (copy), v5 (copy)
		return Signals.createComputed(function(p5) -- line: 38
			-- upvalues: p3 (copy), v13 (copy)
			return p3(v13(p5))
		end, p4 or v5)
	end, {
		v13,
		p3,
		p4
	})
end

return useSelectorSignal
