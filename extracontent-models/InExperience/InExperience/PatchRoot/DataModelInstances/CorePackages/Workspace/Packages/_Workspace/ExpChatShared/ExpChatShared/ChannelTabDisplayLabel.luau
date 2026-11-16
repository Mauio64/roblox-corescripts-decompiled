local TabTypes = require(script.Parent.TabTypes)
local getOtherDisplayNameInWhisperChannel = require(script.Parent.getOtherDisplayNameInWhisperChannel)

return {
	LocalizationKeys = {
		yourServer = "CoreScripts.TextChat.ChannelTabs.Here",
		moreServers = "CoreScripts.TextChat.ChannelTabs.Global2",
		friends = "CoreScripts.TextChat.ChannelTabs.Friends",
		system = "CoreScripts.TextChat.ChannelTabs.System",
		team = "CoreScripts.TextChat.ChannelTabs.Team"
	},
	getDisplayLabel = function(p, value: string, p2, p3, data)
		if p == "TextChat" then
			if string.find(value, "RBXGeneral") then
				return data.yourServer
			end

			if string.find(value, "RBXSystem") then
				return data.system
			end

			if string.find(value, "^RBXTeam") then
				return data.team
			end

			if string.find(value, "^RBXWhisper") and p2 and p3 then
				return getOtherDisplayNameInWhisperChannel(p2, p3) or value
			end
		elseif p == "UniverseChat" then
			if string.find(value, "RBXGlobal") then
				return data.moreServers
			end
		elseif p == "FriendsChat" then
			return data.friends
		else
			TabTypes.unreachable(p)
		end

		return value
	end
}
