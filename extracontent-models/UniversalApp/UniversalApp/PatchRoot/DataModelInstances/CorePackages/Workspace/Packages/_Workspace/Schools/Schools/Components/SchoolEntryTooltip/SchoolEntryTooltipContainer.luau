local Schools = script:FindFirstAncestor("Schools")
local SchoolsParent = Schools.Parent
local React = require(SchoolsParent.React)

require(Schools.Common.Enums)

local useSchoolEntryTooltipVariant = require(Schools.Hooks.useSchoolEntryTooltipVariant)
local SchoolEntryTooltip = require(script.Parent.SchoolEntryTooltip)
local v6 = game:DefineFastInt("SchoolEntryTooltipDurationSeconds", 3)

local function SchoolEntryTooltipContainer(t1: {[any]: any}) -- line: 19
	-- upvalues: useSchoolEntryTooltipVariant (copy), React (copy), v6 (copy), SchoolEntryTooltip (copy)
	local v9, v10 = useSchoolEntryTooltipVariant()

	React.useImperativeHandle(t1.dismissTooltipRef, function() -- line: 22
		-- upvalues: v10 (copy)
		return v10
	end, { v10 })
	React.useEffect(function() -- line: 26
		-- upvalues: v9 (copy), v6 (copy), v10 (copy)
		if v9 == nil then
			return
		end

		local thread = task.delay(v6, v10)

		return function() -- line: 32
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, {
		v9,
		v10
	})

	if v9 == nil then
		return nil
	end

	return React.createElement(SchoolEntryTooltip, {
		variant = v9,
		anchorRef = t1.anchorRef
	})
end

return SchoolEntryTooltipContainer
