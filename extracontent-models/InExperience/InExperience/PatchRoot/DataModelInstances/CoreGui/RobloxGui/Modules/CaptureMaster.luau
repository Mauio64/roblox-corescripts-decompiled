local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CaptureNotification = require(RobloxGui.Modules.CaptureNotification)
local shouldSaveScreenshotToAlbum = require(RobloxGui.Modules.shouldSaveScreenshotToAlbum)

local class = {}
class.__index = class

function class.new()
	local v = {}
	setmetatable(v, class)
	v.init = false
	v.captureEvent = Instance.new("BindableEvent")
	v.permissionEvent = Instance.new("BindableEvent")

	if shouldSaveScreenshotToAlbum() then
		v.captureNotification = Roact.createElement(CaptureNotification, {
			permissionEvent = v.permissionEvent
		})
	end

	return v
end

function class:Start()
	if self.init then
		return
	end

	self.init = true

	if shouldSaveScreenshotToAlbum() then
		self.captureNotificationInstance = Roact.mount(
			self.captureNotification,
			CoreGui,
			"RobloxCaptureNotificationGui"
		)
	end
end

local v = class.new()

function class:DismissNotification()
	if not self.init then
		v:Start()
	elseif shouldSaveScreenshotToAlbum() then
		Roact.update(self.captureNotificationInstance, Roact.createElement(CaptureNotification, {
			permissionEvent = self.permissionEvent,
			forceDismissToast = {
				onDismissed = function()
					Roact.update(
						self.captureNotificationInstance,
						Roact.createElement(CaptureNotification, {
							permissionEvent = self.permissionEvent,
							forceDismissToast = nil
						})
					)
				end
			}
		}))
	end
end

function class.ShowPermissionToast(p)
	if not p.init then
		v:Start()
	end

	p.permissionEvent:Fire()
end

function class:Capture()
	self:DismissNotification()
	self.captureEvent:Fire()
end

return v
