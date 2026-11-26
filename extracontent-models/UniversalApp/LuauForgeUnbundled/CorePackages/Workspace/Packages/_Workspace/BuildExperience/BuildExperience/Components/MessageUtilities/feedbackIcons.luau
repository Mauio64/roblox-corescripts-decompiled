local HttpService = game:GetService("HttpService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Promise")

local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local PlaceVersionHistory = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/PlaceVersionHistory")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local FeedbackAction = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MessageUtilities/FeedbackAction")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MessageUtilities/UserFeedback")
local GetAgentRollbackRequestStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAgentRollbackRequestStore")

local iconName = Foundation.Enums.IconName
local Debug = CreatorAgentChat.debug
local defineFastInt = game:DefineFastInt("BuildAgentRollbackNoteTimeoutSeconds", 5)

local function formatDebugValue(p2)
	if typeof(p2) == "table" then
		local success, result = pcall(function()
			return HttpService:JSONEncode(p2)
		end)

		if success then
			return result
		end
	end

	return (tostring(p2))
end

local function getVersionNumber(p2)
	return (tonumber(p2.version))
end

local function findVersionNote(p2, p3)
	if p2 == nil or typeof(p2.placeVersions) ~= "table" then
		return nil
	end

	for k, placeVersion in p2.placeVersions do
		if tonumber(placeVersion.version) == p3 then
			return {
				title = placeVersion.title,
				description = placeVersion.description
			}
		end
	end

	return nil
end

local function fetchVersionNote(placeVersionHistoryStore, placeId, p2, nextCursor, p3)
	if p3 <= 0 then
		return Promise.resolve(nil)
	end

	return placeVersionHistoryStore.fetchPageHistory(placeId, { cursor = nextCursor }):andThen(function(p4)
		local versionNote = findVersionNote(p4, p2)

		if versionNote ~= nil then
			return versionNote
		end

		if p4.nextCursor == nil or p4.nextCursor == "" then
			return nil
		end

		return fetchVersionNote(placeVersionHistoryStore, placeId, p2, p4.nextCursor, p3 - 1)
	end)
end

return {
	canRevert = function(data)
		local v5

		if data.placeId == nil then
			v5 = false
		else
			local v6

			if data.rollbackTargetVersionNumber == nil then
				local publishedVersionNumber = data.publishedVersionNumber

				if not (publishedVersionNumber == nil or not (publishedVersionNumber > 1)) then
					v6 = publishedVersionNumber - 1
				end
			else
				v6 = data.rollbackTargetVersionNumber
			end

			v5 = v6 ~= nil
		end

		return v5
	end,
	getRollbackTargetVersionNumber = function(p2)
		if p2.rollbackTargetVersionNumber ~= nil then
			return p2.rollbackTargetVersionNumber
		end

		local publishedVersionNumber = p2.publishedVersionNumber

		if publishedVersionNumber == nil or not (publishedVersionNumber > 1) then
			return nil
		end

		return publishedVersionNumber - 1
	end,
	getFeedbackIcons = function(data)
		local feedbackIcons = {}

		if data ~= nil and data.includeCopy then
			table.insert(feedbackIcons, {
				iconName = data.copyIconName or iconName.TwoStackedSquares,
				action = FeedbackAction.COPY,
				testId = data.copyTestId
			})
		end

		local isRatingDisabled = if data ~= nil then data.isRatingDisabled else nil
		table.insert(feedbackIcons, {
			iconName = iconName.ThumbUp,
			action = FeedbackAction.THUMBS_UP,
			isDisabled = isRatingDisabled
		})

		table.insert(feedbackIcons, {
			iconName = iconName.ThumbDown,
			action = FeedbackAction.THUMBS_DOWN,
			isDisabled = isRatingDisabled
		})

		if data ~= nil and data.includeRevert then
			table.insert(feedbackIcons, {
				iconName = iconName.ArrowCurlToLeft,
				action = FeedbackAction.REVERT,
				isDisabled = data.isRevertDisabled,
				allowRepeatedActivation = true
			})
		end

		return feedbackIcons
	end,
	requestAgentRollback = function(data)
		local placeId = data.placeId
		local v5

		if data.rollbackTargetVersionNumber == nil then
			local publishedVersionNumber = data.publishedVersionNumber

			if publishedVersionNumber == nil or not (publishedVersionNumber > 1) then
				v5 = nil
			else
				v5 = publishedVersionNumber - 1
			end
		else
			v5 = data.rollbackTargetVersionNumber
		end

		if placeId == nil or v5 == nil then
			Debug.log("warn", "agent feedback revert missing rollback ids", {
				feedbackIds = data
			})

			return Promise.reject("agent_rollback_missing_ids")
		end

		local v6 = GetAgentRollbackRequestStore(false)
		local v7, v8 = v6.beginRequest({
			universeId = data.universeId,
			placeId = placeId
		})

		if v7 ~= nil then
			local placeVersionHistoryStore = PlaceVersionHistory.getPlaceVersionHistoryStore()
			local v9 = 3
			placeVersionHistoryStore.fetchPageHistory(placeId, { cursor = nil }):andThen(function(p2)
				local versionNote = findVersionNote(p2, v5)

				if versionNote ~= nil then
					return versionNote
				end

				if p2.nextCursor == nil or p2.nextCursor == "" then
					return nil
				end

				return fetchVersionNote(placeVersionHistoryStore, placeId, v5, p2.nextCursor, v9 - 1)
			end):timeout(defineFastInt):catch(function(rawError): nil
				local log = Debug.log
				local v12 = {
					placeId = placeId,
					restoredVersion = v5,
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

				v12.error = result
				v12.rawError = rawError
				log("warn", "agent feedback revert source note load failed", v12)

				return nil
			end):andThen(function(p2)
				local setRequestData = v6.setRequestData
				local v11 = { versionNumber = v5, noteTitle = 0, noteDescription = 0 }

				local v12 = if p2 ~= nil then p2.title else nil
				v11.noteTitle = v12
				local v13 = if p2 ~= nil then p2.description else nil
				v11.noteDescription = v13
				setRequestData(v7, v11)
			end):catch(function(rawError)
				local log = Debug.log
				local v12 = {
					placeId = placeId,
					restoredVersion = v5,
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

				v12.error = result
				v12.rawError = rawError
				log("warn", "agent feedback revert request preparation failed", v12)

				v6.failRequest(v7)
			end)
		end

		return v8:catch(function(rawError)
			local log = Debug.log
			local v11 = {
				placeId = placeId,
				versionToRollback = v5,
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

			v11.error = result
			v11.rawError = rawError
			log("warn", "agent feedback revert request failed", v11)

			error(rawError)
		end)
	end
}
