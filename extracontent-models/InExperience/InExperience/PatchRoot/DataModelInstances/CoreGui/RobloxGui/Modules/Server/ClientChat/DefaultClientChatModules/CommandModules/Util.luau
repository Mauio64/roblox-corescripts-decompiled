local ParentParent = script.Parent.Parent
local ChatConstants = require(ParentParent:WaitForChild("ChatConstants"))
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.SendSystemMessageToSelf(_, p2, p3, p4) -- line: 31
	-- upvalues: ChatConstants (copy)
	p3:AddMessageToChannel({
		ID = -1,
		FromSpeaker = nil,
		SpeakerUserId = 0,
		IsFiltered = true,
		OriginalChannel = p3.Name,
		MessageLength = string.len(p2),
		MessageLengthUtf8 = utf8.len(utf8.nfcnormalize(p2)),
		Message = p2,
		MessageType = ChatConstants.MessageTypeSystem,
		Time = os.time(),
		ExtraData = p4
	})
end
function t1.new() -- line: 50
	-- upvalues: t2 (copy)
	local self = setmetatable({}, t2)

	self.COMMAND_MODULES_VERSION = 1
	self.KEY_COMMAND_PROCESSOR_TYPE = "ProcessorType"
	self.KEY_PROCESSOR_FUNCTION = "ProcessorFunction"
	self.IN_PROGRESS_MESSAGE_PROCESSOR = 0
	self.COMPLETED_MESSAGE_PROCESSOR = 1

	return self
end

return t1.new()
