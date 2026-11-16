local parent = script:FindFirstAncestor("AppChat").Parent

require(parent.AppChatNetworking)

local buildValidMessages = require(script.Parent.buildValidMessages)
local ingestBatch = require(script.Parent.ingestBatch)
local IngestOperation = require(script.Parent.IngestOperation)

local function ingestOlderMessages(p: string, p2, p3: string?)
	return ingestBatch(p, buildValidMessages(p, p2), IngestOperation.AppendAndAdvanceCursor, p3)
end

return ingestOlderMessages
