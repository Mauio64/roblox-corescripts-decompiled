local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)

require(script.Parent.Parent.Types)

local createSignal = Signals.createSignal

local function createExperienceDetailsSheetStore()
	local signal, v = createSignal(false)
	local signal2, v2 = createSignal(nil)

	return {
		getIsOpen = signal,
		getContext = signal2,
		open = function(p)
			v2(p)
			v(true)
		end,
		close = function()
			v(false)
		end
	}
end

return createExperienceDetailsSheetStore
