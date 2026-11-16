local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local v = AppCommonLib.Create("ImageLabel")({
	Name = "NotificationObject",
	Position = UDim2.new(0.5, -860, 1, -301),
	Size = UDim2.new(0, 1700, 0, 1000),
	BackgroundTransparency = 1,
	Image = "rbxasset://textures/ui/VR/notifier_glow.png",
	ImageTransparency = 0,
	BorderSizePixel = 0
})

local function CreateNotificationEffect()
	local renderSteppedConnection = nil
	return {
		Init = function(self, p)
			local lastTime = tick()
			local v2 = lastTime + p

			if renderSteppedConnection then
				renderSteppedConnection:disconnect()
				renderSteppedConnection = nil
			end

			renderSteppedConnection = RunService.RenderStepped:connect(function()
				if v2 <= tick() then
					self:Cancel()
					return
				end

				v.Parent = RobloxGui
				v.ImageTransparency = (math.sin((tick() - lastTime) * 2.5 + 1.5707963267948966) + 1) / 2 * 0.5 + 0.5
			end)
		end,
		Cancel = function(self)
			if renderSteppedConnection then
				renderSteppedConnection:disconnect()
				renderSteppedConnection = nil
			end

			v.Parent = nil
		end
	}
end

local notificationEffect = CreateNotificationEffect()
local NotifierHint3D = {}
NotifierHint3D.DEFAULT_DURATION = 5

function NotifierHint3D:BeginNotification(p)
	self:CancelNotification()
	notificationEffect:Init(p or self.DEFAULT_DURATION)
end

function NotifierHint3D:CancelNotification()
	notificationEffect:Cancel()
end

return NotifierHint3D
