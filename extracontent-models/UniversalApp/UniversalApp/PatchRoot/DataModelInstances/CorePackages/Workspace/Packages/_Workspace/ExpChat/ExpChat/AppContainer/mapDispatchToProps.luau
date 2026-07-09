local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local runGlobalChatCommand = require(ExpChat.runGlobalChatCommand)
local runVirtualChatCommand = require(ExpChat.runVirtualChatCommand)
local ExpChatParent = ExpChat.Parent
local Promise = require(ExpChatParent.Promise)
local List = require(ExpChatParent.llama).List
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local Analytics = ExpChatShared.Analytics
local Logger = require(script.Parent.Logger)
local Config = require(ExpChat.Config)
local DictationAnalytics = require(ExpChat.ChatInput.UI.ChatInputBar.Dictation.DictationAnalytics)
local computeEditDistance = require(ExpChat.ChatInput.UI.ChatInputBar.Dictation.computeEditDistance)

local function truncateToCharLimit(s1: string) -- line: 28
	-- upvalues: Config (copy)
	if #s1 > Config.MessageCharacterLimit then
		return string.sub(s1, 1, Config.MessageCharacterLimit), true
	end

	return s1, false
end

local Commands = ExpChatShared.Commands
local GlobalCommands = ExpChatShared.GlobalCommands
local autoCastCommand = ExpChatShared.Commands.autoCastCommand
local RBXWhisperCommand = ExpChatShared.Commands.Whisper.RBXWhisperCommand
local ChatInputBarResetTargetChannel = ExpChatShared.Actions.ChatInputBarResetTargetChannel
local ChatTranslationGlobalToggled = require(ExpChat.Actions.ChatTranslationGlobalToggled)
local ChatTranslationMessageToggled = require(ExpChat.Actions.ChatTranslationMessageToggled)
local SharedFlags = require(ExpChatParent.SharedFlags)
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FFlagExpChatDictatedSpeechEnabled = require(ExpChat.Flags.FFlagExpChatDictatedSpeechEnabled)
local v28 = game:DefineFastFlag("ExpChatUseVirtualCommandRunner", false)
local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs
local FFlagExpChatDictation = SharedFlags.FFlagExpChatDictation

