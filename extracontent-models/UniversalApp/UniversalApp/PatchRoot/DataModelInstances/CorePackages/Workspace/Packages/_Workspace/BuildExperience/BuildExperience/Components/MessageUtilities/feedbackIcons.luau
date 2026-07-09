local HttpService = game:GetService("HttpService")
local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local Promise = require(BuildExperienceParent.Promise)
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local PlaceVersionHistory = require(BuildExperienceParent.DataHydration.PlaceVersionHistory)

require(BuildExperience.Chat.chatTypes)

local FeedbackAction = require(script.Parent.FeedbackAction)

require(script.Parent.UserFeedback)

local rollbackPlaceWithRetry = require(BuildExperience.utils.rollbackPlaceWithRetry)
local sendAgentTurnFeedback = require(script.Parent.sendAgentTurnFeedback)
local IconName = Foundation.Enums.IconName
local debug = CreatorAgentChat.debug

local function getRollbackTargetVersionNumber(p1) -- line: 38
	if p1.rollbackTargetVersionNumber ~= nil then
		return p1.rollbackTargetVersionNumber
	end

	local publishedVersionNumber = p1.publishedVersionNumber

	if publishedVersionNumber ~= nil and publishedVersionNumber > 1 then
		return publishedVersionNumber - 1
	end

	return nil
end
local function formatDebugValue(p2) -- line: 71
	-- upvalues: HttpService (copy)
	if typeof(p2) == "table" then
		local ok, result = pcall(function() -- line: 73
			-- upvalues: HttpService (copy), p2 (copy)
			return HttpService:JSONEncode(p2)
		end)

		if ok then
			return result
		end
	end

	return (tostring(p2))
end
local function getVersionNumber(p3) -- line: 83
	return (tonumber(p3.version))
end
local function findVersionNote(p4, n1: number) -- line: 87
	if p4 == nil or typeof(p4.placeVersions) ~= "table" then
		return nil
	end

	for _, v35 in p4.placeVersions do
		if n1 == tonumber(v35.version) then
			return {
				title = v35.title,
				description = v35.description
			}
		end
	end

	return nil
end
local function fetchVersionNote(p5, n2: number, n3: number, s1: string?) -- line: 104
	-- upvalues: findVersionNote (copy), fetchVersionNote (copy)
	return p5.fetchPageHistory(n2, {
		cursor = s1
	}):andThen(function(p6) -- line: 110
		-- upvalues: findVersionNote (copy), n3 (copy), fetchVersionNote (copy), p5 (copy), n2 (copy)
		local v56 = findVersionNote(p6, n3)

		if v56 ~= nil then
			return v56
		end

		if p6.nextCursor ~= nil and p6.nextCursor ~= "" then
			return fetchVersionNote(p5, n2, n3, p6.nextCursor)
		end

		return nil
	end)
end
local function getVersionNote(p7, n4: number, n5: number) -- line: 122
	-- upvalues: findVersionNote (copy), Promise (copy), fetchVersionNote (copy)
	local v43 = p7.getHistory(n4).data(false)
	local v44 = findVersionNote(v43, n5)

	if v44 ~= nil then
		return Promise.resolve(v44)
	end

	return fetchVersionNote(p7, n4, n5, nil)
