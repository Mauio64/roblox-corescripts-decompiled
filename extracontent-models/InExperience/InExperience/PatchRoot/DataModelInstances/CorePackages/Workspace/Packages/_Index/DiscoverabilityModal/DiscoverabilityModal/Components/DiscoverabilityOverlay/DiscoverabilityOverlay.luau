local Players = game:GetService("Players")
local ParentParent = script.Parent.Parent.Parent
local TextKeys = require(ParentParent.Common.TextKeys)
local dependencies = require(ParentParent.dependencies)
local Analytics = ParentParent.Analytics
local EventNames = require(Analytics.Enums.EventNames)
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local Checkbox = dependencies.Foundation.Checkbox
local useLocalization = dependencies.Hooks.useLocalization
local DiscoverabilityUpsellNonPrefillDiscoverableUserIdsWhitelist = require(ParentParent.Flags.DiscoverabilityUpsellNonPrefillDiscoverableUserIdsWhitelist)
local useStyle = UIBlox.Core.Style.useStyle
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local RadioButtonList = UIBlox.App.InputButton.RadioButtonList
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize
local t1 = {
	["1"] = "Discoverable",
	["2"] = "NotDiscoverable",
	["nil"] = "Unset"
}

return function(t2: {[any]: any}) -- line: 55
	-- upvalues: Players (copy), DiscoverabilityUpsellNonPrefillDiscoverableUserIdsWhitelist (copy), React (copy), useStyle (copy), useLocalization (copy), TextKeys (copy), EventNames (copy), t1 (copy), ImageSetLabel (copy), Images (copy), IconSize (copy), Checkbox (copy), StyledTextLabel (copy), RadioButtonList (copy), PartialPageModal (copy), ButtonType (copy)
	local prefillDiscoverabilitySetting = t2.prefillDiscoverabilitySetting

	if Players.LocalPlayer and DiscoverabilityUpsellNonPrefillDiscoverableUserIdsWhitelist.isWhitelistedUserId(Players.LocalPlayer.UserId) then
		prefillDiscoverabilitySetting = false
	end

	local v23, v24 = React.useState(if not prefillDiscoverabilitySetting then nil else 1)
	local v25 = useStyle()
	local Font = v25.Font
	local Theme = v25.Theme
	local v28 = useLocalization({
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
	local titleTextPrefillDiscoverable, n1, v32, v33, infoTextPrefillDiscoverable, TextLinkColor

	if prefillDiscoverabilitySetting then
		local function v29() -- line: 96
			-- upvalues: v23 (copy), t2 (copy), EventNames (copy), t1 (copy), v24 (copy)
			local v37 = v23 ~= 1 and 1 or 2

			t2.analytics.fireAnalyticsEvent(EventNames.DiscoverabilityModalRadioButtonClick, {
				selected = t1[tostring(v37)]
			})
			v24(v37)
		end

		titleTextPrefillDiscoverable = v28.titleTextPrefillDiscoverable
		n1 = 12
		v32 = React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Image = Images["icons/graphic/findfriends_xlarge"],
			ImageTransparency = Theme.IconEmphasis.Transparency,
			Size = UDim2.fromOffset(IconSize.XLarge, IconSize.XLarge),
			Position = UDim2.fromScale(0.5, 0.5)
		})
		v33 = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 24)
			}),
			Checkbox = React.createElement(Checkbox, {
				label = "",
				LayoutOrder = 1,
				onActivated = v29,
				isChecked = v23 == 1
			}),
			CheckboxLabel = React.createElement("TextButton", {
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Font = Font.Body.Font,
				Size = UDim2.fromScale(1, 0),
				Text = v28.optInTextPrefillDiscoverable,
				TextColor3 = Theme.TextDefault.Color,
				TextSize = Font.Body.RelativeSize * Font.BaseSize,
				TextTransparency = Theme.TextDefault.Transparency,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				LayoutOrder = 2,
				[React.Event.Activated] = v29
			})
		})
		infoTextPrefillDiscoverable = v28.infoTextPrefillDiscoverable
		TextLinkColor = Theme.TextLink.Color
	else
		titleTextPrefillDiscoverable = v28.titleText
		n1 = 24
		v32 = React.createElement(StyledTextLabel, {
			layoutOrder = 1,
			text = v28.optInText,
			fontStyle = Font.Body,
			colorStyle = Theme.TextDefault,
			size = UDim2.fromScale(1, 0),
			automaticSize = Enum.AutomaticSize.Y,
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Left,
			textYAlignment = Enum.TextYAlignment.Top
		})
		v33 = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			RadioButtonList = React.createElement(RadioButtonList, {
				layoutOrder = 1,
				radioButtons = {
					{
						label = v28.yesText
					},
					{
						label = v28.noText
					}
				},
				elementSize = UDim2.new(1, 0, 0, 50),
				onActivated = function(p1) -- line: 83
					-- upvalues: t2 (copy), EventNames (copy), t1 (copy), v24 (copy)
					t2.analytics.fireAnalyticsEvent(EventNames.DiscoverabilityModalRadioButtonClick, {
						selected = t1[tostring(p1)]
					})
					v24(p1)
				end,
				initialValue = v23,
				padding = UDim.new(0, 0)
			})
		})
		infoTextPrefillDiscoverable = v28.infoText
		TextLinkColor = Theme.TextEmphasis.Color
	end

	return React.createElement(PartialPageModal, {
		title = titleTextPrefillDiscoverable,
		screenSize = t2.screenSize,
		onCloseClicked = function() -- line: 190
			-- upvalues: t2 (copy), t1 (copy), v23 (copy)
			t2.onCloseClicked(t1[tostring(v23)])
		end,
		buttonStackProps = {
			buttonHeight = 48,
			marginBetween = 6,
			buttons = {{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = function() -- line: 90
						-- upvalues: t2 (copy), t1 (copy), v23 (copy)
						t2.onActivated(t1[tostring(v23)])
					end,
					text = v28.continueText
				}
			}},
			forcedFillDirection = Enum.FillDirection.Vertical
		}
	}, {
		ViewContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12),
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, n1),
				PaddingBottom = UDim.new(0, 36)
			}),
			Header = v32,
			Selector = v33,
			Description = React.createElement(StyledTextLabel, {
				layoutOrder = 3,
				text = infoTextPrefillDiscoverable,
				fontStyle = Font.CaptionBody,
				colorStyle = Theme.TextDefault,
				size = UDim2.fromScale(1, 0),
				automaticSize = Enum.AutomaticSize.Y,
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Top
			}),
			LearnMore = React.createElement("TextButton", {
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Font = Font.CaptionBody.Font,
				Size = UDim2.fromScale(1, 0),
				Text = v28.learnMoreText,
				TextColor3 = TextLinkColor,
				TextSize = Font.CaptionBody.RelativeSize * Font.BaseSize,
				TextTransparency = Theme.TextEmphasis.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				LayoutOrder = 4,
				[React.Event.Activated] = t2.onLearnMoreClick
			})
		})
	})
end
