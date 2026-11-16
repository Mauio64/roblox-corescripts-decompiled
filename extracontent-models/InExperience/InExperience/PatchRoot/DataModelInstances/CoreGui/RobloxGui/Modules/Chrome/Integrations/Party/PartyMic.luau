local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local CrossExperienceVoice = require(CorePackages.Workspace.Packages.CrossExperienceVoice)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice

local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local SideSheetPlacement = Chrome2.Enums.SideSheetPlacement

local Service = require(Chrome.Service)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local PartyMicIcon = require(Chrome.Integrations.Party.PartyMicIcon)
local Constants = require(Chrome.Integrations.Party.Constants)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Signal = AppCommonLib.Signal
local MappedSignal = ChromeUtils.MappedSignal

local default = CrossExperienceVoice.CrossExperienceVoiceManager.default

local v = nil
local v2 = false

local isLocalPlayerMutedSignal = Signal.new()
local isVoiceConnectedSignal = Signal.new()

isLocalPlayerMutedSignal:connect(function(p)
	v = p
end)

isVoiceConnectedSignal:connect(function(p)
	v2 = p
end)

local isActivated = MappedSignal.new(isLocalPlayerMutedSignal, function()
	return v2 and v == false
end)

local FFlagChangeToggleMicText = require(Chrome.Flags.FFlagChangeToggleMicText)
local v3

if GetFFlagEnableCrossExpVoice() then
	return (Service:register({
		id = Constants.TOGGLE_MIC_INTEGRATION_ID,
		label = FFlagChangeToggleMicText and "CoreScripts.TopBar.Mic" or "CoreScripts.TopBar.ToggleMic",
		sideSheetPlacement = SideSheetPlacement.Unibar,
		isActivated = isActivated,
		activated = function()
			local userId = Players and Players.LocalPlayer and Players.LocalPlayer.UserId or -1

			if userId ~= -1 and v2 and v ~= nil then
				if v then
					default:unmuteVoiceParticipant(userId)
				else
					default:muteVoiceParticipant(userId)
				end
			end
		end,
		components = {
			Icon = function()
				return PartyMicIcon({
					isLocalPlayerMutedSignal = isLocalPlayerMutedSignal,
					isVoiceConnectedSignal = isVoiceConnectedSignal
				})
			end
		},
		initialAvailability = Service.AvailabilitySignal.Unavailable
	}))
end

return v3
