local Util = require(script.Parent:WaitForChild("Util"))

function ProcessMessage(p1, p2, _) -- line: 8
	if string.sub(p1, 1, 4):lower() == "/cls" or string.sub(p1, 1, 6):lower() == "/clear" then
		local CurrentChannel = p2:GetCurrentChannel()

		if CurrentChannel then
			CurrentChannel:ClearMessageLog()
		end

		return true
	end

	return false
end

return {
	[Util.KEY_COMMAND_PROCESSOR_TYPE] = Util.COMPLETED_MESSAGE_PROCESSOR,
	[Util.KEY_PROCESSOR_FUNCTION] = ProcessMessage
}
