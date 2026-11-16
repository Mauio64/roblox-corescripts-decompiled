local AvatarEditorService = game:GetService("AvatarEditorService")

local Signal = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Signal")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Signals")
local Achievement = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/Achievement/Achievement")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/Logger")
local loginStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/RobloxAppEnums").LoginStatus
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/HttpRequest")

local fFlagUseSignalsForAuthenticationStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/SharedFlags").FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/AuthenticationStatus").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local GetXboxLoginConsecutiveDays = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/Requests/GetXboxLoginConsecutiveDays")

local VoteCountRefresher = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/AchievementDataRefresher/VoteCountRefresher")

local fFlagLuaAppDefaultHttpRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/SharedFlags").FFlagLuaAppDefaultHttpRetry

local FFlagGateLoginStreaksByAchievementAvailability = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/Flags/FFlagGateLoginStreaksByAchievementAvailability")

local engineFeature = game:GetEngineFeature("AchievementServiceIsAchievementAvailable")
local config = HttpRequest.config
local v5 = {
	requestFunction = function(p2, p3, p4)
		return HttpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
	end,
	maxRetryCount = 0
}

local v6 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt(
	"InAppAchievementManagerHttpRetryCount",
	4
) else nil
v5.maxRetryCount = v6
local v7 = config(v5)

local v8 = nil
pcall(function()
	local PlatformCloudStorageService = game:GetService("PlatformCloudStorageService")
	v8 = PlatformCloudStorageService
end)

local v9 = nil

pcall(function()
	local AchievementService = game:GetService("AchievementService")
	v9 = AchievementService
end)

local v10 = {
	startUp = function(self)
		task.spawn(function()
			self:initAchievements()
		end)
	end,
	initAchievements = function(self)
		local readableSignal, v11 = Signal.createReadableSignal(0)
		local readableSignal2, v12 = Signal.createReadableSignal(0)
		local readableSignal3, v13 = Signal.createReadableSignal(false)

		VoteCountRefresher:init(v11, self.store, self.requestImpl, self.platformCloudStorageService)

		self.achievementPollster = Achievement.newWithRefresher(
			Achievement.NAMES.ACHIEVEMENT_POLLSTER,
			readableSignal,
			VoteCountRefresher,
			self.achievementService
		)

		self.achievement3DayRoll = Achievement.new(
			Achievement.NAMES.ACHIEVEMENT_3_DAY_ROLL,
			readableSignal2,
			self.achievementService
		)

		self.achievement10DayRoll = Achievement.new(
			Achievement.NAMES.ACHIEVEMENT_10_DAY_ROLL,
			readableSignal2,
			self.achievementService
		)

		self.achievement20DayRoll = Achievement.new(
			Achievement.NAMES.ACHIEVEMENT_20_DAY_ROLL,
			readableSignal2,
			self.achievementService
		)

		self.achievementOneNameManyFaces = Achievement.new(
			Achievement.NAMES.ACHIEVEMENT_ONE_NAME_MANY_FACES,
			readableSignal3,
			self.achievementService
		)

		self:setupAchievements(v12, v13)
	end,
	hasPendingLoginStreakAchievement = function(self): boolean
		for k, v11 in { self.achievement3DayRoll, self.achievement10DayRoll, self.achievement20DayRoll } do
			if
				v11.hasAchieved == false
				and self.achievementService:IsAchievementAvailable(v11.achievementName)
			then
				return true
			end
		end

		return false
	end,
	setupAchievements = function(self, callback, callback2)
		local v11

		if FFlagGateLoginStreaksByAchievementAvailability and engineFeature then
			v11 = self:hasPendingLoginStreakAchievement()
		else
			v11 = self.achievement3DayRoll.hasAchieved == false
				or self.achievement10DayRoll.hasAchieved == false
				or self.achievement20DayRoll.hasAchieved == false
		end

		if v11 then
			GetXboxLoginConsecutiveDays(self.requestImpl):andThen(function(p2)
				if p2.responseBody == nil then
					Logger:warning("Response body is empty.")
					return
				end

				local count = p2.responseBody.count

				if count == nil then
					Logger:warning("Day count is missing.")
				else
					callback(count)
				end
			end):catch(function(p2)
				Logger:warning(p2)
			end)
		end

		if self.achievementOneNameManyFaces.hasAchieved == false then
			self.saveAvatarCompletedConnection = self.avatarEditorService.PromptSaveAvatarCompleted:Connect(function(p2)
				if p2 == Enum.AvatarPromptResult.Success then
					callback2(true)
					self.saveAvatarCompletedConnection:Disconnect()
					self.saveAvatarCompletedConnection = nil
				end
			end)
		end
	end,
	shutDown = function(self)
		self.achievementPollster = nil
		self.achievement3DayRoll = nil
		self.achievement10DayRoll = nil
		self.achievement20DayRoll = nil
		VoteCountRefresher:stop()

		if self.saveAvatarCompletedConnection and self.saveAvatarCompletedConnection.Connected then
			self.saveAvatarCompletedConnection:Disconnect()
			self.saveAvatarCompletedConnection = nil
		end
	end
}

function v10.new(p2, p3, p4, p5, p6)
	local object = setmetatable({
		store = p2,
		requestImpl = p3 or v7,
		avatarEditorService = p4 or AvatarEditorService,
		platformCloudStorageService = p5 or v8,
		achievementService = p6 or v9
	}, { __index = v10 })

	if not fFlagUseSignalsForAuthenticationStatus then
		p2.changed:connect(function(p7, p8)
			local v11 = if p7.AuthenticationStatus then p7.AuthenticationStatus.status else loginStatus.UNKNOWN

			local v12 = if p8.AuthenticationStatus then p8.AuthenticationStatus.status else loginStatus.UNKNOWN

			if v11 ~= v12 then
				if v11 == loginStatus.LOGGED_IN then
					object:startUp()
				elseif v11 == loginStatus.LOGGED_OUT then
					object:shutDown()
				end
			end
		end)

		return object
	end

	object._authStatusInitialized = false
	object._lastAuthStatus = nil
	object._disposeAuthStatus = Signals.createEffect(function(p7)
		local status = getAuthenticationStatusStore(false).getStatus(p7)

		if object._authStatusInitialized then
			if status ~= object._lastAuthStatus then
				object._lastAuthStatus = status

				if status == loginStatus.LOGGED_IN then
					object:startUp()
				elseif status == loginStatus.LOGGED_OUT then
					object:shutDown()
				end
			end
		else
			object._authStatusInitialized = true
			object._lastAuthStatus = status
		end
	end)
	return object
end

return v10
