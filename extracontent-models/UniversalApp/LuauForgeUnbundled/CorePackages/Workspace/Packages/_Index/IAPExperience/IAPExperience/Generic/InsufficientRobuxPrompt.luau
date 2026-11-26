local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")

local FitFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/FitFrame")
local fitFrameVertical = FitFrame.FitFrameVertical
local fitFrameHorizontal = FitFrame.FitFrameHorizontal
local fitTextLabel = FitFrame.FitTextLabel

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Core.Style.withStyle

local MultiTextLocalizer = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Locale/MultiTextLocalizer")

local iconscommonrobux = images["icons/common/robux"]

local extended = Roact.Component:extend("InsufficientRobuxPrompt")

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function extended:render()
	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			title = { key = "IAPExperience.InsufficientRobux.Title.InsufficientRobux" },
			dontHaveEnough = {
				key = "IAPExperience.InsufficientRobux.Text.DontHaveEnough"
			},
			currentBalance = {
				key = "IAPExperience.InsufficientRobux.Text.CurrentBalance"
			},
			cancel = { key = "IAPExperience.InsufficientRobux.Action.Cancel" },
			buyRobux = { key = "IAPExperience.InsufficientRobux.Action.BuyRobux" }
		},
		render = function(p2)
			return self:renderAlert(p2)
		end
	})
end

function extended:renderAlert(data)
	return withStyle(function(p3)
		local font = p3.Font
		local theme = p3.Theme
		local v5 = font.BaseSize * font.Body.RelativeSize

		return Roact.createElement(interactiveAlert, {
			screenSize = self.props.screenSize,
			title = data.title,
			bodyText = data.dontHaveEnough,
			buttonStackInfo = {
				buttons = {
					{
						props = {
							onActivated = self.props.closePrompt,
							text = data.cancel
						},
						isDefaultChild = true
					},
					{
						buttonType = buttonType.PrimarySystem,
						props = {
							onActivated = self.props.buyRobux,
							text = data.buyRobux
						}
					}
				}
			},
			middleContent = function()
				return Roact.createElement(fitFrameVertical, {
					BackgroundTransparency = 1,
					margin = FitFrame.Rect.quad(10, 0, 10, 0),
					contentPadding = UDim.new(0, 30),
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}, {
					CurrentBalanceLabel = Roact.createElement(fitTextLabel, {
						width = fitTextLabel.Width.FitToText,
						BackgroundTransparency = 1,
						Font = font.Body.Font,
						Text = data.currentBalance,
						TextColor3 = theme.TextDefault.Color,
						TextTransparency = theme.TextDefault.Transparency,
						TextSize = v5,
						LayoutOrder = 0
					}),
					RobuxAmount = Roact.createElement(fitFrameHorizontal, {
						height = UDim.new(1, 0),
						contentPadding = UDim.new(0, 10),
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						BackgroundTransparency = 1,
						LayoutOrder = 1
					}, {
						Icon = Roact.createElement(imageSetLabel, {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							Size = UDim2.fromOffset(v5, v5),
							Image = iconscommonrobux,
							ImageColor3 = theme.TextDefault.Color,
							ImageTransparency = theme.TextDefault.Transparency
						}),
						Text = Roact.createElement(fitTextLabel, {
							LayoutOrder = 2,
							width = fitTextLabel.Width.FitToText,
							Text = self.props.robuxBalance,
							Font = font.Body.Font,
							TextColor3 = theme.TextDefault.Color,
							TextTransparency = theme.TextDefault.Transparency,
							TextSize = v5,
							BackgroundTransparency = 1
						})
					})
				})
			end
		})
	end)
end

return extended
