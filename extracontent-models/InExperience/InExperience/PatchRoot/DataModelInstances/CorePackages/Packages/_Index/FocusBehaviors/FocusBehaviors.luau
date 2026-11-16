local parent = script.Parent
require(parent.FocusNavigation)

local composeFocusBehaviors = require(script.composeFocusBehaviors)

local function defaultDescendantBehavior(p) -- 1 equivalent call inferred from this helper
	return {
		getTargets = function()
			if p then
				return { p }
			end

			return {}
		end
	}
end

local function mostRecentDescendantBehavior()
	local v = nil

	return {
		onDescendantFocusChanged = function(p)
			v = p or v
		end,
		getTargets = function()
			if v then
				return { v }
			end

			return {}
		end
	}
end

local function mostRecentDescendantOrDefaultBehavior(p)
	return composeFocusBehaviors(mostRecentDescendantBehavior(), defaultDescendantBehavior(p)) -- inferred equivalent call
end

return {
	default = defaultDescendantBehavior,
	mostRecent = mostRecentDescendantBehavior,
	mostRecentOrDefault = mostRecentDescendantOrDefaultBehavior,
	composeFocusBehaviors = composeFocusBehaviors
}
