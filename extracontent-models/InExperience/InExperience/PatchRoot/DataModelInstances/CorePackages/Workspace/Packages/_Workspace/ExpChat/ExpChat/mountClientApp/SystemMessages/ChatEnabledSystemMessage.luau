local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local ExpChatShared = require(parent.ExpChatShared)

local displaySystemMessage = require(ExpChat.displaySystemMessage)

local v = ExpChatShared.Flags.FFlagExpChatUseUpdatedUserCountStrings
	and "CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithOnlinePlayers.BelowThreshold"
	or "CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithOnlinePlayers.V3"

local function createDisplayChatEnabledMessage(data)
	local translator = data.translator
	local defaultSystemTextChannel = data.defaultSystemTextChannel
	local displayVirtualSystemMessage = data.displayVirtualSystemMessage

	return function()
		if displayVirtualSystemMessage then
			displayVirtualSystemMessage(v, nil, "👋 Say hi to everyone playing now!")
		else
			displaySystemMessage(
				v,
				nil,
				"Roblox.ChatEnabled.Info",
				translator,
				defaultSystemTextChannel,
				"👋 Say hi to everyone playing now!"
			)
		end
	end
end

return createDisplayChatEnabledMessage
