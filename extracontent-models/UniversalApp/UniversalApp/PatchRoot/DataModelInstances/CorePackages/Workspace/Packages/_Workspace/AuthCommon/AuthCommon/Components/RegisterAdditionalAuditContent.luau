local AuthCommon = script:FindFirstAncestor("AuthCommon")
local useAdditionalAuditContent = require(AuthCommon.Stores.AuditContentContext.AuditContentContext).useAdditionalAuditContent
local GetFFlagEnableAuditSystem = require(AuthCommon.Flags.GetFFlagEnableAuditSystem)

local function RegisterAdditionalAuditContent(t1: {[any]: any}) -- line: 21
	-- upvalues: GetFFlagEnableAuditSystem (copy), useAdditionalAuditContent (copy)
	if not GetFFlagEnableAuditSystem() then
		return nil
	end

	useAdditionalAuditContent(t1.contentKey, t1.value)

	return nil
end

return RegisterAdditionalAuditContent
