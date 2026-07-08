local scriptParent = script.Parent

require(scriptParent.FocusNavigation)

local composeFocusBehaviors = require(script.composeFocusBehaviors)

local function defaultDescendantBehavior(p1) -- line: 8
	return {
		getTargets = function() -- line: 10
			-- upvalues: p1 (copy)
			if p1 then
				return { p1 }
			end

			return {}
		end
	}
end
local function mostRecentDescendantBehavior() -- line: 16
	local u7 = nil

	return {
		onDescendantFocusChanged = function(p2) -- line: 20
			-- upvalues: u7 (ref)
			u7 = p2 or u7
		end,
		getTargets = function() -- line: 23
			-- upvalues: u7 (ref)
			if u7 then
				return { u7 }
			end

			return {}
		end
	}
end
local function mostRecentDescendantOrDefaultBehavior(p3) -- line: 29
	-- upvalues: composeFocusBehaviors (copy), mostRecentDescendantBehavior (copy)
	return composeFocusBehaviors(mostRecentDescendantBehavior(), {
		getTargets = function() -- line: 10
			-- upvalues: p3 (copy)
			if p3 then
				return { p3 }
			end

			return {}
		end
	})
end

return {
	default = defaultDescendantBehavior,
	mostRecent = mostRecentDescendantBehavior,
	mostRecentOrDefault = mostRecentDescendantOrDefaultBehavior,
	composeFocusBehaviors = composeFocusBehaviors
}
