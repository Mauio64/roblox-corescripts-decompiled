local Chrome = script:FindFirstAncestor("Chrome")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local Constants = require(RobloxGui.Modules.VoiceChat.Constants)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local CommonFtuxTooltip = require(Chrome.Integrations.CommonFtuxTooltip)
local Constants2 = require(Chrome.ChromeShared.Unibar.Constants)
local VOICE_JOIN_PROGRESS = Constants.VOICE_JOIN_PROGRESS
local PromptType = require(RobloxGui.Modules.VoiceChatPrompt.PromptType)
local observeCurrentContextId = require(CorePackages.Workspace.Packages.CrossExperience).Utils.observeCurrentContextId
local GetIcon = require(CorePackages.Workspace.Packages.VoiceChat).Utils.GetIcon
local CONTEXT_ID = require(CorePackages.Workspace.Packages.CrossExperience).Constants.AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID
local GetFFlagEnableConnectDisconnectInSettingsAndChrome = require(RobloxGui.Modules.Flags.GetFFlagEnableConnectDisconnectInSettingsAndChrome)
local GetFFlagIntegratePhoneUpsellJoinVoice = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagIntegratePhoneUpsellJoinVoice
local GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice
local GetFFlagEnableVoiceUxUpdates = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableVoiceUxUpdates
local FFlagTokenizeUnibarConstantsWithStyleProvider = require(Chrome.ChromeShared.Flags).FFlagTokenizeUnibarConstantsWithStyleProvider
local v21 = game:DefineFastFlag("CheckShouldShowJoinVoiceInEvent", false)
local v22 = game:DefineFastFlag("ReplaceJoinVoiceIconToMuted", false)
local v23 = game:DefineFastInt("JoinVoiceFtuxShowDelayMs", 1000)
local v24 = game:DefineFastInt("JoinVoiceFtuxDismissDelayMs", 5000)
local v25 = game:DefineFastInt("UnibarJoinVoiceTooltipPriority", 1000)
local v26 = game:DefineFastFlag("EnableChromeJoinVoiceTooltip", false)
local Service = require(Chrome.Service)
local UnibarStyle = require(CorePackages.Workspace.Packages.Chrome).UnibarStyle
local SideSheetPlacement = require(CorePackages.Workspace.Packages.Chrome).Enums.SideSheetPlacement
local u30 = false
local u31 = false
local Unavailable = Service.AvailabilitySignal.Unavailable

function getShouldShowJoinVoiceTooltip() -- line: 48
	-- upvalues: default (copy), u31 (ref)
	local v37 = default:FetchAgeVerificationOverlay()
	local v38 = not u31 and (v37 and v37.showJoinVoiceUpsellTooltip)

	u31 = true

	return v38
end

local u33 = Service:register({
	id = "join_voice",
	label = "CoreScripts.TopBar.JoinVoice",
	initialAvailability = Service.AvailabilitySignal.Unavailable,
	sideSheetPlacement = SideSheetPlacement.Unibar,
	activated = function() -- line: 63
		-- upvalues: GetFFlagIntegratePhoneUpsellJoinVoice (copy), RobloxGui (copy), default (copy), Constants (copy)
		local v39 = if not GetFFlagIntegratePhoneUpsellJoinVoice() then nil else require(RobloxGui.Modules.Settings.SettingsHub)

		default.pendingConnectionSource = Constants.VOICE_CONNECTION_SOURCE.IN_EXPERIENCE
		default:JoinVoice(v39)
	end,
	components = {
		Icon = function() -- line: 71
			-- upvalues: FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants2 (copy), v22 (copy), GetIcon (copy), v26 (copy), React (copy), Foundation (copy), CommonIcon (copy), CommonFtuxTooltip (copy), v25 (copy), v23 (copy), v24 (copy), default (copy), Constants (copy)
			local v40 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants2.ICON_SIZE else UnibarStyle.use().ICON_SIZE
			local s1 = "icons/controls/publicAudioJoin"

			if v22 then
				s1 = GetIcon("Muted", "MicLight")
			end

			if v26 then
				local v42 = getShouldShowJoinVoiceTooltip()

				return React.createElement(Foundation.View, {
					Size = UDim2.new(0, v40, 0, v40)
				}, {
					Icon = CommonIcon(s1),
					Tooltip = CommonFtuxTooltip({
						id = "JOIN_VOICE",
						dismissOnOutsideInput = true,
						headerKey = "CoreScripts.FTUX.Heading.JoinVoice",
						bodyKey = "CoreScripts.FTUX.Label.JoinVoiceDescription",
						priority = v25,
						isIconVisible = v42,
						showDelay = v23,
						dismissDelay = v24,
						onDismissed = function() -- line: 99
							-- upvalues: default (copy), Constants (copy)
							pcall(function() -- line: 100
								-- upvalues: default (copy), Constants (copy)
								default:RecordUserSeenModal(Constants.MODAL_IDS.IN_EXP_JOIN_VOICE_UPSELL)
							end)
						end
					})
				})
			end

			return (CommonIcon(s1))
		end
	}
})

