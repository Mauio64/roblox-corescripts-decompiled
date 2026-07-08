local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local VoiceChat = require(CorePackages.Workspace.Packages.VoiceChat)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local Assets = require(script.Parent.Parent.Parent.InGameMenu.Resources.Assets)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local getMicDeeplinkDirections = require(script.Parent.Parent.Helpers.getMicDeeplinkDirections)
local getPrimingText = require(script.Parent.Parent.Helpers.getPrimingText)
local GetFFlagSupportGamepadNavInVoiceModals = VoiceChat.Flags.GetFFlagSupportGamepadNavInVoiceModals
local v16 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.OpenSettings")
local v17 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.Ok")
local v18 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.NotNow")
local v19 = Images["icons/controls/microphone"]
local v20 = ArgCheck.wrap(t.strictInterface({
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

local function DevicePermissionsModal(t1: {[any]: any}, p1) -- line: 65
	-- upvalues: v20 (copy), getMicDeeplinkDirections (copy), getPrimingText (copy), TextService (copy), GetFFlagSupportGamepadNavInVoiceModals (copy), React (copy), UIBlox (copy), Assets (copy), v19 (copy), Button (copy), ButtonType (copy), v18 (copy), v16 (copy), v17 (copy)
	assert(v20(t1))

	local v24 = getMicDeeplinkDirections(t1.settingsAppAvailable, t1.UserInputService)
	local v25 = getPrimingText(t1.UserInputService)
	local Header1Font = t1.promptStyle.Font.Header1.Font
	local v27 = t1.promptStyle.Font.Header1.RelativeSize * t1.promptStyle.Font.BaseSize
	local v28 = 20 + TextService:GetTextSize(t1.titleText, v27, Header1Font, Vector2.new(325, 1e999)).Y
	local BodyFont = t1.promptStyle.Font.Body.Font
	local v30 = t1.promptStyle.Font.Body.RelativeSize * t1.promptStyle.Font.BaseSize
	local v31 = 20 + TextService:GetTextSize(t1.bodyText, v30, BodyFont, Vector2.new(325, 1e999)).Y
	local n1 = 0

	if v25 then
		local CaptionHeaderFont = t1.promptStyle.Font.CaptionHeader.Font
		local v34 = t1.promptStyle.Font.CaptionHeader.RelativeSize * t1.promptStyle.Font.BaseSize

		n1 = 10 + TextService:GetTextSize(v25, v34, CaptionHeaderFont, Vector2.new(325, 1e999)).Y
	end

	local n2 = 0

	if v24 then
		local BodyFont2 = t1.promptStyle.Font.Body.Font
		local v37 = t1.promptStyle.Font.Body.RelativeSize * t1.promptStyle.Font.BaseSize
		local Y = TextService:GetTextSize(v24, v37, BodyFont2, Vector2.new(325, 1e999)).Y

		n2 = (not v25 and 20 or 10) + Y
	end

	local n3 = 4

	if v24 then
		n3 = 4.5
	end

	if v25 then
		n3 = 5.5
	end

	local v40 = if not GetFFlagSupportGamepadNavInVoiceModals() then nil else Enum.SelectionBehavior.Stop
	local v41 = not not GetFFlagSupportGamepadNavInVoiceModals() or nil

	return React.createElement("ScreenGui", {
		DisplayOrder = 8,
		IgnoreGuiInset = true,
		OnTopOfCoreBlur = true,
		Enabled = t1.showPrompt,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		Overlay = React.createElement("TextButton", {
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Text = "",
			BackgroundColor3 = t1.promptStyle.Theme.Overlay.Color,
			BackgroundTransparency = t1.promptStyle.Theme.Overlay.Transparency,
			Size = UDim2.new(1, 0, 1, 0)
		}),
		DialogMainFrame = React.createElement(UIBlox.Core.ImageSet.ImageSetLabel, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Image = Assets.Images.RoundedRect.Image,
			ImageColor3 = t1.promptStyle.Theme.BackgroundUIDefault.Color,
			ImageTransparency = t1.promptStyle.Theme.BackgroundUIDefault.Transparency,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			ScaleType = Assets.Images.RoundedRect.ScaleType,
			Size = UDim2.new(0, 365, 0, v28 + 5 + v31 + 36 + n3 * 20 + n2 + 55 + n1),
			AutomaticSize = Enum.AutomaticSize.Y,
			SliceCenter = Assets.Images.RoundedRect.SliceCenter,
			SelectionBehaviorDown = v40,
			SelectionBehaviorLeft = v40,
			SelectionBehaviorRight = v40,
			SelectionBehaviorUp = v40,
			SelectionGroup = v41,
			ref = if not GetFFlagSupportGamepadNavInVoiceModals() then nil else p1
		}, {
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
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = v19,
				Size = UDim2.new(0, 55, 0, 55)
			}),
			TitleTextContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, v28),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				Padding = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, 7)
				}),
				TitleText = React.createElement(UIBlox.App.Text.StyledTextLabel, {
					fontStyle = t1.promptStyle.Font.Header1,
					colorStyle = t1.promptStyle.Theme.SystemPrimaryDefault,
					textXAlignment = Enum.TextXAlignment.Center,
					size = UDim2.new(1, 0, 1, 0),
					text = t1.titleText
				})
			}),
			Divider = React.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = 3,
				BackgroundColor3 = t1.promptStyle.Theme.Divider.Color,
				BackgroundTransparency = t1.promptStyle.Theme.Divider.Transparency,
				Size = UDim2.new(1, 0, 0, 1)
			}),
			DividerSpaceContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				Size = UDim2.new(1, 0, 0, 15)
			}),
			BodyTextContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 5,
				Size = UDim2.new(1, 0, 0, v31)
			}, {
				BodyText = React.createElement(UIBlox.App.Text.StyledTextLabel, {
					lineHeight = 1.2,
					fontStyle = t1.promptStyle.Font.Body,
					colorStyle = t1.promptStyle.Theme.TextDefault,
					textXAlignment = Enum.TextXAlignment.Left,
					size = UDim2.new(1, 0, 1, 0),
					text = t1.bodyText
				})
			}),
			InfoTextContainer = if not v24 then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 6,
				Size = UDim2.new(1, 0, 0, n2 + 20)
			}, {
				Padding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, not v25 and 15 or 8),
					PaddingLeft = UDim.new(0, 8)
				}),
				TextContainer = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, n2)
				}, {
					InfoText = React.createElement(UIBlox.App.Text.StyledTextLabel, {
						lineHeight = 1.25,
						fontStyle = t1.promptStyle.Font.Body,
						colorStyle = t1.promptStyle.Theme.TextEmphasis,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Top,
						size = UDim2.new(1, 0, 1, 0),
						text = v24
					})
				})
			}),
			SpaceContainer = if v25 then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 7,
				Size = UDim2.new(1, 0, 0, not v24 and 20 or 40)
			}),
			PrimingTextContainer = if not v25 then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 8,
				Size = UDim2.new(1, 0, 0, n1)
			}, {
				PrimingText = React.createElement(UIBlox.App.Text.StyledTextLabel, {
					lineHeight = 1.25,
					fontStyle = t1.promptStyle.Font.Body,
					colorStyle = t1.promptStyle.Theme.TextDefault,
					textXAlignment = Enum.TextXAlignment.Left,
					textYAlignment = Enum.TextYAlignment.Top,
					size = UDim2.new(1, 0, 1, 0),
					text = v25
				})
			}),
			SpaceContainerTemp = if not v25 then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 9,
				Size = UDim2.new(1, 0, 0, 30)
			}),
			ButtonContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 10,
				Size = UDim2.new(1, 0, 0, 36)
			}, {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 12),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				SecondaryButton = if not t1.settingsAppAvailable then nil else React.createElement(Button, {
					layoutOrder = 1,
					buttonType = ButtonType.Secondary,
					size = UDim2.new(0.5, -5, 0, 36),
					text = v18,
					onActivated = t1.handleSecondaryActivated,
					Selectable = v41
				}),
				ConfirmButton = React.createElement(Button, {
					layoutOrder = 2,
					buttonType = ButtonType.PrimarySystem,
					size = UDim2.new(not t1.settingsAppAvailable and 1 or 0.5, -5, 0, 36),
					text = if not t1.settingsAppAvailable then v17 else v16,
					onActivated = t1.handlePrimaryActivated,
					Selectable = v41
				})
			})
		})
	})
end

if GetFFlagSupportGamepadNavInVoiceModals() then
	return (React.forwardRef(DevicePermissionsModal))
end

return DevicePermissionsModal
