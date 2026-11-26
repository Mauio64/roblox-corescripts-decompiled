local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Foundation").Utility.normalizeFontFace

local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Localization").Hooks.useLocalization
local buttonType = UIBlox.App.Button.Enum.ButtonType
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local mergeProps = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Utils/mergeProps")

local function noOp() end

local v5 = {
	onClose = noOp,
	isButtonDisabled = false,
	onExtraButtonClick = noOp,
	isExtraButtonDisabled = false
}

local function getButtonStackProps(buttonKey, onActivated, isButtonDisabled, extraButtonKey, onActivated2, isExtraButtonDisabled)
	local v6 = {
		{
			buttonType = buttonType.PrimarySystem,
			props = {
				onActivated = onActivated,
				text = buttonKey,
				isDisabled = isButtonDisabled
			}
		}
	}

	if extraButtonKey and extraButtonKey ~= "" then
		table.insert(v6, 1, {
			buttonType = buttonType.Secondary,
			props = {
				onActivated = onActivated2,
				text = extraButtonKey,
				isDisabled = isExtraButtonDisabled
			}
		})
	end

	return {
		buttonHeight = 48,
		forcedFillDirection = Enum.FillDirection.Vertical,
		buttons = v6
	}
end

local function EntryView(p2)
	local v6 = mergeProps(v5, p2)

	local partialPageModalMiddleContentWidth = getPartialPageModalMiddleContentWidth(v6.screenSize.X)

	local v7 = {
		titleKey = v6.titleKey,
		descriptionKey = v6.descriptionKey,
		buttonKey = v6.buttonKey
	}

	if v6.extraButtonKey and v6.extraButtonKey ~= "" then
		v7.extraButtonKey = v6.extraButtonKey
	end

	local v8 = useStyle()
	useLocalization(v7)

	local v9 = {
		titleKey = "Before you leave",
		descriptionKey = "This experience would be even more exciting with Voice Chat turned on. Unlock now before your next session.",
		buttonKey = "Unlock voice chat",
		extraButtonKey = "Leave experience"
	}

	local baseSize = v8.Font.BaseSize

	return React.createElement(
		partialPageModal,
		{
			title = v9.titleKey,
			screenSize = v6.screenSize,
			buttonStackProps = getButtonStackProps(
				v9.buttonKey,
				v6.onButtonClick,
				v6.isButtonDisabled,
				v9.extraButtonKey,
				v6.onExtraButtonClick,
				v6.isExtraButtonDisabled
			),
			onCloseClicked = v6.onClose
		},
		{
			Middle = React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				},
				{
					ContentPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 12),
						PaddingBottom = UDim.new(0, 24)
					}),
					ListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 6)
					}),
					BodyText = React.createElement("TextLabel", {
						LayoutOrder = 0,
						BackgroundTransparency = 1,
						Text = v9.descriptionKey,
						TextSize = baseSize,
						TextColor3 = v8.Theme.TextDefault.Color,
						TextTransparency = v8.Theme.TextDefault.Transparency,
						FontFace = normalizeFontFace(v8.Tokens.Typography.BodyLarge.Font),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextWrapped = true,
						Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						RichText = true
					})
				}
			)
		}
	)
end

return EntryView
