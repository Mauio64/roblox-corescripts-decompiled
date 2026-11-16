local Players = game:GetService("Players")

require(script.Parent.types)

return {
	name = script.Name,
	alias = { "/unmute", "/um" },
	clientRun = function(_, _, value, p)
		local v = string.split(value, " ")[2]
		local v2

		if v == nil then
			v2 = false
		else
			v2 = string.sub(v, 1, 1) == "@"
		end

		if v2 then
			v = string.sub(v, 2)
		end

		if not v or #v < 3 then
			return {
				key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
				args = {
					RBX_NAME = v or ""
				},
				metadata = "Roblox.GlobalUnmute.Error.PlayerNotFound"
			}
		end

		if not (p and p.globalMutedUsersStore) then
			return {
				key = "CoreScripts.TextChat.MessageStatus.Warning.Unknown",
				args = {},
				metadata = "Roblox.GlobalUnmute.Error.ContextNotAvailable"
			}
		end

		if not v2 then
			p.globalMutedUsersStore.unmuteGlobalDisplayName(v)
			return {
				key = "CoreScripts.TextChat.Unmute.Success",
				args = { RBX_NAME = v },
				metadata = "Roblox.GlobalUnmute.Info.Success"
			}
		end

		local v3 = string.lower(v)

		if Players.LocalPlayer and string.lower(Players.LocalPlayer.Name) == v3 then
			return {
				key = "CoreScripts.TextChat.Mute.Error.CannotMuteSelf",
				args = {},
				metadata = "Roblox.GlobalUnmute.Error.CannotMuteSelf"
			}
		end

		p.globalMutedUsersStore.unmuteGlobalUsername(v3)
		return {
			key = "CoreScripts.TextChat.Unmute.Success",
			args = {
				RBX_NAME = "@" .. v3
			},
			metadata = "Roblox.GlobalUnmute.Info.Success"
		}
	end
}
