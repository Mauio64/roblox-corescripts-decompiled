local HttpService = game:GetService("HttpService")
local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local Promise = require(BuildExperienceParent.Promise)
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local PlaceVersionHistory = require(BuildExperienceParent.DataHydration.PlaceVersionHistory)

require(BuildExperience.Chat.chatTypes)

local FFlagisPublishOnBuildRevert = require(BuildExperience.Flags.FFlagisPublishOnBuildRevert)
local FeedbackAction = require(script.Parent.FeedbackAction)

require(script.Parent.UserFeedback)

local rollbackPlaceWithRetry = require(BuildExperience.utils.rollbackPlaceWithRetry)
local IconName = Foundation.Enums.IconName
local debug = CreatorAgentChat.debug

local function formatDebugValue(p1) -- line: 71
	-- upvalues: HttpService (copy)
	if typeof(p1) == "table" then
		local ok, result = pcall(function() -- line: 73
			-- upvalues: HttpService (copy), p1 (copy)
			return HttpService:JSONEncode(p1)
		end)

		if ok then
			return result
		end
	end

	return (tostring(p1))
end
local function getVersionNumber(p2) -- line: 83
	return (tonumber(p2.version))
end
local function findVersionNote(p3, n1: number) -- line: 87
	if p3 == nil or typeof(p3.placeVersions) ~= "table" then
		return nil
	end

	for _, v33 in p3.placeVersions do
		if n1 == tonumber(v33.version) then
			return {
				title = v33.title,
				description = v33.description
			}
		end
	end

	return nil
end
local function fetchVersionNote(p4, n2: number, n3: number, s1: string?) -- line: 104
	-- upvalues: findVersionNote (copy), fetchVersionNote (copy)
	return p4.fetchPageHistory(n2, {
		cursor = s1
	}):andThen(function(p5) -- line: 110
		-- upvalues: findVersionNote (copy), n3 (copy), fetchVersionNote (copy), p4 (copy), n2 (copy)
		local v52 = findVersionNote(p5, n3)

		if v52 ~= nil then
			return v52
		end

		if p5.nextCursor ~= nil and p5.nextCursor ~= "" then
			return fetchVersionNote(p4, n2, n3, p5.nextCursor)
		end

		return nil
	end)
end
local function getVersionNote(p6, n4: number, n5: number) -- line: 122
	-- upvalues: findVersionNote (copy), Promise (copy), fetchVersionNote (copy)
	local v41 = p6.getHistory(n4).data(false)
	local v42 = findVersionNote(v41, n5)

	if v42 ~= nil then
		return Promise.resolve(v42)
	end

	return fetchVersionNote(p6, n4, n5, nil)
end

