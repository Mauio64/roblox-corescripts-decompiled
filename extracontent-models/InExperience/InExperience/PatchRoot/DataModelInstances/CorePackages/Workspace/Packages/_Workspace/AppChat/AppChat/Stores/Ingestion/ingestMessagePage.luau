local parent = script:FindFirstAncestor("AppChat").Parent

require(parent.AppChatNetworking)

local buildValidMessages = require(script.Parent.buildValidMessages)
local ingestBatch = require(script.Parent.ingestBatch)
local IngestOperation = require(script.Parent.IngestOperation)

local function ingestMessagePage(p: string, p2)
	return ingestBatch(p, buildValidMessages(p, p2), IngestOperation.Append)
end

return ingestMessagePage
