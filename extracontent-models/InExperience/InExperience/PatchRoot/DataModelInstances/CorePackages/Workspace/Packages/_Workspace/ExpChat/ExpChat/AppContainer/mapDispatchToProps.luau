local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local runGlobalChatCommand = require(ExpChat.runGlobalChatCommand)
local runVirtualChatCommand = require(ExpChat.runVirtualChatCommand)

local parent = ExpChat.Parent
local Promise = require(parent.Promise)
local llama = require(parent.llama)
local list = llama.List
local ExpChatShared = require(parent.ExpChatShared)

local Analytics = ExpChatShared.Analytics
local Logger = require(script.Parent.Logger)
local Config = require(ExpChat.Config)
local DictationAnalytics = require(ExpChat.ChatInput.UI.ChatInputBar.Dictation.DictationAnalytics)
local computeEditDistance = require(ExpChat.ChatInput.UI.ChatInputBar.Dictation.computeEditDistance)
local defineFastFlag = game:DefineFastFlag("ExpChatFlipDictationPriorityV2", false)

local function truncateToCharLimit(value: string) -- 2 equivalent calls inferred from this helper
	if #value > Config.MessageCharacterLimit then
		return string.sub(value, 1, Config.MessageCharacterLimit), true
	end

	return value, false
end

local Commands = ExpChatShared.Commands
local GlobalCommands = ExpChatShared.GlobalCommands
local autoCastCommand = ExpChatShared.Commands.autoCastCommand
local RBXWhisperCommand = ExpChatShared.Commands.Whisper.RBXWhisperCommand

local ChatInputBarResetTargetChannel = ExpChatShared.Actions.ChatInputBarResetTargetChannel

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatFixBackspaceNilTargetChannel = ExpChatShared.Flags.FFlagExpChatFixBackspaceNilTargetChannel
local FFlagExpChatDictatedSpeechEnabled = require(ExpChat.Flags.FFlagExpChatDictatedSpeechEnabled)
local defineFastFlag2 = game:DefineFastFlag("ExpChatUseVirtualCommandRunner", false)
local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs
local FFlagExpChatDictation = SharedFlags.FFlagExpChatDictation
local FFlagExpChatDictationGrafanaMetrics = require(ExpChat.Flags.FFlagExpChatDictationGrafanaMetrics)

