local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local AcpProtocol = require(script.Parent.Acp.AcpProtocol)
local createCreatorAgentChatStore = require(script.Parent.createCreatorAgentChatStore)
local debug = require(script.Parent.debug)
local getDefaultAuthHeaders = require(script.Parent.Acp.getDefaultAuthHeaders)
local resolveAcpUrl = require(script.Parent.Env.resolveAcpUrl)

require(script.Parent.types)

local wireCapDelivery = require(script.Parent.Acp.wireCapDelivery)

local function createDefaultStore() -- line: 20
	-- upvalues: resolveAcpUrl (copy), debug (copy), AcpProtocol (copy), createCreatorAgentChatStore (copy), getDefaultAuthHeaders (copy), wireCapDelivery (copy)
	local v10 = resolveAcpUrl.resolveCreatorAgentAcp()

	debug.log("info", "creating CreatorAgentChatStore", {
		acpUrl = v10.url,
		gateway = v10.gateway,
		sitetestNumber = v10.sitetestNumber,
		capRtnNamespace = AcpProtocol.CapRtnNamespace
	})

	local v11 = createCreatorAgentChatStore({
		baseUrl = v10.url,
		getAuthHeaders = getDefaultAuthHeaders
	})

	wireCapDelivery(v11)

	return v11
end

return Signals.createComputed(createDefaultStore)
