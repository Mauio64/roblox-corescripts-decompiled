local Chat = game:GetService("Chat")
local Players = game:GetService("Players")
local scriptParent = script.Parent
local Util = require(scriptParent:WaitForChild("Util"))
local ChatLocalization = nil

pcall(function() -- line: 13
	-- upvalues: ChatLocalization (ref), Chat (copy)
	ChatLocalization = require(Chat.ClientChatModules.ChatLocalization)
end)

if ChatLocalization == nil then
	ChatLocalization = {
		Get = function(_, _, p3) -- line: 14
			return p3
		end
	}
end

local LocalPlayer = Players.LocalPlayer
local t1 = {
	wave = true,
	point = true,
	dance = true,
	dance2 = true,
	dance3 = true,
	laugh = true,
	cheer = true
}
local _ = {
	NotSupported = "InGame.Chat.Response.EmotesNotSupported",
	R15Only = "InGame.Chat.Response.EmotesWrongAvatarType",
	SwitchToR15 = "InGame.Chat.ErrorMessageSwitchToR15",
	NoMatchingEmote = "InGame.Chat.Response.EmoteNotAvailable",
	TemporarilyUnavailable = "InGame.Chat.Response.EmotesTemporarilyUnavailable",
	AnimationPlaying = "InGame.Chat.ErrorMessageAnimationPlaying"
}
local t2 = {
	["InGame.Chat.Response.EmotesNotSupported"] = "You can't use Emotes here.",
	["InGame.Chat.Response.EmotesWrongAvatarType"] = "Only R15 avatars can use Emotes.",
	["InGame.Chat.ErrorMessageSwitchToR15"] = "Switch to your R15 avatar to play Emote.",
	["InGame.Chat.Response.EmoteNotAvailable"] = "You can't use that Emote.",
	["InGame.Chat.Response.EmotesTemporarilyUnavailable"] = "You can't use Emotes right now.",
	["InGame.Chat.ErrorMessageAnimationPlaying"] = "You cannot play Emotes during this action."
}
local color3 = Color3.fromRGB(245, 50, 50)

local function getEmoteName(p4) -- line: 48
	if string.sub(p4, 1, 3) == "/e " then
		return (string.sub(p4, 4))
	end

	if string.sub(p4, 1, 7) == "/emote " then
		return (string.sub(p4, 8))
	end

	return nil
end
local function sendErrorMessage(p5, p6) -- line: 58
	-- upvalues: ChatLocalization (ref), t2 (copy), color3 (copy), Util (copy)
	local v20 = ChatLocalization:Get(p6, t2[p6])
	local t3 = {
		ChatColor = color3
	}

	Util:SendSystemMessageToSelf(v20, p5, t3)
