require(script.Parent.types)

return {
	name = script.Name,
	alias = { "/clear", "/cls" },
	clientRun = function(_, _, _, p)
		if p and p.messagesStore then
			p.messagesStore.clearWindowMessages()

			return { key = "", metadata = "Roblox.Clear.Info.Success" }
		end

		return {
			key = "CoreScripts.TextChat.MessageStatus.Warning.Unknown",
			args = {},
			metadata = "Roblox.Clear.Error.ContextNotAvailable"
		}
	end
}
