local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)

local function createPublishGameSheetStore() -- line: 13
	-- upvalues: Signals (copy), SignalsReact (copy)
	local v5, v6 = Signals.createSignal(false)

	return {
		getIsOpen = v5,
		useIsOpen = function() -- line: 16
			-- upvalues: SignalsReact (copy), v5 (copy)
			return SignalsReact.useSignalState(v5)
		end,
		setIsOpen = v6
	}
end

return createPublishGameSheetStore