end
local function rollbackPublishedVersion(p8, t1: {[any]: any}?) -- line: 132
	-- upvalues: debug (copy), PlaceVersionHistory (copy), getVersionNote (copy), HttpService (copy), rollbackPlaceWithRetry (copy)
	local universeId = p8.universeId
	local placeId = p8.placeId
	local rollbackTargetVersionNumber

	if p8.rollbackTargetVersionNumber ~= nil then
		rollbackTargetVersionNumber = p8.rollbackTargetVersionNumber
	else
		local publishedVersionNumber = p8.publishedVersionNumber

		rollbackTargetVersionNumber = if publishedVersionNumber == nil or not (publishedVersionNumber > 1) then nil else publishedVersionNumber - 1
	end

	local v51 = rollbackTargetVersionNumber

	if placeId == nil or v51 == nil then
		debug.log("warn", "agent feedback revert missing rollback ids", {
			feedbackIds = p8
		})

		if t1 ~= nil and t1.onRevertFailure ~= nil then
			t1.onRevertFailure()
		end

		return
	end

	if t1 ~= nil and t1.onRevertStart ~= nil then
		t1.onRevertStart()
	end

	local v52 = PlaceVersionHistory.getPlaceVersionHistoryStore()

	getVersionNote(v52, placeId, v51):catch(function(p9) -- line: 152
		-- upvalues: debug (copy), placeId (copy), v51 (copy), HttpService (copy)
		local log = debug.log
		local t2 = {
			placeId = placeId,
			restoredVersion = v51
		}
		local g62 = nil
		local result = nil

		if typeof(p9) == "table" then
			local ok

			ok, result = pcall(function() -- line: 73
				-- upvalues: HttpService (copy), p9 (copy)
				return HttpService:JSONEncode(p9)
			end)

			if ok then
				g62 = true
			end
		end

		if not g62 then
			result = tostring(p9)
		end

		g62 = false
		t2.error = result
		t2.rawError = p9
		log("warn", "agent feedback revert source note load failed", t2)

		return nil
	end):andThen(function(p10) -- line: 161
		-- upvalues: debug (copy), placeId (copy), v51 (copy), rollbackPlaceWithRetry (copy)
		if p10 == nil then
			debug.log("info", "agent feedback revert note copy skipped", {
				reason = "source_notes_not_found",
				placeId = placeId,
				restoredVersion = v51
			})
		end

		return rollbackPlaceWithRetry(placeId, v51, {
			debugSource = "agent feedback revert",
			note = p10
		})
	end):andThen(function() -- line: 175
		-- upvalues: t1 (copy)
		if t1 ~= nil and t1.onRevertSuccess ~= nil then
			t1.onRevertSuccess()
		end
	end):catch(function(p11) -- line: 180
		-- upvalues: HttpService (copy), debug (copy), universeId (copy), placeId (copy), v51 (copy), t1 (copy)
		local g67 = nil
		local result = nil

		if typeof(p11) == "table" then
			local ok

			ok, result = pcall(function() -- line: 73
				-- upvalues: HttpService (copy), p11 (copy)
				return HttpService:JSONEncode(p11)
			end)

			if ok then
				g67 = true
			end
		end

		if not g67 then
			result = tostring(p11)
		end

		g67 = false
		debug.log("warn", "agent feedback revert rollback failed", {
			universeId = universeId,
			placeId = placeId,
			versionToRollback = v51,
			error = result,
			rawError = p11
		})
		warn(`[BuildExperience] agent feedback revert rollback failed: { result }`)

		if t1 ~= nil and t1.onRevertFailure ~= nil then
			t1.onRevertFailure()
		end
	end)
end

return {
	canRevert = function(p12) -- line: 51
		local v23 = false

		if p12.placeId ~= nil then
			local rollbackTargetVersionNumber

			if p12.rollbackTargetVersionNumber ~= nil then
				rollbackTargetVersionNumber = p12.rollbackTargetVersionNumber
			else
				local publishedVersionNumber = p12.publishedVersionNumber

				rollbackTargetVersionNumber = if publishedVersionNumber == nil or not (publishedVersionNumber > 1) then nil else publishedVersionNumber - 1
			end

			v23 = rollbackTargetVersionNumber ~= nil
		end

		return v23
	end,
	getFeedbackIcons = function(t3: {[any]: any}?) -- line: 55
		-- upvalues: IconName (copy), FeedbackAction (copy)
		local t4 = {
			{
				iconName = IconName.ThumbUp,
				action = FeedbackAction.THUMBS_UP
			},
			{
				iconName = IconName.ThumbDown,
				action = FeedbackAction.THUMBS_DOWN
			}
		}

		if t3 ~= nil and t3.includeRevert then
			table.insert(t4, {
				allowRepeatedActivation = true,
				iconName = IconName.ArrowCurlToLeft,
				action = FeedbackAction.REVERT,
				isDisabled = t3.isRevertDisabled
			})
		end

		return t4
	end,
	createOnActivated = function(p13, t5: {[any]: any}?) -- line: 196
		-- upvalues: sendAgentTurnFeedback (copy), FeedbackAction (copy), rollbackPublishedVersion (copy)
		return function(p14) -- line: 200
			-- upvalues: sendAgentTurnFeedback (copy), p13 (copy), FeedbackAction (copy), rollbackPublishedVersion (copy), t5 (copy)
			if p14.isDisabled == true then
				return
			end

			sendAgentTurnFeedback(p14.action, p13)

			if p14.action == FeedbackAction.REVERT then
				rollbackPublishedVersion(p13, t5)
			end
		end
	end
}
