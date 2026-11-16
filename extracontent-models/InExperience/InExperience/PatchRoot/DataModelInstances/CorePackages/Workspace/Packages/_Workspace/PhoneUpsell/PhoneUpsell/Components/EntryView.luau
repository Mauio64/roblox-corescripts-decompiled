local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local parent = PhoneUpsell.Parent

local React = require(parent.React)

local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useStyle = UIBlox.Core.Style.useStyle
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local mergeProps = require(PhoneUpsell.Utils.mergeProps)

local function noOp() end

local v = {
	onClose = noOp,
	isButtonDisabled = false,
	onExtraButtonClick = noOp,
	isExtraButtonDisabled = false
}

local function getButtonStackProps(buttonKey: string, onActivated, isButtonDisabled: boolean, extraButtonKey: string, onActivated2, isExtraButtonDisabled: boolean)
	local buttons = {
		{
			buttonType = ButtonType.PrimarySystem,
			props = { onActivated = onActivated, text = buttonKey, isDisabled = isButtonDisabled }
		}
	}

	if extraButtonKey and extraButtonKey ~= "" then
		table.insert(buttons, 1, {
			buttonType = ButtonType.Secondary,
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
		buttons = buttons
	}
end

local function EntryView(p)
	local v2 = mergeProps(v, p)

	local partialPageModalMiddleContentWidth = getPartialPageModalMiddleContentWidth(v2.screenSize.X)

	local v3 = {
		titleKey = v2.titleKey,
		descriptionKey = v2.descriptionKey,
		buttonKey = v2.buttonKey
	}

	if v2.extraButtonKey and v2.extraButtonKey ~= "" then
		v3.extraButtonKey = v2.extraButtonKey
	end

	local v4 = useStyle()
	useLocalization(v3)

	local v5 = {
		titleKey = "Before you leave",
		descriptionKey = "This experience would be even more exciting with Voice Chat turned on. Unlock now before your next session.",
		buttonKey = "Unlock voice chat",
		extraButtonKey = "Leave experience"
	}

	local baseSize = v4.Font.BaseSize

	local createElement = React.createElement
	local v6 = {
		title = v5.titleKey,
		screenSize = v2.screenSize,
		buttonStackProps = getButtonStackProps(
			v5.buttonKey,
			v2.onButtonClick,
			v2.isButtonDisabled,
			v5.extraButtonKey,
			v2.onExtraButtonClick,
			v2.isExtraButtonDisabled
		),
		onCloseClicked = v2.onClose
	}

	local createElement2 = React.createElement
	local v7 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local v8 = {
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
	local v9 = {
		LayoutOrder = 0,
		BackgroundTransparency = 1,
		Text = v5.descriptionKey,
		TextSize = baseSize,
		TextColor3 = v4.Theme.TextDefault.Color,
		TextTransparency = v4.Theme.TextDefault.Transparency,
		Font = 0,
		FontFace = 0,
		TextXAlignment = 0,
		TextWrapped = true,
		Size = 0,
		AutomaticSize = 0,
		RichText = true
	}
	local font

	if not FoundationFontFaceMigration then
		font = v4.Font.Body.Font
	end

	v9.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v4.Tokens.Typography.BodyLarge.Font)
	end

	v9.FontFace = fontFace

	v9.TextXAlignment = Enum.TextXAlignment.Left

	v9.Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0)
	v9.AutomaticSize = Enum.AutomaticSize.Y
	v8.BodyText = createElement3("TextLabel", v9)
	return createElement(PartialPageModal, v6, {
		Middle = createElement2("Frame", v7, v8)
	})
end

return EntryView
