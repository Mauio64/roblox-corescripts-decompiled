return {
	AchievementPollster = function(p2): boolean
		return p2 >= 5
	end,
	AchievementMarathon = function(p2): boolean
		return p2 >= 3600
	end,
	Achievement20DayRoll = function(p2): boolean
		return p2 >= 20
	end,
	Achievement10DayRoll = function(p2): boolean
		return p2 >= 10
	end,
	Achievement3DayRoll = function(p2): boolean
		return p2 >= 3
	end,
	AchievementFoursCompany = function(p2): boolean
		return p2 >= 3
	end,
	AchievementOneNameManyFaces = function(p2)
		return p2
	end,
	AchievementStrengthInNumbers = function(p2): boolean
		return p2 >= 0
	end,
	AchievementTrailblazer = function(p2): boolean
		return p2 >= 15
	end,
	AchievementExplorer = function(p2): boolean
		return p2 >= 5
	end,
	AchievementScout = function(p2): boolean
		return p2 >= 1
	end
}
