local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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

	local createElement = React.createElement
	local v11 = {
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
	}

	local createElement2 = React.createElement
	local v14 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local v15 = {
		ContentPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 24)
		}),
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 6)
		}),
		BodyText = 0
	}

	local createElement3 = React.createElement
	local v17 = {
		LayoutOrder = 0,
		BackgroundTransparency = 1,
		Text = v9.descriptionKey,
		TextSize = baseSize,
		TextColor3 = v8.Theme.TextDefault.Color,
		TextTransparency = v8.Theme.TextDefault.Transparency,
		Font = 0,
		FontFace = 0,
		TextXAlignment = 0,
		TextWrapped = true,
		Size = 0,
		AutomaticSize = 0,
		RichText = true
	}
	local v18 = if not foundationFontFaceMigration then v8.Font.Body.Font else nil
	v17.Font = v18

	local v19 = if foundationFontFaceMigration then normalizeFontFace(v8.Tokens.Typography.BodyLarge.Font) else nil
	v17.FontFace = v19

	v17.TextXAlignment = Enum.TextXAlignment.Left

	v17.Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0)
	v17.AutomaticSize = Enum.AutomaticSize.Y
	v15.BodyText = createElement3("TextLabel", v17)
	return createElement(partialPageModal, v11, {
		Middle = createElement2("Frame", v14, v15)
	})
end

return EntryView
