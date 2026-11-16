local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/ExperienceDetailsSheet/Types")

local createSignal = Signals.createSignal

local function createExperienceDetailsSheetStore()
	local signal, v5 = createSignal(false)
	local signal2, v6 = createSignal(nil)

	return {
		getIsOpen = signal,
		getContext = signal2,
		open = function(p2)
			v6(p2)
			v5(true)
		end,
		close = function()
			v5(false)
		end
	}
end

return createExperienceDetailsSheetStore
