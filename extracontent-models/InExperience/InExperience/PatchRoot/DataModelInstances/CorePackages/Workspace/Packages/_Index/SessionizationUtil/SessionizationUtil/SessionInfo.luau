local Parent = script:FindFirstAncestor("SessionizationUtil").Parent
local SessionService = game:GetService("SessionService")
local SessionType = require(Parent.RobloxAppSessionization).SessionType
local t1 = {}

t1.__index = t1

function t1.new(p1, s1: string?, s2: string?, n1: number?, t2: {[any]: any}) -- line: 40
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self.level = p1
	self.sessionId = s1
	self.tagName = s2
	self.creationTimestamp = n1
	self.metadata = t2 or {}

	return self
end
function t1.__tostring(p2) -- line: 63
	local n2 = 0

	for _ in pairs(p2.metadata) do
		n2 += 1
	end

	return string.format("SessionInfo{level=%s, sessionId=%s, tagName=%s, creationTimestamp=%s, metadata_count=%d}", tostring(p2.level), tostring(p2.sessionId), tostring(p2.tagName), tostring(p2.creationTimestamp), n2)
end
function t1.getSessionByLevel(p3) -- line: 97
	-- upvalues: SessionType (copy), SessionService (copy), t1 (copy)
	local v15 = SessionType.StructuralIdentifier[p3]
	local RootSID, v17

	if p3 == SessionType.StructuralIdentifier.Level0 then
		RootSID = SessionService:GetRootSID()
		v17 = nil
	elseif v15 then
		if SessionService:SessionExists(v15) then
			RootSID = SessionService:GetSessionID(v15)
			v17 = SessionService:GetSessionTag(v15)
		else
			RootSID = nil
			v17 = nil
		end
	else
		RootSID = nil
		v17 = nil
	end

	return t1.new(p3, RootSID, v17, nil, {})
end

return t1
