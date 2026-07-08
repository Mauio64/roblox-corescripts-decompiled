local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CaptureNotification = require(RobloxGui.Modules.CaptureNotification)
local shouldSaveScreenshotToAlbum = require(RobloxGui.Modules.shouldSaveScreenshotToAlbum)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 21
	-- upvalues: t1 (copy), shouldSaveScreenshotToAlbum (copy), Roact (copy), CaptureNotification (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2.init = false
	t2.captureEvent = Instance.new("BindableEvent")
	t2.permissionEvent = Instance.new("BindableEvent")

	if shouldSaveScreenshotToAlbum() then
		t2.captureNotification = Roact.createElement(CaptureNotification, {
			permissionEvent = t2.permissionEvent
		})
	end

	return t2
end
function t1.Start(p1) -- line: 36
	-- upvalues: shouldSaveScreenshotToAlbum (copy), Roact (copy), CoreGui (copy)
	if p1.init then
		return
	end

	p1.init = true

	if shouldSaveScreenshotToAlbum() then
		p1.captureNotificationInstance = Roact.mount(p1.captureNotification, CoreGui, "RobloxCaptureNotificationGui")
	end
end

local v8 = t1.new()

function t1.DismissNotification(p2) -- line: 50
	-- upvalues: v8 (copy), shouldSaveScreenshotToAlbum (copy), Roact (copy), CaptureNotification (copy)
	if not p2.init then
		v8:Start()

		return
	end

	if shouldSaveScreenshotToAlbum() then
		Roact.update(p2.captureNotificationInstance, Roact.createElement(CaptureNotification, {
			permissionEvent = p2.permissionEvent,
			forceDismissToast = {
				onDismissed = function() -- line: 59
					-- upvalues: Roact (copy), p2 (copy), CaptureNotification (copy)
					Roact.update(p2.captureNotificationInstance, Roact.createElement(CaptureNotification, {
						forceDismissToast = nil,
						permissionEvent = p2.permissionEvent
					}))
				end
			}
		}))
	end
end
function t1.ShowPermissionToast(p3) -- line: 74
	-- upvalues: v8 (copy)
	if not p3.init then
		v8:Start()
	end

	p3.permissionEvent:Fire()
end
function t1.Capture(p4) -- line: 81
	p4:DismissNotification()
	p4.captureEvent:Fire()
end

return v8
