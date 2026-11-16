local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local ExternalEventConnection = RoactUtils.ExternalEventConnection

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)

local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local Toast = UIBlox.App.Dialog.Toast
local Images = UIBlox.App.ImageSet.Images

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local shouldSaveScreenshotToAlbum = require(RobloxGui.Modules.shouldSaveScreenshotToAlbum)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local renderWithCoreScriptsStyleProvider = require(RobloxGui.Modules.Common.renderWithCoreScriptsStyleProvider)

local _ = { None = "None", Success = "Success", Fail = "Fail", Permission = "Permission" }

local extended = Roact.PureComponent:extend("CaptureNotification")

extended.validateProps = t.strictInterface({
	forceDismissToast = t.optional(t.table),
	permissionEvent = t.optional(t.instanceOf("BindableEvent"))
})

function extended:init()
	self.state = {
		screenSize = Vector2.new(0, 0),
		dismissedPermission = false,
		notificationType = "None",
		toastContent = nil
	}

	function self.onScreenSizeChanged(p)
		if self.state.screenSize ~= p.AbsoluteSize then
			self:setState({ screenSize = p.AbsoluteSize })
		end
	end

	function self.getToastContent(p)
		if p ~= "Success" and p ~= "Fail" then
			return Roact.None
		end

		local v = p == "Success"
		return {
			iconImage = v and Images["icons/status/success"] or Images["icons/status/alert"],
			iconColorStyle = not v and ({ Color = Color3.fromRGB(247, 75, 82), Transparency = 0 } or nil) or nil,
			toastTitle = v and RobloxTranslator:FormatByKey("InGame.NotificationScript2.Capture.Success.ToastText") or RobloxTranslator:FormatByKey("InGame.NotificationScript2.Capture.Fail.ToastText"),
			onDismissed = function()
				self:setState({ notificationType = "None", toastContent = Roact.None })

				if self.props.forceDismissToast and self.props.forceDismissToast.onDismissed then
					self.props.forceDismissToast.onDismissed()
				end
			end
		}
	end

	function self.dismissPermissionAlert()
		self:setState({
			dismissedPermission = true,
			notificationType = "Fail",
			toastContent = self.getToastContent("Fail")
		})
	end

	function self.screenshotSavedToAlbumCallback(_, p, value)
		local notificationType = p and "Success"
			or (self.state.dismissedPermission or not (value:find("Domain=ALAssetsLibraryErrorDomain") and value:find("Data unavailable")))
			and "Fail"
			or "Permission"

		self:setState({
			notificationType = notificationType,
			toastContent = self.getToastContent(notificationType)
		})
	end

	function self.permissionEventCallback()
		self:setState({
			notificationType = "Permission",
			toastContent = self.getToastContent("Permission")
		})
	end

	function self.getPermissionAlertBodyText()
		if UserInputService:GetPlatform() == Enum.Platform.IOS then
			return RobloxTranslator:FormatByKey("InGame.NotificationScript2.Capture.Permission.AlertTextIOS")
		end

		if UserInputService:GetPlatform() == Enum.Platform.Android then
			return RobloxTranslator:FormatByKey("InGame.NotificationScript2.Capture.Permission.AlertTextAndroid")
		end

		return RobloxTranslator:FormatByKey("InGame.NotificationScript2.Capture.Permission.AlertText")
	end
end

function extended:renderWithStyle(p)
	return renderWithCoreScriptsStyleProvider(p)
end

function extended:render()
	local notificationType = self.state.notificationType
	local v = notificationType == "Success" and self.state.toastContent
	local v2 = notificationType == "Fail" and self.state.toastContent
	local v3 = notificationType == "Permission"
	return self:renderWithStyle({
		RobloxCaptureNotificationGui = Roact.createElement("ScreenGui", {
			AutoLocalize = false,
			DisplayOrder = 9,
			IgnoreGuiInset = true,
			OnTopOfCoreBlur = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		}, {
			Content = Roact.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					[Roact.Change.AbsoluteSize] = self.onScreenSizeChanged
				},
				{
					SuccessToast = v and Roact.createElement(Toast, {
						duration = 3,
						show = not self.props.forceDismissToast,
						toastContent = self.state.toastContent
					}),
					FailToast = v2 and Roact.createElement(Toast, {
						duration = 3,
						show = not self.props.forceDismissToast,
						toastContent = self.state.toastContent
					}),
					PermissionAlertOverlay = v3 and Roact.createElement(
						"Frame",
						{
							Active = true,
							BackgroundColor3 = Color3.new(0, 0, 0),
							BackgroundTransparency = 0.5,
							Size = UDim2.new(1, 0, 1, 0)
						},
						{
							PermissionAlert = Roact.createElement(InteractiveAlert, {
								title = RobloxTranslator:FormatByKey("InGame.NotificationScript2.Capture.Permission.AlertTitle"),
								bodyText = self.getPermissionAlertBodyText(),
								buttonStackInfo = {
									buttons = {
										{
											buttonType = ButtonType.PrimarySystem,
											props = {
												onActivated = self.dismissPermissionAlert,
												text = RobloxTranslator:FormatByKey("InGame.NotificationScript2.Capture.Permission.AlertButtonText")
											}
										}
									}
								},
								position = UDim2.fromScale(0.5, 0.5),
								screenSize = self.state.screenSize
							})
						}
					),
					ScreenshotSavedToAlbumConnection = shouldSaveScreenshotToAlbum() and Roact.createElement(ExternalEventConnection, {
						event = game.ScreenshotSavedToAlbum,
						callback = self.screenshotSavedToAlbumCallback
					}),
					PermissionEventConnection = self.props.permissionEvent and Roact.createElement(ExternalEventConnection, {
						event = self.props.permissionEvent.Event,
						callback = self.permissionEventCallback
					})
				}
			)
		})
	})
end

function extended.didUpdate(p, p2)
	local forceDismissToast = p.props.forceDismissToast

	if p2.forceDismissToast ~= forceDismissToast then
		local v

		if p.state.notificationType == "Success" or p.state.notificationType == "Fail" then
			v = p.state.toastContent
		else
			v = false
		end

		if not v and forceDismissToast and forceDismissToast.onDismissed then
			forceDismissToast.onDismissed()
		end
	end
end

return extended
