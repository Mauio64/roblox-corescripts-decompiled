local TextChatService = game:GetService("TextChatService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local SharedFlags = require(ExpChatParent.SharedFlags)
local displaySystemMessage = require(ExpChat.displaySystemMessage)
local ExpChatLocalChatEnabledMessageExperimentation = require(ExpChatParent.SocialExperiments).ExpChatLocalChatEnabledMessageExperimentation
local Analytics = ExpChatShared.Analytics
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local FFlagExpChatUseUpdatedUserCountStrings = ExpChatShared.Flags.FFlagExpChatUseUpdatedUserCountStrings
local v11 = game:DefineFastFlag("ExpChatReportChatEnabledUserCountMetrics", false)
local EngineFeature = game:GetEngineFeature("ExpChatLocalUserCountEnabled")
local v13 = game:DefineFastInt("ExpChatChatableUserCountSystemMessageMinUsers", 5)
local v14 = ExpChatShared.Logger:new("ExpChat/" .. script.Name)

local function createDisplayChatEnabledMessage(t1: {[any]: any}) -- line: 33
	-- upvalues: FFlagConnectionsToFriendsRename (copy), displaySystemMessage (copy), ExpChatLocalChatEnabledMessageExperimentation (copy), EngineFeature (copy), TextChatService (copy), v11 (copy), Analytics (copy), v14 (copy), FFlagExpChatUseUpdatedUserCountStrings (copy), v13 (copy)
	local translator = t1.translator
	local defaultSystemTextChannel = t1.defaultSystemTextChannel
	local localPlayer = t1.localPlayer
	local u20 = false

	return function() -- line: 40
		-- upvalues: FFlagConnectionsToFriendsRename (copy), displaySystemMessage (copy), translator (copy), defaultSystemTextChannel (copy), ExpChatLocalChatEnabledMessageExperimentation (copy), EngineFeature (copy), TextChatService (copy), localPlayer (copy), v11 (copy), Analytics (copy), v14 (copy), FFlagExpChatUseUpdatedUserCountStrings (copy), v13 (copy), u20 (ref)
		local v21 = not FFlagConnectionsToFriendsRename and "CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithAgeGroupAndTC" or "CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithAgeGroupAAndTF"
		local v22 = not FFlagConnectionsToFriendsRename and "Only people in similar age groups and your Trusted Connections can chat with you." or "Only people in similar age groups and your trusted friends can chat with you."

		local function displayControlMessage() -- line: 48
			-- upvalues: displaySystemMessage (copy), v21 (copy), translator (copy), defaultSystemTextChannel (copy), v22 (copy)
			displaySystemMessage(v21, nil, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v22)
		end

		if ExpChatLocalChatEnabledMessageExperimentation.isExperimentEnabled and EngineFeature then
			task.spawn(function() -- line: 63
				-- upvalues: TextChatService (copy), localPlayer (copy), v11 (copy), Analytics (copy), v14 (copy), displaySystemMessage (copy), v21 (copy), translator (copy), defaultSystemTextChannel (copy), v22 (copy), ExpChatLocalChatEnabledMessageExperimentation (copy), FFlagExpChatUseUpdatedUserCountStrings (copy), v13 (copy), u20 (ref)
				local ok, result = pcall(function() -- line: 64
					-- upvalues: TextChatService (copy), localPlayer (copy)
					return TextChatService:GetChatableUserCountAsync(localPlayer.UserId, "local")
				end)

				if v11 then
					Analytics.reportChatEnabledUserCountFetchResult(ok and result ~= nil)
				end

				if not ok then
					v14:warning("GetChatableUserCountAsync (local) failed: {}", (tostring(result)))
					displaySystemMessage(v21, nil, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v22)

					return
				end

				if result == nil then
					displaySystemMessage(v21, nil, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v22)

					return
				end

				local v26 = ExpChatLocalChatEnabledMessageExperimentation.getSystemMessageKey()

				if v26 == nil then
					displaySystemMessage(v21, nil, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v22)

					return
				end

				local function GetSystemMessageKey(s1: string) -- line: 90
					-- upvalues: FFlagExpChatUseUpdatedUserCountStrings (copy), v21 (copy), result (copy), v13 (copy)
					local t2 = {
						FRIENDLY = "CoreScripts.TextChat.ChatWindow.ChatWithOnlinePlayers.Local.Friendly",
						WITH_COUNT_ABOVE_THRESHOLD = not FFlagExpChatUseUpdatedUserCountStrings and "CoreScripts.TextChat.ChatWindow.ChatWithOnlinePlayers.Local.WithCount" or "CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithOnlinePlayers.Local.WithCount",
						WITH_COUNT_BELOW_THRESHOLD = not FFlagExpChatUseUpdatedUserCountStrings and "CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithOnlinePlayers.V3" or "CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithOnlinePlayers.BelowThreshold"
					}

					if s1 == "CONTROL" then
						return v21
					end

					if s1 == "V1_WITH_COUNT" then
						if result >= v13 then
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

				local v28 = GetSystemMessageKey(v26)

				if v28 == nil then
					v14:warning("LocalChatEnabledMessage: IXP returned unrecognized identifier '{}'; showing control message, not logging exposure", v26)
					displaySystemMessage(v21, nil, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v22)

					return
				end

				if not u20 then
					u20 = true
					ExpChatLocalChatEnabledMessageExperimentation.logExposure()
				end

				displaySystemMessage(v28, {
					RBX_COUNT = result
				}, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v22)
			end)

			return
		end

		displaySystemMessage(v21, nil, "Roblox.ChatEnabled.Info", translator, defaultSystemTextChannel, v22)
	end
end

return createDisplayChatEnabledMessage
