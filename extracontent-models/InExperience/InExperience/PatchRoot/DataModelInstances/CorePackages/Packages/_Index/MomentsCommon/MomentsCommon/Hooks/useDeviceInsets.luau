local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local React = require(MomentsCommonParent.React)
local HardwareSafeAreaInsets = require(MomentsCommon.Utils.HardwareSafeAreaInsets)

return function() -- line: 8
	-- upvalues: React (copy), HardwareSafeAreaInsets (copy)
	local v5, v6 = React.useState(HardwareSafeAreaInsets.deviceInsets())

	React.useLayoutEffect(function() -- line: 10
		-- upvalues: HardwareSafeAreaInsets (copy), v6 (copy), v5 (copy)
		local v7 = HardwareSafeAreaInsets:connect(v6)

		if HardwareSafeAreaInsets.diffInsets(v5, HardwareSafeAreaInsets.deviceInsets()) then
			v6(HardwareSafeAreaInsets.deviceInsets)
		end

		return function() -- line: 15
			-- upvalues: v7 (copy)
			v7.disconnect()
		end
	end, {})

	return v5
end
