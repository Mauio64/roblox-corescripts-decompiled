local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)

local function createPlayButtonStore() -- line: 22
	-- upvalues: Signals (copy), SignalsReact (copy)
	local v5, v6 = Signals.createSignal(false)
	local v7, v8 = Signals.createSignal(nil)

	return {
		getIsActive = v5,
		useIsActive = function() -- line: 26
			-- upvalues: SignalsReact (copy), v5 (copy)
			return SignalsReact.useSignalState(v5)
		end,
		setIsActive = v6,
		getResumeTarget = v7,
		useResumeTarget = function() -- line: 30
			-- upvalues: SignalsReact (copy), v7 (copy)
			return SignalsReact.useSignalState(v7)
		end,
		setResumeTarget = v8
	}
end

return createPlayButtonStore