return function(p1) -- line: 53
	-- upvalues: Players (copy), autoCastCommand (copy), RBXWhisperCommand (copy), Promise (copy), Logger (copy), FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), ChatTranslationGlobalToggled (copy), Analytics (copy), ChatTranslationMessageToggled (copy), ChatInputBarResetTargetChannel (copy), GetTransparencyStore (copy), runVirtualChatCommand (copy), Commands (copy), TextChatService (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), FFlagExpChatDictatedSpeechEnabled (copy), List (copy), Config (copy), FFlagExpChatDictation (copy), DictationAnalytics (copy), computeEditDistance (copy), v28 (copy), GlobalCommands (copy), runGlobalChatCommand (copy)
	return {
		activateWhisperMode = function(n1: number) -- line: 55
			-- upvalues: Players (copy), autoCastCommand (copy), RBXWhisperCommand (copy), Promise (copy), Logger (copy)
			local PlayerByUserId = Players:GetPlayerByUserId(n1)
			local LocalPlayer = Players.LocalPlayer

			if not PlayerByUserId then
				return
			end

			if PlayerByUserId == LocalPlayer then
				return
			end

			assert(LocalPlayer, "Players.LocalPlayer should be non-nil")

			local PlayerByUserIdName = PlayerByUserId.Name
			local t1 = { autoCastCommand(RBXWhisperCommand, LocalPlayer.UserId, "/w @" .. PlayerByUserIdName) }

			Promise.any(t1):catch(function(p2) -- line: 71
				-- upvalues: Logger (copy)
				Logger:debug("Could not send autoCastCommand. Error: {}", p2)
			end)
		end,
		onToggleTranslation = function(b1: boolean) -- line: 76
			-- upvalues: FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), p1 (copy), ChatTranslationGlobalToggled (copy)
			if FFlagExpChatUseMessagesStore then
				GetMessagesStore(false).toggleGlobalTranslation(b1)

				return
			end

			p1(ChatTranslationGlobalToggled(b1))
		end,
		onToggleIndividualTranslation = function(b2: boolean, s2: string) -- line: 85
			-- upvalues: Players (copy), Analytics (copy), FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), p1 (copy), ChatTranslationMessageToggled (copy)
			local t2 = {
				useTranslation = b2,
				senderUserId = if not Players.LocalPlayer then nil else Players.LocalPlayer.UserId,
				localeId = if not Players.LocalPlayer then nil else Players.LocalPlayer.LocaleId
			}

			Analytics.FireClientAnalyticsWithEventName("MessageTranslationToggled", t2)

			if FFlagExpChatUseMessagesStore then
				GetMessagesStore(false).toggleMessageTranslation(b2, s2)

				return
			end

			p1(ChatTranslationMessageToggled(b2, s2))
		end,
		resetTargetChannel = function() -- line: 102
			-- upvalues: p1 (copy), ChatInputBarResetTargetChannel (copy)
			p1(ChatInputBarResetTargetChannel())
		end,
		onHovered = function() -- line: 106
			-- upvalues: GetTransparencyStore (copy)
			GetTransparencyStore(false).resetAllTransparency()
		end,
		onUnhovered = function() -- line: 110
			-- upvalues: GetTransparencyStore (copy)
			GetTransparencyStore(false).resetAllTransparency()
		end,
		onSendChat = function(s3: string, t3: {[any]: any}?, b3: boolean?) -- line: 114
			-- upvalues: runVirtualChatCommand (copy), Players (copy), Commands (copy), TextChatService (copy), Logger (copy), Promise (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), FFlagExpChatDictatedSpeechEnabled (copy), List (copy), Config (copy), FFlagExpChatDictation (copy), DictationAnalytics (copy), Analytics (copy), computeEditDistance (copy)
			if string.sub(s3, 1, 1) == "/" and runVirtualChatCommand(s3, Players.LocalPlayer and Players.LocalPlayer.UserId or 0, Commands.getVirtualLocalEnabledCommands(), "RBXGeneral") then
				return
			end

			local ChatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
			local TargetTextChannel = nil

			if ChatInputBarConfiguration then
				TargetTextChannel = ChatInputBarConfiguration.TargetTextChannel
			end

			Logger:debug("onSendChat: {} to {}", s3, not TargetTextChannel and "nil" or TargetTextChannel.Name)

			if TargetTextChannel then
				Promise.try(function() -- line: 135
					-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), TargetTextChannel (ref), s3 (copy), FFlagExpChatDictatedSpeechEnabled (copy), b3 (copy), List (copy), Players (copy), Config (copy), FFlagExpChatDictation (copy), t3 (copy), DictationAnalytics (copy), Analytics (copy), computeEditDistance (copy)
					if getFFlagExpChatProtectedChatInternalAPIs() then
						TargetTextChannel:SendInternalAsync(s3)
					elseif FFlagExpChatDictatedSpeechEnabled and b3 then
						TargetTextChannel:SendDictatedSpeechAsync(s3)
					else
						TargetTextChannel:SendAsync(s3)
					end

					local v52 = List.count(TargetTextChannel:GetChildren(), function(p3) -- line: 144
						return p3:IsA("TextSource")
					end)
					local t4 = {
						channelName = TargetTextChannel.Name,
						senderUserId = if not Players.LocalPlayer then nil else Players.LocalPlayer.UserId,
						numParticipants = v52,
						isDefaultChannel = not Config[TargetTextChannel.Name] and "false" or "true"
					}

					if FFlagExpChatDictation and t3 then
						t4[DictationAnalytics.Properties.SttMode] = t3.mode
						t4[DictationAnalytics.Properties.SttOutcome] = t3.outcome
					end

					Analytics.FireClientAnalyticsWithEventName("LuaMessageSent", t4)

					if FFlagExpChatDictation and t3 then
						local v54 = t3.textStt or ""
						local v55 = t3.textSent or s3
						local v56, v57

						if #v54 > Config.MessageCharacterLimit then
							v56 = string.sub(v54, 1, Config.MessageCharacterLimit)
							v57 = true
						else
							v56 = v54
							v57 = false
						end

						local v58, v59

						if #v55 > Config.MessageCharacterLimit then
							v58 = string.sub(v55, 1, Config.MessageCharacterLimit)
							v59 = true
						else
							v58 = v55
							v59 = false
						end

						DictationAnalytics.fire(DictationAnalytics.Events.MessageSent, {
							[DictationAnalytics.Properties.SttMode] = t3.mode,
							[DictationAnalytics.Properties.SttOutcome] = t3.outcome,
							[DictationAnalytics.Properties.FinalCharCount] = #v55,
							[DictationAnalytics.Properties.WasEdited] = v54 ~= v55,
							[DictationAnalytics.Properties.EditDistance] = computeEditDistance(v54, v55),
							[DictationAnalytics.Properties.TextStt] = v56,
							[DictationAnalytics.Properties.TextSent] = v58,
							[DictationAnalytics.Properties.TextSttTruncated] = v57,
							[DictationAnalytics.Properties.TextSentTruncated] = v59
						})
					end
				end):catch(function(p4) -- line: 178
					warn(p4.error)
				end)
			else
				Logger:warning("TargetTextChannel was nil!")
			end
		end,
		onSendGlobalChat = function(s4: string, _: {[any]: any}?, b4: boolean?) -- line: 186
			-- upvalues: Players (copy), v28 (copy), runVirtualChatCommand (copy), GlobalCommands (copy), runGlobalChatCommand (copy), Promise (copy), FFlagExpChatDictatedSpeechEnabled (copy), TextChatService (copy)
			if string.sub(s4, 1, 1) == "/" then
				local v50 = Players.LocalPlayer and Players.LocalPlayer.UserId or 0

				if if not v28 then runGlobalChatCommand(s4, v50) else runVirtualChatCommand(s4, v50, GlobalCommands.getGlobalEnabledCommands(), "RBXGlobal") then
					return
				end
			end

			Promise.try(function() -- line: 204
				-- upvalues: FFlagExpChatDictatedSpeechEnabled (copy), b4 (copy), TextChatService (copy), s4 (copy)
				if FFlagExpChatDictatedSpeechEnabled and b4 then
					TextChatService:SendDictatedSpeechUniverseChatAsync(s4)

					return
				end

				TextChatService:SendUniverseChatMessageAsync(s4, "")
			end):catch(function(p5) -- line: 210
				warn(p5.error)
			end)
		end
	}
end
