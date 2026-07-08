local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local UIBlox = require(ParentParentParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local MultiTextLocalizer = require(ParentParent.Locale.MultiTextLocalizer)
local v8 = Roact.Component:extend(script.Name)

v8.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function v8.render(p1) -- line: 27
	-- upvalues: Roact (copy), MultiTextLocalizer (copy)
	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			TitleText = {
				key = "IAPExperience.LeaveRoblox.Title.LeavingRoblox"
			},
			BodyText = {
				key = "IAPExperience.LeaveRoblox.Text.ExternalWebsiteWarning"
			},
			ButtonCancel = {
				key = "IAPExperience.LeaveRoblox.Action.Cancel"
			},
			ButtonContinue = {
				key = "IAPExperience.LeaveRoblox.Action.Continue"
			}
		},
		render = function(t1: {[any]: any}) -- line: 43
			-- upvalues: p1 (copy)
			return p1:renderAlert(t1)
		end
	})
end
function v8.renderAlert(t2: {[any]: any}, t3: {[any]: any}) -- line: 49
	-- upvalues: Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	return (Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Active = true,
		Selectable = false,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	}, {
		AlertWindow = Roact.createElement(InteractiveAlert, {
			title = t3.TitleText,
			bodyText = t3.BodyText,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = ButtonType.Secondary,
						props = {
							onActivated = t2.props.cancelActivated,
							text = t3.ButtonCancel
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = t2.props.continueActivated,
							text = t3.ButtonContinue
						}
					}
				}
			},
			screenSize = t2.props.screenSize
		})
	}))
end

return v8
