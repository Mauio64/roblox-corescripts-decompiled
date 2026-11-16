local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle

local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav

local extended = Roact.PureComponent:extend("ActionModal")

extended.defaultProps = { screenSize = Vector2.new(1000, 1000) }

extended.validateProps = t.interface({
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

function extended.render(p)
	return withFoundationOrUIBloxStyle(function(p2)
		return {
			Theme = {
				Overlay = {
					Color = p2.Color.Common.Scrim.Color3,
					Transparency = p2.Color.Common.Scrim.Transparency
				}
			}
		}
	end, function(p2)
		return Roact.createElement("ImageButton", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = p2.Theme.Overlay.Transparency,
			BackgroundColor3 = p2.Theme.Overlay.Color,
			Active = true,
			AutoButtonColor = false,
			Selectable = false,
			Visible = p.props.Visible,
			[Roact.Event.Activated] = p.props.cancel
		}, {
			AlertModal = Roact.createElement(InteractiveAlert, {
				screenSize = p.props.screenSize,
				title = p.props.title,
				bodyText = p.props.body,
				richText = true,
				isRoactGamepadEnabled = not FFlagAddNewPlayerListMobileFocusNav and nil,
				buttonStackInfo = {
					buttons = {
						{
							buttonType = ButtonType.Secondary,
							props = { text = p.props.cancelText, onActivated = p.props.cancel }
						},
						{
							buttonType = ButtonType.Alert,
							props = {
								text = p.props.blockAndReportText,
								onActivated = p.props.blockAndReport
							}
						},
						{
							buttonType = ButtonType.Alert,
							props = { text = p.props.blockText, onActivated = p.props.block }
						}
					}
				}
			})
		})
	end)
end

return extended
