local Players = game:GetService("Players")

local parent = script.Parent.Parent.Parent
local TextKeys = require(parent.Common.TextKeys)
local dependencies = require(parent.dependencies)
local analytics = parent.Analytics
local EventNames = require(analytics.Enums.EventNames)

local react = dependencies.React
local uiBlox = dependencies.UIBlox
local foundation = dependencies.Foundation
local checkbox = foundation.Checkbox
local normalizeFontFace = foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = foundation.Utility.Flags.FoundationFontFaceMigration

local useLocalization = dependencies.Hooks.useLocalization

local DiscoverabilityUpsellNonPrefillDiscoverableUserIdsWhitelist = require(parent.Flags.DiscoverabilityUpsellNonPrefillDiscoverableUserIdsWhitelist)

local useStyle = uiBlox.Core.Style.useStyle
local partialPageModal = uiBlox.App.Dialog.Modal.PartialPageModal
local buttonType = uiBlox.App.Button.Enum.ButtonType
local styledTextLabel = uiBlox.App.Text.StyledTextLabel

local radioButtonList = uiBlox.App.InputButton.RadioButtonList
local images = uiBlox.App.ImageSet.Images
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local iconSize = uiBlox.App.Constant.IconSize

local v = { ["1"] = "Discoverable", ["2"] = "NotDiscoverable", ["nil"] = "Unset" }

