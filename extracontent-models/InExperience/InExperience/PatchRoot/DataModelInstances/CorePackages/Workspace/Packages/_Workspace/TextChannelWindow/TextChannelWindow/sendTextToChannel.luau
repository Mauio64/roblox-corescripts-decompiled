local TextChannelWindow = script:FindFirstAncestor("TextChannelWindow")
local parent = TextChannelWindow.Parent
local TextChannelWindowAnalytics = require(TextChannelWindow.TextChannelWindowAnalytics)
local Logger = require(TextChannelWindow.Logger)
local SharedFlags = require(parent.SharedFlags)
local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs

local function sendTextToChannel(object, p: string)
	local success, result = pcall(function()
		if getFFlagExpChatProtectedChatInternalAPIs() then
			object:SendInternalAsync(p)
		else
			object:SendAsync(p)
		end
	end)

	if not success then
		Logger:warning("SendAsync failed: {}", result)
	end

	TextChannelWindowAnalytics.emit(TextChannelWindowAnalytics.Counters.Send, {
		result = success and "success" or "failure",
		has_target = true,
		target_text_channel_category = TextChannelWindowAnalytics.getChannelCategory(object.Name)
	})

	return success
end

return sendTextToChannel
