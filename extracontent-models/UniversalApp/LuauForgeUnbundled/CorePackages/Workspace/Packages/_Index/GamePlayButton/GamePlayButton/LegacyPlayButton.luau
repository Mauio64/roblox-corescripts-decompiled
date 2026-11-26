local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Roact")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/t")
local PlayButtonStates = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonStates")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/UIBlox")
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local comboButton = UIBlox.App.Button.ComboButton
local withLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Localization").withLocalization

local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").GetFFlagIsSquadEnabled
local fFlagLuaAppPlayButtonLoadingPrimary = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonLoadingPrimary
local getFFlagUIBloxUseFoundationButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").UIBlox.GetFFlagUIBloxUseFoundationButton

local fFlagLuaAppPlayButtonOptOutFoundationButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonOptOutFoundationButton

local fFlagLuaAppPlayLoadingClickTelemetryMobile = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayLoadingClickTelemetryMobile
local fFlagLuaAppTextOnlyPlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppTextOnlyPlayButton
local fFlagLuaAppIconTextPlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppIconTextPlayButton
local fFlagLuaAppUpdatePlayButtonText = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppUpdatePlayButtonText
local fFlagLuaAppPlayButtonPrivatePT = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonPrivatePT
local fFlagEnableGameJoinEarlyAccess = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagEnableGameJoinEarlyAccess

local images = UIBlox.App.ImageSet.Images

local iconscommonplay = images["icons/common/play"]
local iconsstatusunavailable = images["icons/status/unavailable"]
local iconscommonrobux = images["icons/common/robux"]
local iconsactionstruncationCollapse = images["icons/actions/truncationCollapse"]

local extended = Roact.PureComponent:extend("PlayButton")

local strictInterface = t.strictInterface
local v5 = {
	price = t.number,
	localizedFiatPrice = t.string,
	playButtonState = t.string,
	onPlayButtonActivated = t.callback,
	onPlaySquadButtonActivated = 0,
	Size = 0,
	LayoutOrder = 0,
	testId = 0
}
local v6 = if getFFlagIsSquadEnabled() then t.callback else nil
v5.onPlaySquadButtonActivated = v6
v5.Size = t.optional(t.UDim2)
v5.LayoutOrder = t.optional(t.number)
v5.testId = t.optional(t.string)
extended.validateProps = strictInterface(v5)

