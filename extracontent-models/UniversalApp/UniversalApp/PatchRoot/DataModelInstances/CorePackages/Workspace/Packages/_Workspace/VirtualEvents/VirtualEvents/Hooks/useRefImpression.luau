local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local React = require(VirtualEvents.Parent.React)

local function useRefImpression(t1: {[any]: any}, p1: ((...any) -> ...any)) -- line: 5
	-- upvalues: React (copy)
	local v6 = React.useRef(false)
	local v7 = React.useCallback(function(p2, p3) -- line: 8
		-- upvalues: v6 (copy), p1 (copy)
		if p2.AbsolutePosition.Y <= p3.AbsoluteSize.Y then
			v6.current = true
			p1()
		end
	end, { p1 })

	React.useEffect(function() -- line: 15
		-- upvalues: v6 (copy), t1 (copy), v7 (copy)
		if v6.current then
			return
		end

		local current = t1.current
		local connection = nil

		if current then
			local ScreenGui = current:FindFirstAncestorWhichIsA("ScreenGui")

			if ScreenGui then
				v7(current, ScreenGui)
				connection = current:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 29
					-- upvalues: v6 (copy), v7 (copy), current (copy), ScreenGui (copy)
					if v6.current then
						return
					end

					v7(current, ScreenGui)
				end)
			end
		end

		return function() -- line: 39
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end)
end

return useRefImpression
