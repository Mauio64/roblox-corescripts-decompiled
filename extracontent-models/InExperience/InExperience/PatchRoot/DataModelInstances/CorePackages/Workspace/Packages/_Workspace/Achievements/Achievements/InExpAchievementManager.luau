local Achievements = script:FindFirstAncestor("Achievements")
local parent = Achievements.Parent
local Signal = require(parent.Signal)
local Achievement = require(Achievements.Achievement.Achievement)
local Logger = require(Achievements.Logger)
local HttpRequest = require(parent.HttpRequest)
local GetUserRecentExperiences = require(Achievements.Requests.GetUserRecentExperiences)
local Dash = require(parent.Dash)

local TimeRefresher = require(Achievements.AchievementDataRefresher.TimeRefresher)
local FriendCountRefresher = require(Achievements.AchievementDataRefresher.FriendCountRefresher)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDefaultHttpRetry = SharedFlags.FFlagLuaAppDefaultHttpRetry

local config = HttpRequest.config
local v = {
	requestFunction = function(p, p2, p3)
		return HttpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
	end,
	maxRetryCount = 0
}
local maxRetryCount

if FFlagLuaAppDefaultHttpRetry then
	maxRetryCount = game:DefineFastInt("InExpAchievementManagerHttpRetryCount", 4)
end

v.maxRetryCount = maxRetryCount
local v2 = config(v)

local v3 = nil
pcall(function()
	local PlatformFriendsService = game:GetService("PlatformFriendsService")
	v3 = PlatformFriendsService
end)

local v4 = nil
pcall(function()
	local PlatformCloudStorageService = game:GetService("PlatformCloudStorageService")
	v4 = PlatformCloudStorageService
end)

local v5 = nil
pcall(function()
	local AchievementService = game:GetService("AchievementService")
	v5 = AchievementService
end)

local Players = game:GetService("Players")

local v6 = nil

pcall(function()
	local PlatformService = game:GetService("PlatformService")
	v6 = PlatformService
end)

local InExpAchievementManager = {}

function InExpAchievementManager:startUp()
	local readableSignal, v7 = Signal.createReadableSignal(0)
	local readableSignal2, v8 = Signal.createReadableSignal(0)

	local readableSignal3, v9 = Signal.createReadableSignal(0)

	local readableSignal4, v10 = Signal.createReadableSignal(0)

	TimeRefresher:init(v7, 3600)
	FriendCountRefresher:init(v10, self.playersService)

	self.achievementMarathon = Achievement.newWithRefresher(
		Achievement.NAMES.ACHIEVEMENT_MARATHON,
		readableSignal,
		TimeRefresher,
		self.achievementService
	)

	self.achievementFoursCompany = Achievement.newWithRefresher(
		Achievement.NAMES.ACHIEVEMENT_FOURS_COMPANY,
		readableSignal4,
		FriendCountRefresher,
		self.achievementService
	)

	self.achievementScout = Achievement.new(
		Achievement.NAMES.ACHIEVEMENT_SCOUT,
		readableSignal2,
		self.achievementService
	)
	self.achievementExplorer = Achievement.new(
		Achievement.NAMES.ACHIEVEMENT_EXPLORER,
		readableSignal2,
		self.achievementService
	)
	self.achievementTrailblazer = Achievement.new(
		Achievement.NAMES.ACHIEVEMENT_TRAILBLAZER,
		readableSignal2,
		self.achievementService
	)

	self.achievementStrengthInNumbers = Achievement.new(
		Achievement.NAMES.ACHIEVEMENT_STRENGTH_IN_NUMBERS,
		readableSignal3,
		self.achievementService
	)

	self:_checkStrengthInNumbers(v9)

	self:_checkJoinExperienceAchievements(v8)
end

function InExpAchievementManager:_checkJoinExperienceAchievements(callback)
	if
		self.achievementScout.hasAchieved == false
		or self.achievementExplorer.hasAchieved == false
		or self.achievementTrailblazer.hasAchieved == false
	then
		if self.platformCloudStorageService and self.platformCloudStorageService:IsUserDataAvailable() then
			local data = self.platformCloudStorageService:GetUserDataAsync("ExperiencesPlayed").data or {}

			if #data < 15 and not Dash.includes(data, game.GameId) then
				table.insert(data, game.GameId)
				self.platformCloudStorageService:SetUserDataAsync("ExperiencesPlayed", {
					data = data
				})
			end

			callback(#data)
		else
			GetUserRecentExperiences(self.requestImpl):andThen(function(p)
				callback(p)
			end):catch(function(p)
				Logger:warning(p)
			end)
		end
	end
end

function InExpAchievementManager:_checkStrengthInNumbers(callback)
	if self.achievementStrengthInNumbers.hasAchieved == false then
		local localPlayer = self.playersService.LocalPlayer

		if
			localPlayer
			and localPlayer.FollowUserId ~= 0
			and localPlayer:IsFriendsWithAsync(localPlayer.FollowUserId)
			and self.playersService:GetPlayerByUserId(localPlayer.FollowUserId)
		then
			callback(0)
		end
	end
end

function InExpAchievementManager.new(p, p2, p3, p4, p5, p6)
	return (setmetatable({
		requestImpl = p or v2,
		platformFriendsService = p2 or v3,
		platformCloudStorageService = p3 or v4,
		achievementService = p4 or v5,
		playersService = p5 or Players,
		platformService = p6 or v6
	}, { __index = InExpAchievementManager }))
end

return InExpAchievementManager
