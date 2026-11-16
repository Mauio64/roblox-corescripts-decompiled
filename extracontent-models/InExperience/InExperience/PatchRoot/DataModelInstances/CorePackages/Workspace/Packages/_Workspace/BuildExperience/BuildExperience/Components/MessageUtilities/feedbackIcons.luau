local HttpService = game:GetService("HttpService")

local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local Promise = require(parent.Promise)

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local PlaceVersionHistory = require(parent.DataHydration.PlaceVersionHistory)
require(BuildExperience.Chat.chatTypes)
local FeedbackAction = require(script.Parent.FeedbackAction)
require(script.Parent.UserFeedback)
local GetAgentRollbackRequestStore = require(BuildExperience.Stores.GetAgentRollbackRequestStore)

local IconName = Foundation.Enums.IconName
local Debug = CreatorAgentChat.debug
local defineFastInt = game:DefineFastInt("BuildAgentRollbackNoteTimeoutSeconds", 5)

local function getRollbackTargetVersionNumber(p) -- 2 equivalent calls inferred from this helper
	if p.rollbackTargetVersionNumber ~= nil then
		return p.rollbackTargetVersionNumber
	end

	local publishedVersionNumber = p.publishedVersionNumber

	if publishedVersionNumber == nil or not (publishedVersionNumber > 1) then
		return nil
	end

	return publishedVersionNumber - 1
end

local function formatDebugValue(p)
	if typeof(p) == "table" then
		local success, result = pcall(function()
			return HttpService:JSONEncode(p)
		end)

		if success then
			return result
		end
	end

	return (tostring(p))
end

local function getVersionNumber(placeVersion) -- 1 equivalent call inferred from this helper
	return (tonumber(placeVersion.version))
end

local function findVersionNote(p, p2: number)
	if p == nil or typeof(p.placeVersions) ~= "table" then
		return nil
	end

	for _, placeVersion in p.placeVersions do
		if getVersionNumber(placeVersion) == p2 then -- inferred equivalent call
			return { title = placeVersion.title, description = placeVersion.description }
		end
	end

	return nil
end

local function fetchVersionNote(placeVersionHistoryStore, placeId: number, rollbackTargetVersionNumber: number, nextCursor: string?, p: number)
	if p <= 0 then
		return Promise.resolve(nil)
	end

	return placeVersionHistoryStore.fetchPageHistory(placeId, { cursor = nextCursor }):andThen(function(p2)
		local versionNote = findVersionNote(p2, rollbackTargetVersionNumber)

		if versionNote ~= nil then
			return versionNote
		end

		if p2.nextCursor == nil or p2.nextCursor == "" then
			return nil
		end

		return fetchVersionNote(placeVersionHistoryStore, placeId, rollbackTargetVersionNumber, p2.nextCursor, p - 1)
	end)
end

local FeedbackIcons = {}

function FeedbackIcons.canRevert(p): boolean
	return p.placeId ~= nil and getRollbackTargetVersionNumber(p) ~= nil -- inferred equivalent call
end

FeedbackIcons.getRollbackTargetVersionNumber = getRollbackTargetVersionNumber

function FeedbackIcons.getFeedbackIcons(data)
	local feedbackIcons = {}

	if data ~= nil and data.includeCopy then
		table.insert(feedbackIcons, {
			iconName = data.copyIconName or IconName.TwoStackedSquares,
			action = FeedbackAction.COPY,
			testId = data.copyTestId
		})
	end

	local isRatingDisabled

	if data ~= nil then
		isRatingDisabled = data.isRatingDisabled
	end

	table.insert(feedbackIcons, {
		iconName = IconName.ThumbUp,
		action = FeedbackAction.THUMBS_UP,
		isDisabled = isRatingDisabled
	})

	table.insert(feedbackIcons, {
		iconName = IconName.ThumbDown,
		action = FeedbackAction.THUMBS_DOWN,
		isDisabled = isRatingDisabled
	})

	if data ~= nil and data.includeRevert then
		table.insert(feedbackIcons, {
			iconName = IconName.ArrowCurlToLeft,
			action = FeedbackAction.REVERT,
			isDisabled = data.isRevertDisabled,
			allowRepeatedActivation = true
		})
	end

	return feedbackIcons
