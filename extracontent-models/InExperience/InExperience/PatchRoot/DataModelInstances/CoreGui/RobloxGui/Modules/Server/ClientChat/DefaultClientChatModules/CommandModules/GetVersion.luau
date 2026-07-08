local Util = require(script.Parent:WaitForChild("Util"))
local ChatConstants = require(script.Parent.Parent:WaitForChild("ChatConstants"))

local function ProcessMessage(p1, p2, _) -- line: 9
	-- upvalues: Util (copy), ChatConstants (copy)
	if string.sub(p1, 1, 8):lower() == "/version" or string.sub(p1, 1, 9):lower() == "/version " then
		Util:SendSystemMessageToSelf(string.format("This experience is running chat version [%d.%d.%s].", ChatConstants.MajorVersion, ChatConstants.MinorVersion, ChatConstants.BuildVersion), p2:GetCurrentChannel(), {})

		return true
	end

	return false
end

return {
	[Util.KEY_COMMAND_PROCESSOR_TYPE] = Util.COMPLETED_MESSAGE_PROCESSOR,
	[Util.KEY_PROCESSOR_FUNCTION] = ProcessMessage
}
