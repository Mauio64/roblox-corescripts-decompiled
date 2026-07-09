local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local React = require(CorePackages.Packages.React)
local Modules = CoreGui.RobloxGui.Modules
local makeEvents = require(Modules.AvatarExperience.Common.Util.makeEvents)
local AdjustmentDataCallbacksContext = require(script.Parent.AdjustmentDataCallbacksContext)
local AdjustmentDataEventsContext = require(script.Parent.AdjustmentDataEventsContext)

return function(p1) -- line: 14
	-- upvalues: React (copy), makeEvents (copy), AdjustmentDataCallbacksContext (copy), AdjustmentDataEventsContext (copy)
	local v9, v10 = React.useState({})
	local v11, v12 = React.useState({})

	React.useEffect(function() -- line: 18
		-- upvalues: makeEvents (copy), v10 (copy), v12 (copy)
		local v13, v14, v15 = makeEvents({ "setAdjustments" })

		v10(v13)
		v12(v14)

		return function() -- line: 24
			-- upvalues: v15 (copy)
			for _, v17 in v15 do
				v17()
			end
		end
	end, {})

	return React.createElement(AdjustmentDataCallbacksContext.Provider, {
		value = v11
	}, {
		AdjustmentDataEventsContextProvider = React.createElement(AdjustmentDataEventsContext.Provider, {
			value = v9
		}, p1.children)
	})
end
