local parent = script:FindFirstAncestor("GamePlayButton").Parent

local Roact = require(parent.Roact)
local React = require(parent.React)
local t = require(parent.t)
local PlayButtonStates = require(script.Parent.PlayButtonStates)
local UIBlox = require(parent.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ComboButton = UIBlox.App.Button.ComboButton
local Localization = require(parent.Localization)
local withLocalization = Localization.withLocalization

local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonLoadingPrimary = SharedFlags2.FFlagLuaAppPlayButtonLoadingPrimary
local SharedFlags3 = require(parent.SharedFlags)
local GetFFlagUIBloxUseFoundationButton = SharedFlags3.UIBlox.GetFFlagUIBloxUseFoundationButton

local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonOptOutFoundationButton = SharedFlags4.FFlagLuaAppPlayButtonOptOutFoundationButton

local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppPlayLoadingClickTelemetryMobile = SharedFlags5.FFlagLuaAppPlayLoadingClickTelemetryMobile
local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppTextOnlyPlayButton = SharedFlags6.FFlagLuaAppTextOnlyPlayButton
local SharedFlags7 = require(parent.SharedFlags)
local FFlagLuaAppIconTextPlayButton = SharedFlags7.FFlagLuaAppIconTextPlayButton
local SharedFlags8 = require(parent.SharedFlags)
local FFlagLuaAppUpdatePlayButtonText = SharedFlags8.FFlagLuaAppUpdatePlayButtonText
local SharedFlags9 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonPrivatePT = SharedFlags9.FFlagLuaAppPlayButtonPrivatePT
local SharedFlags10 = require(parent.SharedFlags)
local FFlagEnableGameJoinEarlyAccess = SharedFlags10.FFlagEnableGameJoinEarlyAccess

local Images = UIBlox.App.ImageSet.Images

local iconscommonplay = Images["icons/common/play"]
local iconsstatusunavailable = Images["icons/status/unavailable"]
local iconscommonrobux = Images["icons/common/robux"]
local iconsactionstruncationCollapse = Images["icons/actions/truncationCollapse"]

local extended = Roact.PureComponent:extend("PlayButton")

local strictInterface = t.strictInterface
local v = {
	price = t.number,
	localizedFiatPrice = t.string,
	playButtonState = t.string,
	onPlayButtonActivated = t.callback,
	onPlaySquadButtonActivated = 0,
	Size = 0,
	LayoutOrder = 0,
	testId = 0
}
local onPlaySquadButtonActivated2

if GetFFlagIsSquadEnabled() then
	onPlaySquadButtonActivated2 = t.callback
end

v.onPlaySquadButtonActivated = onPlaySquadButtonActivated2
v.Size = t.optional(t.UDim2)
v.LayoutOrder = t.optional(t.number)
v.testId = t.optional(t.string)
extended.validateProps = strictInterface(v)

function extended:renderWithLocalization(props)
	local size = self.props.Size
	local layoutOrder = self.props.LayoutOrder
	local price = self.props.price
	local playButtonState = self.props.playButtonState
	local onPlayButtonActivated = self.props.onPlayButtonActivated
	local onPlaySquadButtonActivated = self.props.onPlaySquadButtonActivated

	local flag = false
	local isDisabled = false
	local v2

	if GetFFlagIsSquadEnabled() then
		v2 = false
	end

	local isDisabled2

	if GetFFlagIsSquadEnabled() then
		isDisabled2 = false
	end

	local buttonType = nil
	local icon = nil
	local text = nil

	if playButtonState == PlayButtonStates.Loading then
		if FFlagLuaAppPlayButtonLoadingPrimary then
			buttonType = ButtonType.PrimaryContextual
		else
			buttonType = ButtonType.Secondary
		end

		flag = true
	elseif playButtonState == PlayButtonStates.Playable then
		buttonType = ButtonType.PrimaryContextual

		if FFlagLuaAppTextOnlyPlayButton or FFlagLuaAppIconTextPlayButton then
			if FFlagLuaAppUpdatePlayButtonText then
				text = props.play
			else
				text = props.join
			end
		end

		if not FFlagLuaAppTextOnlyPlayButton then
			icon = iconscommonplay
		end
	elseif GetFFlagIsSquadEnabled() and playButtonState == PlayButtonStates.PlayableWithParty then
		icon = iconscommonplay
		text = props.joinWithParty
		v2 = true
	elseif GetFFlagIsSquadEnabled() and playButtonState == PlayButtonStates.WaitingForParty then
		icon = iconscommonplay
		text = props.waitingForParty
		v2 = true
		isDisabled = true
		isDisabled2 = true
	elseif playButtonState == PlayButtonStates.PaidAccess then
		buttonType = ButtonType.PrimaryContextual
		icon = iconscommonrobux
		text = tostring(price)
	elseif playButtonState == PlayButtonStates.FiatPaidAccess then
		buttonType = ButtonType.PrimaryContextual
		text = self.props.localizedFiatPrice
	elseif playButtonState == PlayButtonStates.DemoMode then
		buttonType = ButtonType.PrimarySystem
		text = props.playDemo
	elseif FFlagLuaAppPlayButtonPrivatePT and playButtonState == PlayButtonStates.Playtest then
		buttonType = ButtonType.PrimarySystem
		text = props.playtest
	elseif playButtonState == PlayButtonStates.ActionNeeded then
		buttonType = ButtonType.PrimaryContextual
		text = props.unlock
	elseif playButtonState == PlayButtonStates.UnplayableOther then
		buttonType = ButtonType.Secondary
		icon = iconsstatusunavailable
		text = props.unavailable
		isDisabled = true
	elseif FFlagEnableGameJoinEarlyAccess and playButtonState == PlayButtonStates.EarlyAccessLocked then
		buttonType = ButtonType.Secondary
		text = props.unavailable
		isDisabled = true
	else
		error("invalid play button state!")
	end

	if GetFFlagIsSquadEnabled() and v2 then
		return Roact.createElement(ComboButton, {
			layoutOrder = layoutOrder,
			size = size,
			button = {
				icon = icon,
				text = text,
				isDisabled = isDisabled,
				onActivated = isDisabled and function() end or onPlayButtonActivated
			},
			overflow = {
				icon = iconsactionstruncationCollapse,
				isDisabled = isDisabled2,
				onActivated = isDisabled2 and function() end or onPlaySquadButtonActivated
			},
			testId = self.props.testId
		})
	end

	local createElement = Roact.createElement
	local size2

	if FFlagLuaAppPlayLoadingClickTelemetryMobile then
		size2 = UDim2.fromScale(1, 1)
	else
		size2 = size
	end

	local v3 = {
		["size"] = size2,
		layoutOrder = layoutOrder,
		isLoading = flag,
		icon = icon,
		text = text,
		buttonType = buttonType,
		userInteractionEnabled = not isDisabled,
		isDisabled = isDisabled,
		onActivated = isDisabled and function() end or onPlayButtonActivated
	}
	local tag = React.Tag
	local v4

	if self.props.testId then
		v4 = `data-testid={self.props.testId}`
	end

	v3[tag] = v4
	v3.DO_NOT_USE_useUIBloxButton = (GetFFlagUIBloxUseFoundationButton() or FFlagLuaAppPlayButtonOptOutFoundationButton)
		and true
		or nil
	local element = createElement(Button, v3)

	if not FFlagLuaAppPlayLoadingClickTelemetryMobile then
		return element
	end

	local createElement2 = Roact.createElement
	local loadingTelemetryClickCatcher

	if flag then
		loadingTelemetryClickCatcher = Roact.createElement("TextButton", {
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
		{ Size = size, LayoutOrder = layoutOrder, BackgroundTransparency = 1, BorderSizePixel = 0 },
		{ PlayButton = element, LoadingTelemetryClickCatcher = loadingTelemetryClickCatcher }
	)
end

function extended:render()
	return withLocalization({
		join = "Feature.ExperienceDetails.PlayButtonText.ActionNeeded",
		play = (FFlagLuaAppTextOnlyPlayButton or FFlagLuaAppIconTextPlayButton) and FFlagLuaAppUpdatePlayButtonText and "Feature.ExperienceDetails.PlayButtonText.Play" or nil,
		unlock = "Feature.ExperienceDetails.PlayButtonText.Unlock",
		joinWithParty = "Feature.Squads.Action.JoinWithParty",
		unavailable = "Feature.ExperienceDetails.PlayButtonText.Unavailable",
		waitingForParty = "Feature.Squads.Action.WaitingForParty",
		playDemo = "Feature.ExperienceDetails.PlayButtonText.PlayDemo",
		playtest = FFlagLuaAppPlayButtonPrivatePT and "Feature.ExperienceDetails.PlayButtonText.Playtest" or nil
	})(function(p)
		return self:renderWithLocalization(p)
	end)
end

return extended
