local Parent = script:FindFirstAncestor("AppChat").Parent

require(Parent.AppChatNetworking)

local buildValidMessages = require(script.Parent.buildValidMessages)
local ingestBatch = require(script.Parent.ingestBatch)
local IngestOperation = require(script.Parent.IngestOperation)

local function ingestOlderMessages(s1: string, t1: {[any]: any}, s2: string?) -- line: 23
	-- upvalues: buildValidMessages (copy), ingestBatch (copy), IngestOperation (copy)
	local v9 = buildValidMessages(s1, t1)

	return ingestBatch(s1, v9, IngestOperation.AppendAndAdvanceCursor, s2)
end

return ingestOlderMessages
