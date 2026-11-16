local Chrome = script:FindFirstAncestor("Chrome")

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local Foundation = require(CorePackages.Packages.Foundation)
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local Constants = require(RobloxGui.Modules.VoiceChat.Constants)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local CommonFtuxTooltip = require(Chrome.Integrations.CommonFtuxTooltip)
local Constants2 = require(Chrome.ChromeShared.Unibar.Constants)
local isVoiceChatSupported = require(Chrome.Integrations.isVoiceChatSupported)
local VOICE_JOIN_PROGRESS = Constants.VOICE_JOIN_PROGRESS
local PromptType = require(RobloxGui.Modules.VoiceChatPrompt.PromptType)
local CrossExperience = require(CorePackages.Workspace.Packages.CrossExperience)
local observeCurrentContextId = CrossExperience.Utils.observeCurrentContextId
local VoiceChat = require(CorePackages.Workspace.Packages.VoiceChat)
local GetIcon = VoiceChat.Utils.GetIcon

local CrossExperience2 = require(CorePackages.Workspace.Packages.CrossExperience)
local CONTEXT_ID = CrossExperience2.Constants.AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagIntegratePhoneUpsellJoinVoice = SharedFlags.GetFFlagIntegratePhoneUpsellJoinVoice

local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice = SharedFlags2.GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice

local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagProactiveVoiceRestrictionsUFR = SharedFlags3.FFlagProactiveVoiceRestrictionsUFR

local Flags = require(Chrome.ChromeShared.Flags)
local FFlagTokenizeUnibarConstantsWithStyleProvider = Flags.FFlagTokenizeUnibarConstantsWithStyleProvider
local defineFastFlag = game:DefineFastFlag("CheckShouldShowJoinVoiceInEvent", false)

local defineFastFlag2 = game:DefineFastFlag("ReplaceJoinVoiceIconToMuted", false)
local defineFastInt = game:DefineFastInt("JoinVoiceFtuxShowDelayMs", 1000)
local defineFastInt2 = game:DefineFastInt("JoinVoiceFtuxDismissDelayMs", 5000)
local defineFastInt3 = game:DefineFastInt("UnibarJoinVoiceTooltipPriority", 1000)
local defineFastFlag3 = game:DefineFastFlag("EnableChromeJoinVoiceTooltip", false)

local Service = require(Chrome.Service)
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local UnibarStyle = Chrome2.UnibarStyle

local Chrome3 = require(CorePackages.Workspace.Packages.Chrome)
local SideSheetPlacement = Chrome3.Enums.SideSheetPlacement

local v = false
local v2 = false
local v3 = Service.AvailabilitySignal.Unavailable

function getShouldShowJoinVoiceTooltip()
	local ageVerificationOverlay = default:FetchAgeVerificationOverlay()

	local showJoinVoiceUpsellTooltip = not v2
		and ageVerificationOverlay
		and ageVerificationOverlay.showJoinVoiceUpsellTooltip
	v2 = true
	return showJoinVoiceUpsellTooltip
end

local v4 = Service:register({
	initialAvailability = Service.AvailabilitySignal.Unavailable,
	id = "join_voice",
	label = "CoreScripts.TopBar.JoinVoice",
	sideSheetPlacement = SideSheetPlacement.Unibar,
	activated = function()
		if FFlagProactiveVoiceRestrictionsUFR and default:GetVoiceRestrictionState(false) ~= "normal" then
			return
		end

		local SettingsHub

		if GetFFlagIntegratePhoneUpsellJoinVoice() then
			SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
		end

		default.pendingConnectionSource = Constants.VOICE_CONNECTION_SOURCE.IN_EXPERIENCE
		default:JoinVoice(SettingsHub)
	end,
	components = {
		Icon = function()
			local ICON_SIZE

			if FFlagTokenizeUnibarConstantsWithStyleProvider then
				ICON_SIZE = UnibarStyle.use().ICON_SIZE
			else
				ICON_SIZE = Constants2.ICON_SIZE
			end

			local v4 = not defineFastFlag2 and "icons/controls/publicAudioJoin" or GetIcon("Muted", "MicLight")

			if not defineFastFlag3 then
				return (CommonIcon(v4))
			end

			local shouldShowJoinVoiceTooltip = getShouldShowJoinVoiceTooltip()
			return React.createElement(Foundation.View, {
				Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE)
			}, {
				Icon = CommonIcon(v4),
				Tooltip = CommonFtuxTooltip({
					id = "JOIN_VOICE",
					priority = defineFastInt3,
					isIconVisible = shouldShowJoinVoiceTooltip,
					dismissOnOutsideInput = true,
					headerKey = "CoreScripts.FTUX.Heading.JoinVoice",
					bodyKey = "CoreScripts.FTUX.Label.JoinVoiceDescription",
					showDelay = defineFastInt,
					dismissDelay = defineFastInt2,
					onDismissed = function()
						pcall(function()
							default:RecordUserSeenModal(Constants.MODAL_IDS.IN_EXP_JOIN_VOICE_UPSELL)
						end)
					end
				})
			})
		end
	}
})

if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
	return v4
end

local function setAvailability(p: number)
	if FFlagProactiveVoiceRestrictionsUFR and default:GetVoiceRestrictionState(false) ~= "normal" then
		v4.availability:unavailable()
		return
	end

	v3 = p

	if not v then
		if p == Service.AvailabilitySignal.Available then
			v4.availability:available()
		elseif p == Service.AvailabilitySignal.Unavailable then
			v4.availability:unavailable()
		end
	end
end

local function HideOrShowJoinVoiceButton(p)
	if FFlagProactiveVoiceRestrictionsUFR and default:GetVoiceRestrictionState(false) ~= "normal" then
		v4.availability:unavailable()
	elseif p == VOICE_JOIN_PROGRESS.Suspended and (not defineFastFlag or default:ShouldShowJoinVoice()) then
		setAvailability(Service.AvailabilitySignal.Available)
	elseif p == VOICE_JOIN_PROGRESS.Joined then
		setAvailability(Service.AvailabilitySignal.Unavailable)

		if default.inExpUpsellEntrypoint == Constants.IN_EXP_UPSELL_ENTRYPOINTS.JOIN_VOICE then
			default:ToggleMic()
			default:showPrompt(PromptType.VoiceConsentAcceptedToast)
		end
	end
end

if FFlagProactiveVoiceRestrictionsUFR then
	local effect = Signals.createEffect(function(p)
		if default:GetVoiceRestrictionState(p) ~= "normal" then
			v4.availability:unavailable()
		end
	end)
	script.Destroying:Once(effect)
end

observeCurrentContextId(function(p)
	local v5 = p == CONTEXT_ID

	if v ~= v5 then
		v = v5

		if v then
			v3 = v4.availability:get()
			v4.availability:unavailable()
		else
			setAvailability(v3)
		end
	end
end)

if not isVoiceChatSupported() then
	return v4
end

if GetFFlagIntegratePhoneUpsellJoinVoice() then
	task.spawn(function()
		if default:ShouldShowJoinVoice() then
			setAvailability(Service.AvailabilitySignal.Available)
		end

		default.VoiceJoinProgressChanged.Event:Connect(HideOrShowJoinVoiceButton)
	end)
else
	if default:ShouldShowJoinVoice() then
		setAvailability(Service.AvailabilitySignal.Available)
	end

	default.VoiceJoinProgressChanged.Event:Connect(HideOrShowJoinVoiceButton)
end

return v4
