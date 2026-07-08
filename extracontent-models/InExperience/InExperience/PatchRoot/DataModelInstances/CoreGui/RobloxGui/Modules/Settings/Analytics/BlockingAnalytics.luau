local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Cryo = require(CorePackages.Packages.Cryo)
local t1 = {}

t1.__index = t1

local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

function t1.new(n1: number?, t2: {[any]: any}?) -- line: 20
	-- upvalues: LocalPlayer (ref), RbxAnalyticsService (copy), t1 (copy)
	local v9 = n1 or LocalPlayer.UserId

	assert(v9, "BlockingAnalytics must be passed the ID of the local user")

	local t3 = {
		_eventStreamImpl = t2 and t2.EventStream or RbxAnalyticsService,
		localUserId = v9
	}

	setmetatable(t3, t1)

	return t3
end
function t1.action(p1, p2, p3, p4) -- line: 37
	-- upvalues: Cryo (copy)
	local v15 = Cryo.Dictionary.join(p4 or {}, {
		blockerUserId = p1.localUserId
	})

	p1._eventStreamImpl:SendEventDeferred("AccountSettingsApi", p2, p3, v15)
end

return t1
