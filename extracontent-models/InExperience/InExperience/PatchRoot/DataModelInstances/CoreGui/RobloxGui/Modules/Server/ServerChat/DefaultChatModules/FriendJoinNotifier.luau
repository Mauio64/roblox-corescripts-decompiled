local Chat = game:GetService("Chat")
local Players = game:GetService("Players")
game:GetService("FriendService")

local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
require(ClientChatModules:WaitForChild("ChatConstants"))

local success, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserHandleFriendJoinNotifierOnClient")
end)

if not success then
	result = false
end

local v = nil

pcall(function()
	local Chat2 = game:GetService("Chat")
	v = require(Chat2.ClientChatModules.ChatLocalization)
end)

if v == nil then
	v = {}
end

if not (v.FormatMessageToSend and v.LocalizeFormattedMessage) then
	function v:FormatMessageToSend(_, p)
		return p
	end
end

local v2 = { ChatColor = Color3.fromRGB(255, 255, 255) }

local function Run(object)
	local function ShowFriendJoinNotification() -- 1 equivalent call inferred from this helper
		if result == false and ChatSettings.ShowFriendJoinNotification ~= nil then
			return ChatSettings.ShowFriendJoinNotification
		end

		return false
	end

	local function SendFriendJoinNotification(object2, p)
		local speaker = object:GetSpeaker(object2.Name)

		if speaker then
			local v3 = p.Name

			if ChatSettings.PlayerDisplayNamesEnabled then
				v3 = p.DisplayName
			end

			speaker:SendSystemMessage(
				v:FormatMessageToSend(
					"GameChat_FriendChatNotifier_JoinMessage",
					string.format("Your friend %s has joined the game.", v3),
					"RBX_NAME",
					v3
				),
				"System",
				v2
			)
		end
	end

	local function TrySendFriendNotification(object2, p) -- 1 equivalent call inferred from this helper
		if object2 ~= p then
			coroutine.wrap(function()
				if object2:IsFriendsWith(p.UserId) then
					SendFriendJoinNotification(object2, p)
				end
			end)()
		end
	end

	if ShowFriendJoinNotification() then -- inferred equivalent call
		Players.PlayerAdded:connect(function(p)
			local players = Players:GetPlayers()

			for i = 1, #players do
				TrySendFriendNotification(players[i], p) -- inferred equivalent call
			end
		end)
	end
end

return Run
