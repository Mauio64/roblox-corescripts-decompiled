local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local VoiceChat = require(CorePackages.Workspace.Packages.VoiceChat)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Checkbox = require(CorePackages.Packages.Foundation).Checkbox
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local _ = UIBlox.App.ImageSet.Images
local Assets = require(script.Parent.Parent.Parent.InGameMenu.Resources.Assets)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local GetFFlagSupportGamepadNavInVoiceModals = VoiceChat.Flags.GetFFlagSupportGamepadNavInVoiceModals
local GetFFlagDisablePVUpsellDataConsent = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagDisablePVUpsellDataConsent
local v17 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.TurnOn")
local v18 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.NotNow")
local v19 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.SelectingTurnOn")
local v20 = ArgCheck.wrap(t.strictInterface({
	titleText = t.optional(t.string),
	bodyText = t.optional(t.string),
	handlePrimaryActivated = t.optional(t.callback),
	handleSecondaryActivated = t.optional(t.callback),
	Analytics = t.optional(t.table),
	showCheckbox = t.optional(t.boolean),
	promptStyle = t.optional(t.table),
	showPrompt = t.optional(t.boolean)
}))

local function VoiceChatConsentModal(t1: {[any]: any}, p1) -- line: 66
	-- upvalues: v20 (copy), React (copy), TextService (copy), v19 (copy), GetFFlagSupportGamepadNavInVoiceModals (copy), Roact (copy), UIBlox (copy), Assets (copy), GetFFlagDisablePVUpsellDataConsent (copy), Checkbox (copy), Button (copy), ButtonType (copy), v18 (copy), v17 (copy)
	assert(v20(t1))

	local v24, v25 = React.useState(false)
	local Header1Font = t1.promptStyle.Font.Header1.Font
	local v27 = t1.promptStyle.Font.Header1.RelativeSize * t1.promptStyle.Font.BaseSize
	local v28 = 20 + TextService:GetTextSize(t1.titleText, v27, Header1Font, Vector2.new(325, 1e999)).Y
	local BodyFont = t1.promptStyle.Font.Body.Font
	local v30 = t1.promptStyle.Font.Body.RelativeSize * t1.promptStyle.Font.BaseSize
	local v31 = 20 + TextService:GetTextSize(t1.bodyText, v30, BodyFont, Vector2.new(325, 1e999)).Y
	local CaptionHeaderFont = t1.promptStyle.Font.CaptionHeader.Font
	local v33 = t1.promptStyle.Font.CaptionHeader.RelativeSize * t1.promptStyle.Font.BaseSize
	local v34 = 20 + TextService:GetTextSize(v19, v33, CaptionHeaderFont, Vector2.new(325, 1e999)).Y
	local v35 = if not GetFFlagSupportGamepadNavInVoiceModals() then nil else Enum.SelectionBehavior.Stop
	local v36 = not not GetFFlagSupportGamepadNavInVoiceModals() or nil

	return Roact.createElement("ScreenGui", {
		DisplayOrder = 8,
		IgnoreGuiInset = true,
		OnTopOfCoreBlur = true,
		Enabled = t1.showPrompt,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		Overlay = Roact.createElement("TextButton", {
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Text = "",
			BackgroundColor3 = t1.promptStyle.Theme.Overlay.Color,
			BackgroundTransparency = t1.promptStyle.Theme.Overlay.Transparency,
			Size = UDim2.new(1, 0, 1, 0)
		}),
		DialogMainFrame = Roact.createElement(UIBlox.Core.ImageSet.ImageSetLabel, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Image = Assets.Images.RoundedRect.Image,
			ImageColor3 = t1.promptStyle.Theme.BackgroundUIDefault.Color,
			ImageTransparency = t1.promptStyle.Theme.BackgroundUIDefault.Transparency,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			ScaleType = Assets.Images.RoundedRect.ScaleType,
			Size = UDim2.new(0, 365, 0, v28 + 1 + v31 + 14 + 36 + (GetFFlagDisablePVUpsellDataConsent() and 0 or 60 + v34)),
			AutomaticSize = Enum.AutomaticSize.Y,
			SliceCenter = Assets.Images.RoundedRect.SliceCenter,
			SelectionBehaviorDown = v35,
			SelectionBehaviorLeft = v35,
			SelectionBehaviorRight = v35,
			SelectionBehaviorUp = v35,
			SelectionGroup = v36,
			ref = if not GetFFlagSupportGamepadNavInVoiceModals() then nil else p1
		}, {
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
			TitleTextContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, v28),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				TitleText = Roact.createElement(UIBlox.App.Text.StyledTextLabel, {
					fontStyle = t1.promptStyle.Font.Header1,
					colorStyle = t1.promptStyle.Theme.SystemPrimaryDefault,
					textXAlignment = Enum.TextXAlignment.Center,
					size = UDim2.new(1, 0, 1, 0),
					text = t1.titleText
				})
			}),
			Divider = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = 2,
				BackgroundColor3 = t1.promptStyle.Theme.Divider.Color,
				BackgroundTransparency = t1.promptStyle.Theme.Divider.Transparency,
				Size = UDim2.new(1, 0, 0, 1)
			}),
			DividerSpaceContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, 7)
			}),
			BodyTextContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				Size = UDim2.new(1, 0, 0, v31)
			}, {
				BodyText = Roact.createElement(UIBlox.App.Text.StyledTextLabel, {
					lineHeight = 1.2,
					fontStyle = t1.promptStyle.Font.Body,
					colorStyle = t1.promptStyle.Theme.TextDefault,
					textXAlignment = Enum.TextXAlignment.Left,
					size = UDim2.new(1, 0, 1, 0),
					text = t1.bodyText
				})
			}),
			InfoTextContainer = if GetFFlagDisablePVUpsellDataConsent() then nil else Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 5,
				Size = UDim2.new(1, 0, 0, v34 + 20)
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 15)
				}),
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					HorizontalAlignment = Enum.HorizontalAlignment.Left
				}),
				Checkbox = t1.showCheckbox and Roact.createElement(Checkbox, {
					label = "",
					isDisabled = false,
					LayoutOrder = 1,
					isChecked = v24,
					onActivated = function(p2) -- line: 221
						-- upvalues: v25 (copy)
						v25(p2)
					end
				}),
				TextContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(not t1.showCheckbox and 1 or 0.95, 0, 0, v34)
				}, {
					Padding = t1.showCheckbox and Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 10)
					}),
					InfoText = Roact.createElement(UIBlox.App.Text.StyledTextLabel, {
						lineHeight = 1.15,
						fontStyle = t1.promptStyle.Font.CaptionHeader,
						colorStyle = t1.promptStyle.Theme.TextDefault,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Top,
						size = UDim2.new(1, 0, 1, 0),
						text = v19
					})
				})
			}),
			SpaceContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 6,
				Size = UDim2.new(1, 0, 0, 10)
			}),
			ButtonContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 7,
				Size = UDim2.new(1, 0, 0, 36),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 12),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				SecondaryButton = Roact.createElement(Button, {
					layoutOrder = 1,
					buttonType = ButtonType.Secondary,
					size = UDim2.new(0.5, -5, 0, 36),
					text = v18,
					onActivated = t1.handleSecondaryActivated,
					Selectable = v36
				}),
				ConfirmButton = Roact.createElement(Button, {
					layoutOrder = 2,
					buttonType = ButtonType.PrimarySystem,
					size = UDim2.new(0.5, -5, 0, 36),
					text = v17,
					isDisabled = t1.showCheckbox and not v24,
					onActivated = t1.handlePrimaryActivated,
					Selectable = v36
				})
			})
		})
	})
end

if GetFFlagSupportGamepadNavInVoiceModals() then
	return (React.forwardRef(VoiceChatConsentModal))
end

return VoiceChatConsentModal
