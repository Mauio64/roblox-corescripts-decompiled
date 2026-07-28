local Achievements = script:FindFirstAncestor("Achievements")
local AvatarEditorService = game:GetService("AvatarEditorService")
local AchievementsParent = Achievements.Parent
local Signal = require(AchievementsParent.Signal)
local Signals = require(AchievementsParent.Signals)
local Achievement = require(Achievements.Achievement.Achievement)
local Logger = require(Achievements.Logger)
local LoginStatus = require(AchievementsParent.RobloxAppEnums).LoginStatus
local HttpRequest = require(AchievementsParent.HttpRequest)
local FFlagUseSignalsForAuthenticationStatus = require(AchievementsParent.SharedFlags).FFlagUseSignalsForAuthenticationStatus
local v11 = if not FFlagUseSignalsForAuthenticationStatus then nil else require(AchievementsParent.AuthenticationStatus).GetAuthenticationStatusStore
local GetXboxLoginConsecutiveDays = require(Achievements.Requests.GetXboxLoginConsecutiveDays)
local VoteCountRefresher = require(Achievements.AchievementDataRefresher.VoteCountRefresher)
local FFlagLuaAppDefaultHttpRetry = require(AchievementsParent.SharedFlags).FFlagLuaAppDefaultHttpRetry
local v15 = game:DefineFastFlag("FixOneNameManyFacesDisconnectCrash", false)
local v16 = HttpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 25
		-- upvalues: HttpRequest (copy)
		return HttpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("InAppAchievementManagerHttpRetryCount", 4)
})
local PlatformCloudStorageService = nil

pcall(function() -- line: 34
	-- upvalues: PlatformCloudStorageService (ref)
	PlatformCloudStorageService = game:GetService("PlatformCloudStorageService")
end)

local AchievementService = nil

pcall(function() -- line: 41
	-- upvalues: AchievementService (ref)
	AchievementService = game:GetService("AchievementService")
end)

local t1 = {
	startUp = function(p4) -- line: 47
		task.spawn(function() -- line: 48
			-- upvalues: p4 (copy)
			p4:initAchievements()
		end)
	end,
	initAchievements = function(p5) -- line: 53
		-- upvalues: Signal (copy), VoteCountRefresher (copy), Achievement (copy)
		local v25, v26 = Signal.createReadableSignal(0)
		local v27, v28 = Signal.createReadableSignal(0)
		local v29, v30 = Signal.createReadableSignal(false)

		VoteCountRefresher:init(v26, p5.store, p5.requestImpl, p5.platformCloudStorageService)
		p5.achievementPollster = Achievement.newWithRefresher(Achievement.NAMES.ACHIEVEMENT_POLLSTER, v25, VoteCountRefresher, p5.achievementService)
		p5.achievement3DayRoll = Achievement.new(Achievement.NAMES.ACHIEVEMENT_3_DAY_ROLL, v27, p5.achievementService)
		p5.achievement10DayRoll = Achievement.new(Achievement.NAMES.ACHIEVEMENT_10_DAY_ROLL, v27, p5.achievementService)
		p5.achievement20DayRoll = Achievement.new(Achievement.NAMES.ACHIEVEMENT_20_DAY_ROLL, v27, p5.achievementService)
		p5.achievementOneNameManyFaces = Achievement.new(Achievement.NAMES.ACHIEVEMENT_ONE_NAME_MANY_FACES, v29, p5.achievementService)
		p5:setupAchievements(v28, v30)
	end,
	setupAchievements = function(p6, p7, p8) -- line: 85
		-- upvalues: GetXboxLoginConsecutiveDays (copy), Logger (copy), v15 (copy)
		if p6.achievement3DayRoll.hasAchieved == false or (p6.achievement10DayRoll.hasAchieved == false or p6.achievement20DayRoll.hasAchieved == false) then
			GetXboxLoginConsecutiveDays(p6.requestImpl):andThen(function(p9) -- line: 91
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
			end):catch(function(p10) -- line: 104
				-- upvalues: Logger (copy)
				Logger:warning(p10)
			end)
		end

		if p6.achievementOneNameManyFaces.hasAchieved == false then
			p6.saveAvatarCompletedConnection = p6.avatarEditorService.PromptSaveAvatarCompleted:Connect(function(p11) -- line: 111
				-- upvalues: p8 (copy), v15 (copy), p6 (copy)
				if p11 == Enum.AvatarPromptResult.Success then
					p8(true)

					if v15 then
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
	shutDown = function(p12) -- line: 129
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

function t1.new(p13, p14, p15, p16, p17) -- line: 142
	-- upvalues: v16 (copy), AvatarEditorService (copy), PlatformCloudStorageService (ref), AchievementService (ref), t1 (copy), FFlagUseSignalsForAuthenticationStatus (copy), Signals (copy), v11 (copy), LoginStatus (copy)
	local v40 = setmetatable({
		store = p13,
		requestImpl = p14 or v16,
		avatarEditorService = p15 or AvatarEditorService,
		platformCloudStorageService = p16 or PlatformCloudStorageService,
		achievementService = p17 or AchievementService
	}, {
		__index = t1
	})

	if FFlagUseSignalsForAuthenticationStatus then
		v40._authStatusInitialized = false
		v40._lastAuthStatus = nil
		v40._disposeAuthStatus = Signals.createEffect(function(p18) -- line: 160
			-- upvalues: v11 (copy), v40 (copy), LoginStatus (copy)
			local v46 = v11(false).getStatus(p18)

			if not v40._authStatusInitialized then
				v40._authStatusInitialized = true
				v40._lastAuthStatus = v46

				return
			end

			if v46 ~= v40._lastAuthStatus then
				v40._lastAuthStatus = v46

				if v46 == LoginStatus.LOGGED_IN then
					v40:startUp()

					return
				end

				if v46 == LoginStatus.LOGGED_OUT then
					v40:shutDown()
				end
			end
		end)

		return v40
	end

	p13.changed:connect(function(p19, p20) -- line: 177
		-- upvalues: LoginStatus (copy), v40 (copy)
		local v49 = if not p19.AuthenticationStatus then LoginStatus.UNKNOWN else p19.AuthenticationStatus.status

		if v49 ~= if not p20.AuthenticationStatus then LoginStatus.UNKNOWN else p20.AuthenticationStatus.status then
			if v49 == LoginStatus.LOGGED_IN then
				v40:startUp()

				return
			end

			if v49 == LoginStatus.LOGGED_OUT then
				v40:shutDown()
			end
		end
	end)

	return v40
end

return t1
