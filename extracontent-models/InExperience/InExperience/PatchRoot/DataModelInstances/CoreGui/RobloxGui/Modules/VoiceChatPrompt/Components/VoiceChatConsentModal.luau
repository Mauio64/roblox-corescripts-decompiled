local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local VoiceChat = require(CorePackages.Workspace.Packages.VoiceChat)

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local Checkbox = Foundation.Checkbox
local Style = require(CorePackages.Workspace.Packages.Style)
local GetTextSize = Style.GetTextSize
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local Images = UIBlox.App.ImageSet.Images

local Assets = require(script.Parent.Parent.Parent.InGameMenu.Resources.Assets)

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local GetFFlagSupportGamepadNavInVoiceModals = VoiceChat.Flags.GetFFlagSupportGamepadNavInVoiceModals
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagDisablePVUpsellDataConsent = SharedFlags.GetFFlagDisablePVUpsellDataConsent

local formatByKey = RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.TurnOn")
local formatByKey2 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.NotNow")
local formatByKey3 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.SelectingTurnOn")

local wrapped = ArgCheck.wrap(t.strictInterface({
	titleText = t.optional(t.string),
	bodyText = t.optional(t.string),
	handlePrimaryActivated = t.optional(t.callback),
	handleSecondaryActivated = t.optional(t.callback),
	Analytics = t.optional(t.table),
	showCheckbox = t.optional(t.boolean),
	promptStyle = t.optional(t.table),
	showPrompt = t.optional(t.boolean)
}))

