local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local AcpProtocol = require(script.Parent.Acp.AcpProtocol)
local createCreatorAgentChatStore = require(script.Parent.createCreatorAgentChatStore)
local Debug = require(script.Parent.debug)
local getDefaultAuthHeaders = require(script.Parent.Acp.getDefaultAuthHeaders)
local resolveAcpUrl = require(script.Parent.Env.resolveAcpUrl)
require(script.Parent.types)
local wireCapDelivery = require(script.Parent.Acp.wireCapDelivery)

local function createDefaultStore()
	local creatorAgentAcp = resolveAcpUrl.resolveCreatorAgentAcp()
	Debug.log("info", "creating CreatorAgentChatStore", {
		acpUrl = creatorAgentAcp.url,
		gateway = creatorAgentAcp.gateway,
		sitetestNumber = creatorAgentAcp.sitetestNumber,
		capRtnNamespace = AcpProtocol.CapRtnNamespace
	})

	local creatorAgentChatStore = createCreatorAgentChatStore({
		baseUrl = creatorAgentAcp.url,
		getAuthHeaders = getDefaultAuthHeaders
	})

	wireCapDelivery(creatorAgentChatStore)
	return creatorAgentChatStore
end

return Signals.createComputed(createDefaultStore)
