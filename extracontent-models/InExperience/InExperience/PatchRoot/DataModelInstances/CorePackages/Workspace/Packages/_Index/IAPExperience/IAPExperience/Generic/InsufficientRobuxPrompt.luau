local parent = script.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)

local RoactFitComponents = require(parent2.RoactFitComponents)
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local FitFrameHorizontal = RoactFitComponents.FitFrameHorizontal
local FitTextLabel = RoactFitComponents.FitTextLabel

local UIBlox = require(parent2.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Core.Style.withStyle

local MultiTextLocalizer = require(parent.Locale.MultiTextLocalizer)

local iconscommonrobux = Images["icons/common/robux"]

local extended = Roact.Component:extend(script.Name)

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function extended:render()
	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			title = { key = "IAPExperience.InsufficientRobux.Title.InsufficientRobux" },
			dontHaveEnough = { key = "IAPExperience.InsufficientRobux.Text.DontHaveEnough" },
			currentBalance = { key = "IAPExperience.InsufficientRobux.Text.CurrentBalance" },
			cancel = { key = "IAPExperience.InsufficientRobux.Action.Cancel" },
			buyRobux = { key = "IAPExperience.InsufficientRobux.Action.BuyRobux" }
		},
		render = function(p)
			return self:renderAlert(p)
		end
	})
end

function extended:renderAlert(data)
	return withStyle(function(p)
		local font = p.Font
		local theme = p.Theme
		local textSize = font.BaseSize * font.Body.RelativeSize

		return Roact.createElement(InteractiveAlert, {
			screenSize = self.props.screenSize,
			title = data.title,
			bodyText = data.dontHaveEnough,
			buttonStackInfo = {
				buttons = {
					{
						props = { onActivated = self.props.closePrompt, text = data.cancel },
						isDefaultChild = true
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = { onActivated = self.props.buyRobux, text = data.buyRobux }
					}
				}
			},
			middleContent = function()
				return Roact.createElement(FitFrameVertical, {
					BackgroundTransparency = 1,
					margin = RoactFitComponents.Rect.quad(10, 0, 10, 0),
					contentPadding = UDim.new(0, 30),
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}, {
					CurrentBalanceLabel = Roact.createElement(FitTextLabel, {
						width = FitTextLabel.Width.FitToText,
						BackgroundTransparency = 1,
						Font = font.Body.Font,
						Text = data.currentBalance,
						TextColor3 = theme.TextDefault.Color,
						TextTransparency = theme.TextDefault.Transparency,
						TextSize = textSize,
						LayoutOrder = 0
					}),
					RobuxAmount = Roact.createElement(FitFrameHorizontal, {
						height = UDim.new(1, 0),
						contentPadding = UDim.new(0, 10),
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						BackgroundTransparency = 1,
						LayoutOrder = 1
					}, {
						Icon = Roact.createElement(ImageSetLabel, {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							Size = UDim2.fromOffset(textSize, textSize),
							Image = iconscommonrobux,
							ImageColor3 = theme.TextDefault.Color,
							ImageTransparency = theme.TextDefault.Transparency
						}),
						Text = Roact.createElement(FitTextLabel, {
							LayoutOrder = 2,
							width = FitTextLabel.Width.FitToText,
							Text = self.props.robuxBalance,
							Font = font.Body.Font,
							TextColor3 = theme.TextDefault.Color,
							TextTransparency = theme.TextDefault.Transparency,
							TextSize = textSize,
							BackgroundTransparency = 1
						})
					})
				})
			end
		})
	end)
end

return extended
