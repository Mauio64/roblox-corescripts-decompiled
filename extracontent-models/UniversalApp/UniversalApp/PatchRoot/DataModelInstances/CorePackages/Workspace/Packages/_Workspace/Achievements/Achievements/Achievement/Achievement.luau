local Parent = script:FindFirstAncestor("Achievements").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)

require(Parent.Signal)

local AchievementRules = require(script.Parent.AchievementRules)
local AchievementConstants = require(script.Parent.AchievementConstants)
local AchievementTelemetry = require(script.Parent.AchievementTelemetry)
local t2 = {
	NAMES = AchievementConstants.ACHIEVEMENT_NAMES,
	_init = function(p1, p2, p3, p4) -- line: 28
		-- upvalues: AchievementRules (copy)
		p1.achievementService = p4
		p1.achievementName = p2
		p1.achievementRule = AchievementRules[p2]
		p1.achievementAwardedCallbacks = {}
		p1.hasAchieved = nil
		assert(p1.achievementRule, "Achievement rule not found for " .. tostring(p2))

		if p1.achievementService:IsAvailable() then
			pcall(function() -- line: 37
				-- upvalues: p1 (copy), p2 (copy)
				p1.hasAchieved = p1.achievementService:HasAchieved(p2)
			end)

			if p1.hasAchieved == false then
				p1.achievementDataSubscription = p3:subscribe(function(p5) -- line: 42
					-- upvalues: p1 (copy)
					if p1.achievementRule(p5) then
						p1:grantAchievement(p1.achievementName)
					end
				end)
			end
		end
	end,
	grantAchievement = function(p6, p7) -- line: 51
		-- upvalues: LoggingProtocol (copy), AchievementTelemetry (copy)
		if p6.hasAchieved == false then
			local _, result = pcall(function() -- line: 53
				-- upvalues: p6 (copy), p7 (copy)
				return p6.achievementService:GrantAchievement(p7)
			end)

			LoggingProtocol.default:logRobloxTelemetryEvent(AchievementTelemetry, nil, {
				achievementName = p7,
				grantedState = tostring(result)
			})

			if result == true then
				p6.hasAchieved = true
				p6.achievementDataSubscription:unsubscribe()

				for _, v16 in p6.achievementAwardedCallbacks do
					v16(p7)
				end
			end
		end
	end,
	registerOnAchievementAwardedListener = function(t1: {[any]: any}, p8: ((...any) -> ...any)) -- line: 72
		t1.achievementAwardedCallbacks[p8] = p8

		return {
			unsubscribe = function() -- line: 77
				-- upvalues: t1 (copy), p8 (copy)
				t1.achievementAwardedCallbacks[p8] = nil
			end
		}
	end
}

function t2.new(p9, p10, p11) -- line: 83
	-- upvalues: t2 (copy)
	local t3 = {}

	setmetatable(t3, {
		__index = t2
	})
	t3:_init(p9, p10, p11)

	return t3
end
function t2.newWithRefresher(p12, p13, t4: {[any]: any}, p14) -- line: 94
	-- upvalues: t2 (copy)
	local v27 = t2.new(p12, p13, p14)

	if v27.hasAchieved == false then
		t4:start()
		v27:registerOnAchievementAwardedListener(function() -- line: 104
			-- upvalues: t4 (copy)
			t4:stop()
		end)
	end

	return v27
end

return t2
