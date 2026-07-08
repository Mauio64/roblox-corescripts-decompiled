local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local CorePackages = game:GetService("CorePackages")
local FFlagEnableGlobalChatAbuseReporting = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableGlobalChatAbuseReporting
local t1 = {
	CHANNEL_GENERAL = "RBXGeneral",
	CHANNEL_GLOBAL = "RBXGlobal",
	areChannelTabsEnabled = function() -- line: 30
		-- upvalues: TextChatService (copy)
		if not game:GetEngineFeature("EnableChannelTabsConfiguration") then
			return false
		end

		local ChannelTabsConfiguration = TextChatService:FindFirstChildOfClass("ChannelTabsConfiguration")

		return ChannelTabsConfiguration ~= nil and ChannelTabsConfiguration.Enabled
	end,
	localizeString = function(p1, s1: string) -- line: 42
		if not p1 then
			return s1
		end

		local ok, result = pcall(p1.TranslateGameText, p1, game, s1)

		if ok and type(result) == "string" then
			return result
		end

		return s1
	end,
	isSystemMessage = function(p2) -- line: 53
		if p2.textChannel and p2.textChannel.Name == "RBXSystem" then
			return true
		end

		if not p2.userId or p2.userId == "0" then
			return true
		end

		return false
	end,
	formatChannelLabel = function(s2: string, p3) -- line: 65
		-- upvalues: Players (copy), FFlagEnableGlobalChatAbuseReporting (copy)
		if string.find(s2, "RBXGeneral") then
			return "General"
		end

		if string.find(s2, "^RBXTeam") then
			return "Team"
		end

		if string.find(s2, "^RBXWhisper") then
			if p3 and Players.LocalPlayer then
				for _, child in ipairs(p3:GetChildren()) do
					if not child:IsA("TextSource") then
						continue
					end

					local PlayerByUserId = Players:GetPlayerByUserId(child.UserId)

					if PlayerByUserId and PlayerByUserId ~= Players.LocalPlayer then
						return PlayerByUserId.DisplayName
					end
				end
			end

			return "Whisper"
		end

		if FFlagEnableGlobalChatAbuseReporting and s2 == "RBXGlobal" then
			return "Global"
		end

		return s2
	end,
	formatMessageLabel = function(p4) -- line: 89
		local v18 = p4.prefixText or ""
		local v19 = p4.text or ""

		if #v18 > 0 then
			return v18 .. " " .. v19
		end

		return v19
	end,
	getMessageUsername = function(p5) -- line: 95
		-- upvalues: Players (copy)
		local num = tonumber(p5.userId)

		if num and num ~= 0 then
			local PlayerByUserId = Players:GetPlayerByUserId(num)

			if PlayerByUserId then
				return PlayerByUserId.Name
			end
		end

		local textChatMessageInstance = p5.textChatMessageInstance

		if textChatMessageInstance then
			local TextSource = textChatMessageInstance.TextSource

			if TextSource and TextSource.Username and #TextSource.Username > 0 then
				return TextSource.Username
			end
		end

		return nil
	end
}

function t1.collectItems(p6, p7) -- line: 123
	-- upvalues: t1 (copy)
	local t2 = {}

	for _, v in ipairs(p7) do
		local v30 = p6[v]

		if v30 and not t1.isSystemMessage(v30) then
			table.insert(t2, {
				id = v30.messageId,
				label = t1.formatMessageLabel(v30),
				meta = {
					textChannel = v30.textChannel,
					userId = tostring(v30.userId),
					presetId = v30.presetId,
					presetChatVersion = v30.presetChatVersion,
					username = t1.getMessageUsername(v30)
				}
			})
		end
	end

	return t2
end
function t1.annotateWhisperItems(t3: {[any]: any}, p8, s3: string) -- line: 147
	for _, v in ipairs(t3) do
		local v36 = p8[v.id]

		if v36 and v36.textChannel and typeof(v36.textChannel.Name) == "string" and string.sub(v36.textChannel.Name, 1, 10) == "RBXWhisper" then
			v.label = string.format("[%s] %s", s3, v.label)
		end
	end
end

return t1
