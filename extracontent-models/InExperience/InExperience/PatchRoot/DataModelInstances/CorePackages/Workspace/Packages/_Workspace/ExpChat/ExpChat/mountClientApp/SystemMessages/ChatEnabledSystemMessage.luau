local TextChatService = game:GetService("TextChatService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local SharedFlags = require(ExpChatParent.SharedFlags)
local displaySystemMessage = require(ExpChat.displaySystemMessage)
local ExpChatLocalChatEnabledMessageExperimentation = require(ExpChatParent.SocialExperiments).ExpChatLocalChatEnabledMessageExperimentation
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local FFlagExpChatUseUpdatedUserCountStrings = ExpChatShared.Flags.FFlagExpChatUseUpdatedUserCountStrings
local EngineFeature = game:GetEngineFeature("ExpChatLocalUserCountEnabled")
local v11 = game:DefineFastInt("ExpChatChatableUserCountSystemMessageMinUsers", 5)
local v12 = ExpChatShared.Logger:new("ExpChat/" .. script.Name)

local function createDisplayChatEnabledMessage(t1: {[any]: any}) -- line: 30
	-- upvalues: FFlagConnectionsToFriendsRename (copy), displaySystemMessage (copy), ExpChatLocalChatEnabledMessageExperimentation (copy), EngineFeature (copy), TextChatService (copy), v12 (copy), FFlagExpChatUseUpdatedUserCountStrings (copy), v11 (copy)
	local translator = t1.translator
	local defaultSystemTextChannel = t1.defaultSystemTextChannel
	local localPlayer = t1.localPlayer
	local u18 = false

	return function() -- line: 37
		-- upvalues: FFlagConnectionsToFriendsRename (copy), displaySystemMessage (copy), translator (copy), defaultSystemTextChannel (copy), ExpChatLocalChatEnabledMessageExperimentation (copy), EngineFeature (copy), TextChatService (copy), localPlayer (copy), v12 (copy), FFlagExpChatUseUpdatedUserCountStrings (copy), v11 (copy), u18 (ref)
		local v19 = not FFlagConnectionsToFriendsRename and "CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithAgeGroupAndTC" or "CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithAgeGroupAAndTF"
		local v20 = not FFlagConnectionsToFriendsRename and "Only people in similar age groups and your Trusted Connections can chat with you." or "Only people in similar age groups and your trusted friends can chat with you."

		local function displayControlMessage() -- line: 45
			-- upvalues: displaySystemMessage (copy), v19 (copy), translator (copy), defaultSystemTextChannel (copy), v20 (copy)
			displaySystemMessage(v19, nil, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v20)
		end

		if ExpChatLocalChatEnabledMessageExperimentation.isExperimentEnabled and EngineFeature then
			task.spawn(function() -- line: 60
				-- upvalues: TextChatService (copy), localPlayer (copy), v12 (copy), displaySystemMessage (copy), v19 (copy), translator (copy), defaultSystemTextChannel (copy), v20 (copy), ExpChatLocalChatEnabledMessageExperimentation (copy), FFlagExpChatUseUpdatedUserCountStrings (copy), v11 (copy), u18 (ref)
				local ok, result = pcall(function() -- line: 61
					-- upvalues: TextChatService (copy), localPlayer (copy)
					return TextChatService:GetChatableUserCountAsync(localPlayer.UserId, "local")
				end)

				if not ok then
					v12:warning("GetChatableUserCountAsync (local) failed: {}", (tostring(result)))
					displaySystemMessage(v19, nil, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v20)

					return
				end

				if result == nil then
					displaySystemMessage(v19, nil, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v20)

					return
				end

				local v24 = ExpChatLocalChatEnabledMessageExperimentation.getSystemMessageKey()

				if v24 == nil then
					displaySystemMessage(v19, nil, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v20)

					return
				end

				local function GetSystemMessageKey(s1: string) -- line: 83
					-- upvalues: FFlagExpChatUseUpdatedUserCountStrings (copy), v19 (copy), result (copy), v11 (copy)
					local t2 = {
						FRIENDLY = "CoreScripts.TextChat.ChatWindow.ChatWithOnlinePlayers.Local.Friendly",
						WITH_COUNT_ABOVE_THRESHOLD = not FFlagExpChatUseUpdatedUserCountStrings and "CoreScripts.TextChat.ChatWindow.ChatWithOnlinePlayers.Local.WithCount" or "CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithOnlinePlayers.Local.WithCount",
						WITH_COUNT_BELOW_THRESHOLD = not FFlagExpChatUseUpdatedUserCountStrings and "CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithOnlinePlayers.V3" or "CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithOnlinePlayers.BelowThreshold"
					}

					if s1 == "CONTROL" then
						return v19
					end

					if s1 == "V1_WITH_COUNT" then
						if result >= v11 then
							return t2.WITH_COUNT_ABOVE_THRESHOLD
						end

						return t2.WITH_COUNT_BELOW_THRESHOLD
					end

					if s1 == "V2_FRIENDLY" then
						return t2.FRIENDLY
					end

					if s1 == "V3_WITHOUT_COUNT" then
						return t2.WITH_COUNT_BELOW_THRESHOLD
					end

					return nil
				end

				local v26 = GetSystemMessageKey(v24)

				if v26 == nil then
					v12:warning("LocalChatEnabledMessage: IXP returned unrecognized identifier '{}'; showing control message, not logging exposure", v24)
					displaySystemMessage(v19, nil, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v20)

					return
				end

				if not u18 then
					u18 = true
					ExpChatLocalChatEnabledMessageExperimentation.logExposure()
				end

				displaySystemMessage(v26, {
					RBX_COUNT = result
				}, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v20)
			end)

			return
		end

		displaySystemMessage(v19, nil, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v20)
	end
end

return createDisplayChatEnabledMessage
