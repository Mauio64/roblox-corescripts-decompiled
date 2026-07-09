local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local AppliedDescriptionCallbackContext = require(script.Parent.AppliedDescriptionCallbackContext)
local AppliedDescriptionValueContext = require(script.Parent.AppliedDescriptionValueContext)

return function(p1) -- line: 11
	-- upvalues: React (copy), AppliedDescriptionCallbackContext (copy), AppliedDescriptionValueContext (copy)
	local v6, v7 = React.useBinding(nil)
	local v8, v9 = React.useState({
		appliedDescriptionBinding = v6
	})
	local v10 = React.useCallback(function(p2) -- line: 15
		-- upvalues: v7 (copy)
		v7(p2)
	end, { v7 })

	React.useEffect(function() -- line: 18
		-- upvalues: v9 (copy), v6 (copy)
		v9({
			appliedDescriptionBinding = v6
		})
	end, { v6 })

	local v11 = React.useMemo(function() -- line: 22
		-- upvalues: v10 (copy)
		return {
			setAppliedDescription = v10
		}
	end, { v10 })

	return React.createElement(AppliedDescriptionCallbackContext.Provider, {
		value = v11
	}, {
		AppliedDescriptionValueContextProvider = React.createElement(AppliedDescriptionValueContext.Provider, {
			value = v8
		}, p1.children)
	})
end
