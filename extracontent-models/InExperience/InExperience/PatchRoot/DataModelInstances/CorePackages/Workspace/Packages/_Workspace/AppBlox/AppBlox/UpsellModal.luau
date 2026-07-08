local Parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(Parent.React)
local useScreenSize = require(Parent.RobloxAppHooks).useScreenSize
local UIBlox = require(Parent.UIBlox)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useTokens = require(Parent.Foundation).Hooks.useTokens

function UpsellModal(t1: {[any]: any}) -- line: 26
	-- upvalues: useTokens (copy), useScreenSize (copy), React (copy), PartialPageModal (copy), ButtonType (copy), StyledTextLabel (copy)
	local v10 = useTokens()
	local v11 = useScreenSize()
	local v12 = React.createElement(PartialPageModal, {
		title = t1.titleText,
		screenSize = v11,
		onCloseClicked = t1.onCloseModal,
		buttonStackProps = {
			forcedFillDirection = Enum.FillDirection.Horizontal,
			buttonHeight = v10.Size.Size_1200,
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						isDisabled = false,
						onActivated = t1.onCancelButtonClick,
						text = t1.cancelButtonText
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						isDisabled = false,
						onActivated = t1.onActionButtonClick,
						text = t1.actionButtonText
					}
				}
			}
		}
	}, {
		ViewFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v10.Padding.XXLarge),
				PaddingBottom = UDim.new(0, v10.Padding.XXLarge)
			}),
			Text = React.createElement(StyledTextLabel, {
				fluidSizing = false,
				fontStyle = v10.Typography.BodyLarge,
				colorStyle = v10.Color.Content.Emphasis,
				size = UDim2.new(1, 0, 0, 0),
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center,
				automaticSize = Enum.AutomaticSize.Y,
				text = t1.bodyText
			})
		})
	})

	return React.createElement("ImageButton", {
		AutoButtonColor = false,
		ImageTransparency = 1,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.new(0, 0, 0)
	}, {
		Content = v12
	})
end

return UpsellModal
