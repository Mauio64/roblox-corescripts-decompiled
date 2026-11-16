local parent = script.Parent.Parent
local ChatConstants = require(parent:WaitForChild("ChatConstants"))

local v = {}
local class = {}
class.__index = class

function class.SendSystemMessageToSelf(_, message, object, extraData)
	object:AddMessageToChannel({
		ID = -1,
		FromSpeaker = nil,
		SpeakerUserId = 0,
		OriginalChannel = object.Name,
		IsFiltered = true,
		MessageLength = string.len(message),
		MessageLengthUtf8 = utf8.len(utf8.nfcnormalize(message)),
		Message = message,
		MessageType = ChatConstants.MessageTypeSystem,
		Time = os.time(),
		ExtraData = extraData
	})
end

function v.new()
	local self = setmetatable({}, class)

	self.COMMAND_MODULES_VERSION = 1

	self.KEY_COMMAND_PROCESSOR_TYPE = "ProcessorType"
	self.KEY_PROCESSOR_FUNCTION = "ProcessorFunction"

	self.IN_PROGRESS_MESSAGE_PROCESSOR = 0
	self.COMPLETED_MESSAGE_PROCESSOR = 1

	return self
end

return v.new()
