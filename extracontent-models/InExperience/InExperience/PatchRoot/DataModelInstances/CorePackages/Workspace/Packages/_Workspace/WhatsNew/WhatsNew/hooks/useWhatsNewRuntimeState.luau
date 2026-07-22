local WhatsNew = script:FindFirstAncestor("WhatsNew")
local WhatsNewParent = WhatsNew.Parent
local SignalsReact = require(WhatsNewParent.SignalsReact)

require(WhatsNew.Types)

local GetWhatsNewStore = require(WhatsNew.store.GetWhatsNewStore)

local function useWhatsNewRuntimeState() -- line: 12
	-- upvalues: GetWhatsNewStore (copy), SignalsReact (copy)
	local v6 = GetWhatsNewStore()

	return SignalsReact.useSignalState(v6.getRuntimeStateSignal)
end

return useWhatsNewRuntimeState
