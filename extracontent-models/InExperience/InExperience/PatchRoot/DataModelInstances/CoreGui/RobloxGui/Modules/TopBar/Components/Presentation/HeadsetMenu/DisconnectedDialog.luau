local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local FitFrame = require(CorePackages.Packages.FitFrame)
local FitFrameVertical = FitFrame.FitFrameVertical
local FitTextLabel = FitFrame.FitTextLabel
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Core.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Modules = CoreGui.RobloxGui.Modules
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local InGameMenuConstants = require(Modules.InGameMenuConstants)
local v19 = Images["icons/status/alert"]
local v20 = Roact.PureComponent:extend("DisconnectedDialog")

v20.validateProps = t.strictInterface({
	visible = t.boolean,
	onConfirm = t.callback,
	screenSize = t.Vector2,
	guiService = t.optional(t.union(t.instanceOf("GuiService"), t.table))
})
v20.defaultProps = {
	guiService = GuiService
}

function v20.init(p1) -- line: 50
	p1.guiService = p1.props.guiService

	function p1.onConfirmBindingAction(_, p3, _) -- line: 53
		-- upvalues: p1 (copy)
		if p3 ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		p1.props.onConfirm()

		return Enum.ContextActionResult.Sink
	end
end
function v20.render(p5) -- line: 64
	-- upvalues: withStyle (copy), RobloxTranslator (copy), Roact (copy), InteractiveAlert (copy), FitFrameVertical (copy), ImageSetLabel (copy), v19 (copy), FitTextLabel (copy), ButtonType (copy), CoreGui (copy), InGameMenuConstants (copy)
	return withStyle(function(p6) -- line: 65
		-- upvalues: RobloxTranslator (copy), Roact (copy), InteractiveAlert (copy), FitFrameVertical (copy), ImageSetLabel (copy), v19 (copy), FitTextLabel (copy), ButtonType (copy), p5 (copy), CoreGui (copy), InGameMenuConstants (copy)
		local Theme = p6.Theme
		local p6Font = p6.Font
		local v36 = RobloxTranslator:FormatByKey("InGame.ConnectionError.Heading.VRDisconnected")
		local v37 = RobloxTranslator:FormatByKey("InGame.ConnectionError.Message.RestartApp")
		local v38 = RobloxTranslator:FormatByKey("InGame.ConnectionError.Action.Restart")
		local v39 = Roact.createElement(InteractiveAlert, {
			title = v36,
			middleContent = function() -- line: 75
				-- upvalues: Roact (copy), FitFrameVertical (copy), ImageSetLabel (copy), v19 (copy), FitTextLabel (copy), p6Font (copy), v37 (copy), Theme (copy)
				return Roact.createElement(FitFrameVertical, {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = UDim.new(0, 24)
				}, {
					Icon = Roact.createElement(ImageSetLabel, {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						ImageTransparency = 0,
						Position = UDim2.new(0, 5, 0, 5),
						Size = UDim2.fromOffset(40, 40),
						Image = v19
					}),
					BodyText = Roact.createElement(FitTextLabel, {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						width = FitTextLabel.Width.FitToText,
						Font = p6Font.Body.Font,
						Text = v37,
						TextSize = p6Font.BaseSize * p6Font.Body.RelativeSize,
						TextColor3 = Theme.TextDefault.Color
					})
				})
			end,
			buttonStackInfo = {
				buttons = {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p5.props.onConfirm,
						text = v38
					}
				}}
			},
			screenSize = p5.props.screenSize
		})

		return Roact.createElement(Roact.Portal, {
			target = CoreGui
		}, {
			HeadsetDisconnectedDialog = Roact.createElement("ScreenGui", {
				IgnoreGuiInset = true,
				OnTopOfCoreBlur = true,
				DisplayOrder = InGameMenuConstants.DisplayOrder.HeadsetDisconnectedDialog,
				Enabled = p5.props.visible,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			}, {
				Overlay = Roact.createElement("Frame", {
					Active = true,
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.Overlay.Color,
					BackgroundTransparency = Theme.Overlay.Transparency,
					Size = UDim2.fromScale(1, 1)
				}, {
					Alert = v39
				})
			})
		})
	end)
end
function v20.bindActions(p7) -- line: 144
	-- upvalues: ContextActionService (copy)
	ContextActionService:BindCoreAction("TopBarGamepadDisableMenuShortcut", function() -- line: 148
	end, false, Enum.KeyCode.ButtonStart, Enum.KeyCode.Escape)
	ContextActionService:BindCoreAction("TopBarDialogConfirm", p7.onConfirmBindingAction, false, Enum.KeyCode.Return, Enum.KeyCode.ButtonA)
end
function v20.unbindActions(_) -- line: 163
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("TopBarGamepadDisableMenuShortcut")
	ContextActionService:UnbindCoreAction("TopBarDialogConfirm")
end
function v20.didMount(p9) -- line: 168
	if p9.props.visible then
		p9:bindActions()
		p9.guiService:SetMenuIsOpen(true, "HeadsetDisconnectedDialog")
	end
end
function v20.didUpdate(p10, p11, _) -- line: 175
	if p10.props.visible ~= p11.visible then
		if p10.props.visible then
			p10:bindActions()
			p10.guiService:SetMenuIsOpen(true, "HeadsetDisconnectedDialog")

			return
		end

		p10:unbindActions()
		p10.guiService:SetMenuIsOpen(false, "HeadsetDisconnectedDialog")
	end
end
function v20.willUnmount(p13) -- line: 187
	p13:unbindActions()
	p13.guiService:SetMenuIsOpen(false, "HeadsetDisconnectedDialog")
end

return v20
