local Parent = script:FindFirstAncestor("AmpUpsell").Parent
local UIBlox = require(Parent.UIBlox)
local React = require(Parent.React)
local IconSize = UIBlox.App.Constant.IconSize
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector

local function IDVErrorScreen(t1: {[any]: any}) -- line: 26
	-- upvalues: useStyle (copy), useSelector (copy), React (copy), PartialPageModal (copy), ButtonType (copy), ImageSetLabel (copy), IconSize (copy), Images (copy), StyledTextLabel (copy)
	local errorTitle = t1.errorTitle
	local errorDescription = t1.errorDescription
	local onClose = t1.onClose
	local buttonText = t1.buttonText
	local v18 = useStyle()
	local v19 = useSelector(function(p1) -- line: 32
		return p1.ScreenSize
	end)

	return React.createElement(PartialPageModal, {
		bottomPadding = 20,
		title = errorTitle,
		screenSize = v19,
		onCloseClicked = function() -- line: 39
			-- upvalues: onClose (copy)
			onClose()
		end,
		buttonStackProps = {
			buttonHeight = 48,
			forcedFillDirection = Enum.FillDirection.Horizontal,
			buttons = {{
				buttonType = ButtonType.PrimarySystem,
				props = {
					isDisabled = false,
					onActivated = function() -- line: 51
						-- upvalues: onClose (copy)
						onClose()
					end,
					text = buttonText
				}
			}}
		}
	}, {
		ViewFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
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
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, IconSize.XXLarge, 0, IconSize.XXLarge),
				ScaleType = Enum.ScaleType.Fit,
				Image = Images["icons/graphic/error_xlarge"],
				ImageTransparency = v18.Theme.SystemPrimaryDefault.Transparency
			}),
			ErrorText = React.createElement(StyledTextLabel, {
				lineHeight = 1,
				layoutOrder = 2,
				text = errorDescription,
				fontStyle = v18.Font.CaptionBody,
				colorStyle = v18.Theme.TextEmphasis,
				size = UDim2.new(1, 0, 0, 0),
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Center,
				textYAlignment = Enum.TextYAlignment.Center,
				automaticSize = Enum.AutomaticSize.XY
			})
		})
	})
end

return IDVErrorScreen
