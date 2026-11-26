local SessionService = game:GetService("SessionService")
local sessionType = require("@game/CorePackages/Workspace/Packages/_Workspace/SessionizationUtil/RobloxAppSessionization").SessionType

local class = {}
class.__index = class

function class.new(level, sessionId, tagName, creationTimestamp, options)
	local object = setmetatable({}, class)

	object.level = level
	object.sessionId = sessionId
	object.tagName = tagName
	object.creationTimestamp = creationTimestamp
	object.metadata = options or {}

	return object
end

function class.__tostring(data)
	local count = 0

	for k in pairs(data.metadata) do
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

function class.getSessionByLevel(p2)
	local v5 = sessionType.StructuralIdentifier[p2]
	local v6, sessionTag

	if p2 == sessionType.StructuralIdentifier.Level0 then
		v6 = SessionService:GetRootSID()
	elseif v5 and SessionService:SessionExists(v5) then
		v6 = SessionService:GetSessionID(v5)
		sessionTag = SessionService:GetSessionTag(v5)
	end

	return class.new(p2, v6, sessionTag, nil, {})
end

return class
