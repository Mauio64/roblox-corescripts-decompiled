local parent = script:FindFirstAncestor("SessionizationUtil").Parent

local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

local v = {}
v.__index = v

function v.new(sid: string, tag: string)
	local v2 = {
		sid = sid,
		tag = tag,
		metadata = {},
		children = {},
		timestamp = tick(),
		parent = nil
	}

	setmetatable(v2, { __index = v })

	return v2
end

function v:addChild(p, p2)
	local v2 = v.new(p, p2)
	v2.parent = self
	self.children[p] = v2
end

function v:dump(p, p2)
	local v2 = p2 .. `{p} sid: {self.sid}, tag: {self.tag}\n`
	local v3 = p .. "----"

	for _, child in self.children do
		v2 = child:dump(v3, v2)
	end

	return v2
end

function findSid(p, p2)
	if p.sid == p2 then
		return p
	end

	for _, child in p.children do
		local sid = findSid(child, p2)

		if sid ~= nil then
			return sid
		end
	end

	return nil
end

local MockSessionService = { MOCK_ROOT_SID = "MOCK_ROOT_SID" }

MockSessionService.__index = MockSessionService

function MockSessionService.new()
	local v2 = {
		mockRootNode = v.new(MockSessionService.MOCK_ROOT_SID, MockSessionService.MOCK_ROOT_SID),
		SessionChangedSignal = Signal.new()
	}

	setmetatable(v2, { __index = MockSessionService })

	return v2
end

function MockSessionService:_resetMockData()
	self.mockRootNode = v.new(MockSessionService.MOCK_ROOT_SID, MockSessionService.MOCK_ROOT_SID)
end

function MockSessionService._findSid(p, p2)
	return findSid(p.mockRootNode, p2)
end

function MockSessionService._dumpSessionTree(p)
	if p.mockRootNode == nil then
		return "Root node is nil!"
	end

	return p.mockRootNode:dump("", "")
end

function MockSessionService.GetRootSID(p)
	return p.MOCK_ROOT_SID
end

function MockSessionService.SetSession(p, p2, p3, p4)
	(findSid(p.mockRootNode, p2) or p.mockRootNode):addChild(p3, p4)
end

function MockSessionService.ReplaceSession(p, p2, p3)
	local sid = findSid(p.mockRootNode, p2)

	if sid ~= nil and sid.parent ~= nil then
		sid.parent.children[p2] = nil
		sid.parent:addChild(p2, p3)
	end
end

function MockSessionService:RemoveSession(p)
	local sid = findSid(self.mockRootNode, p)

	if sid ~= nil then
		local parent2 = sid.parent

		if parent2 ~= nil then
			parent2.children[p] = nil
		end
	end
end

function MockSessionService.GetMetadata(p, p2, p3)
	local sid = findSid(p.mockRootNode, p2)

	if sid == nil then
		return nil
	end

	return sid.metadata[p3]
end

function MockSessionService.SetMetadata(p, p2, p3, p4)
	local sid = findSid(p.mockRootNode, p2)

	if sid ~= nil then
		sid.metadata[p3] = p4
	end
end

function MockSessionService.SessionExists(p, p2): boolean
	return findSid(p.mockRootNode, p2) ~= nil
end

function MockSessionService:RemoveSessionsWithMetadataKey(p)
	if p == nil then
		return
	end

	local function findNodeWithMetadataKey(p2, mockRootNode)
		if mockRootNode == nil then
			return nil
		end

		if mockRootNode.metadata[p2] ~= nil then
			return mockRootNode
		end

		for _, child in mockRootNode.children do
			local v2 = findNodeWithMetadataKey(p2, child)

			if v2 ~= nil then
				return v2
			end
		end

		return nil
	end

	local v2 = findNodeWithMetadataKey(p, self.mockRootNode)

	while v2 ~= nil do
		self:RemoveSession(v2.sid)
		v2 = findNodeWithMetadataKey(p, self.mockRootNode)
	end
end

function MockSessionService.generateSessionInfoString(_, _, _, _, _): string
	return ""
end

function MockSessionService.GetSessionTag(p, p2)
	local sid = findSid(p.mockRootNode, p2)
	return if sid == nil then "" else sid.tag
end

return MockSessionService
