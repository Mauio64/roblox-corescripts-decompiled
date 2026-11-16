local Achievements = script:FindFirstAncestor("Achievements")
local AvatarEditorService = game:GetService("AvatarEditorService")

local parent = Achievements.Parent
local Signal = require(parent.Signal)
local Signals = require(parent.Signals)
local Achievement = require(Achievements.Achievement.Achievement)
local Logger = require(Achievements.Logger)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local LoginStatus = RobloxAppEnums.LoginStatus
local HttpRequest = require(parent.HttpRequest)

local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if FFlagUseSignalsForAuthenticationStatus then
	local AuthenticationStatus = require(parent.AuthenticationStatus)
	getAuthenticationStatusStore = AuthenticationStatus.GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local GetXboxLoginConsecutiveDays = require(Achievements.Requests.GetXboxLoginConsecutiveDays)

local VoteCountRefresher = require(Achievements.AchievementDataRefresher.VoteCountRefresher)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppDefaultHttpRetry = SharedFlags2.FFlagLuaAppDefaultHttpRetry

local FFlagGateLoginStreaksByAchievementAvailability = require(Achievements.Flags.FFlagGateLoginStreaksByAchievementAvailability)

local engineFeature = game:GetEngineFeature("AchievementServiceIsAchievementAvailable")
local config = HttpRequest.config
local v = {
	requestFunction = function(p, p2, p3)
		return HttpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
	end,
	maxRetryCount = 0
}
local maxRetryCount

if FFlagLuaAppDefaultHttpRetry then
	maxRetryCount = game:DefineFastInt("InAppAchievementManagerHttpRetryCount", 4)
end

v.maxRetryCount = maxRetryCount
local v2 = config(v)

local v3 = nil
pcall(function()
	local PlatformCloudStorageService = game:GetService("PlatformCloudStorageService")
	v3 = PlatformCloudStorageService
end)

local v4 = nil

pcall(function()
	local AchievementService = game:GetService("AchievementService")
	v4 = AchievementService
end)

local InAppAchievementManager = {}

function InAppAchievementManager:startUp()
	task.spawn(function()
		self:initAchievements()
	end)
end

function InAppAchievementManager:initAchievements()
	local readableSignal, v5 = Signal.createReadableSignal(0)
	local readableSignal2, v6 = Signal.createReadableSignal(0)
	local readableSignal3, v7 = Signal.createReadableSignal(false)

	VoteCountRefresher:init(v5, self.store, self.requestImpl, self.platformCloudStorageService)

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

	self:setupAchievements(v6, v7)
end

function InAppAchievementManager:hasPendingLoginStreakAchievement(): boolean
	for _, v5 in { self.achievement3DayRoll, self.achievement10DayRoll, self.achievement20DayRoll } do
		if v5.hasAchieved == false and self.achievementService:IsAchievementAvailable(v5.achievementName) then
			return true
		end
	end

	return false
end

function InAppAchievementManager:setupAchievements(callback, callback2)
	local v5

	if FFlagGateLoginStreaksByAchievementAvailability and engineFeature then
		v5 = self:hasPendingLoginStreakAchievement()
	else
		v5 = self.achievement3DayRoll.hasAchieved == false
			or self.achievement10DayRoll.hasAchieved == false
			or self.achievement20DayRoll.hasAchieved == false
	end

	if v5 then
		GetXboxLoginConsecutiveDays(self.requestImpl):andThen(function(p)
			if p.responseBody == nil then
				Logger:warning("Response body is empty.")
				return
			end

			local count = p.responseBody.count

			if count == nil then
				Logger:warning("Day count is missing.")
			else
				callback(count)
			end
		end):catch(function(p)
			Logger:warning(p)
		end)
	end

	if self.achievementOneNameManyFaces.hasAchieved == false then
		self.saveAvatarCompletedConnection = self.avatarEditorService.PromptSaveAvatarCompleted:Connect(function(p)
			if p == Enum.AvatarPromptResult.Success then
				callback2(true)
				self.saveAvatarCompletedConnection:Disconnect()
				self.saveAvatarCompletedConnection = nil
			end
		end)
	end
end

function InAppAchievementManager:shutDown()
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

function InAppAchievementManager.new(store, p, p2, p3, p4)
	local object = setmetatable({
		store = store,
		requestImpl = p or v2,
		avatarEditorService = p2 or AvatarEditorService,
		platformCloudStorageService = p3 or v3,
		achievementService = p4 or v4
	}, { __index = InAppAchievementManager })

	if not FFlagUseSignalsForAuthenticationStatus then
		store.changed:connect(function(p5, p6)
			local v5

			if p5.AuthenticationStatus then
				v5 = p5.AuthenticationStatus.status
			else
				v5 = LoginStatus.UNKNOWN
			end

			local v6

			if p6.AuthenticationStatus then
				v6 = p6.AuthenticationStatus.status
			else
				v6 = LoginStatus.UNKNOWN
			end

			if v5 ~= v6 then
				if v5 == LoginStatus.LOGGED_IN then
					object:startUp()
				elseif v5 == LoginStatus.LOGGED_OUT then
					object:shutDown()
				end
			end
		end)

		return object
	end

	object._authStatusInitialized = false
	object._lastAuthStatus = nil
	object._disposeAuthStatus = Signals.createEffect(function(p5)
		local status = getAuthenticationStatusStore(false).getStatus(p5)

		if object._authStatusInitialized then
			if status ~= object._lastAuthStatus then
				object._lastAuthStatus = status

				if status == LoginStatus.LOGGED_IN then
					object:startUp()
				elseif status == LoginStatus.LOGGED_OUT then
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

return InAppAchievementManager
