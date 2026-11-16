local useAdditionalAuditContent = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Stores/AuditContentContext/AuditContentContext").useAdditionalAuditContent

local GetFFlagEnableAuditSystem = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Flags/GetFFlagEnableAuditSystem")

local function RegisterAdditionalAuditContent(p2): nil
	if not GetFFlagEnableAuditSystem() then
		return nil
	end

	useAdditionalAuditContent(p2.contentKey, p2.value)

	return nil
end

return RegisterAdditionalAuditContent
