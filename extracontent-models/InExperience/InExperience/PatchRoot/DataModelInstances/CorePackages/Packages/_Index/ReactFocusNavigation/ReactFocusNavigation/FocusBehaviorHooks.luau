local ParentParent = script.Parent.Parent

require(ParentParent.FocusNavigation)

local FocusBehaviors = require(ParentParent.FocusBehaviors)
local React = require(ParentParent.React)
local default = FocusBehaviors.default
local mostRecent = FocusBehaviors.mostRecent
local mostRecentOrDefault = FocusBehaviors.mostRecentOrDefault
local useContainerFocusBehavior = require(script.Parent.useContainerFocusBehavior)

return {
	useDefaultFocusBehavior = function(p1) -- line: 15
		-- upvalues: React (copy), default (copy), useContainerFocusBehavior (copy)
		local v9, v10 = React.useState(nil)
		local v11 = React.useMemo(function() -- line: 20
			-- upvalues: default (copy), v9 (copy)
			return default(v9)
		end, { v9 })

		return v10, (useContainerFocusBehavior(v11, p1))
	end,
	useMostRecentFocusBehavior = function(p2) -- line: 29
		-- upvalues: React (copy), mostRecent (copy), useContainerFocusBehavior (copy)
		local v13 = React.useMemo(mostRecent, {})

		return useContainerFocusBehavior(v13, p2)
	end,
	useMostRecentOrDefaultFocusBehavior = function(p3) -- line: 35
		-- upvalues: React (copy), mostRecentOrDefault (copy), useContainerFocusBehavior (copy)
		local v15, v16 = React.useState(nil)
		local v17 = React.useMemo(function() -- line: 40
			-- upvalues: mostRecentOrDefault (copy), v15 (copy)
			return mostRecentOrDefault(v15)
		end, { v15 })

		return v16, (useContainerFocusBehavior(v17, p3))
	end
}
