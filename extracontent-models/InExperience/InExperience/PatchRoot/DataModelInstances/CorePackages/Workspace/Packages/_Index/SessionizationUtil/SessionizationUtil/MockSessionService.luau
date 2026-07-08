local Parent = script:FindFirstAncestor("SessionizationUtil").Parent
local Signal = require(Parent.AppCommonLib).Signal
local t1 = {}

t1.__index = t1

function t1.new(s1: string, s2: string) -- line: 10
	-- upvalues: t1 (copy)
	local t2 = {
		parent = nil,
		sid = s1,
		tag = s2,
		metadata = {},
		children = {},
		timestamp = tick()
	}

	setmetatable(t2, {
		__index = t1
	})

	return t2
end
function t1.addChild(p1, p2, p3) -- line: 27
	-- upvalues: t1 (copy)
	local v11 = t1.new(p2, p3)

	v11.parent = p1
	p1.children[p2] = v11
end
function t1.dump(p4, p5, p6) -- line: 34
	local v15 = p6 .. `{ p5 } sid: { p4.sid }, tag: { p4.tag }\n`
	local v16 = p5 .. "----"

	for _, v18 in p4.children do
		v15 = v18:dump(v16, v15)
	end

	return v15
end
function findSid(p7, p8) -- line: 44
	if p8 == p7.sid then
		return p7
	end

	for _, v22 in p7.children do
		local v23 = findSid(v22, p8)

		if v23 ~= nil then
			return v23
		end
	end

	return nil
end

local t3 = {
	MOCK_ROOT_SID = "MOCK_ROOT_SID"
}

t3.__index = t3

function t3.new() -- line: 65
	-- upvalues: t1 (copy), t3 (copy), Signal (copy)
	local t4 = {
		mockRootNode = t1.new(t3.MOCK_ROOT_SID, t3.MOCK_ROOT_SID),
		SessionChangedSignal = Signal.new()
	}

	setmetatable(t4, {
		__index = t3
	})

	return t4
end
function t3._resetMockData(p9) -- line: 78
	-- upvalues: t1 (copy), t3 (copy)
	p9.mockRootNode = t1.new(t3.MOCK_ROOT_SID, t3.MOCK_ROOT_SID)
end
function t3._findSid(p10, p11) -- line: 82
	return findSid(p10.mockRootNode, p11)
end
function t3._dumpSessionTree(p12) -- line: 86
	if p12.mockRootNode ~= nil then
		return p12.mockRootNode:dump("", "")
	end

	return "Root node is nil!"
end
function t3.GetRootSID(p13) -- line: 94
	return p13.MOCK_ROOT_SID
end
function t3.SetSession(p14, p15, p16, p17) -- line: 98
	(findSid(p14.mockRootNode, p15) or p14.mockRootNode):addChild(p16, p17)
end
function t3.ReplaceSession(p18, p19, p20) -- line: 104
	local v37 = findSid(p18.mockRootNode, p19)

	if v37 ~= nil and v37.parent ~= nil then
		v37.parent.children[p19] = nil
		v37.parent:addChild(p19, p20)
	end
end
function t3.RemoveSession(p21, p22) -- line: 114
	local v40 = findSid(p21.mockRootNode, p22)

	if v40 ~= nil then
		local parent = v40.parent

		if parent ~= nil then
			parent.children[p22] = nil
		end
	end
end
function t3.GetMetadata(p23, p24, p25) -- line: 124
	local v45 = findSid(p23.mockRootNode, p24)

	if v45 ~= nil then
		return v45.metadata[p25]
	end

	return nil
end
function t3.SetMetadata(p26, p27, p28, p29) -- line: 133
	local v50 = findSid(p26.mockRootNode, p27)

	if v50 ~= nil then
		v50.metadata[p28] = p29
	end
end
function t3.SessionExists(p30, p31) -- line: 140
	return findSid(p30.mockRootNode, p31) ~= nil
end
function t3.RemoveSessionsWithMetadataKey(p32, p33) -- line: 145
	if p33 == nil then
		return
	end

	local function findNodeWithMetadataKey(p34, p35) -- line: 150
		-- upvalues: findNodeWithMetadataKey (copy)
		if p35 ~= nil then
			if p35.metadata[p34] ~= nil then
				return p35
			end

			for _, v68 in p35.children do
				local v69 = findNodeWithMetadataKey(p34, v68)

				if v69 ~= nil then
					return v69
				end
			end
		end

		return nil
	end

	local v56 = findNodeWithMetadataKey(p33, p32.mockRootNode)

	while v56 ~= nil do
		p32:RemoveSession(v56.sid)
		v56 = findNodeWithMetadataKey(p33, p32.mockRootNode)
	end
end
function t3.generateSessionInfoString(_, _, _, _, _) -- line: 174
	return ""
end
function t3.GetSessionTag(p41, p42) -- line: 183
	local v64 = findSid(p41.mockRootNode, p42)

	if v64 ~= nil then
		return v64.tag
	end

	return ""
end

return t3
