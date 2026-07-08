local Parent = script:FindFirstAncestor("Responsive").Parent
local React = require(Parent.React)
local HardwareSafeAreaInsets = require(script.Parent.Parent.HardwareSafeAreaInsets)

return function() -- line: 6
	-- upvalues: React (copy), HardwareSafeAreaInsets (copy)
	local v4, v5 = React.useState(HardwareSafeAreaInsets.deviceInsets())

	React.useLayoutEffect(function() -- line: 8
		-- upvalues: HardwareSafeAreaInsets (copy), v5 (copy), v4 (copy)
		local v6 = HardwareSafeAreaInsets:connect(v5)

		if HardwareSafeAreaInsets.diffInsets(v4, HardwareSafeAreaInsets.deviceInsets()) then
			v5(HardwareSafeAreaInsets.deviceInsets)
		end

		return function() -- line: 13
			-- upvalues: v6 (copy)
			v6:disconnect()
		end
	end, {})

	return v4
end
