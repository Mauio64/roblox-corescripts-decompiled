local WhatsNew = script:FindFirstAncestor("WhatsNew")
local parent = WhatsNew.Parent

local SignalsReact = require(parent.SignalsReact)
require(WhatsNew.Types)
local GetWhatsNewStore = require(WhatsNew.store.GetWhatsNewStore)

local function useWhatsNewRuntimeState()
	local whatsNewStore = GetWhatsNewStore()
	return SignalsReact.useSignalState(whatsNewStore.getRuntimeStateSignal)
end

return useWhatsNewRuntimeState
