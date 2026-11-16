require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Types/common")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Types/model")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Types/acpSession")

return {
	RequestFailureKind = table.freeze({
		Timeout = "timeout",
		Transport = "transport",
		Http = "http",
		RpcError = "rpc_error",
		Unknown = "unknown"
	})
}
