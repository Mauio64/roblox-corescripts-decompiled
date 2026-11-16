local AuthCommon = script:FindFirstAncestor("AuthCommon")

local AuditContentContext = require(AuthCommon.Stores.AuditContentContext.AuditContentContext)
local useAdditionalAuditContent = AuditContentContext.useAdditionalAuditContent

local GetFFlagEnableAuditSystem = require(AuthCommon.Flags.GetFFlagEnableAuditSystem)

local function RegisterAdditionalAuditContent(p): nil
	if not GetFFlagEnableAuditSystem() then
		return nil
	end

	useAdditionalAuditContent(p.contentKey, p.value)

	return nil
end

return RegisterAdditionalAuditContent
