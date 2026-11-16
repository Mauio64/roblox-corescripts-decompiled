local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local Cryo = require(CorePackages.Packages.Cryo)

local BlockingAnalytics = {}
BlockingAnalytics.__index = BlockingAnalytics

local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

function BlockingAnalytics.new(p: number?, p2)
	local localUserId = p or LocalPlayer.UserId

	assert(localUserId, "BlockingAnalytics must be passed the ID of the local user")

	local v = {
		_eventStreamImpl = p2 and p2.EventStream or RbxAnalyticsService,
		localUserId = localUserId
	}

	setmetatable(v, BlockingAnalytics)

	return v
end

function BlockingAnalytics:action(p, p2, options)
	local joined = Cryo.Dictionary.join(options or {}, { blockerUserId = self.localUserId })

	self._eventStreamImpl:SendEventDeferred("AccountSettingsApi", p, p2, joined)
end

return BlockingAnalytics
