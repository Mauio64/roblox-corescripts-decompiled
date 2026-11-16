local Players = game:GetService("Players")

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Common/TextKeys")
local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/dependencies")

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Analytics/Enums/EventNames")

local react = dependencies.React
local uiBlox = dependencies.UIBlox
local foundation = dependencies.Foundation
local checkbox = foundation.Checkbox
local normalizeFontFace = foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = foundation.Utility.Flags.FoundationFontFaceMigration

local useLocalization = dependencies.Hooks.useLocalization

local DiscoverabilityUpsellNonPrefillDiscoverableUserIdsWhitelist = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Flags/DiscoverabilityUpsellNonPrefillDiscoverableUserIdsWhitelist")

local useStyle = uiBlox.Core.Style.useStyle
local partialPageModal = uiBlox.App.Dialog.Modal.PartialPageModal
local buttonType = uiBlox.App.Button.Enum.ButtonType
local styledTextLabel = uiBlox.App.Text.StyledTextLabel

local radioButtonList = uiBlox.App.InputButton.RadioButtonList
local images = uiBlox.App.ImageSet.Images
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local iconSize = uiBlox.App.Constant.IconSize

local v5 = { ["1"] = "Discoverable", ["2"] = "NotDiscoverable", ["nil"] = "Unset" }

return function(props)
	local v6 = props.prefillDiscoverabilitySetting

	if Players.LocalPlayer and DiscoverabilityUpsellNonPrefillDiscoverableUserIdsWhitelist.isWhitelistedUserId(Players.LocalPlayer.UserId) then
		v6 = false
	end

	local state, setState = react.useState(v6 and 1 or nil)

	local v7 = useStyle()
	local font = v7.Font
	local theme = v7.Theme

	local v8 = useLocalization({
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

	local function onActivated(p2)
		props.analytics.fireAnalyticsEvent(EventNames.DiscoverabilityModalRadioButtonClick, {
			selected = v5[tostring(p2)]
		})

		setState(p2)
	end

	local function onActivated2()
		props.onActivated(v5[tostring(state)])
	end

	local v9, v10, v11, v12, v13, color

	if v6 then
		local function onActivated3()
			local v14 = state == 1 and 2 or 1
			props.analytics.fireAnalyticsEvent(EventNames.DiscoverabilityModalRadioButtonClick, {
				selected = v5[tostring(v14)]
			})

			setState(v14)
		end

		v9 = v8.titleTextPrefillDiscoverable
		v10 = 12
		v11 = react.createElement(imageSetLabel, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = images["icons/graphic/findfriends_xlarge"],
			ImageTransparency = theme.IconEmphasis.Transparency,
			Size = UDim2.fromOffset(iconSize.XLarge, iconSize.XLarge),
			Position = UDim2.fromScale(0.5, 0.5),
			LayoutOrder = 1
		})

		local createElement = react.createElement
		local v15 = {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local v16 = {
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
		local v18 = if not foundationFontFaceMigration then font.Body.Font else nil
		onActivatedsByActivated.Font = v18

		local v19 = if foundationFontFaceMigration then normalizeFontFace(v7.Tokens.Typography.BodyLarge.Font) else nil
		onActivatedsByActivated.FontFace = v19

		onActivatedsByActivated.Size = UDim2.fromScale(1, 0)
		onActivatedsByActivated.Text = v8.optInTextPrefillDiscoverable
		onActivatedsByActivated.TextColor3 = theme.TextDefault.Color
		onActivatedsByActivated.TextSize = font.Body.RelativeSize * font.BaseSize
		onActivatedsByActivated.TextTransparency = theme.TextDefault.Transparency
		onActivatedsByActivated.TextWrapped = true
		onActivatedsByActivated.TextXAlignment = Enum.TextXAlignment.Left
		onActivatedsByActivated.TextYAlignment = Enum.TextYAlignment.Top
		onActivatedsByActivated.LayoutOrder = 2
		onActivatedsByActivated[react.Event.Activated] = onActivated3
		v16.CheckboxLabel = createElement2("TextButton", onActivatedsByActivated)
		v12 = createElement("Frame", v15, v16)

		v13 = v8.infoTextPrefillDiscoverable
		color = theme.TextLink.Color
	else
		v9 = v8.titleText

		v11 = react.createElement(styledTextLabel, {
			text = v8.optInText,
			fontStyle = font.Body,
			colorStyle = theme.TextDefault,
			size = UDim2.fromScale(1, 0),
			automaticSize = Enum.AutomaticSize.Y,
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Left,
			textYAlignment = Enum.TextYAlignment.Top,
			layoutOrder = 1
		})

		v12 = react.createElement(
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
						{ label = v8.yesText },
						{ label = v8.noText }
					},
					elementSize = UDim2.new(1, 0, 0, 50),
					onActivated = onActivated,
					initialValue = state,
					padding = UDim.new(0, 0),
					layoutOrder = 1
				})
			}
		)

		v13 = v8.infoText
		color = theme.TextEmphasis.Color
		v10 = 24
	end

	local createElement = react.createElement
	local v15 = {
		title = v9,
		screenSize = props.screenSize,
		onCloseClicked = function()
			props.onCloseClicked(v5[tostring(state)])
		end,
		buttonStackProps = {
			buttons = {
				{
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = onActivated2, text = v8.continueText }
				}
			},
			buttonHeight = 48,
			marginBetween = 6,
			forcedFillDirection = Enum.FillDirection.Vertical
		}
	}

	local createElement2 = react.createElement
	local v18 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1
	}

	local v19 = {
		UIListLayout = react.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12),
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		UIPadding = react.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v10),
			PaddingBottom = UDim.new(0, 36)
		}),
		Header = v11,
		Selector = v12,
		Description = react.createElement(styledTextLabel, {
			text = v13,
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
	local v21 = if not foundationFontFaceMigration then font.CaptionBody.Font else nil
	onLearnMoreClicksByActivated.Font = v21

	local v22 = if foundationFontFaceMigration then normalizeFontFace(v7.Tokens.Typography.BodySmall.Font) else nil
	onLearnMoreClicksByActivated.FontFace = v22

	onLearnMoreClicksByActivated.Size = UDim2.fromScale(1, 0)
	onLearnMoreClicksByActivated.Text = v8.learnMoreText
	onLearnMoreClicksByActivated.TextColor3 = color
	onLearnMoreClicksByActivated.TextSize = font.CaptionBody.RelativeSize * font.BaseSize
	onLearnMoreClicksByActivated.TextTransparency = theme.TextEmphasis.Transparency
	onLearnMoreClicksByActivated.TextXAlignment = Enum.TextXAlignment.Left
	onLearnMoreClicksByActivated.TextYAlignment = Enum.TextYAlignment.Top
	onLearnMoreClicksByActivated.LayoutOrder = 4
	onLearnMoreClicksByActivated[react.Event.Activated] = props.onLearnMoreClick
	v19.LearnMore = createElement3("TextButton", onLearnMoreClicksByActivated)
	return createElement(partialPageModal, v15, {
		ViewContainer = createElement2("Frame", v18, v19)
	})
end
