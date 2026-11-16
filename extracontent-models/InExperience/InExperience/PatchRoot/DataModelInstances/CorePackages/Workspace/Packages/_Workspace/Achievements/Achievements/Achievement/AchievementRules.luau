local AchievementRules = {}

function AchievementRules.AchievementPollster(p: number): boolean
	return p >= 5
end

function AchievementRules.AchievementMarathon(p: number): boolean
	return p >= 3600
end

function AchievementRules.Achievement20DayRoll(p: number): boolean
	return p >= 20
end

function AchievementRules.Achievement10DayRoll(p: number): boolean
	return p >= 10
end

function AchievementRules.Achievement3DayRoll(p: number): boolean
	return p >= 3
end

function AchievementRules.AchievementFoursCompany(p: number): boolean
	return p >= 3
end

function AchievementRules.AchievementOneNameManyFaces(flag: boolean)
	return flag
end

function AchievementRules.AchievementStrengthInNumbers(p: number): boolean
	return p >= 0
end

function AchievementRules.AchievementTrailblazer(p: number): boolean
	return p >= 15
end

function AchievementRules.AchievementExplorer(p: number): boolean
	return p >= 5
end

function AchievementRules.AchievementScout(p: number): boolean
	return p >= 1
end

return AchievementRules