return {
	canRevert = function(p7) -- line: 51
		local v21 = false

		if p7.placeId ~= nil then
			local rollbackTargetVersionNumber

			if p7.rollbackTargetVersionNumber ~= nil then
				rollbackTargetVersionNumber = p7.rollbackTargetVersionNumber
			else
				local publishedVersionNumber = p7.publishedVersionNumber

				rollbackTargetVersionNumber = if publishedVersionNumber == nil or not (publishedVersionNumber > 1) then nil else publishedVersionNumber - 1
			end

			v21 = rollbackTargetVersionNumber ~= nil
		end

		return v21
	end,
	getRollbackTargetVersionNumber = function(p8) -- line: 38
		if p8.rollbackTargetVersionNumber ~= nil then
			return p8.rollbackTargetVersionNumber
		end

		local publishedVersionNumber = p8.publishedVersionNumber

		if publishedVersionNumber ~= nil and publishedVersionNumber > 1 then
			return publishedVersionNumber - 1
		end

		return nil
	end,
	getFeedbackIcons = function(t1: {[any]: any}?) -- line: 55
		-- upvalues: IconName (copy), FeedbackAction (copy)
		local t2 = {
			{
				iconName = IconName.ThumbUp,
				action = FeedbackAction.THUMBS_UP
			},
			{
				iconName = IconName.ThumbDown,
				action = FeedbackAction.THUMBS_DOWN
			}
		}

		if t1 ~= nil and t1.includeRevert then
			table.insert(t2, {
				allowRepeatedActivation = true,
				iconName = IconName.ArrowCurlToLeft,
				action = FeedbackAction.REVERT,
				isDisabled = t1.isRevertDisabled
			})
		end

		return t2
	end,
	rollbackPublishedVersion = function(p9, t3: {[any]: any}?) -- line: 132
		-- upvalues: debug (copy), PlaceVersionHistory (copy), getVersionNote (copy), HttpService (copy), rollbackPlaceWithRetry (copy), FFlagisPublishOnBuildRevert (copy)
		local universeId = p9.universeId
		local placeId = p9.placeId
		local rollbackTargetVersionNumber

		if p9.rollbackTargetVersionNumber ~= nil then
			rollbackTargetVersionNumber = p9.rollbackTargetVersionNumber
		else
			local publishedVersionNumber = p9.publishedVersionNumber

			rollbackTargetVersionNumber = if publishedVersionNumber == nil or not (publishedVersionNumber > 1) then nil else publishedVersionNumber - 1
		end

		local v49 = rollbackTargetVersionNumber

		if placeId == nil or v49 == nil then
			debug.log("warn", "agent feedback revert missing rollback ids", {
				feedbackIds = p9
			})

			if t3 ~= nil and t3.onRevertFailure ~= nil then
				t3.onRevertFailure()
			end

			return
		end

		if t3 ~= nil and t3.onRevertStart ~= nil then
			t3.onRevertStart()
		end

		local v50 = PlaceVersionHistory.getPlaceVersionHistoryStore()

		getVersionNote(v50, placeId, v49):catch(function(p10) -- line: 152
			-- upvalues: debug (copy), placeId (copy), v49 (copy), HttpService (copy)
			local log = debug.log
			local t4 = {
				placeId = placeId,
				restoredVersion = v49
			}
			local g58 = nil
			local result = nil

			if typeof(p10) == "table" then
				local ok

				ok, result = pcall(function() -- line: 73
					-- upvalues: HttpService (copy), p10 (copy)
					return HttpService:JSONEncode(p10)
				end)

				if ok then
					g58 = true
				end
			end

			if not g58 then
				result = tostring(p10)
			end

			g58 = false
			t4.error = result
			t4.rawError = p10
			log("warn", "agent feedback revert source note load failed", t4)

			return nil
		end):andThen(function(p11) -- line: 161
			-- upvalues: debug (copy), placeId (copy), v49 (copy), rollbackPlaceWithRetry (copy), FFlagisPublishOnBuildRevert (copy)
			if p11 == nil then
				debug.log("info", "agent feedback revert note copy skipped", {
					reason = "source_notes_not_found",
					placeId = placeId,
					restoredVersion = v49
				})
			end

			return rollbackPlaceWithRetry(placeId, v49, {
				debugSource = "agent feedback revert",
				note = p11,
				published = FFlagisPublishOnBuildRevert
			})
		end):andThen(function() -- line: 176
			-- upvalues: t3 (copy)
			if t3 ~= nil and t3.onRevertSuccess ~= nil then
				t3.onRevertSuccess()
			end
		end):catch(function(p12) -- line: 181
			-- upvalues: HttpService (copy), debug (copy), universeId (copy), placeId (copy), v49 (copy), t3 (copy)
			local g63 = nil
			local result = nil

			if typeof(p12) == "table" then
				local ok

				ok, result = pcall(function() -- line: 73
					-- upvalues: HttpService (copy), p12 (copy)
					return HttpService:JSONEncode(p12)
				end)

				if ok then
					g63 = true
				end
			end

			if not g63 then
				result = tostring(p12)
			end

			g63 = false
			debug.log("warn", "agent feedback revert rollback failed", {
				universeId = universeId,
				placeId = placeId,
				versionToRollback = v49,
				error = result,
				rawError = p12
			})
			warn(`[BuildExperience] agent feedback revert rollback failed: { result }`)

			if t3 ~= nil and t3.onRevertFailure ~= nil then
				t3.onRevertFailure()
			end
		end)
	end
}
