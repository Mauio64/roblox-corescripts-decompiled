local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local AcpProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Acp/AcpProtocol")
local createCreatorAgentChatStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/createCreatorAgentChatStore")
local debug = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/debug")
local getDefaultAuthHeaders = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Acp/getDefaultAuthHeaders")
local resolveAcpUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Env/resolveAcpUrl")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")
local wireCapDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Acp/wireCapDelivery")

local function createDefaultStore()
	local creatorAgentAcp = resolveAcpUrl.resolveCreatorAgentAcp()
	debug.log("info", "creating CreatorAgentChatStore", {
		acpUrl = creatorAgentAcp.url,
		gateway = creatorAgentAcp.gateway,
		sitetestNumber = creatorAgentAcp.sitetestNumber,
		capRtnNamespace = AcpProtocol.CapRtnNamespace
	})

	local defaultStore = createCreatorAgentChatStore({
		baseUrl = creatorAgentAcp.url,
		getAuthHeaders = getDefaultAuthHeaders
	})

	wireCapDelivery(defaultStore)
	return defaultStore
end

return Signals.createComputed(createDefaultStore)
