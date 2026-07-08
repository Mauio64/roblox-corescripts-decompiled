local ParentParent = script.Parent.Parent

require(ParentParent.FocusNavigation)

local function composeFocusBehaviors(...) -- line: 5
	local t1 = { ... }

	return {
		onDescendantFocusChanged = function(p1) -- line: 8
			-- upvalues: t1 (copy)
			for _, v6 in t1 do
				if v6.onDescendantFocusChanged then
					v6.onDescendantFocusChanged(p1)
				end
			end
		end,
		getTargets = function() -- line: 15
			-- upvalues: t1 (copy)
			local t2 = {}

			for _, v9 in t1 do
				for _, v11 in (v9.getTargets()) do
					table.insert(t2, v11)
				end
			end

			return t2
		end
	}
end

return composeFocusBehaviors
