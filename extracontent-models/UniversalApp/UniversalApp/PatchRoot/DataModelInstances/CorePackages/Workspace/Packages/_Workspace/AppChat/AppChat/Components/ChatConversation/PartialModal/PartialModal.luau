local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local memo = React.memo
local UIBlox = require(AppChatParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Enum2 = UIBlox.App.Button.Enum
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local SocialLibraries = require(AppChat.SocialLibraries)
local Info = SocialLibraries.Components.AlertViews.Info
local Warning = SocialLibraries.Components.AlertViews.Warning
local t1 = {
	titleText = "",
	cancelAlertText = "",
	bodyText = "",
	isButtonDisabled = false,
	screenSize = Vector2.new(1000, 1000),
	onActivated = function() -- line: 41
	end,
	onDismissed = function() -- line: 42
	end
}

local function PartialModal(t2: {[any]: any}) -- line: 45
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), useIsInExperience (copy), Warning (copy), Info (copy), React (copy), PartialPageModal (copy), Enum2 (copy), StyledTextLabel (copy)
	local v18 = Cryo.Dictionary.union(t1, t2)
	local v19 = useStyle()
	local v20 = v18.style or v19
	local Size_600 = v20.Tokens.Size.Size_600
	local LineHeight_140 = v20.Tokens.LineHeight.LineHeight_140

	if useIsInExperience() then
		local v23 = if not v18.actionText then Info else Warning
		local v24 = if not v18.actionText then nil else v18.cancelAlertText
		local v25 = if not v18.actionText then v18.cancelAlertText else v18.actionText

		return React.createElement(v23, {
			soakAreaTransparency = 0.8,
			displayFailed = false,
			titleText = v18.titleText,
			bodyText = v18.bodyText,
			cancelText = v24,
			confirmText = v25,
			screenSize = v18.screenSize,
			soakAreaColor3 = Color3.fromRGB(25, 25, 25),
			width = UDim.new(0.8, 0),
			onActivated = v18.onActivated,
			onModalClose = v18.onDismissed
		})
	end

	return React.createElement(PartialPageModal, {
		title = v18.titleText,
		buttonStackProps = if not v18.actionText then nil else {
			buttons = {{
				buttonType = Enum2.ButtonType.PrimarySystem,
				props = {
					onActivated = v18.onActivated,
					text = v18.actionText,
					isDisabled = v18.isButtonDisabled
				}
			}}
		},
		screenSize = v18.screenSize,
		onCloseClicked = v18.onDismissed
	}, {
		Body = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			ContentPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, Size_600 / 2),
				PaddingBottom = if not v18.actionText then nil else UDim.new(0, Size_600)
			}),
			Body = React.createElement(StyledTextLabel, {
				fluidSizing = false,
				text = v18.bodyText,
				textXAlignment = Enum.TextXAlignment.Left,
				fontStyle = v20.Font.Body,
				lineHeight = LineHeight_140,
				colorStyle = v20.Theme.TextDefault,
				size = UDim2.fromScale(1, 0),
				automaticSize = Enum.AutomaticSize.Y
			})
		})
	})
end

return memo(PartialModal)
