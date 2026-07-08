local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local FFlagAddNewPlayerListMobileFocusNav = require(CorePackages.Workspace.Packages.PlayerList).Flags.FFlagAddNewPlayerListMobileFocusNav
local v9 = Roact.PureComponent:extend("ActionModal")

v9.defaultProps = {
	screenSize = Vector2.new(1000, 1000)
}
v9.validateProps = t.interface({
	block = t.callback,
	blockText = t.string,
	blockAndReport = t.callback,
	blockAndReportText = t.string,
	cancel = t.callback,
	cancelText = t.string,
	body = t.string,
	title = t.string,
	screenSize = t.optional(t.Vector2)
})

function v9.render(p1) -- line: 35
	-- upvalues: withFoundationOrUIBloxStyle (copy), Roact (copy), InteractiveAlert (copy), FFlagAddNewPlayerListMobileFocusNav (copy), ButtonType (copy)
	return withFoundationOrUIBloxStyle(function(p2) -- line: 36
		return {
			Theme = {
				Overlay = {
					Color = p2.Color.Common.Scrim.Color3,
					Transparency = p2.Color.Common.Scrim.Transparency
				}
			}
		}
	end, function(p3) -- line: 45
		-- upvalues: Roact (copy), p1 (copy), InteractiveAlert (copy), FFlagAddNewPlayerListMobileFocusNav (copy), ButtonType (copy)
		return Roact.createElement("ImageButton", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = p3.Theme.Overlay.Transparency,
			BackgroundColor3 = p3.Theme.Overlay.Color,
			Active = true,
			AutoButtonColor = false,
			Selectable = false,
			Visible = p1.props.Visible,
			[Roact.Event.Activated] = p1.props.cancel
		}, {
			AlertModal = Roact.createElement(InteractiveAlert, {
				richText = true,
				screenSize = p1.props.screenSize,
				title = p1.props.title,
				bodyText = p1.props.body,
				isRoactGamepadEnabled = not FFlagAddNewPlayerListMobileFocusNav and nil,
				buttonStackInfo = {
					buttons = {
						{
							buttonType = ButtonType.Secondary,
							props = {
								text = p1.props.cancelText,
								onActivated = p1.props.cancel
							}
						},
						{
							buttonType = ButtonType.Alert,
							props = {
								text = p1.props.blockAndReportText,
								onActivated = p1.props.blockAndReport
							}
						},
						{
							buttonType = ButtonType.Alert,
							props = {
								text = p1.props.blockText,
								onActivated = p1.props.block
							}
						}
					}
				}
			})
		})
	end)
end

return v9