function extended:renderWithLocalization(props)
	local size = self.props.Size
	local layoutOrder = self.props.LayoutOrder
	local price = self.props.price
	local playButtonState = self.props.playButtonState
	local onPlayButtonActivated = self.props.onPlayButtonActivated
	local onPlaySquadButtonActivated = self.props.onPlaySquadButtonActivated

	local flag = false
	local v7 = false
	local v8 = if getFFlagIsSquadEnabled() then false else nil
	local v9 = if getFFlagIsSquadEnabled() then false else nil

	local v10 = nil
	local v11 = nil
	local v12 = nil

	if playButtonState == PlayButtonStates.Loading then
		if fFlagLuaAppPlayButtonLoadingPrimary then
			v10 = buttonType.PrimaryContextual
		else
			v10 = buttonType.Secondary
		end

		flag = true
	elseif playButtonState == PlayButtonStates.Playable then
		v10 = buttonType.PrimaryContextual

		if fFlagLuaAppTextOnlyPlayButton or fFlagLuaAppIconTextPlayButton then
			v12 = if fFlagLuaAppUpdatePlayButtonText then props.play else props.join
		end

		if not fFlagLuaAppTextOnlyPlayButton then
			v11 = iconscommonplay
		end
	elseif getFFlagIsSquadEnabled() and playButtonState == PlayButtonStates.PlayableWithParty then
		v11 = iconscommonplay
		v12 = props.joinWithParty
		v8 = true
	elseif getFFlagIsSquadEnabled() and playButtonState == PlayButtonStates.WaitingForParty then
		v11 = iconscommonplay
		v12 = props.waitingForParty
		v8 = true
		v7 = true
		v9 = true
	elseif playButtonState == PlayButtonStates.PaidAccess then
		v10 = buttonType.PrimaryContextual
		v11 = iconscommonrobux
		v12 = tostring(price)
	elseif playButtonState == PlayButtonStates.FiatPaidAccess then
		v10 = buttonType.PrimaryContextual
		v12 = self.props.localizedFiatPrice
	elseif playButtonState == PlayButtonStates.DemoMode then
		v10 = buttonType.PrimarySystem
		v12 = props.playDemo
	elseif fFlagLuaAppPlayButtonPrivatePT and playButtonState == PlayButtonStates.Playtest then
		v10 = buttonType.PrimarySystem
		v12 = props.playtest
	elseif playButtonState == PlayButtonStates.ActionNeeded then
		v10 = buttonType.PrimaryContextual
		v12 = props.unlock
	elseif playButtonState == PlayButtonStates.UnplayableOther then
		v10 = buttonType.Secondary
		v11 = iconsstatusunavailable
		v12 = props.unavailable
		v7 = true
	elseif fFlagEnableGameJoinEarlyAccess and playButtonState == PlayButtonStates.EarlyAccessLocked then
		v10 = buttonType.Secondary
		v12 = props.unavailable
		v7 = true
	else
		error("invalid play button state!")
	end

	if getFFlagIsSquadEnabled() and v8 then
		return Roact.createElement(comboButton, {
			layoutOrder = layoutOrder,
			size = size,
			button = {
				icon = v11,
				text = v12,
				isDisabled = v7,
				onActivated = v7 and function() end or onPlayButtonActivated
			},
			overflow = {
				icon = iconsactionstruncationCollapse,
				isDisabled = v9,
				onActivated = v9 and function() end or onPlaySquadButtonActivated
			},
			testId = self.props.testId
		})
	end

	local createElement = Roact.createElement
	local v15 = if fFlagLuaAppPlayLoadingClickTelemetryMobile then UDim2.fromScale(1, 1) else size

	local tag = React.Tag
	local v16 = if self.props.testId then `data-testid={self.props.testId}` else nil
	local element = createElement(button, {
		size = v15,
		layoutOrder = layoutOrder,
		isLoading = flag,
		icon = v11,
		text = v12,
		buttonType = v10,
		userInteractionEnabled = not v7,
		isDisabled = v7,
		onActivated = v7 and function() end or onPlayButtonActivated,
		[tag] = v16,
		DO_NOT_USE_useUIBloxButton = (getFFlagUIBloxUseFoundationButton() or fFlagLuaAppPlayButtonOptOutFoundationButton) and true or nil
	})

	if not fFlagLuaAppPlayLoadingClickTelemetryMobile then
		return element
	end

	local createElement2 = Roact.createElement
	local v20

	if flag then
		v20 = Roact.createElement("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 2,
			[Roact.Event.Activated] = onPlayButtonActivated
		})
	end

	return createElement2(
		"Frame",
		{
			Size = size,
			LayoutOrder = layoutOrder,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		},
		{ PlayButton = element, LoadingTelemetryClickCatcher = v20 }
	)
end

function extended:render()
	return withLocalization({
		join = "Feature.ExperienceDetails.PlayButtonText.ActionNeeded",
		play = (fFlagLuaAppTextOnlyPlayButton or fFlagLuaAppIconTextPlayButton) and fFlagLuaAppUpdatePlayButtonText and "Feature.ExperienceDetails.PlayButtonText.Play" or nil,
		unlock = "Feature.ExperienceDetails.PlayButtonText.Unlock",
		joinWithParty = "Feature.Squads.Action.JoinWithParty",
		unavailable = "Feature.ExperienceDetails.PlayButtonText.Unavailable",
		waitingForParty = "Feature.Squads.Action.WaitingForParty",
		playDemo = "Feature.ExperienceDetails.PlayButtonText.PlayDemo",
		playtest = fFlagLuaAppPlayButtonPrivatePT and "Feature.ExperienceDetails.PlayButtonText.Playtest" or nil
	})(function(p2)
		return self:renderWithLocalization(p2)
	end)
end

return extended
