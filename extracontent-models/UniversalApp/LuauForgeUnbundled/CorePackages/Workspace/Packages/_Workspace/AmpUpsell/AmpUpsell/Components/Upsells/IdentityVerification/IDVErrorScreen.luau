local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UIBlox")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")
local iconSize = UIBlox.App.Constant.IconSize
local images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local buttonType = UIBlox.App.Button.Enum.ButtonType
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactUtils").Hooks.RoactRodux.useSelector

local function IDVErrorScreen(props)
	local errorTitle = props.errorTitle
	local errorDescription = props.errorDescription
	local onClose = props.onClose
	local buttonText = props.buttonText
	local v5 = useStyle()
	local v6 = useSelector(function(p2)
		return p2.ScreenSize
	end)

	return React.createElement(partialPageModal, {
		title = errorTitle,
		screenSize = v6,
		onCloseClicked = function()
			onClose()
		end,
		bottomPadding = 20,
		buttonStackProps = {
			forcedFillDirection = Enum.FillDirection.Horizontal,
			buttonHeight = 48,
			buttons = {
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						isDisabled = false,
						onActivated = function()
							onClose()
						end,
						text = buttonText
					}
				}
			}
		}
	}, {
		ViewFrame = React.createElement(
			"Frame",
			{ AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1 },
			{
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 24),
					PaddingBottom = UDim.new(0, 24)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 20)
				}),
				ImageIcon = React.createElement(imageSetLabel, {
					Size = UDim2.new(0, iconSize.XXLarge, 0, iconSize.XXLarge),
					ScaleType = Enum.ScaleType.Fit,
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Image = images["icons/graphic/error_xlarge"],
					ImageTransparency = v5.Theme.SystemPrimaryDefault.Transparency
				}),
				ErrorText = React.createElement(styledTextLabel, {
					text = errorDescription,
					fontStyle = v5.Font.CaptionBody,
					colorStyle = v5.Theme.TextEmphasis,
					size = UDim2.new(1, 0, 0, 0),
					lineHeight = 1,
					textTruncate = Enum.TextTruncate.AtEnd,
					textXAlignment = Enum.TextXAlignment.Center,
					textYAlignment = Enum.TextYAlignment.Center,
					automaticSize = Enum.AutomaticSize.XY,
					layoutOrder = 2
				})
			}
		)
	})
end

return IDVErrorScreen
