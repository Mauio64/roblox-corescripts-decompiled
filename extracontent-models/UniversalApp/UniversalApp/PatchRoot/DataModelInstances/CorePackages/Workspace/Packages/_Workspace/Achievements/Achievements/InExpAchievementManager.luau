local Achievements = script:FindFirstAncestor("Achievements")
local AchievementsParent = Achievements.Parent
local Signal = require(AchievementsParent.Signal)
local Achievement = require(Achievements.Achievement.Achievement)
local Logger = require(Achievements.Logger)
local HttpRequest = require(AchievementsParent.HttpRequest)
local GetUserRecentExperiences = require(Achievements.Requests.GetUserRecentExperiences)
local Dash = require(AchievementsParent.Dash)
local TimeRefresher = require(Achievements.AchievementDataRefresher.TimeRefresher)
local FriendCountRefresher = require(Achievements.AchievementDataRefresher.FriendCountRefresher)
local FFlagLuaAppDefaultHttpRetry = require(AchievementsParent.SharedFlags).FFlagLuaAppDefaultHttpRetry
local v12 = HttpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 19
		-- upvalues: HttpRequest (copy)
		return HttpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("InExpAchievementManagerHttpRetryCount", 4)
})
local PlatformFriendsService = nil

pcall(function() -- line: 29
	-- upvalues: PlatformFriendsService (ref)
	PlatformFriendsService = game:GetService("PlatformFriendsService")
end)

local PlatformCloudStorageService = nil

pcall(function() -- line: 34
	-- upvalues: PlatformCloudStorageService (ref)
	PlatformCloudStorageService = game:GetService("PlatformCloudStorageService")
end)

local AchievementService = nil

pcall(function() -- line: 39
	-- upvalues: AchievementService (ref)
	AchievementService = game:GetService("AchievementService")
end)

local Players = game:GetService("Players")
local PlatformService = nil

pcall(function() -- line: 47
	-- upvalues: PlatformService (ref)
	PlatformService = game:GetService("PlatformService")
end)

local t1 = {
	startUp = function(p4) -- line: 56
		-- upvalues: Signal (copy), TimeRefresher (copy), FriendCountRefresher (copy), Achievement (copy)
		local v23, v24 = Signal.createReadableSignal(0)
		local v25, v26 = Signal.createReadableSignal(0)
		local v27, v28 = Signal.createReadableSignal(0)
		local v29, v30 = Signal.createReadableSignal(0)

		TimeRefresher:init(v24, 3600)
		FriendCountRefresher:init(v30, p4.playersService)
		p4.achievementMarathon = Achievement.newWithRefresher(Achievement.NAMES.ACHIEVEMENT_MARATHON, v23, TimeRefresher, p4.achievementService)
		p4.achievementFoursCompany = Achievement.newWithRefresher(Achievement.NAMES.ACHIEVEMENT_FOURS_COMPANY, v29, FriendCountRefresher, p4.achievementService)
		p4.achievementScout = Achievement.new(Achievement.NAMES.ACHIEVEMENT_SCOUT, v25, p4.achievementService)
		p4.achievementExplorer = Achievement.new(Achievement.NAMES.ACHIEVEMENT_EXPLORER, v25, p4.achievementService)
		p4.achievementTrailblazer = Achievement.new(Achievement.NAMES.ACHIEVEMENT_TRAILBLAZER, v25, p4.achievementService)
		p4.achievementStrengthInNumbers = Achievement.new(Achievement.NAMES.ACHIEVEMENT_STRENGTH_IN_NUMBERS, v27, p4.achievementService)
		p4:_checkStrengthInNumbers(v28)
		p4:_checkJoinExperienceAchievements(v26)
	end,
	_checkJoinExperienceAchievements = function(p5, p6) -- line: 98
		-- upvalues: Dash (copy), GetUserRecentExperiences (copy), Logger (copy)
		if p5.achievementScout.hasAchieved == false or (p5.achievementExplorer.hasAchieved == false or p5.achievementTrailblazer.hasAchieved == false) then
			if p5.platformCloudStorageService and p5.platformCloudStorageService:IsUserDataAvailable() then
				local v33 = p5.platformCloudStorageService:GetUserDataAsync("ExperiencesPlayed").data or {}

				if #v33 < 15 and not Dash.includes(v33, game.GameId) then
					table.insert(v33, game.GameId)
					p5.platformCloudStorageService:SetUserDataAsync("ExperiencesPlayed", {
						data = v33
					})
				end

				p6(#v33)

				return
			end

			GetUserRecentExperiences(p5.requestImpl):andThen(function(p7) -- line: 116
				-- upvalues: p6 (copy)
				p6(p7)
			end):catch(function(p8) -- line: 118
				-- upvalues: Logger (copy)
				Logger:warning(p8)
			end)
		end
	end,
	_checkStrengthInNumbers = function(p9, p10) -- line: 125
		if p9.achievementStrengthInNumbers.hasAchieved == false then
			local LocalPlayer = p9.playersService.LocalPlayer

			if LocalPlayer and LocalPlayer.FollowUserId ~= 0 and (if not game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then LocalPlayer:IsFriendsWith(LocalPlayer.FollowUserId) else LocalPlayer:IsFriendsWithAsync(LocalPlayer.FollowUserId)) and p9.playersService:GetPlayerByUserId(LocalPlayer.FollowUserId) then
				p10(0)
			end
		end
	end
}

function t1.new(p11, p12, p13, p14, p15, p16) -- line: 142
	-- upvalues: v12 (copy), PlatformFriendsService (ref), PlatformCloudStorageService (ref), AchievementService (ref), Players (copy), PlatformService (ref), t1 (copy)
	return (setmetatable({
		requestImpl = p11 or v12,
		platformFriendsService = p12 or PlatformFriendsService,
		platformCloudStorageService = p13 or PlatformCloudStorageService,
		achievementService = p14 or AchievementService,
		playersService = p15 or Players,
		platformService = p16 or PlatformService
	}, {
		__index = t1
	}))
end

return t1
