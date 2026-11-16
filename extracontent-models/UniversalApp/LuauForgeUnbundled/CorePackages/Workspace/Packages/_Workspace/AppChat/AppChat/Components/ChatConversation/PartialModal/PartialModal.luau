require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local enum = UIBlox.App.Button.Enum
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local useIsInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsInExperience")

local SocialLibraries = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries")
local info = SocialLibraries.Components.AlertViews.Info
local warning = SocialLibraries.Components.AlertViews.Warning

local v5 = {
	titleText = "",
	cancelAlertText = "",
	bodyText = "",
	isButtonDisabled = false,
	screenSize = Vector2.new(1000, 1000),
	onActivated = function() end,
	onDismissed = function() end
}

local function PartialModal(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local v6 = useStyle()
	local style = union.style or v6

	local size_600 = style.Tokens.Size.Size_600
	local lineHeight_140 = style.Tokens.LineHeight.LineHeight_140

	if useIsInExperience() then
		local v7 = if union.actionText then warning else info

		local cancelAlertText = if union.actionText then union.cancelAlertText else nil
		local v8 = if union.actionText then union.actionText else union.cancelAlertText
		return React.createElement(v7, {
			titleText = union.titleText,
			bodyText = union.bodyText,
			cancelText = cancelAlertText,
			confirmText = v8,
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
		local v8 = {
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
		local v11 = {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		}

		local createElement3 = React.createElement
		local v13 = {
			PaddingTop = UDim.new(0, size_600 / 2),
			PaddingBottom = 0
		}
		local v14 = if union.actionText then UDim.new(0, size_600) else nil
		v13.PaddingBottom = v14
		return createElement(partialPageModal, v8, {
			Body = createElement2("Frame", v11, {
				ContentPadding = createElement3("UIPadding", v13),
				Body = React.createElement(styledTextLabel, {
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
