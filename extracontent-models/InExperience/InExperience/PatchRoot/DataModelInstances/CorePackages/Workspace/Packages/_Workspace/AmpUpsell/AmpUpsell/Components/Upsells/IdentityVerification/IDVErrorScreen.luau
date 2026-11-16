local parent = script:FindFirstAncestor("AmpUpsell").Parent
local UIBlox = require(parent.UIBlox)
local React = require(parent.React)
local IconSize = UIBlox.App.Constant.IconSize
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function IDVErrorScreen(props)
	local errorTitle = props.errorTitle
	local errorDescription = props.errorDescription
	local onClose = props.onClose
	local buttonText = props.buttonText
	local v = useStyle()
	local screenSize = useSelector(function(p)
		return p.ScreenSize
	end)

	return React.createElement(PartialPageModal, {
		title = errorTitle,
		screenSize = screenSize,
		onCloseClicked = function()
			onClose()
		end,
		bottomPadding = 20,
		buttonStackProps = {
			forcedFillDirection = Enum.FillDirection.Horizontal,
			buttonHeight = 48,
			buttons = {
				{
					buttonType = ButtonType.PrimarySystem,
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
				ImageIcon = React.createElement(ImageSetLabel, {
					Size = UDim2.new(0, IconSize.XXLarge, 0, IconSize.XXLarge),
					ScaleType = Enum.ScaleType.Fit,
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Image = Images["icons/graphic/error_xlarge"],
					ImageTransparency = v.Theme.SystemPrimaryDefault.Transparency
				}),
				ErrorText = React.createElement(StyledTextLabel, {
					text = errorDescription,
					fontStyle = v.Font.CaptionBody,
					colorStyle = v.Theme.TextEmphasis,
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
