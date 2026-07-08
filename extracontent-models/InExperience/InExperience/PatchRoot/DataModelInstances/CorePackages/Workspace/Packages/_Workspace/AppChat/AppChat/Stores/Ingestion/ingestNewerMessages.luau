local Parent = script:FindFirstAncestor("AppChat").Parent

require(Parent.AppChatNetworking)

local buildValidMessages = require(script.Parent.buildValidMessages)
local ingestBatch = require(script.Parent.ingestBatch)
local IngestOperation = require(script.Parent.IngestOperation)

local function ingestNewerMessages(s1: string, t1: {[any]: any}) -- line: 22
	-- upvalues: buildValidMessages (copy), ingestBatch (copy), IngestOperation (copy)
	local v8 = buildValidMessages(s1, t1)

	return ingestBatch(s1, v8, IngestOperation.Prepend)
end

return ingestNewerMessages