end

function FeedbackIcons.requestAgentRollback(feedbackIds)
	local placeId = feedbackIds.placeId
	local rollbackTargetVersionNumber = getRollbackTargetVersionNumber(feedbackIds) -- inferred equivalent call

	if placeId == nil or rollbackTargetVersionNumber == nil then
		Debug.log("warn", "agent feedback revert missing rollback ids", {
			feedbackIds = feedbackIds
		})

		return Promise.reject("agent_rollback_missing_ids")
	end

	local agentRollbackRequestStore = GetAgentRollbackRequestStore(false)
	local v, v2 = agentRollbackRequestStore.beginRequest({
		universeId = feedbackIds.universeId,
		placeId = placeId
	})

	if v ~= nil then
		local placeVersionHistoryStore = PlaceVersionHistory.getPlaceVersionHistoryStore()
		local v3 = 3
		placeVersionHistoryStore.fetchPageHistory(placeId, { cursor = nil }):andThen(function(p)
			local versionNote = findVersionNote(p, rollbackTargetVersionNumber)

			if versionNote ~= nil then
				return versionNote
			end

			if p.nextCursor == nil or p.nextCursor == "" then
				return nil
			end

			return fetchVersionNote(
				placeVersionHistoryStore,
				placeId,
				rollbackTargetVersionNumber,
				p.nextCursor,
				v3 - 1
			)
		end):timeout(defineFastInt):catch(function(rawError): nil
			local log = Debug.log
			local v4 = {
				placeId = placeId,
				restoredVersion = rollbackTargetVersionNumber,
				error = 0,
				rawError = 0
			}
			local result

			if typeof(rawError) == "table" then
				local success
				success, result = pcall(function()
					return HttpService:JSONEncode(rawError)
				end)

				if not success then
					result = tostring(rawError)
				end
			else
				result = tostring(rawError)
			end

			v4.error = result
			v4.rawError = rawError
			log("warn", "agent feedback revert source note load failed", v4)

			return nil
		end):andThen(function(p)
			local setRequestData = agentRollbackRequestStore.setRequestData
			local v4 = {
				versionNumber = rollbackTargetVersionNumber,
				noteTitle = 0,
				noteDescription = 0
			}
			local noteTitle

			if p ~= nil then
				noteTitle = p.title
			end

			v4.noteTitle = noteTitle
			local noteDescription

			if p ~= nil then
				noteDescription = p.description
			end

			v4.noteDescription = noteDescription
			setRequestData(v, v4)
		end):catch(function(rawError)
			local log = Debug.log
			local v4 = {
				placeId = placeId,
				restoredVersion = rollbackTargetVersionNumber,
				error = 0,
				rawError = 0
			}
			local result

			if typeof(rawError) == "table" then
				local success
				success, result = pcall(function()
					return HttpService:JSONEncode(rawError)
				end)

				if not success then
					result = tostring(rawError)
				end
			else
				result = tostring(rawError)
			end

			v4.error = result
			v4.rawError = rawError
			log("warn", "agent feedback revert request preparation failed", v4)

			agentRollbackRequestStore.failRequest(v)
		end)
	end

	return v2:catch(function(rawError)
		local log = Debug.log
		local v3 = {
			placeId = placeId,
			versionToRollback = rollbackTargetVersionNumber,
			error = 0,
			rawError = 0
		}
		local result

		if typeof(rawError) == "table" then
			local success
			success, result = pcall(function()
				return HttpService:JSONEncode(rawError)
			end)

			if not success then
				result = tostring(rawError)
			end
		else
			result = tostring(rawError)
		end

		v3.error = result
		v3.rawError = rawError
		log("warn", "agent feedback revert request failed", v3)

		error(rawError)
	end)
end

return FeedbackIcons
