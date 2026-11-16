local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/LoggingProtocol")
require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Signal")

local AchievementRules = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/Achievement/AchievementRules")
local AchievementConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/Achievement/AchievementConstants")

local AchievementTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/Achievement/AchievementTelemetry")

local v5 = { NAMES = AchievementConstants.ACHIEVEMENT_NAMES }

function v5:_init(achievementName, object2, achievementService)
	self.achievementService = achievementService
	self.achievementName = achievementName
	self.achievementRule = AchievementRules[achievementName]
	self.achievementAwardedCallbacks = {}
	self.hasAchieved = nil
	assert(self.achievementRule, "Achievement rule not found for " .. tostring(achievementName))

	if self.achievementService:IsAvailable() then
		pcall(function()
			self.hasAchieved = self.achievementService:HasAchieved(achievementName)
		end)

		if self.hasAchieved == false then
			self.achievementDataSubscription = object2:subscribe(function(p2)
				if self.achievementRule(p2) then
					self:grantAchievement(self.achievementName)
				end
			end)
		end
	end
end

function v5:grantAchievement(p2)
	if self.hasAchieved == false then
		local success, result = pcall(function()
			return self.achievementService:GrantAchievement(p2)
		end)

		LoggingProtocol.default:logRobloxTelemetryEvent(AchievementTelemetry, nil, {
			achievementName = p2,
			grantedState = tostring(result)
		})

		if result == true then
			self.hasAchieved = true
			self.achievementDataSubscription:unsubscribe()

			for k, achievementAwardedCallback in self.achievementAwardedCallbacks do
				achievementAwardedCallback(p2)
			end
		end
	end
end

function v5:registerOnAchievementAwardedListener(p3)
	self.achievementAwardedCallbacks[p3] = p3
	return {
		unsubscribe = function()
			self.achievementAwardedCallbacks[p3] = nil
		end
	}
end

function v5.new(p2, p3, p4)
	local class = {}
	setmetatable(class, { __index = v5 })
	class:_init(p2, p3, p4)
	return class
end

function v5.newWithRefresher(p2, p3, object, p4)
	local v6 = v5.new(p2, p3, p4)

	if v6.hasAchieved == false then
		object:start()
		v6:registerOnAchievementAwardedListener(function()
			object:stop()
		end)
	end

	return v6
end

return v5
