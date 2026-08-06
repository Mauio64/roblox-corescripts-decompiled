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
local v17 = game:DefineFastFlag("ExpChatFlipDictationPriority", false)

local function truncateToCharLimit(s1: string) -- line: 29
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
local FFlagExpChatFixBackspaceNilTargetChannel = ExpChatShared.Flags.FFlagExpChatFixBackspaceNilTargetChannel
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FFlagExpChatDictatedSpeechEnabled = require(ExpChat.Flags.FFlagExpChatDictatedSpeechEnabled)
local v30 = game:DefineFastFlag("ExpChatUseVirtualCommandRunner", false)
local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs
local FFlagExpChatDictation = SharedFlags.FFlagExpChatDictation

return function(p1) -- line: 55
	-- upvalues: Players (copy), autoCastCommand (copy), RBXWhisperCommand (copy), Promise (copy), Logger (copy), FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), ChatTranslationGlobalToggled (copy), Analytics (copy), ChatTranslationMessageToggled (copy), ChatInputBarResetTargetChannel (copy), FFlagExpChatFixBackspaceNilTargetChannel (copy), GetTransparencyStore (copy), runVirtualChatCommand (copy), Commands (copy), TextChatService (copy), v17 (copy), FFlagExpChatDictatedSpeechEnabled (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), List (copy), Config (copy), FFlagExpChatDictation (copy), DictationAnalytics (copy), computeEditDistance (copy), v30 (copy), GlobalCommands (copy), runGlobalChatCommand (copy)
	return {
		activateWhisperMode = function(n1: number) -- line: 57
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

			Promise.any(t1):catch(function(p2) -- line: 73
				-- upvalues: Logger (copy)
				Logger:debug("Could not send autoCastCommand. Error: {}", p2)
			end)
		end,
		onToggleTranslation = function(b1: boolean) -- line: 78
			-- upvalues: FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), p1 (copy), ChatTranslationGlobalToggled (copy)
			if FFlagExpChatUseMessagesStore then
				GetMessagesStore(false).toggleGlobalTranslation(b1)

				return
			end

			p1(ChatTranslationGlobalToggled(b1))
		end,
		onToggleIndividualTranslation = function(b2: boolean, s2: string) -- line: 87
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
		resetTargetChannel = function(b3: boolean?) -- line: 104
			-- upvalues: p1 (copy), ChatInputBarResetTargetChannel (copy), FFlagExpChatFixBackspaceNilTargetChannel (copy)
			p1(ChatInputBarResetTargetChannel(if not FFlagExpChatFixBackspaceNilTargetChannel then nil else b3))
		end,
		onHovered = function() -- line: 112
			-- upvalues: GetTransparencyStore (copy)
			GetTransparencyStore(false).resetAllTransparency()
		end,
		onUnhovered = function() -- line: 116
			-- upvalues: GetTransparencyStore (copy)
			GetTransparencyStore(false).resetAllTransparency()
		end,
		onSendChat = function(s3: string, t3: {[any]: any}?, b4: boolean?) -- line: 120
			-- upvalues: runVirtualChatCommand (copy), Players (copy), Commands (copy), TextChatService (copy), Logger (copy), Promise (copy), v17 (copy), FFlagExpChatDictatedSpeechEnabled (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), List (copy), Config (copy), FFlagExpChatDictation (copy), DictationAnalytics (copy), Analytics (copy), computeEditDistance (copy)
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
				Promise.try(function() -- line: 141
					-- upvalues: v17 (copy), FFlagExpChatDictatedSpeechEnabled (copy), b4 (copy), TargetTextChannel (ref), s3 (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), List (copy), Players (copy), Config (copy), FFlagExpChatDictation (copy), t3 (copy), DictationAnalytics (copy), Analytics (copy), computeEditDistance (copy)
					if v17 then
						if FFlagExpChatDictatedSpeechEnabled and b4 then
							TargetTextChannel:SendDictatedSpeechAsync(s3)
						elseif getFFlagExpChatProtectedChatInternalAPIs() then
							TargetTextChannel:SendInternalAsync(s3)
						end
					elseif getFFlagExpChatProtectedChatInternalAPIs() then
						TargetTextChannel:SendInternalAsync(s3)
					elseif FFlagExpChatDictatedSpeechEnabled and b4 then
						TargetTextChannel:SendDictatedSpeechAsync(s3)
					else
						TargetTextChannel:SendAsync(s3)
					end

					local v55 = List.count(TargetTextChannel:GetChildren(), function(p3) -- line: 158
						return p3:IsA("TextSource")
					end)
					local t4 = {
						channelName = TargetTextChannel.Name,
						senderUserId = if not Players.LocalPlayer then nil else Players.LocalPlayer.UserId,
						numParticipants = v55,
						isDefaultChannel = not Config[TargetTextChannel.Name] and "false" or "true"
					}

					if FFlagExpChatDictation and t3 then
						t4[DictationAnalytics.Properties.SttMode] = t3.mode
						t4[DictationAnalytics.Properties.SttOutcome] = t3.outcome
					end

					Analytics.FireClientAnalyticsWithEventName("LuaMessageSent", t4)

					if FFlagExpChatDictation and t3 then
						local v57 = t3.textStt or ""
						local v58 = t3.textSent or s3
						local v59, v60

						if #v57 > Config.MessageCharacterLimit then
							v59 = string.sub(v57, 1, Config.MessageCharacterLimit)
							v60 = true
						else
							v59 = v57
							v60 = false
						end

						local v61, v62

						if #v58 > Config.MessageCharacterLimit then
							v61 = string.sub(v58, 1, Config.MessageCharacterLimit)
							v62 = true
						else
							v61 = v58
							v62 = false
						end

						DictationAnalytics.fire(DictationAnalytics.Events.MessageSent, {
							[DictationAnalytics.Properties.SttMode] = t3.mode,
							[DictationAnalytics.Properties.SttOutcome] = t3.outcome,
							[DictationAnalytics.Properties.FinalCharCount] = #v58,
							[DictationAnalytics.Properties.WasEdited] = v57 ~= v58,
							[DictationAnalytics.Properties.EditDistance] = computeEditDistance(v57, v58),
							[DictationAnalytics.Properties.TextStt] = v59,
							[DictationAnalytics.Properties.TextSent] = v61,
							[DictationAnalytics.Properties.TextSttTruncated] = v60,
							[DictationAnalytics.Properties.TextSentTruncated] = v62
						})
					end
				end):catch(function(p4) -- line: 192
					warn(p4.error)
				end)
			else
				Logger:warning("TargetTextChannel was nil!")
			end
		end,
		onSendGlobalChat = function(s4: string, _: {[any]: any}?, b5: boolean?) -- line: 200
			-- upvalues: Players (copy), v30 (copy), runVirtualChatCommand (copy), GlobalCommands (copy), runGlobalChatCommand (copy), Promise (copy), FFlagExpChatDictatedSpeechEnabled (copy), TextChatService (copy)
			if string.sub(s4, 1, 1) == "/" then
				local v53 = Players.LocalPlayer and Players.LocalPlayer.UserId or 0

				if if not v30 then runGlobalChatCommand(s4, v53) else runVirtualChatCommand(s4, v53, GlobalCommands.getGlobalEnabledCommands(), "RBXGlobal") then
					return
				end
			end

			Promise.try(function() -- line: 218
				-- upvalues: FFlagExpChatDictatedSpeechEnabled (copy), b5 (copy), TextChatService (copy), s4 (copy)
				if FFlagExpChatDictatedSpeechEnabled and b5 then
					TextChatService:SendDictatedSpeechUniverseChatAsync(s4)

					return
				end

				TextChatService:SendUniverseChatMessageAsync(s4, "")
			end):catch(function(p5) -- line: 224
				warn(p5.error)
			end)
		end
	}
end
