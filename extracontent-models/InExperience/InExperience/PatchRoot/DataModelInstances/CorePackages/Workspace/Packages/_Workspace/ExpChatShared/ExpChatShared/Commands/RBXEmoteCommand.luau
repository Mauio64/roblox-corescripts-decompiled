local StarterPlayer = game:GetService("StarterPlayer")

require(script.Parent.types)

local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local Logger = require(ExpChatShared.Logger)
local v = Logger:new("ExpChat/Command/Emote")

local v2 = {
	wave = true,
	point = true,
	dance = true,
	dance1 = true,
	dance2 = true,
	dance3 = true,
	laugh = true,
	cheer = true
}

local function getDanceBasedOnRigType(instance) -- 1 equivalent call inferred from this helper
	local v3 = nil
	local humanoid = instance:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return v3
	end

	if humanoid.RigType == Enum.HumanoidRigType.R15 then
		return "dance"
	end

	if humanoid.RigType == Enum.HumanoidRigType.R6 then
		return "dance" .. math.random(1, 3)
	end

	return v3
end

local function handleLegacyEmote(p: string, localCharacter)
	local success, result = pcall(function(): boolean
		local animate = localCharacter:FindFirstChild("Animate")

		if not animate then
			return false
		end

		local playEmote = animate:FindFirstChild("PlayEmote")

		if playEmote and playEmote:IsA("BindableFunction") then
			if p == "dance" then
				p = getDanceBasedOnRigType(localCharacter) -- inferred equivalent call
			end

			playEmote:Invoke(p)
			return true
		end

		v:debug("PlayEmote BindableFunction does not exist.")

		return false
	end)

	if success and result then
		v:debug("Playing legacy emote successfully")
	else
		return {
			key = "InGame.EmotesMenu.ErrorMessageNotSupported",
			metadata = "Roblox.Emote.Error.NotSupported"
		}
	end
end

local function getValidEmoteOrResponse(humanoidDescription, p: string)
	local v3 = tonumber(p, 10)

	if v3 then
		local equippedEmotes = humanoidDescription:GetEquippedEmotes()

		if equippedEmotes[v3] then
			return equippedEmotes[v3].Name, nil
		end

		if v3 >= 1 and v3 <= 8 then
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

		for k, _ in pairs(emotes) do
			if string.lower(k) == p then
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
	name = script.Name,
	alias = { "/emote", "/e" },
	clientRun = function(object, _, value)
		local v3 = nil

		if string.sub(value, 1, 3):lower() == "/e " then
			v3 = string.sub(value, 4)
		elseif string.sub(value, 1, 7):lower() == "/emote " then
			v3 = string.sub(value, 8)
		end

		if not v3 then
			v:debug("No emote string given")
			return {
				key = "CoreScripts.TextChat.Emote.Error.DoesNotExist",
				metadata = "Roblox.Emote.Error.DoesNotExist"
			}
		end

		local v4 = string.lower(v3)

		local localCharacter = object:getState().LocalCharacter

		if v2[v4] then
			v:trace("Legacy emote found")
			return handleLegacyEmote(v4, localCharacter)
		end

		if not StarterPlayer.UserEmotesEnabled then
			v:debug("Experience does not have emotes enabled")
			return {
				key = "CoreScripts.TextChat.Emote.Error.NotEnabled",
				metadata = "Roblox.Emote.Error.UserEmotesNotEnabled"
			}
		end

		if not localCharacter then
			v:debug("No character loaded")
			return {
				key = "InGame.EmotesMenu.ErrorMessageTemporarilyUnavailable",
				metadata = "Roblox.Emote.Error.TemporarilyUnavailable"
			}
		end

		if not localCharacter:FindFirstChild("Animate") then
			v:debug("Animate script missing")
			return {
				key = "InGame.EmotesMenu.ErrorMessageNotSupported",
				metadata = "Roblox.Emote.Error.NotSupported"
			}
		end

		local humanoid = localCharacter:FindFirstChildOfClass("Humanoid")

		if not humanoid then
			v:debug("Humanoid missing")
			return {
				key = "InGame.EmotesMenu.ErrorMessageTemporarilyUnavailable",
				metadata = "Roblox.Emote.Error.TemporarilyUnavailable"
			}
		end

		if humanoid.RigType ~= Enum.HumanoidRigType.R15 then
			v:debug("Humanoid.RigType is not R15")
			return {
				key = "InGame.EmotesMenu.ErrorMessageSwitchToR15",
				metadata = "Roblox.Emote.Error.SwitchToR15"
			}
		end

		local humanoidDescription = humanoid:FindFirstChildOfClass("HumanoidDescription")

		if not humanoidDescription then
			v:debug("HumanoidDescription missing")
			return {
				key = "InGame.EmotesMenu.ErrorMessageNotSupported",
				metadata = "Roblox.Emote.Error.NotSupported"
			}
		end

		local validEmoteOrResponse, v5 = getValidEmoteOrResponse(humanoidDescription, v4)

		if not validEmoteOrResponse then
			v:debug("Could not find a valid emote within HumanoidDescription")
			return v5
		end

		local success, result = pcall(function()
			return humanoid:PlayEmoteAsync(validEmoteOrResponse)
		end)

		if success and result then
			v:debug("Playing emote: {}", (tostring(validEmoteOrResponse)))

			return nil
		end

		v:debug("Humanoid:PlayEmote encountered an error: {}", result)
		return {
			key = "InGame.EmotesMenu.ErrorMessageAnimationPlaying",
			metadata = "Roblox.Emote.Error.AnimationPlaying"
		}
	end
}
