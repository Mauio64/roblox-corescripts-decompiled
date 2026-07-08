local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
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
local _ = {
	None = "None",
	Success = "Success",
	Fail = "Fail",
	Permission = "Permission"
}
local v17 = Roact.PureComponent:extend("CaptureNotification")

v17.validateProps = t.strictInterface({
	forceDismissToast = t.optional(t.table),
	permissionEvent = t.optional(t.instanceOf("BindableEvent"))
})

function v17.init(p1) -- line: 40
	-- upvalues: Images (copy), RobloxTranslator (copy), Roact (copy), UserInputService (copy)
	p1.state = {
		dismissedPermission = false,
		notificationType = "None",
		toastContent = nil,
		screenSize = Vector2.new(0, 0)
	}

	function p1.onScreenSizeChanged(p2) -- line: 48
		-- upvalues: p1 (copy)
		if p1.state.screenSize ~= p2.AbsoluteSize then
			p1:setState({
				screenSize = p2.AbsoluteSize
			})
		end
	end
	function p1.getToastContent(p3) -- line: 56
		-- upvalues: Images (copy), RobloxTranslator (copy), p1 (copy), Roact (copy)
		if p3 == "Success" or p3 == "Fail" then
			local v31 = p3 == "Success"

			return {
				iconImage = v31 and Images["icons/status/success"] or Images["icons/status/alert"],
				iconColorStyle = not v31 and {
					Transparency = 0,
					Color = Color3.fromRGB(247, 75, 82)
				} or nil,
				toastTitle = v31 and RobloxTranslator:FormatByKey("InGame.NotificationScript2.Capture.Success.ToastText") or RobloxTranslator:FormatByKey("InGame.NotificationScript2.Capture.Fail.ToastText"),
				onDismissed = function() -- line: 68
					-- upvalues: p1 (copy), Roact (copy)
					p1:setState({
						notificationType = "None",
						toastContent = Roact.None
					})

					if p1.props.forceDismissToast and p1.props.forceDismissToast.onDismissed then
						p1.props.forceDismissToast.onDismissed()
					end
				end
			}
		end

		return Roact.None
	end
	function p1.dismissPermissionAlert() -- line: 83
		-- upvalues: p1 (copy)
		p1:setState({
			dismissedPermission = true,
			notificationType = "Fail",
			toastContent = p1.getToastContent("Fail")
		})
	end
	function p1.screenshotSavedToAlbumCallback(_, p5, p6) -- line: 91
		-- upvalues: p1 (copy)
		local v35 = if not p5 then (p1.state.dismissedPermission or (not p6:find("Domain=ALAssetsLibraryErrorDomain") or not p6:find("Data unavailable"))) and "Fail" or "Permission" else "Success"

		p1:setState({
			notificationType = v35,
			toastContent = p1.getToastContent(v35)
		})
	end
	function p1.permissionEventCallback() -- line: 116
		-- upvalues: p1 (copy)
		p1:setState({
			notificationType = "Permission",
			toastContent = p1.getToastContent("Permission")
		})
	end
	function p1.getPermissionAlertBodyText() -- line: 123
		-- upvalues: UserInputService (copy), RobloxTranslator (copy)
		if UserInputService:GetPlatform() == Enum.Platform.IOS then
			return RobloxTranslator:FormatByKey("InGame.NotificationScript2.Capture.Permission.AlertTextIOS")
		end

		if UserInputService:GetPlatform() == Enum.Platform.Android then
			return RobloxTranslator:FormatByKey("InGame.NotificationScript2.Capture.Permission.AlertTextAndroid")
		end

		return RobloxTranslator:FormatByKey("InGame.NotificationScript2.Capture.Permission.AlertText")
	end
end
function v17.renderWithStyle(_, p8) -- line: 134
	-- upvalues: renderWithCoreScriptsStyleProvider (copy)
	return renderWithCoreScriptsStyleProvider(p8)
end
function v17.render(p9) -- line: 138
	-- upvalues: Roact (copy), Toast (copy), InteractiveAlert (copy), RobloxTranslator (copy), ButtonType (copy), shouldSaveScreenshotToAlbum (copy), ExternalEventConnection (copy)
	local notificationType = p9.state.notificationType
	local v23 = notificationType == "Success" and p9.state.toastContent
	local v24 = notificationType == "Fail" and p9.state.toastContent
	local v25 = notificationType == "Permission"

	return p9:renderWithStyle({
		RobloxCaptureNotificationGui = Roact.createElement("ScreenGui", {
			AutoLocalize = false,
			DisplayOrder = 9,
			IgnoreGuiInset = true,
			OnTopOfCoreBlur = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		}, {
			Content = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				[Roact.Change.AbsoluteSize] = p9.onScreenSizeChanged
			}, {
				SuccessToast = v23 and Roact.createElement(Toast, {
					duration = 3,
					show = not p9.props.forceDismissToast,
					toastContent = p9.state.toastContent
				}),
				FailToast = v24 and Roact.createElement(Toast, {
					duration = 3,
					show = not p9.props.forceDismissToast,
					toastContent = p9.state.toastContent
				}),
				PermissionAlertOverlay = v25 and Roact.createElement("Frame", {
					Active = true,
					BackgroundTransparency = 0.5,
					BackgroundColor3 = Color3.new(0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0)
				}, {
					PermissionAlert = Roact.createElement(InteractiveAlert, {
						title = RobloxTranslator:FormatByKey("InGame.NotificationScript2.Capture.Permission.AlertTitle"),
						bodyText = p9.getPermissionAlertBodyText(),
						buttonStackInfo = {
							buttons = {{
								buttonType = ButtonType.PrimarySystem,
								props = {
									onActivated = p9.dismissPermissionAlert,
									text = RobloxTranslator:FormatByKey("InGame.NotificationScript2.Capture.Permission.AlertButtonText")
								}
							}}
						},
						position = UDim2.fromScale(0.5, 0.5),
						screenSize = p9.state.screenSize
					})
				}),
				ScreenshotSavedToAlbumConnection = shouldSaveScreenshotToAlbum() and Roact.createElement(ExternalEventConnection, {
					event = game.ScreenshotSavedToAlbum,
					callback = p9.screenshotSavedToAlbumCallback
				}),
				PermissionEventConnection = p9.props.permissionEvent and Roact.createElement(ExternalEventConnection, {
					event = p9.props.permissionEvent.Event,
					callback = p9.permissionEventCallback
				})
			})
		})
	})
end
function v17.didUpdate(p10, p11) -- line: 208
	local forceDismissToast = p10.props.forceDismissToast

	if forceDismissToast ~= p11.forceDismissToast and ((p10.state.notificationType ~= "Success" and p10.state.notificationType ~= "Fail" or not p10.state.toastContent) and forceDismissToast and forceDismissToast.onDismissed) then
		forceDismissToast.onDismissed()
	end
end

return v17
