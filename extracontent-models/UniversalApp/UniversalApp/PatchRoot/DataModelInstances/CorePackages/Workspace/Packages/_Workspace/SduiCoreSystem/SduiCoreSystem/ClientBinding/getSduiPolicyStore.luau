local Parent = script:FindFirstAncestor("SduiCoreSystem").Parent
local Signals = require(Parent.Signals)

require(Parent.UniversalAppPolicy)

local function createSduiPolicyStore() -- line: 13
	-- upvalues: Signals (copy)
	local v6, v7 = Signals.createSignal(nil)

	return {
		getAppPolicy = v6,
		setAppPolicy = v7
	}
end

local t1 = nil

local function getSduiPolicyStore() -- line: 24
	-- upvalues: t1 (ref), Signals (copy)
	if t1 == nil then
		local v8, v9 = Signals.createSignal(nil)

		t1 = {
			getAppPolicy = v8,
			setAppPolicy = v9
		}
	end

	return t1
end

return getSduiPolicyStore
