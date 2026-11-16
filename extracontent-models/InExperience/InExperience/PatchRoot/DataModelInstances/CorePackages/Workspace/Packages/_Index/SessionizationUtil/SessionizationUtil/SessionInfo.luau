local parent = script:FindFirstAncestor("SessionizationUtil").Parent

local SessionService = game:GetService("SessionService")
local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local SessionType = RobloxAppSessionization.SessionType

local SessionInfo = {}
SessionInfo.__index = SessionInfo

function SessionInfo.new(level, sessionId: string?, tagName: string?, creationTimestamp: number?, options)
	local self = setmetatable({}, SessionInfo)

	self.level = level
	self.sessionId = sessionId
	self.tagName = tagName
	self.creationTimestamp = creationTimestamp
	self.metadata = options or {}

	return self
end

function SessionInfo.__tostring(data)
	local count = 0

	for _ in pairs(data.metadata) do
		count += 1
	end

	return string.format(
		"SessionInfo{level=%s, sessionId=%s, tagName=%s, creationTimestamp=%s, metadata_count=%d}",
		tostring(data.level),
		tostring(data.sessionId),
		tostring(data.tagName),
		tostring(data.creationTimestamp),
		count
	)
end

function SessionInfo.getSessionByLevel(p)
	local v = SessionType.StructuralIdentifier[p]
	local v2, sessionTag

	if p == SessionType.StructuralIdentifier.Level0 then
		v2 = SessionService:GetRootSID()
	elseif v and SessionService:SessionExists(v) then
		v2 = SessionService:GetSessionID(v)
		sessionTag = SessionService:GetSessionTag(v)
	end

	return SessionInfo.new(p, v2, sessionTag, nil, {})
end

return SessionInfo
