local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Display = require(Parent.Display)
local Signals = require(Parent.Signals)

local function createAssistantBuildStore() -- line: 13
	-- upvalues: Signals (copy), Display (copy)
	local v5 = Signals.createComputed(function(p1) -- line: 14
		-- upvalues: Display (copy)
		local v9 = Display.GetDisplayStore(p1)
		local v10 = v9.getDisplaySize(p1)
		local v11 = v9.getViewportSize(p1)

		return v10 == Enum.DisplaySize.Small and v11.X > v11.Y
	end)
	local v6, v7 = Signals.createSignal(false)

	return {
		getIsDisabled = v5,
		getIsDisabledTooltipOpen = v6,
		setIsDisabledTooltipOpen = v7
	}
end

return createAssistantBuildStore
