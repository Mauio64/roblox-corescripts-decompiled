local Parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(Parent.Signals)

require(script.Parent.Parent.Types)

local createSignal = Signals.createSignal

local function createExperienceDetailsSheetStore() -- line: 26
	-- upvalues: createSignal (copy)
	local v5, v6 = createSignal(false)
	local v7, v8 = createSignal(nil)

	return {
		getIsOpen = v5,
		getContext = v7,
		open = function(p1) -- line: 30
			-- upvalues: v8 (copy), v6 (copy)
			v8(p1)
			v6(true)
		end,
		close = function() -- line: 35
			-- upvalues: v6 (copy)
			v6(false)
		end
	}
end

return createExperienceDetailsSheetStore