local function VoiceChatConsentModal(props, ref)
	assert(wrapped(props))

	local state, setState = React.useState(false)

	local font = props.promptStyle.Font.Header1.Font
	local v = props.promptStyle.Font.Header1.RelativeSize * props.promptStyle.Font.BaseSize
	local v2

	if FoundationFontFaceMigration then
		v2 = GetTextSize(props.titleText, v, font, Vector2.new(325, 1e999), {
			addTemporaryPadding = false
		}).Y
	else
		v2 = TextService:GetTextSize(props.titleText, v, font, Vector2.new(325, 1e999)).Y
	end

	local v3 = 20 + v2

	local font2 = props.promptStyle.Font.Body.Font
	local v4 = props.promptStyle.Font.Body.RelativeSize * props.promptStyle.Font.BaseSize
	local v5

	if FoundationFontFaceMigration then
		v5 = GetTextSize(props.bodyText, v4, font2, Vector2.new(325, 1e999), {
			addTemporaryPadding = false
		}).Y
	else
		v5 = TextService:GetTextSize(props.bodyText, v4, font2, Vector2.new(325, 1e999)).Y
	end

	local v6 = 20 + v5

	local font3 = props.promptStyle.Font.CaptionHeader.Font
	local v7 = props.promptStyle.Font.CaptionHeader.RelativeSize * props.promptStyle.Font.BaseSize
	local v8

	if FoundationFontFaceMigration then
		v8 = GetTextSize(formatByKey3, v7, font3, Vector2.new(325, 1e999), {
			addTemporaryPadding = false
		}).Y
	else
		v8 = TextService:GetTextSize(formatByKey3, v7, font3, Vector2.new(325, 1e999)).Y
	end

	local v9 = 20 + v8
	local stop

	if GetFFlagSupportGamepadNavInVoiceModals() then
		stop = Enum.SelectionBehavior.Stop
	end

	local v10 = GetFFlagSupportGamepadNavInVoiceModals() and true or nil

	local createElement = Roact.createElement
	local v11 = {
		DisplayOrder = 8,
		IgnoreGuiInset = true,
		OnTopOfCoreBlur = true,
		Enabled = props.showPrompt,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}
	local v12 = {
		Overlay = Roact.createElement("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = props.promptStyle.Theme.Overlay.Color,
			BackgroundTransparency = props.promptStyle.Theme.Overlay.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Text = ""
		}),
		DialogMainFrame = 0
	}

	local createElement2 = Roact.createElement
	local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
	local v13 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = Assets.Images.RoundedRect.Image,
		ImageColor3 = props.promptStyle.Theme.BackgroundUIDefault.Color,
		ImageTransparency = props.promptStyle.Theme.BackgroundUIDefault.Transparency,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		ScaleType = Assets.Images.RoundedRect.ScaleType,
		Size = UDim2.new(0, 365, 0, v3 + 1 + v6 + 14 + 36 + (GetFFlagDisablePVUpsellDataConsent() and 0 or 60 + v9)),
		AutomaticSize = Enum.AutomaticSize.Y,
		SliceCenter = Assets.Images.RoundedRect.SliceCenter,
		SelectionBehaviorDown = stop,
		SelectionBehaviorLeft = stop,
		SelectionBehaviorRight = stop,
		SelectionBehaviorUp = stop,
		SelectionGroup = v10,
		ref = 0
	}

	if not GetFFlagSupportGamepadNavInVoiceModals() then
		ref = nil
	end

	v13.ref = ref
	local children = {
		Padding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 20),
			PaddingLeft = UDim.new(0, 20),
			PaddingRight = UDim.new(0, 20)
		}),
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		TitleTextContainer = Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, v3),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			{
				TitleText = Roact.createElement(UIBlox.App.Text.StyledTextLabel, {
					fontStyle = props.promptStyle.Font.Header1,
					colorStyle = props.promptStyle.Theme.SystemPrimaryDefault,
					textXAlignment = Enum.TextXAlignment.Center,
					size = UDim2.new(1, 0, 1, 0),
					text = props.titleText
				})
			}
		),
		Divider = Roact.createElement("Frame", {
			BackgroundColor3 = props.promptStyle.Theme.Divider.Color,
			BackgroundTransparency = props.promptStyle.Theme.Divider.Transparency,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 1)
		}),
		DividerSpaceContainer = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 7)
		}),
		BodyTextContainer = Roact.createElement(
			"Frame",
			{ BackgroundTransparency = 1, LayoutOrder = 4, Size = UDim2.new(1, 0, 0, v6) },
			{
				BodyText = Roact.createElement(UIBlox.App.Text.StyledTextLabel, {
					fontStyle = props.promptStyle.Font.Body,
					colorStyle = props.promptStyle.Theme.TextDefault,
					textXAlignment = Enum.TextXAlignment.Left,
					size = UDim2.new(1, 0, 1, 0),
					text = props.bodyText,
					lineHeight = 1.2
				})
			}
		),
		InfoTextContainer = 0,
		SpaceContainer = 0,
		ButtonContainer = 0
	}
	local infoTextContainer

	if not GetFFlagDisablePVUpsellDataConsent() then
		infoTextContainer = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 5,
			Size = UDim2.new(1, 0, 0, v9 + 20)
		}, {
			Padding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, 15) }),
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			}),
			Checkbox = props.showCheckbox and Roact.createElement(Checkbox, {
				label = "",
				isChecked = state,
				isDisabled = false,
				onActivated = function(p)
					setState(p)
				end,
				LayoutOrder = 1
			}),
			TextContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(props.showCheckbox and 0.95 or 1, 0, 0, v9)
			}, {
				Padding = props.showCheckbox and Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 10)
				}),
				InfoText = Roact.createElement(UIBlox.App.Text.StyledTextLabel, {
					fontStyle = props.promptStyle.Font.CaptionHeader,
					colorStyle = props.promptStyle.Theme.TextDefault,
					textXAlignment = Enum.TextXAlignment.Left,
					textYAlignment = Enum.TextYAlignment.Top,
					size = UDim2.new(1, 0, 1, 0),
					text = formatByKey3,
					lineHeight = 1.15
				})
			})
		})
	end

	children.InfoTextContainer = infoTextContainer

	children.SpaceContainer = Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 6,
		Size = UDim2.new(1, 0, 0, 10)
	})

	children.ButtonContainer = Roact.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			LayoutOrder = 7,
			Size = UDim2.new(1, 0, 0, 36),
			AutomaticSize = Enum.AutomaticSize.Y
		},
		{
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 12),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			SecondaryButton = Roact.createElement(Button, {
				buttonType = ButtonType.Secondary,
				layoutOrder = 1,
				size = UDim2.new(0.5, -5, 0, 36),
				text = formatByKey2,
				onActivated = props.handleSecondaryActivated,
				Selectable = v10
			}),
			ConfirmButton = Roact.createElement(Button, {
				buttonType = ButtonType.PrimarySystem,
				layoutOrder = 2,
				size = UDim2.new(0.5, -5, 0, 36),
				text = formatByKey,
				isDisabled = props.showCheckbox and not state,
				onActivated = props.handlePrimaryActivated,
				Selectable = v10
			})
		}
	)
	v12.DialogMainFrame = createElement2(imageSetLabel, v13, children)
	return createElement("ScreenGui", v11, v12)
end

if GetFFlagSupportGamepadNavInVoiceModals() then
	return (React.forwardRef(VoiceChatConsentModal))
end

return VoiceChatConsentModal
