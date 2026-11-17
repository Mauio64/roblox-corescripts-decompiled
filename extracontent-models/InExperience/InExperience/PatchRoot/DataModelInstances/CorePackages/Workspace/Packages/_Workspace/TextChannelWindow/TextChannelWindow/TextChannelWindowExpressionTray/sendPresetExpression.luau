local TextChannelWindow = script:FindFirstAncestor("TextChannelWindow")
local Logger = require(TextChannelWindow.Logger)
local sendPreset = require(script.Parent.sendPreset)

local function sendPresetExpression(p: string, p2): boolean
	local v = sendPreset(p, p2)

	if v == "Sent" then
		return true
	end

	if v == "NoChannel" then
		Logger:warning("Preset not sent: no reachable channel")
	elseif v == "DirectChat" then
		Logger:warning("Preset not sent: direct chats do not support Quick Words")
	end

	return false
end

return sendPresetExpression
