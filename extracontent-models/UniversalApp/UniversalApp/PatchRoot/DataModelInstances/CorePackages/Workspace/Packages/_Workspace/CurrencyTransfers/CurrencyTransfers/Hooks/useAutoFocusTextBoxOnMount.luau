local Parent = script:FindFirstAncestor("CurrencyTransfers").Parent
local React = require(Parent.React)

local function useAutoFocusTextBoxOnMount(p1: ((...any) -> ...any)?, n1: number?) -- line: 7
	-- upvalues: React (copy)
	local v6 = React.useRef(false)

	return React.useCallback(function(p2) -- line: 10
		-- upvalues: p1 (copy), v6 (copy), n1 (copy)
		if p1 then
			p1(p2)
		end

		if p2 and not v6.current then
			v6.current = true
			task.spawn(function() -- line: 17
				-- upvalues: n1 (copy), p2 (copy)
				task.wait(n1 or 0.05)

				if p2 and p2.Parent then
					p2:CaptureFocus()
				end
			end)
		end
	end, {
		p1,
		n1
	})
end

return useAutoFocusTextBoxOnMount
