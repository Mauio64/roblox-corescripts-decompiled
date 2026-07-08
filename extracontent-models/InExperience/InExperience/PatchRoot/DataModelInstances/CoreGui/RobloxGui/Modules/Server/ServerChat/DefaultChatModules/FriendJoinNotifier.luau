local Chat = game:GetService("Chat")
local Players = game:GetService("Players")

game:GetService("FriendService")

local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))

require(ClientChatModules:WaitForChild("ChatConstants"))

local u5 = false
local ok, result = pcall(function() -- line: 16
	return UserSettings():IsUserFeatureEnabled("UserHandleFriendJoinNotifierOnClient")
end)

if ok then
	u5 = result
end

local ChatLocalization = nil

pcall(function() -- line: 26
	-- upvalues: ChatLocalization (ref)
	ChatLocalization = require(game:GetService("Chat").ClientChatModules.ChatLocalization)
end)

if ChatLocalization == nil then
	ChatLocalization = {}
end

if not ChatLocalization.FormatMessageToSend or not ChatLocalization.LocalizeFormattedMessage then
	function ChatLocalization.FormatMessageToSend(_, _, p3) -- line: 29
		return p3
	end
end

local t1 = {
	ChatColor = Color3.fromRGB(255, 255, 255)
}

local function Run(p4) -- line: 35
	-- upvalues: u5 (ref), ChatSettings (copy), ChatLocalization (ref), t1 (copy), Players (copy)
	local function ShowFriendJoinNotification() -- line: 37
		-- upvalues: u5 (ref), ChatSettings (copy)
		if u5 == false and ChatSettings.ShowFriendJoinNotification ~= nil then
			return ChatSettings.ShowFriendJoinNotification
		end

		return false
	end
	local function SendFriendJoinNotification(p5, p6) -- line: 46
		-- upvalues: p4 (copy), ChatSettings (copy), ChatLocalization (ref), t1 (copy)
		local Speaker = p4:GetSpeaker(p5.Name)

		if Speaker then
			local p6Name = p6.Name

			if ChatSettings.PlayerDisplayNamesEnabled then
				p6Name = p6.DisplayName
			end

			Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_FriendChatNotifier_JoinMessage", string.format("Your friend %s has joined the game.", p6Name), "RBX_NAME", p6Name), "System", t1)
		end
	end
	local function TrySendFriendNotification(p7, p8) -- line: 62
		-- upvalues: SendFriendJoinNotification (copy)
		if p7 ~= p8 then
			coroutine.wrap(function() -- line: 64
				-- upvalues: p7 (copy), p8 (copy), SendFriendJoinNotification (copy)
				if p7:IsFriendsWith(p8.UserId) then
					SendFriendJoinNotification(p7, p8)
				end
			end)()
		end
	end

	if u5 == false and (ChatSettings.ShowFriendJoinNotification ~= nil and ChatSettings.ShowFriendJoinNotification) then
		Players.PlayerAdded:connect(function(p9) -- line: 73
			-- upvalues: Players (copy), SendFriendJoinNotification (copy)
			local players = Players:GetPlayers()

			for i = 1, #players do
				local v27 = players[i]

				if v27 ~= p9 then
					coroutine.wrap(function() -- line: 64
						-- upvalues: v27 (copy), p9 (copy), SendFriendJoinNotification (copy)
						if v27:IsFriendsWith(p9.UserId) then
							SendFriendJoinNotification(v27, p9)
						end
					end)()
				end
			end
		end)
	end
end

return Run