end
local function ProcessMessage(p7, p8, _) -- line: 67
	-- upvalues: t1 (copy), LocalPlayer (copy), ChatLocalization (ref), t2 (copy), color3 (copy), Util (copy)
	local v25 = if string.sub(p7, 1, 3) ~= "/e " then if string.sub(p7, 1, 7) ~= "/emote " then nil else string.sub(p7, 8) else string.sub(p7, 4)

	if not v25 then
		return false
	end

	if t1[v25] then
		return true
	end

	local CurrentChannel = p8:GetCurrentChannel()

	if not CurrentChannel then
		return true
	end

	local Character = LocalPlayer.Character

	if not Character then
		local v28 = ChatLocalization:Get("InGame.Chat.Response.EmotesTemporarilyUnavailable", t2["InGame.Chat.Response.EmotesTemporarilyUnavailable"])
		local t4 = {
			ChatColor = color3
		}

		Util:SendSystemMessageToSelf(v28, CurrentChannel, t4)

		return true
	end

	local Animate = Character:FindFirstChild("Animate")

	if not Animate then
		local v31 = ChatLocalization:Get("InGame.Chat.Response.EmotesNotSupported", t2["InGame.Chat.Response.EmotesNotSupported"])
		local t5 = {
			ChatColor = color3
		}

		Util:SendSystemMessageToSelf(v31, CurrentChannel, t5)

		return true
	end

	if not Animate:FindFirstChild("PlayEmote") then
		local v33 = ChatLocalization:Get("InGame.Chat.Response.EmotesNotSupported", t2["InGame.Chat.Response.EmotesNotSupported"])
		local t6 = {
			ChatColor = color3
		}

		Util:SendSystemMessageToSelf(v33, CurrentChannel, t6)

		return true
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		local v36 = ChatLocalization:Get("InGame.Chat.Response.EmotesTemporarilyUnavailable", t2["InGame.Chat.Response.EmotesTemporarilyUnavailable"])
		local t7 = {
			ChatColor = color3
		}

		Util:SendSystemMessageToSelf(v36, CurrentChannel, t7)

		return true
	end

	if Humanoid.RigType ~= Enum.HumanoidRigType.R15 then
		local v38 = ChatLocalization:Get("InGame.Chat.Response.EmotesWrongAvatarType", t2["InGame.Chat.Response.EmotesWrongAvatarType"])
		local t8 = {
			ChatColor = color3
		}

		Util:SendSystemMessageToSelf(v38, CurrentChannel, t8)

		return true
	end

	local HumanoidDescription = Humanoid:FindFirstChildOfClass("HumanoidDescription")

	if not HumanoidDescription then
		local v41 = ChatLocalization:Get("InGame.Chat.Response.EmotesTemporarilyUnavailable", t2["InGame.Chat.Response.EmotesTemporarilyUnavailable"])
		local t9 = {
			ChatColor = color3
		}

		Util:SendSystemMessageToSelf(v41, CurrentChannel, t9)

		return true
	end

	local t10 = {}
	local Emotes = HumanoidDescription:GetEmotes()

	for k, _ in pairs(Emotes) do
		t10[string.lower(k)] = k
	end

	local num = tonumber(v25)

	if num then
		local EquippedEmotes = HumanoidDescription:GetEquippedEmotes()

		for _, v in pairs(EquippedEmotes) do
			if num == v.Slot then
				v25 = v.Name
			end
		end
	end

	local u51 = t10[string.lower(v25)]

	if not u51 then
		local v52 = ChatLocalization:Get("InGame.Chat.Response.EmoteNotAvailable", t2["InGame.Chat.Response.EmoteNotAvailable"])
		local t11 = {
			ChatColor = color3
		}

		Util:SendSystemMessageToSelf(v52, CurrentChannel, t11)

		return true
	end

	spawn(function() -- line: 143
		-- upvalues: Humanoid (copy), u51 (ref), CurrentChannel (copy), ChatLocalization (ref), t2 (copy), color3 (copy), Util (copy)
		local ok, result = pcall(function() -- line: 144
			-- upvalues: Humanoid (copy), u51 (ref)
			return Humanoid:PlayEmote(u51)
		end)

		if not ok then
			local v56 = CurrentChannel
			local v57 = ChatLocalization:Get("InGame.Chat.Response.EmotesNotSupported", t2["InGame.Chat.Response.EmotesNotSupported"])
			local t12 = {
				ChatColor = color3
			}

			Util:SendSystemMessageToSelf(v57, v56, t12)

			return
		end

		if not result then
			local v59 = CurrentChannel
			local v60 = ChatLocalization:Get("InGame.Chat.Response.EmotesTemporarilyUnavailable", t2["InGame.Chat.Response.EmotesTemporarilyUnavailable"])
			local t13 = {
				ChatColor = color3
			}

			Util:SendSystemMessageToSelf(v60, v59, t13)
		end
	end)

	return true
end

return {
	[Util.KEY_COMMAND_PROCESSOR_TYPE] = Util.COMPLETED_MESSAGE_PROCESSOR,
	[Util.KEY_PROCESSOR_FUNCTION] = ProcessMessage
}
