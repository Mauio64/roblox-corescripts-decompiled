local parent = script.Parent.Parent
require(parent.FocusNavigation)

local function composeFocusBehaviors(...)
	local v = { ... }
	return {
		onDescendantFocusChanged = function(p)
			for _, v2 in v do
				if v2.onDescendantFocusChanged then
					v2.onDescendantFocusChanged(p)
				end
			end
		end,
		getTargets = function()
			local targets = {}

			for _, v2 in v do
				local targets2 = v2.getTargets()

				for _, target in targets2 do
					table.insert(targets, target)
				end
			end

			return targets
		end
	}
end

return composeFocusBehaviors
