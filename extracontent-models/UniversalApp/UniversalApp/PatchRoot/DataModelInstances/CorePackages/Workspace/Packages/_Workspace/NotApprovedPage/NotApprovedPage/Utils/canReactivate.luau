local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local INTERVENTION_TYPES = require(NotApprovedPageParent.NotApprovedPageShared).Constants.INTERVENTION_TYPES
local MockableProxyServices = require(NotApprovedPageParent.MockableProxyServices)

require(NotApprovedPage.Common.Types)

local function canReactivate(p1, s1: string, s2: string) -- line: 20
	-- upvalues: MockableProxyServices (copy), INTERVENTION_TYPES (copy)
	if s2 ~= "" then
		return true
	end

	local v9 = MockableProxyServices.Workspace:GetServerTimeNow() * 1000
	local dateTime = DateTime.fromIsoDate(s1)
	local v11 = dateTime and v9 > dateTime.UnixTimestampMillis

	if p1 == INTERVENTION_TYPES.Warning then
		return true
	end

	if p1 == INTERVENTION_TYPES.Banned and v11 then
		return true
	end

	return false
end

return canReactivate
