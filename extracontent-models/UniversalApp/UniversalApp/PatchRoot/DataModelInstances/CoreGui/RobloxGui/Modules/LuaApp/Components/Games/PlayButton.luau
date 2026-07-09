local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)
local PlayButtonStates = require(CorePackages.Workspace.Packages.GamePlayButton).PlayButtonStates
local UIBlox = require(CorePackages.Packages.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ComboButton = UIBlox.App.Button.ComboButton
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local GetFFlagIsSquadEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagIsSquadEnabled
local FFlagLuaAppPlayButtonLoadingPrimary = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppPlayButtonLoadingPrimary
local FFlagLuaAppEnablePlaySquadButton = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEnablePlaySquadButton
local FFlagUpdateActionNeededPlayButtonUi = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUpdateActionNeededPlayButtonUi
local GetFFlagUIBloxUseFoundationButton = require(CorePackages.Workspace.Packages.SharedFlags).UIBlox.GetFFlagUIBloxUseFoundationButton
local FFlagLuaAppPlayButtonOptOutFoundationButton = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppPlayButtonOptOutFoundationButton
local FFlagLuaAppPlayLoadingClickTelemetryMobile = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppPlayLoadingClickTelemetryMobile
local FFlagLuaAppTextOnlyPlayButton = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppTextOnlyPlayButton
local FFlagLuaAppIconTextPlayButton = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppIconTextPlayButton
local FFlagLuaAppUpdatePlayButtonText = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppUpdatePlayButtonText
local Images = UIBlox.App.ImageSet.Images
local v22 = Images["icons/common/play"]
local v23 = Images["icons/status/private"]
local v24 = Images["icons/status/unavailable"]
local v25 = Images["icons/common/robux"]
local v26 = Images["icons/actions/truncationCollapse"]
local v27 = Roact.PureComponent:extend("PlayButton")

v27.validateProps = t.strictInterface({
	price = t.number,
	localizedFiatPrice = t.string,
	playButtonState = t.string,
	onPlayButtonActivated = t.callback,
	onPlaySquadButtonActivated = if not FFlagLuaAppEnablePlaySquadButton then nil else t.callback,
	Size = t.optional(t.UDim2),
	LayoutOrder = t.optional(t.number),
	testId = t.optional(t.string)
})

function v27.renderWithLocalization(p1, p2) -- line: 51
	-- upvalues: FFlagLuaAppEnablePlaySquadButton (copy), PlayButtonStates (copy), FFlagLuaAppPlayButtonLoadingPrimary (copy), ButtonType (copy), FFlagLuaAppTextOnlyPlayButton (copy), FFlagLuaAppIconTextPlayButton (copy), FFlagLuaAppUpdatePlayButtonText (copy), v22 (copy), GetFFlagIsSquadEnabled (copy), v25 (copy), FFlagUpdateActionNeededPlayButtonUi (copy), v23 (copy), v24 (copy), Roact (copy), ComboButton (copy), v26 (copy), Button (copy), FFlagLuaAppPlayLoadingClickTelemetryMobile (copy), React (copy), GetFFlagUIBloxUseFoundationButton (copy), FFlagLuaAppPlayButtonOptOutFoundationButton (copy)
	local propsSize = p1.props.Size
	local propsLayoutOrder = p1.props.LayoutOrder
	local price = p1.props.price
	local playButtonState = p1.props.playButtonState
	local onPlayButtonActivated = p1.props.onPlayButtonActivated
	local onPlaySquadButtonActivated = p1.props.onPlaySquadButtonActivated
	local v36 = false
	local v37 = false
	local v38 = not FFlagLuaAppEnablePlaySquadButton and nil
	local v39 = not FFlagLuaAppEnablePlaySquadButton and nil
	local v40 = nil
	local v41 = nil
	local v42 = nil

	if playButtonState == PlayButtonStates.Loading then
		v40 = if not FFlagLuaAppPlayButtonLoadingPrimary then ButtonType.Secondary else ButtonType.PrimaryContextual
		v36 = true
	elseif playButtonState == PlayButtonStates.Playable then
		v40 = ButtonType.PrimaryContextual

		if FFlagLuaAppTextOnlyPlayButton or FFlagLuaAppIconTextPlayButton then
			v42 = if not FFlagLuaAppUpdatePlayButtonText then p2.join else p2.play
		end

		if not FFlagLuaAppTextOnlyPlayButton then
			v41 = v22
		end
	elseif GetFFlagIsSquadEnabled() and playButtonState == PlayButtonStates.PlayableWithParty then
		v41 = v22
		v42 = p2.joinWithParty
		v38 = true
	elseif GetFFlagIsSquadEnabled() and playButtonState == PlayButtonStates.WaitingForParty then
		v41 = v22
		v42 = p2.waitingForParty
		v37 = true
		v39 = true
		v38 = true
	elseif playButtonState == PlayButtonStates.PaidAccess then
		v40 = ButtonType.PrimaryContextual
		v41 = v25
		v42 = tostring(price)
	elseif playButtonState == PlayButtonStates.FiatPaidAccess then
		v40 = ButtonType.PrimaryContextual
		v42 = p1.props.localizedFiatPrice
	elseif playButtonState == PlayButtonStates.ActionNeeded then
		if FFlagUpdateActionNeededPlayButtonUi then
			v40 = ButtonType.PrimaryContextual
			v42 = p2.unlock
		else
			v40 = ButtonType.PrimarySystem
			v41 = v23
			v42 = p2.join
		end
	elseif playButtonState == PlayButtonStates.UnplayableOther then
		v40 = ButtonType.Secondary
		v41 = v24
		v42 = p2.unavailable
		v37 = true
	else
		error("invalid play button state!")
	end

	if FFlagLuaAppEnablePlaySquadButton and v38 then
		return Roact.createElement(ComboButton, {
			layoutOrder = propsLayoutOrder,
			size = propsSize,
			button = {
				icon = v41,
				text = v42,
				isDisabled = v37,
				onActivated = v37 and function() -- line: 120
				end or onPlayButtonActivated
			},
			overflow = {
				icon = v26,
				isDisabled = v39,
				onActivated = v39 and function() -- line: 125
				end or onPlaySquadButtonActivated
			},
			testId = p1.props.testId
		})
	end

	local v43 = Roact.createElement(Button, {
		size = if not FFlagLuaAppPlayLoadingClickTelemetryMobile then propsSize else UDim2.fromScale(1, 1),
		layoutOrder = propsLayoutOrder,
		isLoading = v36,
		icon = v41,
		text = v42,
		buttonType = v40,
		userInteractionEnabled = not v37,
		isDisabled = v37,
		onActivated = v37 and function() -- line: 139
		end or onPlayButtonActivated,
		[React.Tag] = if not p1.props.testId then nil else `data-testid={ p1.props.testId }`,
		DO_NOT_USE_useUIBloxButton = GetFFlagUIBloxUseFoundationButton() and true or (not not FFlagLuaAppPlayButtonOptOutFoundationButton or nil)
	})

	if FFlagLuaAppPlayLoadingClickTelemetryMobile then
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = propsSize,
			LayoutOrder = propsLayoutOrder
		}, {
			PlayButton = v43,
			LoadingTelemetryClickCatcher = if not v36 then nil else Roact.createElement("TextButton", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 2,
				[Roact.Event.Activated] = onPlayButtonActivated
			})
		})
	end

	return v43
end
function v27.render(p3) -- line: 173
	-- upvalues: withLocalization (copy), FFlagLuaAppTextOnlyPlayButton (copy), FFlagLuaAppIconTextPlayButton (copy), FFlagLuaAppUpdatePlayButtonText (copy), FFlagUpdateActionNeededPlayButtonUi (copy)
	return withLocalization({
		join = "Feature.ExperienceDetails.PlayButtonText.ActionNeeded",
		joinWithParty = "Feature.Squads.Action.JoinWithParty",
		unavailable = "Feature.ExperienceDetails.PlayButtonText.Unavailable",
		waitingForParty = "Feature.Squads.Action.WaitingForParty",
		play = if not FFlagLuaAppTextOnlyPlayButton and not FFlagLuaAppIconTextPlayButton or not FFlagLuaAppUpdatePlayButtonText then nil else "Feature.ExperienceDetails.PlayButtonText.Play",
		unlock = if not FFlagUpdateActionNeededPlayButtonUi then nil else "Feature.ExperienceDetails.PlayButtonText.Unlock"
	})(function(p4) -- line: 184
		-- upvalues: p3 (copy)
		return p3:renderWithLocalization(p4)
	end)
end

return v27
