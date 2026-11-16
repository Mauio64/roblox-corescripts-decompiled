local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local memo = React.memo

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local enum = UIBlox.App.Button.Enum
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)

local SocialLibraries = require(AppChat.SocialLibraries)
local Info = SocialLibraries.Components.AlertViews.Info
local Warning = SocialLibraries.Components.AlertViews.Warning

local v = {
	titleText = "",
	cancelAlertText = "",
	bodyText = "",
	isButtonDisabled = false,
	screenSize = Vector2.new(1000, 1000),
	onActivated = function() end,
	onDismissed = function() end
}

local function PartialModal(p)
	local union = Cryo.Dictionary.union(v, p)
	local v2 = useStyle()
	local style = union.style or v2

	local size_600 = style.Tokens.Size.Size_600
	local lineHeight_140 = style.Tokens.LineHeight.LineHeight_140

	if useIsInExperience() then
		local v3 = if union.actionText then Warning else Info
		local cancelAlertText

		if union.actionText then
			cancelAlertText = union.cancelAlertText
		end

		local confirmText

		if union.actionText then
			confirmText = union.actionText
		else
			confirmText = union.cancelAlertText
		end

		return React.createElement(v3, {
			titleText = union.titleText,
			bodyText = union.bodyText,
			cancelText = cancelAlertText,
			confirmText = confirmText,
			screenSize = union.screenSize,
			soakAreaColor3 = Color3.fromRGB(25, 25, 25),
			soakAreaTransparency = 0.8,
			width = UDim.new(0.8, 0),
			displayFailed = false,
			onActivated = union.onActivated,
			onModalClose = union.onDismissed
		})
	else
		local createElement = React.createElement
		local v3 = {
			title = union.titleText,
			buttonStackProps = union.actionText and {
				buttons = {
					{
						buttonType = enum.ButtonType.PrimarySystem,
						props = {
							onActivated = union.onActivated,
							text = union.actionText,
							isDisabled = union.isButtonDisabled
						}
					}
				}
			} or nil,
			screenSize = union.screenSize,
			onCloseClicked = union.onDismissed
		}

		local createElement2 = React.createElement
		local v4 = {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		}

		local createElement3 = React.createElement
		local v5 = {
			PaddingTop = UDim.new(0, size_600 / 2),
			PaddingBottom = 0
		}
		local paddingBottom

		if union.actionText then
			paddingBottom = UDim.new(0, size_600)
		end

		v5.PaddingBottom = paddingBottom
		return createElement(PartialPageModal, v3, {
			Body = createElement2("Frame", v4, {
				ContentPadding = createElement3("UIPadding", v5),
				Body = React.createElement(StyledTextLabel, {
					text = union.bodyText,
					textXAlignment = Enum.TextXAlignment.Left,
					fontStyle = style.Font.Body,
					lineHeight = lineHeight_140,
					colorStyle = style.Theme.TextDefault,
					size = UDim2.fromScale(1, 0),
					automaticSize = Enum.AutomaticSize.Y,
					fluidSizing = false
				})
			})
		})
	end
end

return memo(PartialModal)
