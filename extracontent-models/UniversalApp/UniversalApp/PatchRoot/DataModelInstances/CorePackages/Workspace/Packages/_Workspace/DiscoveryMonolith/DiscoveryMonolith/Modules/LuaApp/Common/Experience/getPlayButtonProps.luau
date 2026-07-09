local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local PlayButtonStates = require(Parent.GamePlayButton).PlayButtonStates
local ButtonType = require(Parent.UIBlox).App.Button.Enum.ButtonType
local GetFFlagIsSquadEnabled = require(Parent.SharedFlags).GetFFlagIsSquadEnabled
local FFlagLuaAppPlayButtonLoadingPrimary = require(Parent.SharedFlags).FFlagLuaAppPlayButtonLoadingPrimary
local FFlagUpdateActionNeededPlayButtonUi = require(Parent.SharedFlags).FFlagUpdateActionNeededPlayButtonUi
local FFlagLuaAppTextOnlyPlayButton = require(Parent.SharedFlags).FFlagLuaAppTextOnlyPlayButton
local FFlagLuaAppIconTextPlayButton = require(Parent.SharedFlags).FFlagLuaAppIconTextPlayButton
local FFlagLuaAppUpdatePlayButtonText = require(Parent.SharedFlags).FFlagLuaAppUpdatePlayButtonText

local function getPlayButtonProps(s1: string, p1) -- line: 43
	-- upvalues: PlayButtonStates (copy), FFlagLuaAppPlayButtonLoadingPrimary (copy), ButtonType (copy), FFlagLuaAppTextOnlyPlayButton (copy), FFlagLuaAppIconTextPlayButton (copy), FFlagLuaAppUpdatePlayButtonText (copy), GetFFlagIsSquadEnabled (copy), FFlagUpdateActionNeededPlayButtonUi (copy)
	assert(s1 ~= nil, "Expect playButtonState ~= nil")

	local t1 = {}

	if s1 == PlayButtonStates.Loading then
		t1.icon = "icons/status/unavailable"
		t1.isLoading = true
		t1.isDisabled = true
		t1.buttonType = if not FFlagLuaAppPlayButtonLoadingPrimary then ButtonType.Secondary else ButtonType.PrimaryContextual

		return t1
	end

	if s1 == PlayButtonStates.Playable then
		if FFlagLuaAppTextOnlyPlayButton or FFlagLuaAppIconTextPlayButton then
			t1.textKey = not FFlagLuaAppUpdatePlayButtonText and "Feature.ExperienceDetails.PlayButtonText.ActionNeeded" or "Feature.ExperienceDetails.PlayButtonText.Play"
		end

		if not FFlagLuaAppTextOnlyPlayButton then
			t1.icon = "icons/common/play"
		end

		t1.isDisabled = false

		return t1
	end

	if s1 == PlayButtonStates.PaidAccess then
		assert(p1 ~= nil, "gameProductInfo cannot be nil when PlayButtonStates.PaidAccess")
		t1.price = p1.price
		t1.icon = "icons/common/robux"
		t1.isDisabled = false

		return t1
	end

	if s1 == PlayButtonStates.FiatPaidAccess then
		assert(p1 ~= nil, "gameProductInfo cannot be nil when PlayButtonStates.FiatPaidAccess")
		t1.localizedFiatPrice = p1.localizedFiatPrice
		t1.isDisabled = false

		return t1
	end

	if s1 == PlayButtonStates.UnplayableOther then
		t1.icon = "icons/status/unavailable"
		t1.textKey = "Feature.ExperienceDetails.PlayButtonText.Unavailable"
		t1.isDisabled = true
		t1.buttonType = ButtonType.Secondary

		return t1
	end

	if GetFFlagIsSquadEnabled() and s1 == PlayButtonStates.PlayableWithParty then
		t1.icon = "icons/common/play"
		t1.textKey = "Feature.Squads.Action.JoinWithParty"
		t1.isDisabled = false
		t1.showSquadButton = true

		return t1
	end

	if GetFFlagIsSquadEnabled() and s1 == PlayButtonStates.WaitingForParty then
		t1.icon = "icons/common/play"
		t1.textKey = "Feature.Squads.Action.WaitingForParty"
		t1.isDisabled = true
		t1.showSquadButton = true
		t1.isSquadButtonDisabled = true

		return t1
	end

	if s1 == PlayButtonStates.ActionNeeded then
		if FFlagUpdateActionNeededPlayButtonUi then
			t1.textKey = "Feature.ExperienceDetails.PlayButtonText.Unlock"
		else
			t1.textKey = "Feature.ExperienceDetails.PlayButtonText.ActionNeeded"
			t1.icon = "icons/status/private"
			t1.buttonType = ButtonType.PrimarySystem
		end

		t1.isDisabled = false

		return t1
	end

	t1.icon = "icons/status/unavailable"
	t1.textKey = "Feature.ExperienceDetails.PlayButtonText.Unavailable"
	t1.isDisabled = true
	t1.buttonType = ButtonType.Secondary

	return t1
end

return getPlayButtonProps
