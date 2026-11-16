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

local iconsstatusalert = Images["icons/status/alert"]

local extended = Roact.PureComponent:extend("DisconnectedDialog")

extended.validateProps = t.strictInterface({
	visible = t.boolean,
	onConfirm = t.callback,
	screenSize = t.Vector2,
	guiService = t.optional(t.union(t.instanceOf("GuiService"), t.table))
})

extended.defaultProps = { guiService = GuiService }

function extended:init()
	self.guiService = self.props.guiService

	function self.onConfirmBindingAction(_, p, _)
		if p ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		self.props.onConfirm()

		return Enum.ContextActionResult.Sink
	end
end

function extended.render(p)
	return withStyle(function(p2)
		local theme = p2.Theme
		local font = p2.Font

		local formatByKey = RobloxTranslator:FormatByKey("InGame.ConnectionError.Heading.VRDisconnected")
		local formatByKey2 = RobloxTranslator:FormatByKey("InGame.ConnectionError.Message.RestartApp")
		local formatByKey3 = RobloxTranslator:FormatByKey("InGame.ConnectionError.Action.Restart")

		local element = Roact.createElement(InteractiveAlert, {
			title = formatByKey,
			middleContent = function()
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
						Position = UDim2.new(0, 5, 0, 5),
						Size = UDim2.fromOffset(40, 40),
						Image = iconsstatusalert,
						ImageTransparency = 0
					}),
					BodyText = Roact.createElement(FitTextLabel, {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						width = FitTextLabel.Width.FitToText,
						Font = font.Body.Font,
						Text = formatByKey2,
						TextSize = font.BaseSize * font.Body.RelativeSize,
						TextColor3 = theme.TextDefault.Color
					})
				})
			end,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = ButtonType.PrimarySystem,
						props = { onActivated = p.props.onConfirm, text = formatByKey3 }
					}
				}
			},
			screenSize = p.props.screenSize
		})

		return Roact.createElement(Roact.Portal, { target = CoreGui }, {
			HeadsetDisconnectedDialog = Roact.createElement("ScreenGui", {
				DisplayOrder = InGameMenuConstants.DisplayOrder.HeadsetDisconnectedDialog,
				IgnoreGuiInset = true,
				OnTopOfCoreBlur = true,
				Enabled = p.props.visible,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			}, {
				Overlay = Roact.createElement("Frame", {
					Active = true,
					BackgroundColor3 = theme.Overlay.Color,
					BackgroundTransparency = theme.Overlay.Transparency,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1)
				}, { Alert = element })
			})
		})
	end)
end

function extended:bindActions()
	ContextActionService:BindCoreAction(
		"TopBarGamepadDisableMenuShortcut",
		function() end,
		false,
		Enum.KeyCode.ButtonStart,
		Enum.KeyCode.Escape
	)

	ContextActionService:BindCoreAction(
		"TopBarDialogConfirm",
		self.onConfirmBindingAction,
		false,
		Enum.KeyCode.Return,
		Enum.KeyCode.ButtonA
	)
end

function extended:unbindActions()
	ContextActionService:UnbindCoreAction("TopBarGamepadDisableMenuShortcut")
	ContextActionService:UnbindCoreAction("TopBarDialogConfirm")
end

function extended:didMount()
	if self.props.visible then
		self:bindActions()
		self.guiService:SetMenuIsOpen(true, "HeadsetDisconnectedDialog")
	end
end

function extended:didUpdate(p, _)
	if self.props.visible ~= p.visible then
		if self.props.visible then
			self:bindActions()
			self.guiService:SetMenuIsOpen(true, "HeadsetDisconnectedDialog")
		else
			self:unbindActions()
			self.guiService:SetMenuIsOpen(false, "HeadsetDisconnectedDialog")
		end
	end
end

function extended:willUnmount()
	self:unbindActions()
	self.guiService:SetMenuIsOpen(false, "HeadsetDisconnectedDialog")
end

return extended
