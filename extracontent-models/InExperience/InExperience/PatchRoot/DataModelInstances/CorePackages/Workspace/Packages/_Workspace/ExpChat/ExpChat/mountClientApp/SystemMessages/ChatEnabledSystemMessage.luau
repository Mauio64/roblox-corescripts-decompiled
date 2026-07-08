local TextChatService = game:GetService("TextChatService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local SharedFlags = require(ExpChatParent.SharedFlags)
local displaySystemMessage = require(ExpChat.displaySystemMessage)
local ExpChatLocalChatEnabledMessageExperimentation = require(ExpChatParent.SocialExperiments).ExpChatLocalChatEnabledMessageExperimentation
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local EngineFeature = game:GetEngineFeature("ExpChatLocalUserCountEnabled")
local v10 = game:DefineFastInt("ExpChatChatableUserCountSystemMessageMinUsers", 5)
local v11 = ExpChatShared.Logger:new("ExpChat/" .. script.Name)

local function createDisplayChatEnabledMessage(t1: {[any]: any}) -- line: 29
	-- upvalues: FFlagConnectionsToFriendsRename (copy), displaySystemMessage (copy), ExpChatLocalChatEnabledMessageExperimentation (copy), EngineFeature (copy), TextChatService (copy), v11 (copy), v10 (copy)
	local translator = t1.translator
	local defaultSystemTextChannel = t1.defaultSystemTextChannel
	local localPlayer = t1.localPlayer
	local u17 = false

	return function() -- line: 36
		-- upvalues: FFlagConnectionsToFriendsRename (copy), displaySystemMessage (copy), translator (copy), defaultSystemTextChannel (copy), ExpChatLocalChatEnabledMessageExperimentation (copy), EngineFeature (copy), TextChatService (copy), localPlayer (copy), v11 (copy), v10 (copy), u17 (ref)
		local v18 = not FFlagConnectionsToFriendsRename and "CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithAgeGroupAndTC" or "CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithAgeGroupAAndTF"
		local v19 = not FFlagConnectionsToFriendsRename and "Only people in similar age groups and your Trusted Connections can chat with you." or "Only people in similar age groups and your trusted friends can chat with you."

		local function displayControlMessage() -- line: 44
			-- upvalues: displaySystemMessage (copy), v18 (copy), translator (copy), defaultSystemTextChannel (copy), v19 (copy)
			displaySystemMessage(v18, nil, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v19)
		end

		if ExpChatLocalChatEnabledMessageExperimentation.isExperimentEnabled and EngineFeature then
			task.spawn(function() -- line: 59
				-- upvalues: TextChatService (copy), localPlayer (copy), v11 (copy), displaySystemMessage (copy), v18 (copy), translator (copy), defaultSystemTextChannel (copy), v19 (copy), ExpChatLocalChatEnabledMessageExperimentation (copy), v10 (copy), u17 (ref)
				local ok, result = pcall(function() -- line: 60
					-- upvalues: TextChatService (copy), localPlayer (copy)
					return TextChatService:GetChatableUserCountAsync(localPlayer.UserId, "local")
				end)

				if not ok then
					v11:warning("GetChatableUserCountAsync (local) failed: {}", (tostring(result)))
					displaySystemMessage(v18, nil, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v19)

					return
				end

				if result == nil then
					displaySystemMessage(v18, nil, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v19)

					return
				end

				local v23 = ExpChatLocalChatEnabledMessageExperimentation.getSystemMessageKey()

				if v23 == nil then
					displaySystemMessage(v18, nil, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v19)

					return
				end

				local function GetSystemMessageKey(s1: string) -- line: 82
					-- upvalues: v18 (copy), result (copy), v10 (copy)
					local _ = {
						WITH_COUNT_ABOVE_THRESHOLD = "CoreScripts.TextChat.ChatWindow.ChatWithOnlinePlayers.Local.WithCount",
						WITH_COUNT_BELOW_THRESHOLD = "CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithOnlinePlayers.V3",
						FRIENDLY = "CoreScripts.TextChat.ChatWindow.ChatWithOnlinePlayers.Local.Friendly"
					}

					if s1 == "CONTROL" then
						return v18
					end

					if s1 == "V1_WITH_COUNT" then
						if result >= v10 then
							return "CoreScripts.TextChat.ChatWindow.ChatWithOnlinePlayers.Local.WithCount"
						end

						return "CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithOnlinePlayers.V3"
					end

					if s1 == "V2_FRIENDLY" then
						return "CoreScripts.TextChat.ChatWindow.ChatWithOnlinePlayers.Local.Friendly"
					end

					if s1 == "V3_WITHOUT_COUNT" then
						return "CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithOnlinePlayers.V3"
					end

					return nil
				end

				local _ = {
					WITH_COUNT_ABOVE_THRESHOLD = "CoreScripts.TextChat.ChatWindow.ChatWithOnlinePlayers.Local.WithCount",
					WITH_COUNT_BELOW_THRESHOLD = "CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithOnlinePlayers.V3",
					FRIENDLY = "CoreScripts.TextChat.ChatWindow.ChatWithOnlinePlayers.Local.Friendly"
				}
				local v26 = if v23 ~= "CONTROL" then if v23 ~= "V1_WITH_COUNT" then if v23 ~= "V2_FRIENDLY" then if v23 ~= "V3_WITHOUT_COUNT" then nil else "CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithOnlinePlayers.V3" else "CoreScripts.TextChat.ChatWindow.ChatWithOnlinePlayers.Local.Friendly" else not (result >= v10) and "CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithOnlinePlayers.V3" or "CoreScripts.TextChat.ChatWindow.ChatWithOnlinePlayers.Local.WithCount" else v18

				if v26 == nil then
					v11:warning("LocalChatEnabledMessage: IXP returned unrecognized identifier '{}'; showing control message, not logging exposure", v23)
					displaySystemMessage(v18, nil, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v19)

					return
				end

				if not u17 then
					u17 = true
					ExpChatLocalChatEnabledMessageExperimentation.logExposure()
				end

				displaySystemMessage(v26, {
					RBX_COUNT = result
				}, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v19)
			end)

			return
		end

		displaySystemMessage(v18, nil, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v19)
	end
end

return createDisplayChatEnabledMessage