if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
	return u33
end

local function setAvailability(n1: number) -- line: 118
	-- upvalues: Unavailable (ref), u30 (ref), Service (copy), u33 (ref)
	Unavailable = n1

	if not u30 then
		if n1 == Service.AvailabilitySignal.Available then
			u33.availability:available()

			return
		end

		if n1 == Service.AvailabilitySignal.Unavailable then
			u33.availability:unavailable()
		end
	end
end
local function HideOrShowJoinVoiceButton(p1) -- line: 129
	-- upvalues: VOICE_JOIN_PROGRESS (copy), v21 (copy), default (copy), Service (copy), Unavailable (ref), u30 (ref), u33 (ref), Constants (copy), PromptType (copy)
	if p1 == VOICE_JOIN_PROGRESS.Suspended and (not v21 or default:ShouldShowJoinVoice()) then
		local Available = Service.AvailabilitySignal.Available

		Unavailable = Available

		if not u30 then
			if Available == Service.AvailabilitySignal.Available then
				u33.availability:available()

				return
			end

			if Available == Service.AvailabilitySignal.Unavailable then
				u33.availability:unavailable()

				return
			end
		end
	elseif p1 == VOICE_JOIN_PROGRESS.Joined then
		local Unavailable2 = Service.AvailabilitySignal.Unavailable

		Unavailable = Unavailable2

		if not u30 then
			if Unavailable2 == Service.AvailabilitySignal.Available then
				u33.availability:available()
			elseif Unavailable2 == Service.AvailabilitySignal.Unavailable then
				u33.availability:unavailable()
			end
		end

		if default.inExpUpsellEntrypoint == Constants.IN_EXP_UPSELL_ENTRYPOINTS.JOIN_VOICE then
			default:ToggleMic()
			default:showPrompt(PromptType.VoiceConsentAcceptedToast)
		end
	end
end

observeCurrentContextId(function(p2) -- line: 144
	-- upvalues: CONTEXT_ID (copy), u30 (ref), Unavailable (ref), u33 (ref), Service (copy)
	local v48 = p2 == CONTEXT_ID

	if v48 ~= u30 then
		u30 = v48

		if u30 then
			Unavailable = u33.availability:get()
			u33.availability:unavailable()

			return
		end

		local v49 = Unavailable

		Unavailable = v49

		if not u30 then
			if v49 == Service.AvailabilitySignal.Available then
				u33.availability:available()

				return
			end

			if v49 == Service.AvailabilitySignal.Unavailable then
				u33.availability:unavailable()
			end
		end
	end
end)

if game:GetEngineFeature("VoiceChatSupported") then
	if GetFFlagIntegratePhoneUpsellJoinVoice() then
		task.spawn(function() -- line: 159
			-- upvalues: default (copy), Service (copy), Unavailable (ref), u30 (ref), u33 (ref), HideOrShowJoinVoiceButton (copy)
			if default:ShouldShowJoinVoice() then
				local Available = Service.AvailabilitySignal.Available

				Unavailable = Available

				if not u30 then
					if Available == Service.AvailabilitySignal.Available then
						u33.availability:available()
					elseif Available == Service.AvailabilitySignal.Unavailable then
						u33.availability:unavailable()
					end
				end
			end

			default.VoiceJoinProgressChanged.Event:Connect(HideOrShowJoinVoiceButton)
		end)
	else
		if default:ShouldShowJoinVoice() then
			local Available = Service.AvailabilitySignal.Available

			Unavailable = Available

			if not u30 then
				if Available == Service.AvailabilitySignal.Available then
					u33.availability:available()
				elseif Available == Service.AvailabilitySignal.Unavailable then
					u33.availability:unavailable()
				end
			end
		end

		default.VoiceJoinProgressChanged.Event:Connect(HideOrShowJoinVoiceButton)
	end

	if GetFFlagEnableConnectDisconnectInSettingsAndChrome() then
		if not GetFFlagEnableVoiceUxUpdates() then
			default.showVoiceUI.Event:Connect(function() -- line: 175
				-- upvalues: Service (copy), Unavailable (ref), u30 (ref), u33 (ref)
				local Unavailable3 = Service.AvailabilitySignal.Unavailable

				Unavailable = Unavailable3

				if not u30 then
					if Unavailable3 == Service.AvailabilitySignal.Available then
						u33.availability:available()

						return
					end

					if Unavailable3 == Service.AvailabilitySignal.Unavailable then
						u33.availability:unavailable()
					end
				end
			end)
			default.hideVoiceUI.Event:Connect(function() -- line: 178
				-- upvalues: Service (copy), Unavailable (ref), u30 (ref), u33 (ref)
				local Available = Service.AvailabilitySignal.Available

				Unavailable = Available

				if not u30 then
					if Available == Service.AvailabilitySignal.Available then
						u33.availability:available()

						return
					end

					if Available == Service.AvailabilitySignal.Unavailable then
						u33.availability:unavailable()
					end
				end
			end)
		end
	else
		default.VoiceJoinProgressChanged.Event:Connect(HideOrShowJoinVoiceButton)
	end
end

return u33
