local Achievements = script:FindFirstAncestor("Achievements")
local AvatarEditorService = game:GetService("AvatarEditorService")
local AchievementsParent = Achievements.Parent
local Signal = require(AchievementsParent.Signal)
local Achievement = require(Achievements.Achievement.Achievement)
local Logger = require(Achievements.Logger)
local LoginStatus = require(AchievementsParent.RobloxAppEnums).LoginStatus
local HttpRequest = require(AchievementsParent.HttpRequest)
local GetXboxLoginConsecutiveDays = require(Achievements.Requests.GetXboxLoginConsecutiveDays)
local VoteCountRefresher = require(Achievements.AchievementDataRefresher.VoteCountRefresher)
local FFlagLuaAppDefaultHttpRetry = require(AchievementsParent.SharedFlags).FFlagLuaAppDefaultHttpRetry
local v12 = game:DefineFastFlag("FixOneNameManyFacesDisconnectCrash", false)
local v13 = HttpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 17
		-- upvalues: HttpRequest (copy)
		return HttpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("InAppAchievementManagerHttpRetryCount", 4)
})
local PlatformCloudStorageService = nil

pcall(function() -- line: 26
	-- upvalues: PlatformCloudStorageService (ref)
	PlatformCloudStorageService = game:GetService("PlatformCloudStorageService")
end)

local AchievementService = nil

pcall(function() -- line: 33
	-- upvalues: AchievementService (ref)
	AchievementService = game:GetService("AchievementService")
end)

local t1 = {
	startUp = function(p4) -- line: 39
		task.spawn(function() -- line: 40
			-- upvalues: p4 (copy)
			p4:initAchievements()
		end)
	end,
	initAchievements = function(p5) -- line: 45
		-- upvalues: Signal (copy), VoteCountRefresher (copy), Achievement (copy)
		local v22, v23 = Signal.createReadableSignal(0)
		local v24, v25 = Signal.createReadableSignal(0)
		local v26, v27 = Signal.createReadableSignal(false)

		VoteCountRefresher:init(v23, p5.store, p5.requestImpl, p5.platformCloudStorageService)
		p5.achievementPollster = Achievement.newWithRefresher(Achievement.NAMES.ACHIEVEMENT_POLLSTER, v22, VoteCountRefresher, p5.achievementService)
		p5.achievement3DayRoll = Achievement.new(Achievement.NAMES.ACHIEVEMENT_3_DAY_ROLL, v24, p5.achievementService)
		p5.achievement10DayRoll = Achievement.new(Achievement.NAMES.ACHIEVEMENT_10_DAY_ROLL, v24, p5.achievementService)
		p5.achievement20DayRoll = Achievement.new(Achievement.NAMES.ACHIEVEMENT_20_DAY_ROLL, v24, p5.achievementService)
		p5.achievementOneNameManyFaces = Achievement.new(Achievement.NAMES.ACHIEVEMENT_ONE_NAME_MANY_FACES, v26, p5.achievementService)
		p5:setupAchievements(v25, v27)
	end,
	setupAchievements = function(p6, p7, p8) -- line: 77
		-- upvalues: GetXboxLoginConsecutiveDays (copy), Logger (copy), v12 (copy)
		if p6.achievement3DayRoll.hasAchieved == false or (p6.achievement10DayRoll.hasAchieved == false or p6.achievement20DayRoll.hasAchieved == false) then
			GetXboxLoginConsecutiveDays(p6.requestImpl):andThen(function(p9) -- line: 83
				-- upvalues: Logger (copy), p7 (copy)
				if p9.responseBody == nil then
					Logger:warning("Response body is empty.")

					return
				end

				local count = p9.responseBody.count

				if count == nil then
					Logger:warning("Day count is missing.")

					return
				end

				p7(count)
			end):catch(function(p10) -- line: 96
				-- upvalues: Logger (copy)
				Logger:warning(p10)
			end)
		end

		if p6.achievementOneNameManyFaces.hasAchieved == false then
			p6.saveAvatarCompletedConnection = p6.avatarEditorService.PromptSaveAvatarCompleted:Connect(function(p11) -- line: 103
				-- upvalues: p8 (copy), v12 (copy), p6 (copy)
				if p11 == Enum.AvatarPromptResult.Success then
					p8(true)

					if v12 then
						if p6.saveAvatarCompletedConnection and p6.saveAvatarCompletedConnection.Connected then
							p6.saveAvatarCompletedConnection:Disconnect()
						end

						p6.saveAvatarCompletedConnection = nil

						return
					end

					p6.saveAvatarCompletedConnection:Disconnect()
					p6.saveAvatarCompletedConnection = nil
				end
			end)
		end
	end,
	shutDown = function(p12) -- line: 121
		-- upvalues: VoteCountRefresher (copy)
		p12.achievementPollster = nil
		p12.achievement3DayRoll = nil
		p12.achievement10DayRoll = nil
		p12.achievement20DayRoll = nil
		VoteCountRefresher:stop()

		if p12.saveAvatarCompletedConnection and p12.saveAvatarCompletedConnection.Connected then
			p12.saveAvatarCompletedConnection:Disconnect()
			p12.saveAvatarCompletedConnection = nil
		end
	end
}

function t1.new(p13, p14, p15, p16, p17) -- line: 134
	-- upvalues: v13 (copy), AvatarEditorService (copy), PlatformCloudStorageService (ref), AchievementService (ref), t1 (copy), LoginStatus (copy)
	local v37 = setmetatable({
		store = p13,
		requestImpl = p14 or v13,
		avatarEditorService = p15 or AvatarEditorService,
		platformCloudStorageService = p16 or PlatformCloudStorageService,
		achievementService = p17 or AchievementService
	}, {
		__index = t1
	})

	p13.changed:connect(function(p18, p19) -- line: 149
		-- upvalues: LoginStatus (copy), v37 (copy)
		local v44 = if not p18.AuthenticationStatus then LoginStatus.UNKNOWN else p18.AuthenticationStatus.status

		if v44 ~= if not p19.AuthenticationStatus then LoginStatus.UNKNOWN else p19.AuthenticationStatus.status then
			if v44 == LoginStatus.LOGGED_IN then
				v37:startUp()

				return
			end

			if v44 == LoginStatus.LOGGED_OUT then
				v37:shutDown()
			end
		end
	end)

	return v37
end

return t1
