local Parent = script:FindFirstAncestor("BuildExperience").Parent
local GuiService = game:GetService("GuiService")
local React = require(Parent.React)

local function getHardwareSafeAreaInsets() -- line: 9
	-- upvalues: GuiService (copy)
	local InsetArea = GuiService:GetInsetArea(Enum.ScreenInsets.DeviceSafeInsets)
	local InsetArea2 = GuiService:GetInsetArea(Enum.ScreenInsets.None)

	return {
		left = InsetArea.Min.X - InsetArea2.Min.X,
		top = InsetArea.Min.Y - InsetArea2.Min.Y,
		right = InsetArea2.Max.X - InsetArea.Max.X,
		bottom = InsetArea2.Max.Y - InsetArea.Max.Y
	}
end
local function useHardwareInsets(p1) -- line: 21
	-- upvalues: React (copy), getHardwareSafeAreaInsets (copy)
	local v9, v10 = React.useState(getHardwareSafeAreaInsets)

	React.useEffect(function() -- line: 24
		-- upvalues: p1 (copy), v10 (copy), getHardwareSafeAreaInsets (copy)
		local connection = nil

		if p1 then
			connection = p1:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 28
				-- upvalues: v10 (copy), getHardwareSafeAreaInsets (copy)
				v10(function(p2) -- line: 29
					-- upvalues: getHardwareSafeAreaInsets (copy)
					local v13 = getHardwareSafeAreaInsets()

					if v13.bottom ~= p2.bottom or (v13.top ~= p2.top or v13.left ~= p2.left or v13.right ~= p2.right) then
						return v13
					end

					return p2
				end)
			end)
		end

		return function() -- line: 45
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, { p1 })

	return v9
end

return useHardwareInsets
