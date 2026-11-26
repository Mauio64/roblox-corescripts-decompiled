require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/types")

return {
	name = "RBXClearCommand",
	alias = { "/clear", "/cls" },
	clientRun = function(p2, p3, p4, p5)
		if p5 and p5.messagesStore then
			p5.messagesStore.clearWindowMessages()

			return { key = "", metadata = "Roblox.Clear.Info.Success" }
		end

		return {
			key = "CoreScripts.TextChat.MessageStatus.Warning.Unknown",
			args = {},
			metadata = "Roblox.Clear.Error.ContextNotAvailable"
		}
	end
}
