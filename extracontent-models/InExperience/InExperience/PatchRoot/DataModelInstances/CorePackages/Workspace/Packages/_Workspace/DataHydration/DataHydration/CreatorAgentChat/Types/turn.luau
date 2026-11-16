require(script.Parent.common)
require(script.Parent.model)
require(script.Parent.acpSession)

return {
	RequestFailureKind = table.freeze({
		Timeout = "timeout",
		Transport = "transport",
		Http = "http",
		RpcError = "rpc_error",
		Unknown = "unknown"
	})
}
