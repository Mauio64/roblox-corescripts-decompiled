local Players = game:GetService("Players")

require(script.Parent.types)

return {
	name = script.Name,
	alias = {
		"/unmute",
		"/um"
	},
	clientRun = function(_, _, p3, p4) -- line: 8
		-- upvalues: Players (copy)
		local v6 = string.split(p3, " ")[2]
		local v7 = v6 ~= nil and string.sub(v6, 1, 1) == "@"
		local v8 = if not v7 then v6 else string.sub(v6, 2)

		if not v8 or #v8 < 3 then
			return {
				key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
				metadata = "Roblox.GlobalUnmute.Error.PlayerNotFound",
				args = {
					RBX_NAME = v8 or ""
				}
			}
		end

		if not p4 or not p4.globalMutedUsersStore then
			return {
				key = "CoreScripts.TextChat.MessageStatus.Warning.Unknown",
				metadata = "Roblox.GlobalUnmute.Error.ContextNotAvailable",
				args = {}
			}
		end

		if v7 then
			local v9 = string.lower(v8)

			if Players.LocalPlayer and v9 == string.lower(Players.LocalPlayer.Name) then
				return {
					key = "CoreScripts.TextChat.Mute.Error.CannotMuteSelf",
					metadata = "Roblox.GlobalUnmute.Error.CannotMuteSelf",
					args = {}
				}
			end

			p4.globalMutedUsersStore.unmuteGlobalUsername(v9)

			return {
				key = "CoreScripts.TextChat.Unmute.Success",
				metadata = "Roblox.GlobalUnmute.Info.Success",
				args = {
					RBX_NAME = "@" .. v9
				}
			}
		end

		p4.globalMutedUsersStore.unmuteGlobalDisplayName(v8)

		return {
			key = "CoreScripts.TextChat.Unmute.Success",
			metadata = "Roblox.GlobalUnmute.Info.Success",
			args = {
				RBX_NAME = v8
			}
		}
	end
}
