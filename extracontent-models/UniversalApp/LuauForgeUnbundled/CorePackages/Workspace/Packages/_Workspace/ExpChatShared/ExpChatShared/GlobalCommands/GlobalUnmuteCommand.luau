local Players = game:GetService("Players")

require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/GlobalCommands/types")

return {
	name = "GlobalUnmuteCommand",
	alias = { "/unmute", "/um" },
	clientRun = function(p2, p3, value, p4)
		local v5 = string.split(value, " ")[2]
		local v6 = not (v5 == nil) and string.sub(v5, 1, 1) == "@"

		if v6 then
			v5 = string.sub(v5, 2)
		end

		if not v5 or #v5 < 3 then
			return {
				key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
				args = {
					RBX_NAME = v5 or ""
				},
				metadata = "Roblox.GlobalUnmute.Error.PlayerNotFound"
			}
		end

		if not (p4 and p4.globalMutedUsersStore) then
			return {
				key = "CoreScripts.TextChat.MessageStatus.Warning.Unknown",
				args = {},
				metadata = "Roblox.GlobalUnmute.Error.ContextNotAvailable"
			}
		end

		if not v6 then
			p4.globalMutedUsersStore.unmuteGlobalDisplayName(v5)
			return {
				key = "CoreScripts.TextChat.Unmute.Success",
				args = { RBX_NAME = v5 },
				metadata = "Roblox.GlobalUnmute.Info.Success"
			}
		end

		local v7 = string.lower(v5)

		if Players.LocalPlayer and string.lower(Players.LocalPlayer.Name) == v7 then
			return {
				key = "CoreScripts.TextChat.Mute.Error.CannotMuteSelf",
				args = {},
				metadata = "Roblox.GlobalUnmute.Error.CannotMuteSelf"
			}
		end

		p4.globalMutedUsersStore.unmuteGlobalUsername(v7)
		return {
			key = "CoreScripts.TextChat.Unmute.Success",
			args = {
				RBX_NAME = "@" .. v7
			},
			metadata = "Roblox.GlobalUnmute.Info.Success"
		}
	end
}
