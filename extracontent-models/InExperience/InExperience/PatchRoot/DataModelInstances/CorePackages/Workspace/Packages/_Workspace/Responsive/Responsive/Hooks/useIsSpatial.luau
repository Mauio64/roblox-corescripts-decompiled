local Parent = script:FindFirstAncestor("Responsive").Parent
local React = require(Parent.React)
local AppCommonLib = require(Parent.AppCommonLib)

local function useIsSpatial() -- line: 5
	-- upvalues: React (copy), AppCommonLib (copy)
	local v5, v6 = React.useState(AppCommonLib.isSpatial)

	React.useEffect(function() -- line: 7
		-- upvalues: v6 (copy), AppCommonLib (copy)
		v6(AppCommonLib.isSpatial())

		local v7 = AppCommonLib.connectToIsSpatialChanged(function(b1: boolean) -- line: 9
			-- upvalues: v6 (copy)
			v6(b1)
		end)

		return function() -- line: 12
			-- upvalues: v7 (copy)
			v7:Disconnect()
		end
	end, {})

	return v5
end

return useIsSpatial
