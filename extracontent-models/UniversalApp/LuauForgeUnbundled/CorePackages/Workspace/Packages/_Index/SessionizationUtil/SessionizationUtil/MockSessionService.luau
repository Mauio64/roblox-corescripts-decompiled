local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/SessionizationUtil/AppCommonLib").Signal

local v5 = {}
v5.__index = v5

function v5.new(p2, p3)
	local v6 = {
		sid = p2,
		tag = p3,
		metadata = {},
		children = {},
		timestamp = tick(),
		parent = nil
	}

	setmetatable(v6, { __index = v5 })

	return v6
end

function v5:addChild(p2, p3)
	local v6 = v5.new(p2, p3)
	v6.parent = self
	self.children[p2] = v6
end

function v5:dump(p2, p3)
	local v6 = p3 .. `{p2} sid: {self.sid}, tag: {self.tag}\n`
	local v7 = p2 .. "----"

	for k, child in self.children do
		v6 = child:dump(v7, v6)
	end

	return v6
end

function LUAUFORGE_MODULE_GLOBALS_hVE_findSid(p2, p3)
	if p2.sid == p3 then
		return p2
	end

	for k, child in p2.children do
		local v6 = LUAUFORGE_MODULE_GLOBALS_hVE_findSid(child, p3)

		if v6 ~= nil then
			return v6
		end
	end

	return nil
end

local v6 = { MOCK_ROOT_SID = "MOCK_ROOT_SID" }

v6.__index = v6

function v6.new()
	local v7 = {
		mockRootNode = v5.new(v6.MOCK_ROOT_SID, v6.MOCK_ROOT_SID),
		SessionChangedSignal = signal.new()
	}

	setmetatable(v7, { __index = v6 })

	return v7
end

function v6:_resetMockData()
	self.mockRootNode = v5.new(v6.MOCK_ROOT_SID, v6.MOCK_ROOT_SID)
end

function v6._findSid(p2, p3)
	return LUAUFORGE_MODULE_GLOBALS_hVE_findSid(p2.mockRootNode, p3)
end

function v6._dumpSessionTree(p2)
	if p2.mockRootNode == nil then
		return "Root node is nil!"
	end

	return p2.mockRootNode:dump("", "")
end

function v6:GetRootSID()
	return self.MOCK_ROOT_SID
end

function v6:SetSession(p3, p4, p5)
	(LUAUFORGE_MODULE_GLOBALS_hVE_findSid(self.mockRootNode, p3) or self.mockRootNode):addChild(p4, p5)
end

function v6:ReplaceSession(p3, p4)
	local v7 = LUAUFORGE_MODULE_GLOBALS_hVE_findSid(self.mockRootNode, p3)

	if v7 ~= nil and v7.parent ~= nil then
		v7.parent.children[p3] = nil
		v7.parent:addChild(p3, p4)
	end
end

function v6:RemoveSession(p3)
	local v7 = LUAUFORGE_MODULE_GLOBALS_hVE_findSid(self.mockRootNode, p3)

	if v7 ~= nil then
		local parent = v7.parent

		if parent ~= nil then
			parent.children[p3] = nil
		end
	end
end

function v6.GetMetadata(p2, p3, p4)
	local v7 = LUAUFORGE_MODULE_GLOBALS_hVE_findSid(p2.mockRootNode, p3)

	if v7 == nil then
		return nil
	end

	return v7.metadata[p4]
end

function v6:SetMetadata(p3, p4, p5)
	local v7 = LUAUFORGE_MODULE_GLOBALS_hVE_findSid(self.mockRootNode, p3)

	if v7 ~= nil then
		v7.metadata[p4] = p5
	end
end

function v6:SessionExists(p3): boolean
	return LUAUFORGE_MODULE_GLOBALS_hVE_findSid(self.mockRootNode, p3) ~= nil
end

function v6:RemoveSessionsWithMetadataKey(p2)
	if p2 == nil then
		return
	end

	local function findNodeWithMetadataKey(p3, mockRootNode)
		if mockRootNode == nil then
			return nil
		end

		if mockRootNode.metadata[p3] ~= nil then
			return mockRootNode
		end

		for k, child in mockRootNode.children do
			local v7 = findNodeWithMetadataKey(p3, child)

			if v7 ~= nil then
				return v7
			end
		end

		return nil
	end

	local v7 = findNodeWithMetadataKey(p2, self.mockRootNode)

	while v7 ~= nil do
		self:RemoveSession(v7.sid)
		v7 = findNodeWithMetadataKey(p2, self.mockRootNode)
	end
end

function v6:generateSessionInfoString(p3, p4, p5, p6): string
	return ""
end

function v6:GetSessionTag(p3)
	local v7 = LUAUFORGE_MODULE_GLOBALS_hVE_findSid(self.mockRootNode, p3)

	if v7 == nil then
		return ""
	end

	return v7.tag
end

return v6
