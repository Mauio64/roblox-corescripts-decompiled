local Signal = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Signal")
local Achievement = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/Achievement/Achievement")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/Logger")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/HttpRequest")
local GetUserRecentExperiences = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/Requests/GetUserRecentExperiences")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Dash")

local TimeRefresher = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/AchievementDataRefresher/TimeRefresher")
local FriendCountRefresher = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/AchievementDataRefresher/FriendCountRefresher")
local fFlagLuaAppDefaultHttpRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/SharedFlags").FFlagLuaAppDefaultHttpRetry

local config = HttpRequest.config
local v5 = {
	requestFunction = function(p2, p3, p4)
		return HttpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
	end,
	maxRetryCount = 0
}

local v6 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt(
	"InExpAchievementManagerHttpRetryCount",
	4
) else nil
v5.maxRetryCount = v6
local v7 = config(v5)

local v8 = nil
pcall(function()
	local PlatformFriendsService = game:GetService("PlatformFriendsService")
	v8 = PlatformFriendsService
end)

local v9 = nil
pcall(function()
	local PlatformCloudStorageService = game:GetService("PlatformCloudStorageService")
	v9 = PlatformCloudStorageService
end)

local v10 = nil
pcall(function()
	local AchievementService = game:GetService("AchievementService")
	v10 = AchievementService
end)

local Players = game:GetService("Players")

local v11 = nil

pcall(function()
	local PlatformService = game:GetService("PlatformService")
	v11 = PlatformService
end)

local v12 = {
	startUp = function(self)
		local readableSignal, v13 = Signal.createReadableSignal(0)
		local readableSignal2, v14 = Signal.createReadableSignal(0)

		local readableSignal3, v15 = Signal.createReadableSignal(0)

		local readableSignal4, v16 = Signal.createReadableSignal(0)

		TimeRefresher:init(v13, 3600)
		FriendCountRefresher:init(v16, self.playersService)

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

		self:_checkStrengthInNumbers(v15)

		self:_checkJoinExperienceAchievements(v14)
	end,
	_checkJoinExperienceAchievements = function(self, callback)
		if
			self.achievementScout.hasAchieved == false
			or self.achievementExplorer.hasAchieved == false
			or self.achievementTrailblazer.hasAchieved == false
		then
			if
				self.platformCloudStorageService
				and self.platformCloudStorageService:IsUserDataAvailable()
			then
				local data2 = self.platformCloudStorageService:GetUserDataAsync("ExperiencesPlayed").data
					or {}

				if #data2 < 15 and not Dash.includes(data2, game.GameId) then
					table.insert(data2, game.GameId)
					self.platformCloudStorageService:SetUserDataAsync("ExperiencesPlayed", {
						data = data2
					})
				end

				callback(#data2)
			else
				GetUserRecentExperiences(self.requestImpl):andThen(function(p2)
					callback(p2)
				end):catch(function(p2)
					Logger:warning(p2)
				end)
			end
		end
	end,
	_checkStrengthInNumbers = function(self, callback)
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
}

function v12.new(p2, p3, p4, p5, p6, p7)
	return (setmetatable({
		requestImpl = p2 or v7,
		platformFriendsService = p3 or v8,
		platformCloudStorageService = p4 or v9,
		achievementService = p5 or v10,
		playersService = p6 or Players,
		platformService = p7 or v11
	}, { __index = v12 }))
end

return v12
