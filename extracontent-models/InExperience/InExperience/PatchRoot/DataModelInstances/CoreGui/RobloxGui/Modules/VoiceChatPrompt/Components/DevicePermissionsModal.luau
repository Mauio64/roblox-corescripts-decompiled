local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local VoiceChat = require(CorePackages.Workspace.Packages.VoiceChat)

local UIBlox = require(CorePackages.Packages.UIBlox)
local Style = require(CorePackages.Workspace.Packages.Style)
local GetTextSize = Style.GetTextSize
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local Assets = require(script.Parent.Parent.Parent.InGameMenu.Resources.Assets)

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local getMicDeeplinkDirections = require(script.Parent.Parent.Helpers.getMicDeeplinkDirections)
local getPrimingText = require(script.Parent.Parent.Helpers.getPrimingText)

local GetFFlagSupportGamepadNavInVoiceModals = VoiceChat.Flags.GetFFlagSupportGamepadNavInVoiceModals

local formatByKey = RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.OpenSettings")
local formatByKey2 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.Ok")
local formatByKey3 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.NotNow")

local iconscontrolsmicrophone = Images["icons/controls/microphone"]

local wrapped = ArgCheck.wrap(t.strictInterface({
	titleText = t.string,
	bodyText = t.string,
	handlePrimaryActivated = t.callback,
	handleSecondaryActivated = t.callback,
	Analytics = t.table,
	promptStyle = t.table,
	showPrompt = t.boolean,
	settingsAppAvailable = t.boolean,
	UserInputService = t.table
}))

