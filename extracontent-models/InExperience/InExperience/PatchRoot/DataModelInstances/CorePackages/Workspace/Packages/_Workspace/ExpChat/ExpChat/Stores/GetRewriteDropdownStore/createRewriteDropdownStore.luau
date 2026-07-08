local Parent = script:FindFirstAncestor("ExpChat").Parent
local createSignal = require(Parent.Signals).createSignal

return function() -- line: 16
	-- upvalues: createSignal (copy)
	local v3, v4 = createSignal(nil)
	local v5, v6 = createSignal(nil)

	return {
		getOpenMessageId = v3,
		getComponentId = v5,
		toggleDropdown = function(s1: string) -- line: 20
			-- upvalues: v4 (copy)
			v4(function(p1) -- line: 21
				-- upvalues: s1 (copy)
				if p1 == s1 then
					return nil
				end

				return s1
			end)
		end,
		setComponentId = v6
	}
end
