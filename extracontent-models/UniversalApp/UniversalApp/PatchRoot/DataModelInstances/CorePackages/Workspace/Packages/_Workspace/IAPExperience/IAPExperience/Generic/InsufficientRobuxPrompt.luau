local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local RoactFitComponents = require(ParentParentParent.RoactFitComponents)
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local FitFrameHorizontal = RoactFitComponents.FitFrameHorizontal
local FitTextLabel = RoactFitComponents.FitTextLabel
local UIBlox = require(ParentParentParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Core.Style.withStyle
local MultiTextLocalizer = require(ParentParent.Locale.MultiTextLocalizer)
local v15 = Images["icons/common/robux"]
local v16 = Roact.Component:extend(script.Name)

v16.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function v16.render(p1) -- line: 45
	-- upvalues: Roact (copy), MultiTextLocalizer (copy)
	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			title = {
				key = "IAPExperience.InsufficientRobux.Title.InsufficientRobux"
			},
			dontHaveEnough = {
				key = "IAPExperience.InsufficientRobux.Text.DontHaveEnough"
			},
			currentBalance = {
				key = "IAPExperience.InsufficientRobux.Text.CurrentBalance"
			},
			cancel = {
				key = "IAPExperience.InsufficientRobux.Action.Cancel"
			},
			buyRobux = {
				key = "IAPExperience.InsufficientRobux.Action.BuyRobux"
			}
		},
		render = function(t1: {[any]: any}) -- line: 64
			-- upvalues: p1 (copy)
			return p1:renderAlert(t1)
		end
	})
end
function v16.renderAlert(t2: {[any]: any}, t3: {[any]: any}) -- line: 70
	-- upvalues: withStyle (copy), Roact (copy), InteractiveAlert (copy), ButtonType (copy), FitFrameVertical (copy), RoactFitComponents (copy), FitTextLabel (copy), FitFrameHorizontal (copy), ImageSetLabel (copy), v15 (copy)
	return withStyle(function(p2) -- line: 71
		-- upvalues: Roact (copy), InteractiveAlert (copy), t2 (copy), t3 (copy), ButtonType (copy), FitFrameVertical (copy), RoactFitComponents (copy), FitTextLabel (copy), FitFrameHorizontal (copy), ImageSetLabel (copy), v15 (copy)
		local p2Font = p2.Font
		local Theme = p2.Theme
		local v24 = p2Font.BaseSize * p2Font.Body.RelativeSize

		return Roact.createElement(InteractiveAlert, {
			screenSize = t2.props.screenSize,
			title = t3.title,
			bodyText = t3.dontHaveEnough,
			buttonStackInfo = {
				buttons = {
					{
						isDefaultChild = true,
						props = {
							onActivated = t2.props.closePrompt,
							text = t3.cancel
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = t2.props.buyRobux,
							text = t3.buyRobux
						}
					}
				}
			},
			middleContent = function() -- line: 99
				-- upvalues: Roact (copy), FitFrameVertical (copy), RoactFitComponents (copy), FitTextLabel (copy), p2Font (copy), t3 (copy), Theme (copy), v24 (copy), FitFrameHorizontal (copy), ImageSetLabel (copy), v15 (copy), t2 (copy)
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
						BackgroundTransparency = 1,
						LayoutOrder = 0,
						width = FitTextLabel.Width.FitToText,
						Font = p2Font.Body.Font,
						Text = t3.currentBalance,
						TextColor3 = Theme.TextDefault.Color,
						TextTransparency = Theme.TextDefault.Transparency,
						TextSize = v24
					}),
					RobuxAmount = Roact.createElement(FitFrameHorizontal, {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						height = UDim.new(1, 0),
						contentPadding = UDim.new(0, 10),
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}, {
						Icon = Roact.createElement(ImageSetLabel, {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							Size = UDim2.fromOffset(v24, v24),
							Image = v15,
							ImageColor3 = Theme.TextDefault.Color,
							ImageTransparency = Theme.TextDefault.Transparency
						}),
						Text = Roact.createElement(FitTextLabel, {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							width = FitTextLabel.Width.FitToText,
							Text = t2.props.robuxBalance,
							Font = p2Font.Body.Font,
							TextColor3 = Theme.TextDefault.Color,
							TextTransparency = Theme.TextDefault.Transparency,
							TextSize = v24
						})
					})
				})
			end
		})
	end)
end

return v16
