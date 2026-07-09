local RunService = game:GetService("RunService")
local Parent = script:FindFirstAncestor("CollectionViews").Parent
local React = require(Parent.React)

local function useCarouselScrollingBinding(t1: {[any]: any}, b1: boolean) -- line: 9
	-- upvalues: React (copy), RunService (copy)
	local v7, v8 = React.useBinding(false)

	React.useEffect(function() -- line: 15
		-- upvalues: t1 (copy), b1 (copy), v8 (copy), RunService (copy)
		local current = t1.current

		if not b1 or not current then
			return nil
		end

		assert(current, "scrollingFrame must exist")

		local n1 = 0
		local u11 = nil
		local connection = current:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 25
			-- upvalues: n1 (ref), u11 (ref), v8 (copy), RunService (copy)
			n1 = os.clock() + 0.01

			if not u11 then
				v8(true)
				u11 = RunService.Heartbeat:Connect(function() -- line: 29
					-- upvalues: n1 (ref), v8 (copy), u11 (ref)
					if os.clock() >= n1 then
						v8(false)

						if u11 then
							u11:Disconnect()
							u11 = nil
						end
					end
				end)
			end
		end)

		return function() -- line: 41
			-- upvalues: connection (copy), u11 (ref)
			connection:Disconnect()

			if u11 then
				u11:Disconnect()
			end
		end
	end, { t1 })

	return v7
end

return useCarouselScrollingBinding