return function(props)
	local v2 = props.prefillDiscoverabilitySetting

	if
		Players.LocalPlayer
		and DiscoverabilityUpsellNonPrefillDiscoverableUserIdsWhitelist.isWhitelistedUserId(Players.LocalPlayer.UserId)
	then
		v2 = false
	end

	local state, setState = react.useState(v2 and 1 or nil)

	local v3 = useStyle()
	local font = v3.Font
	local theme = v3.Theme

	local v4 = useLocalization({
		optInText = TextKeys.DISCOVERABILITY_OPT_IN,
		infoText = TextKeys.DISCOVERABILITY_INFO,
		learnMoreText = TextKeys.LEARN_MORE,
		continueText = TextKeys.CONTINUE,
		yesText = TextKeys.YES_OPT_IN,
		noText = TextKeys.NO_OPT_OUT,
		titleText = TextKeys.DISCOVERABILITY_TITLE,
		titleTextPrefillDiscoverable = TextKeys.DISCOVERABILITY_TITLE_PREFILL_DISCOVERABLE,
		optInTextPrefillDiscoverable = TextKeys.DISCOVERABILITY_OPT_IN_PREFILL_DISCOVERABLE,
		infoTextPrefillDiscoverable = TextKeys.DISCOVERABILITY_INFO_PREFILL_DISCOVERABLE
	})

	local function onActivated(p) -- 1 equivalent call inferred from this helper
		props.analytics.fireAnalyticsEvent(EventNames.DiscoverabilityModalRadioButtonClick, {
			selected = v[tostring(p)]
		})

		setState(p)
	end

	local function onActivated2()
		props.onActivated(v[tostring(state)])
	end

	local title, v5, header, selector, text, color

	if v2 then
		local function onActivated3()
			onActivated(state == 1 and 2 or 1) -- inferred equivalent call
		end

		title = v4.titleTextPrefillDiscoverable
		v5 = 12
		header = react.createElement(imageSetLabel, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = images["icons/graphic/findfriends_xlarge"],
			ImageTransparency = theme.IconEmphasis.Transparency,
			Size = UDim2.fromOffset(iconSize.XLarge, iconSize.XLarge),
			Position = UDim2.fromScale(0.5, 0.5),
			LayoutOrder = 1
		})

		local createElement = react.createElement
		local v6 = {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local v7 = {
			UIListLayout = react.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			UIPadding = react.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 24)
			}),
			Checkbox = react.createElement(checkbox, {
				label = "",
				onActivated = onActivated3,
				isChecked = state == 1,
				LayoutOrder = 1
			}),
			CheckboxLabel = 0
		}

		local createElement2 = react.createElement
		local onActivatedsByActivated = {}
		onActivatedsByActivated.AutomaticSize = Enum.AutomaticSize.Y
		onActivatedsByActivated.BackgroundTransparency = 1
		local font2

		if not foundationFontFaceMigration then
			font2 = font.Body.Font
		end

		onActivatedsByActivated.Font = font2
		local fontFace

		if foundationFontFaceMigration then
			fontFace = normalizeFontFace(v3.Tokens.Typography.BodyLarge.Font)
		end

		onActivatedsByActivated.FontFace = fontFace

		onActivatedsByActivated.Size = UDim2.fromScale(1, 0)
		onActivatedsByActivated.Text = v4.optInTextPrefillDiscoverable
		onActivatedsByActivated.TextColor3 = theme.TextDefault.Color
		onActivatedsByActivated.TextSize = font.Body.RelativeSize * font.BaseSize
		onActivatedsByActivated.TextTransparency = theme.TextDefault.Transparency
		onActivatedsByActivated.TextWrapped = true
		onActivatedsByActivated.TextXAlignment = Enum.TextXAlignment.Left
		onActivatedsByActivated.TextYAlignment = Enum.TextYAlignment.Top
		onActivatedsByActivated.LayoutOrder = 2
		onActivatedsByActivated[react.Event.Activated] = onActivated3
		v7.CheckboxLabel = createElement2("TextButton", onActivatedsByActivated)
		selector = createElement("Frame", v6, v7)

		text = v4.infoTextPrefillDiscoverable
		color = theme.TextLink.Color
	else
		title = v4.titleText

		header = react.createElement(styledTextLabel, {
			text = v4.optInText,
			fontStyle = font.Body,
			colorStyle = theme.TextDefault,
			size = UDim2.fromScale(1, 0),
			automaticSize = Enum.AutomaticSize.Y,
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Left,
			textYAlignment = Enum.TextYAlignment.Top,
			layoutOrder = 1
		})

		selector = react.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			{
				RadioButtonList = react.createElement(radioButtonList, {
					radioButtons = {
						{ label = v4.yesText },
						{ label = v4.noText }
					},
					elementSize = UDim2.new(1, 0, 0, 50),
					onActivated = onActivated,
					initialValue = state,
					padding = UDim.new(0, 0),
					layoutOrder = 1
				})
			}
		)

		text = v4.infoText
		color = theme.TextEmphasis.Color
		v5 = 24
	end

	local createElement = react.createElement
	local v6 = {
		title = title,
		screenSize = props.screenSize,
		onCloseClicked = function()
			props.onCloseClicked(v[tostring(state)])
		end,
		buttonStackProps = {
			buttons = {
				{
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = onActivated2, text = v4.continueText }
				}
			},
			buttonHeight = 48,
			marginBetween = 6,
			forcedFillDirection = Enum.FillDirection.Vertical
		}
	}

	local createElement2 = react.createElement
	local v7 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1
	}

	local v8 = {
		UIListLayout = react.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12),
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		UIPadding = react.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v5),
			PaddingBottom = UDim.new(0, 36)
		}),
		Header = header,
		Selector = selector,
		Description = react.createElement(styledTextLabel, {
			text = text,
			fontStyle = font.CaptionBody,
			colorStyle = theme.TextDefault,
			size = UDim2.fromScale(1, 0),
			automaticSize = Enum.AutomaticSize.Y,
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Left,
			textYAlignment = Enum.TextYAlignment.Top,
			layoutOrder = 3
		}),
		LearnMore = 0
	}

	local createElement3 = react.createElement
	local onLearnMoreClicksByActivated = {}
	onLearnMoreClicksByActivated.AutomaticSize = Enum.AutomaticSize.Y
	onLearnMoreClicksByActivated.BackgroundTransparency = 1
	local font2

	if not foundationFontFaceMigration then
		font2 = font.CaptionBody.Font
	end

	onLearnMoreClicksByActivated.Font = font2
	local fontFace

	if foundationFontFaceMigration then
		fontFace = normalizeFontFace(v3.Tokens.Typography.BodySmall.Font)
	end

	onLearnMoreClicksByActivated.FontFace = fontFace

	onLearnMoreClicksByActivated.Size = UDim2.fromScale(1, 0)
	onLearnMoreClicksByActivated.Text = v4.learnMoreText
	onLearnMoreClicksByActivated.TextColor3 = color
	onLearnMoreClicksByActivated.TextSize = font.CaptionBody.RelativeSize * font.BaseSize
	onLearnMoreClicksByActivated.TextTransparency = theme.TextEmphasis.Transparency
	onLearnMoreClicksByActivated.TextXAlignment = Enum.TextXAlignment.Left
	onLearnMoreClicksByActivated.TextYAlignment = Enum.TextYAlignment.Top
	onLearnMoreClicksByActivated.LayoutOrder = 4
	onLearnMoreClicksByActivated[react.Event.Activated] = props.onLearnMoreClick
	v8.LearnMore = createElement3("TextButton", onLearnMoreClicksByActivated)
	return createElement(partialPageModal, v6, {
		ViewContainer = createElement2("Frame", v7, v8)
	})
end