local function DevicePermissionsModal(props, ref)
	assert(wrapped(props))

	local micDeeplinkDirections = getMicDeeplinkDirections(props.settingsAppAvailable, props.UserInputService)
	local primingText = getPrimingText(props.UserInputService)

	local font = props.promptStyle.Font.Header1.Font
	local v = props.promptStyle.Font.Header1.RelativeSize * props.promptStyle.Font.BaseSize
	local v2 = 20 + GetTextSize(props.titleText, v, font, Vector2.new(325, 1e999), {
		addTemporaryPadding = false
	}).Y

	local font2 = props.promptStyle.Font.Body.Font
	local v3 = props.promptStyle.Font.Body.RelativeSize * props.promptStyle.Font.BaseSize
	local v4 = 20 + GetTextSize(props.bodyText, v3, font2, Vector2.new(325, 1e999), {
		addTemporaryPadding = false
	}).Y
	local v5

	if primingText then
		local font3 = props.promptStyle.Font.CaptionHeader.Font
		v5 = 10 + GetTextSize(
			primingText,
			props.promptStyle.Font.CaptionHeader.RelativeSize * props.promptStyle.Font.BaseSize,
			font3,
			Vector2.new(325, 1e999),
			{ addTemporaryPadding = false }
		).Y
	else
		v5 = 0
	end

	local v6

	if micDeeplinkDirections then
		local font3 = props.promptStyle.Font.Body.Font
		v6 = (primingText and 10 or 20) + GetTextSize(
			micDeeplinkDirections,
			props.promptStyle.Font.Body.RelativeSize * props.promptStyle.Font.BaseSize,
			font3,
			Vector2.new(325, 1e999),
			{ addTemporaryPadding = false }
		).Y
	else
		v6 = 0
	end

	local stop

	if GetFFlagSupportGamepadNavInVoiceModals() then
		stop = Enum.SelectionBehavior.Stop
	end

	local v7 = GetFFlagSupportGamepadNavInVoiceModals() and true or nil

	local createElement = React.createElement
	local v8 = {
		DisplayOrder = 8,
		IgnoreGuiInset = true,
		OnTopOfCoreBlur = true,
		Enabled = props.showPrompt,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}
	local v9 = {
		Overlay = React.createElement("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = props.promptStyle.Theme.Overlay.Color,
			BackgroundTransparency = props.promptStyle.Theme.Overlay.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Text = ""
		}),
		DialogMainFrame = 0
	}

	local createElement2 = React.createElement
	local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
	local v10 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = Assets.Images.RoundedRect.Image,
		ImageColor3 = props.promptStyle.Theme.BackgroundUIDefault.Color,
		ImageTransparency = props.promptStyle.Theme.BackgroundUIDefault.Transparency,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		ScaleType = Assets.Images.RoundedRect.ScaleType,
		Size = UDim2.new(
			0,
			365,
			0,
			v2 + 5 + v4 + 36 + (primingText and 5.5 or micDeeplinkDirections and 4.5 or 4) * 20 + v6 + 55 + v5
		),
		AutomaticSize = Enum.AutomaticSize.Y,
		SliceCenter = Assets.Images.RoundedRect.SliceCenter,
		SelectionBehaviorDown = stop,
		SelectionBehaviorLeft = stop,
		SelectionBehaviorRight = stop,
		SelectionBehaviorUp = stop,
		SelectionGroup = v7,
		ref = 0
	}

	if not GetFFlagSupportGamepadNavInVoiceModals() then
		ref = nil
	end

	v10.ref = ref
	local v11 = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 15),
			PaddingBottom = UDim.new(0, 20),
			PaddingLeft = UDim.new(0, 20),
			PaddingRight = UDim.new(0, 20)
		}),
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Icon = React.createElement(UIBlox.Core.ImageSet.ImageSetLabel, {
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Image = iconscontrolsmicrophone,
			Size = UDim2.new(0, 55, 0, 55),
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}),
		TitleTextContainer = React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, v2),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			{
				Padding = React.createElement("UIPadding", { PaddingBottom = UDim.new(0, 7) }),
				TitleText = React.createElement(UIBlox.App.Text.StyledTextLabel, {
					fontStyle = props.promptStyle.Font.Header1,
					colorStyle = props.promptStyle.Theme.SystemPrimaryDefault,
					textXAlignment = Enum.TextXAlignment.Center,
					size = UDim2.new(1, 0, 1, 0),
					text = props.titleText
				})
			}
		),
		Divider = React.createElement("Frame", {
			BackgroundColor3 = props.promptStyle.Theme.Divider.Color,
			BackgroundTransparency = props.promptStyle.Theme.Divider.Transparency,
			BorderSizePixel = 0,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 1)
		}),
		DividerSpaceContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 4,
			Size = UDim2.new(1, 0, 0, 15)
		}),
		BodyTextContainer = React.createElement(
			"Frame",
			{ BackgroundTransparency = 1, LayoutOrder = 5, Size = UDim2.new(1, 0, 0, v4) },
			{
				BodyText = React.createElement(UIBlox.App.Text.StyledTextLabel, {
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
		PrimingTextContainer = 0,
		SpaceContainerTemp = 0,
		ButtonContainer = 0
	}
	local infoTextContainer

	if micDeeplinkDirections then
		infoTextContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 6,
			Size = UDim2.new(1, 0, 0, v6 + 20)
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, primingText and 8 or 15),
				PaddingLeft = UDim.new(0, 8)
			}),
			TextContainer = React.createElement(
				"Frame",
				{ BackgroundTransparency = 1, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, v6) },
				{
					InfoText = React.createElement(UIBlox.App.Text.StyledTextLabel, {
						fontStyle = props.promptStyle.Font.Body,
						colorStyle = props.promptStyle.Theme.TextEmphasis,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Top,
						size = UDim2.new(1, 0, 1, 0),
						text = micDeeplinkDirections,
						lineHeight = 1.25
					})
				}
			)
		})
	end

	v11.InfoTextContainer = infoTextContainer
	local spaceContainer

	if not primingText then
		spaceContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 7,
			Size = UDim2.new(1, 0, 0, micDeeplinkDirections and 40 or 20)
		})
	end

	v11.SpaceContainer = spaceContainer
	local primingTextContainer

	if primingText then
		primingTextContainer = React.createElement(
			"Frame",
			{ BackgroundTransparency = 1, LayoutOrder = 8, Size = UDim2.new(1, 0, 0, v5) },
			{
				PrimingText = React.createElement(UIBlox.App.Text.StyledTextLabel, {
					fontStyle = props.promptStyle.Font.Body,
					colorStyle = props.promptStyle.Theme.TextDefault,
					textXAlignment = Enum.TextXAlignment.Left,
					textYAlignment = Enum.TextYAlignment.Top,
					size = UDim2.new(1, 0, 1, 0),
					text = primingText,
					lineHeight = 1.25
				})
			}
		)
	end

	v11.PrimingTextContainer = primingTextContainer
	local spaceContainerTemp

	if primingText then
		spaceContainerTemp = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 9,
			Size = UDim2.new(1, 0, 0, 30)
		})
	end

	v11.SpaceContainerTemp = spaceContainerTemp

	local createElement3 = React.createElement
	local v12 = { BackgroundTransparency = 1, LayoutOrder = 10, Size = UDim2.new(1, 0, 0, 36) }
	local v13 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		SecondaryButton = 0,
		ConfirmButton = 0
	}
	local secondaryButton

	if props.settingsAppAvailable then
		secondaryButton = React.createElement(Button, {
			buttonType = ButtonType.Secondary,
			layoutOrder = 1,
			size = UDim2.new(0.5, -5, 0, 36),
			text = formatByKey3,
			onActivated = props.handleSecondaryActivated,
			Selectable = v7
		})
	end

	v13.SecondaryButton = secondaryButton

	local createElement4 = React.createElement
	local v14 = {
		buttonType = ButtonType.PrimarySystem,
		layoutOrder = 2,
		size = UDim2.new(props.settingsAppAvailable and 0.5 or 1, -5, 0, 36),
		text = 0,
		onActivated = 0,
		Selectable = 0
	}
	local text

	if props.settingsAppAvailable then
		text = formatByKey
	else
		text = formatByKey2
	end

	v14.text = text
	v14.onActivated = props.handlePrimaryActivated
	v14.Selectable = v7
	v13.ConfirmButton = createElement4(Button, v14)
	v11.ButtonContainer = createElement3("Frame", v12, v13)
	v9.DialogMainFrame = createElement2(imageSetLabel, v10, v11)
	return createElement("ScreenGui", v8, v9)
end

if GetFFlagSupportGamepadNavInVoiceModals() then
	return (React.forwardRef(DevicePermissionsModal))
end

return DevicePermissionsModal
