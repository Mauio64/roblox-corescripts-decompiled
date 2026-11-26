local playButtonStates = require("@luauforge/bundled/due").PlayButtonStates
local buttonType = require("@luauforge/bundled/duf").App.Button.Enum.ButtonType

local getFFlagIsSquadEnabled = require("@luauforge/bundled/dtD").GetFFlagIsSquadEnabled
local fFlagLuaAppPlayButtonLoadingPrimary = require("@luauforge/bundled/dtD").FFlagLuaAppPlayButtonLoadingPrimary
local fFlagLuaAppTextOnlyPlayButton = require("@luauforge/bundled/dtD").FFlagLuaAppTextOnlyPlayButton
local fFlagLuaAppIconTextPlayButton = require("@luauforge/bundled/dtD").FFlagLuaAppIconTextPlayButton
local fFlagLuaAppUpdatePlayButtonText = require("@luauforge/bundled/dtD").FFlagLuaAppUpdatePlayButtonText
local fFlagEnableGameJoinEarlyAccess = require("@luauforge/bundled/dtD").FFlagEnableGameJoinEarlyAccess

local function getPlayButtonProps(p2, p3)
	assert(p2 ~= nil, "Expect playButtonState ~= nil")
	local playButtonProps = {}

	if p2 == playButtonStates.Loading then
		playButtonProps.icon = "icons/status/unavailable"
		playButtonProps.isLoading = true
		playButtonProps.isDisabled = true

		local v5 = if fFlagLuaAppPlayButtonLoadingPrimary then buttonType.PrimaryContextual else buttonType.Secondary
		playButtonProps.buttonType = v5
		return playButtonProps
	end

	if p2 == playButtonStates.Playable then
		if fFlagLuaAppTextOnlyPlayButton or fFlagLuaAppIconTextPlayButton then
			playButtonProps.textKey = fFlagLuaAppUpdatePlayButtonText
				and "Feature.ExperienceDetails.PlayButtonText.Play"
				or "Feature.ExperienceDetails.PlayButtonText.ActionNeeded"
		end

		if not fFlagLuaAppTextOnlyPlayButton then
			playButtonProps.icon = "icons/common/play"
		end

		playButtonProps.isDisabled = false
	elseif p2 == playButtonStates.PaidAccess then
		assert(p3 ~= nil, "gameProductInfo cannot be nil when PlayButtonStates.PaidAccess")
		playButtonProps.price = p3.price
		playButtonProps.icon = "icons/common/robux"
		playButtonProps.isDisabled = false
	elseif p2 == playButtonStates.FiatPaidAccess then
		assert(p3 ~= nil, "gameProductInfo cannot be nil when PlayButtonStates.FiatPaidAccess")
		playButtonProps.localizedFiatPrice = p3.localizedFiatPrice
		playButtonProps.isDisabled = false
	elseif p2 == playButtonStates.UnplayableOther then
		playButtonProps.icon = "icons/status/unavailable"
		playButtonProps.textKey = "Feature.ExperienceDetails.PlayButtonText.Unavailable"
		playButtonProps.isDisabled = true
		playButtonProps.buttonType = buttonType.Secondary
	elseif getFFlagIsSquadEnabled() and p2 == playButtonStates.PlayableWithParty then
		playButtonProps.icon = "icons/common/play"
		playButtonProps.textKey = "Feature.Squads.Action.JoinWithParty"
		playButtonProps.isDisabled = false
		playButtonProps.showSquadButton = true
	elseif getFFlagIsSquadEnabled() and p2 == playButtonStates.WaitingForParty then
		playButtonProps.icon = "icons/common/play"
		playButtonProps.textKey = "Feature.Squads.Action.WaitingForParty"
		playButtonProps.isDisabled = true
		playButtonProps.showSquadButton = true
		playButtonProps.isSquadButtonDisabled = true
	elseif p2 == playButtonStates.ActionNeeded then
		playButtonProps.textKey = "Feature.ExperienceDetails.PlayButtonText.Unlock"
		playButtonProps.isDisabled = false
	else
		if fFlagEnableGameJoinEarlyAccess and p2 == playButtonStates.EarlyAccessLocked then
			playButtonProps.textKey = "Feature.VirtualEvents.Label.EarlyAccess"
		else
			playButtonProps.icon = "icons/status/unavailable"
			playButtonProps.textKey = "Feature.ExperienceDetails.PlayButtonText.Unavailable"
		end

		playButtonProps.isDisabled = true
		playButtonProps.buttonType = buttonType.Secondary
	end

	return playButtonProps
end

return getPlayButtonProps
