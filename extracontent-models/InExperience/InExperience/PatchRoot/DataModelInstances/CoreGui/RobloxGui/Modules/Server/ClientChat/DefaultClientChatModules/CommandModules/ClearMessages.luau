local Util = require(script.Parent:WaitForChild("Util"))

function ProcessMessage(value, object, _): boolean
	if string.sub(value, 1, 4):lower() ~= "/cls" and string.sub(value, 1, 6):lower() ~= "/clear" then
		return false
	end

	local currentChannel = object:GetCurrentChannel()

	if currentChannel then
		currentChannel:ClearMessageLog()
	end

	return true
end

return {
	[Util.KEY_COMMAND_PROCESSOR_TYPE] = Util.COMPLETED_MESSAGE_PROCESSOR,
	[Util.KEY_PROCESSOR_FUNCTION] = ProcessMessage
}
