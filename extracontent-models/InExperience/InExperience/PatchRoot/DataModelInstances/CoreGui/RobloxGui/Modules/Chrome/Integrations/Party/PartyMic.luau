local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local CrossExperienceVoice = require(CorePackages.Workspace.Packages.CrossExperienceVoice)
local GetFFlagEnableCrossExpVoice = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableCrossExpVoice
local SideSheetPlacement = require(CorePackages.Workspace.Packages.Chrome).Enums.SideSheetPlacement
local Service = require(Chrome.Service)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local PartyMicIcon = require(Chrome.Integrations.Party.PartyMicIcon)
local Constants = require(Chrome.Integrations.Party.Constants)
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local FFlagChromeActivatedMappedSignal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagChromeActivatedMappedSignal
local MappedSignal = ChromeUtils.MappedSignal
local default = CrossExperienceVoice.CrossExperienceVoiceManager.default
local u15 = nil
local u16 = false
local v17 = Signal.new()
local v18 = Signal.new()

v17:connect(function(p1) -- line: 30
	-- upvalues: u15 (ref)
	u15 = p1
end)
v18:connect(function(p2) -- line: 34
	-- upvalues: u16 (ref)
	u16 = p2
end)

local v19 = if not FFlagChromeActivatedMappedSignal then nil else MappedSignal.new(v17, function() -- line: 39
	-- upvalues: u16 (ref), u15 (ref)
	return u16 and u15 == false
end)
local FFlagChangeToggleMicText = require(Chrome.Flags.FFlagChangeToggleMicText)
local v21 = nil

if GetFFlagEnableCrossExpVoice() then
	v21 = Service:register({
		id = Constants.TOGGLE_MIC_INTEGRATION_ID,
		label = not FFlagChangeToggleMicText and "CoreScripts.TopBar.ToggleMic" or "CoreScripts.TopBar.Mic",
		sideSheetPlacement = SideSheetPlacement.Unibar,
		isActivated = if not FFlagChromeActivatedMappedSignal then nil else v19,
		activated = function() -- line: 54
			-- upvalues: Players (copy), u16 (ref), u15 (ref), default (copy)
			local v24 = Players and (not not Players.LocalPlayer and Players.LocalPlayer.UserId) or -1

			if v24 ~= -1 and (u16 and u15 ~= nil) then
				if u15 then
					default:unmuteVoiceParticipant(v24)

					return
				end

				default:muteVoiceParticipant(v24)
			end
		end,
		components = {
			Icon = function() -- line: 65
				-- upvalues: PartyMicIcon (copy), v17 (copy), v18 (copy)
				return PartyMicIcon({
					isLocalPlayerMutedSignal = v17,
					isVoiceConnectedSignal = v18
				})
			end
		},
		initialAvailability = Service.AvailabilitySignal.Unavailable
	})
end

return v21
