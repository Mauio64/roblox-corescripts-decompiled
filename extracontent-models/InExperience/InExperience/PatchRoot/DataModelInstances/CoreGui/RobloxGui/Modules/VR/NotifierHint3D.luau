local t1 = {}
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local v6 = require(CorePackages.Workspace.Packages.AppCommonLib).Create("ImageLabel")({
	Name = "NotificationObject",
	BackgroundTransparency = 1,
	Image = "rbxasset://textures/ui/VR/notifier_glow.png",
	ImageTransparency = 0,
	BorderSizePixel = 0,
	Position = UDim2.new(0.5, -860, 1, -301),
	Size = UDim2.new(0, 1700, 0, 1000)
})

t1.DEFAULT_DURATION = 5

local function CreateNotificationEffect() -- line: 30
	-- upvalues: RunService (copy), v6 (copy), RobloxGui (copy)
	local t2 = {}
	local u10 = nil

	function t2.Init(p1, p2) -- line: 39
		-- upvalues: u10 (ref), RunService (copy), v6 (copy), RobloxGui (copy)
		local timestamp = tick()
		local v17 = timestamp + p2

		if u10 then
			u10:disconnect()
			u10 = nil
		end

		u10 = RunService.RenderStepped:connect(function() -- line: 47
			-- upvalues: v17 (copy), p1 (copy), v6 (copy), RobloxGui (copy), timestamp (copy)
			if tick() >= v17 then
				p1:Cancel()

				return
			end

			v6.Parent = RobloxGui
			v6.ImageTransparency = (math.sin((tick() - timestamp) * 2.5 + 1.5707963267948966) + 1) / 2 * 0.5 + 0.5
		end)
	end
	function t2.Cancel(_) -- line: 62
		-- upvalues: u10 (ref), v6 (copy)
		if u10 then
			u10:disconnect()
			u10 = nil
		end

		v6.Parent = nil
	end

	return t2
end

local v8 = CreateNotificationEffect()

function t1.BeginNotification(p4, p5) -- line: 75
	-- upvalues: v8 (copy)
	p4:CancelNotification()
	v8:Init(p5 or p4.DEFAULT_DURATION)
end
function t1.CancelNotification(_) -- line: 80
	-- upvalues: v8 (copy)
	v8:Cancel()
end

return t1
