local parent = script:FindFirstAncestor("Achievements").Parent

local LoggingProtocol = require(parent.LoggingProtocol)
require(parent.Signal)

local AchievementRules = require(script.Parent.AchievementRules)
local AchievementConstants = require(script.Parent.AchievementConstants)

local AchievementTelemetry = require(script.Parent.AchievementTelemetry)

local Achievement = { NAMES = AchievementConstants.ACHIEVEMENT_NAMES }

function Achievement:_init(achievementName, object, achievementService)
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
			self.achievementDataSubscription = object:subscribe(function(p)
				if self.achievementRule(p) then
					self:grantAchievement(self.achievementName)
				end
			end)
		end
	end
end

function Achievement:grantAchievement(achievementName)
	if self.hasAchieved == false then
		local _, result = pcall(function()
			return self.achievementService:GrantAchievement(achievementName)
		end)

		LoggingProtocol.default:logRobloxTelemetryEvent(AchievementTelemetry, nil, {
			achievementName = achievementName,
			grantedState = tostring(result)
		})

		if result == true then
			self.hasAchieved = true
			self.achievementDataSubscription:unsubscribe()

			for _, achievementAwardedCallback in self.achievementAwardedCallbacks do
				achievementAwardedCallback(achievementName)
			end
		end
	end
end

function Achievement:registerOnAchievementAwardedListener(callback)
	self.achievementAwardedCallbacks[callback] = callback
	return {
		unsubscribe = function()
			self.achievementAwardedCallbacks[callback] = nil
		end
	}
end

function Achievement.new(p, p2, p3)
	local class = {}
	setmetatable(class, { __index = Achievement })
	class:_init(p, p2, p3)
	return class
end

function Achievement.newWithRefresher(p, p2, object, p3)
	local v = Achievement.new(p, p2, p3)

	if v.hasAchieved == false then
		object:start()
		v:registerOnAchievementAwardedListener(function()
			object:stop()
		end)
	end

	return v
end

return Achievement
