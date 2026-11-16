local StarterPlayer = game:GetService("StarterPlayer")

require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/types")

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Logger"):new("ExpChat/Command/Emote")

local v6 = {
	wave = true,
	point = true,
	dance = true,
	dance1 = true,
	dance2 = true,
	dance3 = true,
	laugh = true,
	cheer = true
}

local function getDanceBasedOnRigType(instance)
	local v7 = nil
	local humanoid = instance:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return v7
	end

	if humanoid.RigType == Enum.HumanoidRigType.R15 then
		return "dance"
	end

	if humanoid.RigType == Enum.HumanoidRigType.R6 then
		v7 = "dance" .. math.random(1, 3)
	end

	return v7
end

local function handleLegacyEmote(p2, localCharacter)
	local success, result = pcall(function(): boolean
		local animate = localCharacter:FindFirstChild("Animate")

		if not animate then
			return false
		end

		local playEmote = animate:FindFirstChild("PlayEmote")

		if playEmote and playEmote:IsA("BindableFunction") then
			if p2 == "dance" then
				local v7 = nil
				local humanoid = localCharacter:FindFirstChildOfClass("Humanoid")

				if humanoid then
					if humanoid.RigType == Enum.HumanoidRigType.R15 then
						v7 = "dance"
					elseif humanoid.RigType == Enum.HumanoidRigType.R6 then
						v7 = "dance" .. math.random(1, 3)
					end
				end

				p2 = v7
			end

			playEmote:Invoke(p2)
			return true
		end

		v5:debug("PlayEmote BindableFunction does not exist.")

		return false
	end)

	if success and result then
		v5:debug("Playing legacy emote successfully")
	else
		return {
			key = "InGame.EmotesMenu.ErrorMessageNotSupported",
			metadata = "Roblox.Emote.Error.NotSupported"
		}
	end
end

local function getValidEmoteOrResponse(humanoidDescription, p2)
	local v7 = tonumber(p2, 10)

	if v7 then
		local equippedEmotes = humanoidDescription:GetEquippedEmotes()

		if equippedEmotes[v7] then
			return equippedEmotes[v7].Name, nil
		end

		if v7 >= 1 and v7 <= 8 then
			return
				nil,
				{
					key = "CoreScripts.TextChat.Emote.Error.NotEquipped",
					metadata = "Roblox.Emote.Error.EmoteNotEquipped"
				}
		end

		return
			nil,
			{
				key = "CoreScripts.TextChat.Emote.Error.DoesNotExist",
				metadata = "Roblox.Emote.Error.DoesNotExist"
			}
	else
		local emotes = humanoidDescription:GetEmotes()

		for k, emote in pairs(emotes) do
			if string.lower(k) == p2 then
				return k, nil
			end
		end

		return
			nil,
			{
				key = "CoreScripts.TextChat.Emote.Error.NotOwnedGeneric",
				metadata = "Roblox.Emote.Error.NotOwnedGeneric"
			}
	end
end

return {
	name = "RBXEmoteCommand",
	alias = { "/emote", "/e" },
	clientRun = function(object, p2, value)
		local v7 = nil

		if string.sub(value, 1, 3):lower() == "/e " then
			v7 = string.sub(value, 4)
		elseif string.sub(value, 1, 7):lower() == "/emote " then
			v7 = string.sub(value, 8)
		end

		if not v7 then
			v5:debug("No emote string given")
			return {
				key = "CoreScripts.TextChat.Emote.Error.DoesNotExist",
				metadata = "Roblox.Emote.Error.DoesNotExist"
			}
		end

		local v8 = string.lower(v7)

		local localCharacter = object:getState().LocalCharacter

		if v6[v8] then
			v5:trace("Legacy emote found")
			return handleLegacyEmote(v8, localCharacter)
		end

		if not StarterPlayer.UserEmotesEnabled then
			v5:debug("Experience does not have emotes enabled")
			return {
				key = "CoreScripts.TextChat.Emote.Error.NotEnabled",
				metadata = "Roblox.Emote.Error.UserEmotesNotEnabled"
			}
		end

		if not localCharacter then
			v5:debug("No character loaded")
			return {
				key = "InGame.EmotesMenu.ErrorMessageTemporarilyUnavailable",
				metadata = "Roblox.Emote.Error.TemporarilyUnavailable"
			}
		end

		if not localCharacter:FindFirstChild("Animate") then
			v5:debug("Animate script missing")
			return {
				key = "InGame.EmotesMenu.ErrorMessageNotSupported",
				metadata = "Roblox.Emote.Error.NotSupported"
			}
		end

		local humanoid = localCharacter:FindFirstChildOfClass("Humanoid")

		if not humanoid then
			v5:debug("Humanoid missing")
			return {
				key = "InGame.EmotesMenu.ErrorMessageTemporarilyUnavailable",
				metadata = "Roblox.Emote.Error.TemporarilyUnavailable"
			}
		end

		if humanoid.RigType ~= Enum.HumanoidRigType.R15 then
			v5:debug("Humanoid.RigType is not R15")
			return {
				key = "InGame.EmotesMenu.ErrorMessageSwitchToR15",
				metadata = "Roblox.Emote.Error.SwitchToR15"
			}
		end

		local humanoidDescription = humanoid:FindFirstChildOfClass("HumanoidDescription")

		if not humanoidDescription then
			v5:debug("HumanoidDescription missing")
			return {
				key = "InGame.EmotesMenu.ErrorMessageNotSupported",
				metadata = "Roblox.Emote.Error.NotSupported"
			}
		end

		local validEmoteOrResponse, v9 = getValidEmoteOrResponse(humanoidDescription, v8)

		if not validEmoteOrResponse then
			v5:debug("Could not find a valid emote within HumanoidDescription")
			return v9
		end

		local success, result = pcall(function()
			return humanoid:PlayEmoteAsync(validEmoteOrResponse)
		end)

		if success and result then
			v5:debug("Playing emote: {}", (tostring(validEmoteOrResponse)))

			return nil
		end

		v5:debug("Humanoid:PlayEmote encountered an error: {}", result)
		return {
			key = "InGame.EmotesMenu.ErrorMessageAnimationPlaying",
			metadata = "Roblox.Emote.Error.AnimationPlaying"
		}
	end
}
