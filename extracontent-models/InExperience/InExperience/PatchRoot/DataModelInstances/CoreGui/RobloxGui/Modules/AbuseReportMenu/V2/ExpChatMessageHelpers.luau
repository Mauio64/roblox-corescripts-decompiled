local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

local CorePackages = game:GetService("CorePackages")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableGlobalChatAbuseReporting = SharedFlags.FFlagEnableGlobalChatAbuseReporting
local FFlagAbuseReportAttributedRBXSystemMessages = SharedFlags.FFlagAbuseReportAttributedRBXSystemMessages

local ExpChatMessageHelpers = {}
ExpChatMessageHelpers.CHANNEL_GENERAL = "RBXGeneral"
ExpChatMessageHelpers.CHANNEL_GLOBAL = "RBXGlobal"

function ExpChatMessageHelpers.areChannelTabsEnabled()
	local channelTabsConfiguration = TextChatService:FindFirstChildOfClass("ChannelTabsConfiguration")
	return channelTabsConfiguration ~= nil and channelTabsConfiguration.Enabled
end

function ExpChatMessageHelpers.localizeString(p, p2: string)
	if not p then
		return p2
	end

	local success, result = pcall(p.TranslateGameText, p, game, p2)
	return if success and type(result) == "string" then result else p2
end

function ExpChatMessageHelpers.isSystemMessage(p): boolean
	if not FFlagAbuseReportAttributedRBXSystemMessages and p.textChannel and p.textChannel.Name == "RBXSystem" then
		return true
	end

	return not p.userId or p.userId == "0"
end

function ExpChatMessageHelpers.formatChannelLabel(value: string, instance)
	if string.find(value, "RBXGeneral") then
		return "General"
	end

	if string.find(value, "^RBXTeam") then
		return "Team"
	end

	if string.find(value, "^RBXWhisper") then
		if instance and Players.LocalPlayer then
			for _, textSource in ipairs(instance:GetChildren()) do
				if not textSource:IsA("TextSource") then
					continue
				end

				local playerByUserId = Players:GetPlayerByUserId(textSource.UserId)

				if playerByUserId and playerByUserId ~= Players.LocalPlayer then
					return playerByUserId.DisplayName
				end
			end
		end

		return "Whisper"
	elseif FFlagEnableGlobalChatAbuseReporting and value == "RBXGlobal" then
		return "Global"
	else
		return value
	end
end

function ExpChatMessageHelpers.formatMessageLabel(p)
	local prefixText = p.prefixText or ""
	local text = p.text or ""

	if #prefixText > 0 then
		return prefixText .. " " .. text
	end

	return text
end

function ExpChatMessageHelpers.getMessageUsername(p)
	local userId = tonumber(p.userId)

	local playerByUserId = userId and userId ~= 0 and Players:GetPlayerByUserId(userId)

	if playerByUserId then
		return playerByUserId.Name
	end

	local textChatMessageInstance = p.textChatMessageInstance

	if textChatMessageInstance then
		local textSource = textChatMessageInstance.TextSource

		if textSource and textSource.Username and #textSource.Username > 0 then
			return textSource.Username
		end
	end

	return nil
end

function ExpChatMessageHelpers.collectItems(p, list)
	local items = {}

	for _, item in ipairs(list) do
		local v = p[item]

		if not v or ExpChatMessageHelpers.isSystemMessage(v) then
			continue
		end

		table.insert(items, {
			id = v.messageId,
			label = ExpChatMessageHelpers.formatMessageLabel(v),
			meta = {
				textChannel = v.textChannel,
				userId = tostring(v.userId),
				presetId = v.presetId,
				presetChatVersion = v.presetChatVersion,
				username = ExpChatMessageHelpers.getMessageUsername(v)
			}
		})
	end

	return items
end

function ExpChatMessageHelpers.annotateWhisperItems(list, p, p2: string)
	for _, item in ipairs(list) do
		local v = p[item.id]

		if not (v and v.textChannel and typeof(v.textChannel.Name) == "string" and string.sub(v.textChannel.Name, 1, 10) == "RBXWhisper") then
			continue
		end

		item.label = string.format("[%s] %s", p2, item.label)
	end
end

return ExpChatMessageHelpers
