require("@luauforge/bundled/dFO")
local React = require("@game/CorePackages/Workspace/Packages/React")
local useLazyRef = require("@luauforge/bundled/dGD").useLazyRef
local useNavigation = require("@luauforge/bundled/dFH").useNavigation

local module2 = require("@luauforge/bundled/dGE")

local function RnBypassAdapter(data): nil
	local rnBypassActionSignal = data.rnBypassActionSignal
	local v5 = useNavigation()

	local v6 = useLazyRef(function()
		return rnBypassActionSignal:connect(function(p2)
			v5.dispatch(p2)
		end)
	end)

	React.useEffect(function()
		v6.current:disconnect()
	end, {})

	React.useEffect(function()
		local connection = rnBypassActionSignal:connect(function(p2)
			v5.dispatch(p2)
		end)

		return function()
			connection:disconnect()
		end
	end, { v5, rnBypassActionSignal })

	local v7 = module2(data.ApplyRoactNavigationHistory, data.updateRoute)

	React.useEffect(function()
		v7(nil, v5.state, nil)
	end, { v5.state })

	return nil
end

return RnBypassAdapter
