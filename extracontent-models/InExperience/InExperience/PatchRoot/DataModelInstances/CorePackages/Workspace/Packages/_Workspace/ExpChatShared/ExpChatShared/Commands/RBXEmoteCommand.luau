local StarterPlayer = game:GetService("StarterPlayer")

require(script.Parent.types)

local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local v3 = require(ExpChatShared.Logger):new("ExpChat/Command/Emote")
local t1 = {
	wave = true,
	point = true,
	dance = true,
	dance1 = true,
	dance2 = true,
	dance3 = true,
	laugh = true,
	cheer = true
}

local function getDanceBasedOnRigType(p1) -- line: 18
	local v9 = nil
	local Humanoid = p1:FindFirstChildOfClass("Humanoid")

	if Humanoid then
		if Humanoid.RigType == Enum.HumanoidRigType.R15 then
			return "dance"
		end

		if Humanoid.RigType == Enum.HumanoidRigType.R6 then
			v9 = "dance" .. math.random(1, 3)
		end
	end

	return v9
end
local function handleLegacyEmote(s1: string, p2) -- line: 33
	-- upvalues: v3 (copy)
	local ok, result = pcall(function() -- line: 34
		-- upvalues: p2 (copy), s1 (ref), v3 (copy)
		local Animate = p2:FindFirstChild("Animate")

		if Animate then
			local PlayEmote = Animate:FindFirstChild("PlayEmote")

			if PlayEmote and PlayEmote:IsA("BindableFunction") then
				if s1 == "dance" then
					local s2 = nil
					local Humanoid = p2:FindFirstChildOfClass("Humanoid")

					if Humanoid then
						if Humanoid.RigType == Enum.HumanoidRigType.R15 then
							s2 = "dance"
						elseif Humanoid.RigType == Enum.HumanoidRigType.R6 then
							s2 = "dance" .. math.random(1, 3)
						end
					end

					s1 = s2
				end

				PlayEmote:Invoke(s1)

				return true
			end

			v3:debug("PlayEmote BindableFunction does not exist.")
		end

		return false
	end)

	if ok and result then
		v3:debug("Playing legacy emote successfully")

		return
	end

	return {
		key = "InGame.EmotesMenu.ErrorMessageNotSupported",
		metadata = "Roblox.Emote.Error.NotSupported"
	}
end
local function getValidEmoteOrResponse(p3, s3: string) -- line: 63
	local num = tonumber(s3, 10)

	if num then
		local EquippedEmotes = p3:GetEquippedEmotes()

		if EquippedEmotes[num] then
			return EquippedEmotes[num].Name, nil
		end

		if not (num >= 1) or not (num <= 8) then
			return nil, {
				key = "CoreScripts.TextChat.Emote.Error.DoesNotExist",
				metadata = "Roblox.Emote.Error.DoesNotExist"
			}
		end

		return nil, {
			key = "CoreScripts.TextChat.Emote.Error.NotEquipped",
			metadata = "Roblox.Emote.Error.EmoteNotEquipped"
		}
	end

	local Emotes = p3:GetEmotes()

	for k, _ in pairs(Emotes) do
		if s3 == string.lower(k) then
			return k, nil
		end
	end

	return nil, {
		key = "CoreScripts.TextChat.Emote.Error.NotOwnedGeneric",
		metadata = "Roblox.Emote.Error.NotOwnedGeneric"
	}
end

return {
	name = script.Name,
	alias = {
		"/emote",
		"/e"
	},
	clientRun = function(p4, _, p6) -- line: 105
		-- upvalues: v3 (copy), t1 (copy), handleLegacyEmote (copy), StarterPlayer (copy), getValidEmoteOrResponse (copy)
		local v26 = nil

		if string.sub(p6, 1, 3):lower() == "/e " then
			v26 = string.sub(p6, 4)
		elseif string.sub(p6, 1, 7):lower() == "/emote " then
			v26 = string.sub(p6, 8)
		end

		if not v26 then
			v3:debug("No emote string given")

			return {
				key = "CoreScripts.TextChat.Emote.Error.DoesNotExist",
				metadata = "Roblox.Emote.Error.DoesNotExist"
			}
		end

		local v27 = string.lower(v26)
		local LocalCharacter = p4:getState().LocalCharacter

		if t1[v27] then
			v3:trace("Legacy emote found")

			return handleLegacyEmote(v27, LocalCharacter)
		end

		if not StarterPlayer.UserEmotesEnabled then
			v3:debug("Experience does not have emotes enabled")

			return {
				key = "CoreScripts.TextChat.Emote.Error.NotEnabled",
				metadata = "Roblox.Emote.Error.UserEmotesNotEnabled"
			}
		end

		if not LocalCharacter then
			v3:debug("No character loaded")

			return {
				key = "InGame.EmotesMenu.ErrorMessageTemporarilyUnavailable",
				metadata = "Roblox.Emote.Error.TemporarilyUnavailable"
			}
		end

		if not LocalCharacter:FindFirstChild("Animate") then
			v3:debug("Animate script missing")

			return {
				key = "InGame.EmotesMenu.ErrorMessageNotSupported",
				metadata = "Roblox.Emote.Error.NotSupported"
			}
		end

		local Humanoid = LocalCharacter:FindFirstChildOfClass("Humanoid")

		if not Humanoid then
			v3:debug("Humanoid missing")

			return {
				key = "InGame.EmotesMenu.ErrorMessageTemporarilyUnavailable",
				metadata = "Roblox.Emote.Error.TemporarilyUnavailable"
			}
		end

		if Humanoid.RigType ~= Enum.HumanoidRigType.R15 then
			v3:debug("Humanoid.RigType is not R15")

			return {
				key = "InGame.EmotesMenu.ErrorMessageSwitchToR15",
				metadata = "Roblox.Emote.Error.SwitchToR15"
			}
		end

		local HumanoidDescription = Humanoid:FindFirstChildOfClass("HumanoidDescription")

		if not HumanoidDescription then
			v3:debug("HumanoidDescription missing")

			return {
				key = "InGame.EmotesMenu.ErrorMessageNotSupported",
				metadata = "Roblox.Emote.Error.NotSupported"
			}
		end

		local v31, v32 = getValidEmoteOrResponse(HumanoidDescription, v27)

		if not v31 then
			v3:debug("Could not find a valid emote within HumanoidDescription")

			return v32
		end

		local ok, result = pcall(function() -- line: 192
			-- upvalues: Humanoid (copy), v31 (copy)
			if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
				return Humanoid:PlayEmoteAsync(v31)
			end

			return Humanoid:PlayEmote(v31)
		end)

		if not ok or not result then
			v3:debug("Humanoid:PlayEmote encountered an error: {}", result)

			return {
				key = "InGame.EmotesMenu.ErrorMessageAnimationPlaying",
				metadata = "Roblox.Emote.Error.AnimationPlaying"
			}
		end

		v3:debug("Playing emote: {}", (tostring(v31)))

		return nil
	end
}
