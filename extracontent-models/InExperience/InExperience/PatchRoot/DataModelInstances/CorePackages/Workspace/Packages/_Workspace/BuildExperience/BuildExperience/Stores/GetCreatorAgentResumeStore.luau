local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)

local function createCreatorAgentResumeStore() -- line: 20
	-- upvalues: Signals (copy), SignalsReact (copy)
	local v5, v6 = Signals.createSignal(nil)

	return {
		getActiveTarget = v5,
		useActiveTarget = function() -- line: 23
			-- upvalues: SignalsReact (copy), v5 (copy)
			return SignalsReact.useSignalState(v5)
		end,
		setActiveTarget = v6
	}
end

return Signals.createComputed(createCreatorAgentResumeStore)