return function(callback)
	return {
		activateWhisperMode = function(p: number)
			local playerByUserId = Players:GetPlayerByUserId(p)
			local localPlayer = Players.LocalPlayer

			if not (playerByUserId and playerByUserId ~= localPlayer) then
				return
			end

			assert(localPlayer, "Players.LocalPlayer should be non-nil")

			local name = playerByUserId.Name
			local v = { autoCastCommand(RBXWhisperCommand, localPlayer.UserId, "/w @" .. name) }

			Promise.any(v):catch(function(p2)
				Logger:debug("Could not send autoCastCommand. Error: {}", p2)
			end)
		end,
		onToggleTranslation = function(flag: boolean)
			GetMessagesStore(false).toggleGlobalTranslation(flag)
		end,
		onToggleIndividualTranslation = function(useTranslation: boolean, p: string)
			local senderUserId

			if Players.LocalPlayer then
				senderUserId = Players.LocalPlayer.UserId
			end

			local localeId

			if Players.LocalPlayer then
				localeId = Players.LocalPlayer.LocaleId
			end

			Analytics.FireClientAnalyticsWithEventName("MessageTranslationToggled", {
				useTranslation = useTranslation,
				senderUserId = senderUserId,
				localeId = localeId
			})

			GetMessagesStore(false).toggleMessageTranslation(useTranslation, p)
		end,
		resetTargetChannel = function(flag: boolean?)
			if not FFlagExpChatFixBackspaceNilTargetChannel then
				flag = nil
			end

			callback(ChatInputBarResetTargetChannel(flag))
		end,
		onHovered = function()
			GetTransparencyStore(false).resetAllTransparency()
		end,
		onUnhovered = function()
			GetTransparencyStore(false).resetAllTransparency()
		end,
		onSendChat = function(value: string, data, flag: boolean?, instance)
			if
				string.sub(value, 1, 1) == "/"
				and runVirtualChatCommand(
					value,
					Players.LocalPlayer and Players.LocalPlayer.UserId or 0,
					Commands.getVirtualLocalEnabledCommands(),
					"RBXGeneral"
				)
			then
				return
			end

			local chatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")

			if instance == nil and chatInputBarConfiguration then
				instance = chatInputBarConfiguration.TargetTextChannel
			end

			Logger:debug("onSendChat: {} to {}", value, not instance and "nil" or instance.Name)

			if instance then
				Promise.try(function()
					if defineFastFlag then
						if FFlagExpChatDictatedSpeechEnabled and flag then
							instance:SendDictatedSpeechAsync(value)
						elseif getFFlagExpChatProtectedChatInternalAPIs() then
							instance:SendInternalAsync(value)
						else
							instance:SendAsync(value)
						end
					elseif getFFlagExpChatProtectedChatInternalAPIs() then
						instance:SendInternalAsync(value)
					elseif FFlagExpChatDictatedSpeechEnabled and flag then
						instance:SendDictatedSpeechAsync(value)
					else
						instance:SendAsync(value)
					end

					local count = list.count(instance:GetChildren(), function(textSource)
						return textSource:IsA("TextSource")
					end)

					local v = {
						channelName = instance.Name,
						senderUserId = 0,
						numParticipants = 0,
						isDefaultChannel = 0
					}
					local senderUserId

					if Players.LocalPlayer then
						senderUserId = Players.LocalPlayer.UserId
					end

					v.senderUserId = senderUserId
					v.numParticipants = count
					v.isDefaultChannel = Config[instance.Name] and "true" or "false"

					if FFlagExpChatDictation and data then
						v[DictationAnalytics.Properties.SttMode] = data.mode
						v[DictationAnalytics.Properties.SttOutcome] = data.outcome
					end

					Analytics.FireClientAnalyticsWithEventName("LuaMessageSent", v)

					if FFlagExpChatDictation and data then
						local textStt = data.textStt or ""
						local textSent = data.textSent or value
						local v2, v3 = truncateToCharLimit(textStt) -- inferred equivalent call
						local v4, v5 = truncateToCharLimit(textSent) -- inferred equivalent call
						DictationAnalytics.fire(DictationAnalytics.Events.MessageSent, {
							[DictationAnalytics.Properties.SttMode] = data.mode,
							[DictationAnalytics.Properties.SttOutcome] = data.outcome,
							[DictationAnalytics.Properties.FinalCharCount] = #textSent,
							[DictationAnalytics.Properties.WasEdited] = textStt ~= textSent,
							[DictationAnalytics.Properties.EditDistance] = computeEditDistance(textStt, textSent),
							[DictationAnalytics.Properties.TextStt] = v2,
							[DictationAnalytics.Properties.TextSent] = v4,
							[DictationAnalytics.Properties.TextSttTruncated] = v3,
							[DictationAnalytics.Properties.TextSentTruncated] = v5
						})

						if FFlagExpChatDictationGrafanaMetrics then
							DictationAnalytics.reportMessageSentCounter(data.mode)
						end
					end
				end):catch(function(p)
					warn(p.error)
				end)
			else
				Logger:warning("TargetTextChannel was nil!")
			end
		end,
		onSendGlobalChat = function(value: string, _, flag: boolean?)
			if string.sub(value, 1, 1) == "/" then
				local userId = Players.LocalPlayer and Players.LocalPlayer.UserId or 0
				local v

				if defineFastFlag2 then
					v = runVirtualChatCommand(value, userId, GlobalCommands.getGlobalEnabledCommands(), "RBXGlobal")
				else
					v = runGlobalChatCommand(value, userId)
				end

				if v then
					return
				end
			end

			Promise.try(function()
				if FFlagExpChatDictatedSpeechEnabled and flag then
					TextChatService:SendDictatedSpeechUniverseChatAsync(value)
				else
					TextChatService:SendUniverseChatMessageAsync(value, "")
				end
			end):catch(function(p)
				warn(p.error)
			end)
		end
	}
end
