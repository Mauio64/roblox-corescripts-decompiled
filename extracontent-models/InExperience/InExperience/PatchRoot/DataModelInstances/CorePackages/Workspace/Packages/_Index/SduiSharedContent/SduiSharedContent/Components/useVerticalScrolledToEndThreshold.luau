local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local v3 = game:DefineFastFlag("LuaAppSduiVerticalFeedThresholdRefresh", false)

local function useVerticalScrolledToEndThreshold(t1: {[any]: any}, n1: number?, p1: ((...any) -> ...any)?) -- line: 8
	-- upvalues: React (copy), v3 (copy)
	local v9 = React.useRef(false)
	local u10 = nil

	if v3 then
		u10 = React.useRef(p1)
		u10.current = p1

		if p1 == nil then
			n1 = nil
		end
	end

	React.useEffect(function() -- line: 29
		-- upvalues: v3 (copy), p1 (copy), n1 (ref), t1 (copy), v9 (copy), u10 (ref)
		if not v3 and p1 == nil or (n1 == nil or t1.current == nil) then
			return nil
		end

		local t2 = {}
		local current = t1.current

		local function checkThreshold() -- line: 41
			-- upvalues: current (copy), n1 (ref), v9 (copy), v3 (copy), u10 (ref), p1 (copy)
			local v15 = current.AbsoluteCanvasSize.Y - current.AbsoluteWindowSize.Y - n1
			local CanvasPositionY = current.CanvasPosition.Y

			if CanvasPositionY < v15 and v9.current then
				v9.current = false

				return
			end

			if v15 < CanvasPositionY and not v9.current then
				v9.current = true

				if v3 then
					if u10.current then
						u10.current()

						return
					end
				else
					p1()
				end
			end
		end

		table.insert(t2, current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(checkThreshold))
		table.insert(t2, current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(checkThreshold))
		table.insert(t2, current:GetPropertyChangedSignal("CanvasPosition"):Connect(checkThreshold))

		local u14 = nil

		if v3 then
			u14 = false
			task.defer(function() -- line: 73
				-- upvalues: u14 (ref), checkThreshold (copy)
				if not u14 then
					checkThreshold()
				end
			end)
		end

		return function() -- line: 80
			-- upvalues: v3 (copy), u14 (ref), t2 (copy)
			if v3 then
				u14 = true
			end

			for _, v18 in t2 do
				v18:Disconnect()
			end
		end
	end, {
		t1,
		n1,
		if not v3 then p1 else nil
	})
end

return useVerticalScrolledToEndThreshold
