local TabTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/TabTypes")
local getOtherDisplayNameInWhisperChannel = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/getOtherDisplayNameInWhisperChannel")

return {
	LocalizationKeys = {
		yourServer = "CoreScripts.TextChat.ChannelTabs.Here",
		moreServers = "CoreScripts.TextChat.ChannelTabs.Global2",
		friends = "CoreScripts.TextChat.ChannelTabs.Friends",
		system = "CoreScripts.TextChat.ChannelTabs.System",
		team = "CoreScripts.TextChat.ChannelTabs.Team"
	},
	getDisplayLabel = function(p2, value, p3, p4, data)
		if p2 == "TextChat" then
			if string.find(value, "RBXGeneral") then
				return data.yourServer
			end

			if string.find(value, "RBXSystem") then
				return data.system
			end

			if string.find(value, "^RBXTeam") then
				return data.team
			end

			if string.find(value, "^RBXWhisper") and p3 and p4 then
				return getOtherDisplayNameInWhisperChannel(p3, p4) or value
			end
		elseif p2 == "UniverseChat" then
			if string.find(value, "RBXGlobal") then
				return data.moreServers
			end
		elseif p2 == "FriendsChat" then
			return data.friends
		else
			TabTypes.unreachable(p2)
		end

		return value
	end
}
