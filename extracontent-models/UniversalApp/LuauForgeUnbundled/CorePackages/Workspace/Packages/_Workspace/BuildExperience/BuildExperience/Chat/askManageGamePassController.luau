local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local GamePassConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/GamePassConfig")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Promise")

local fFlagBuildExperienceManageMonetizationTool = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceManageMonetizationTool

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/localToolOverlay")
local createManageGamePassStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/createManageGamePassStore")
local createMonetizationToolController = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/createMonetizationToolController")
local toolControllerUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/toolControllerUtils")

local store = nil

local function getStore()
	if store == nil then
		store = createManageGamePassStore()
	end

	return store
end

local v5 = {
	tool = 0,
	itemKind = "gamePass",
	resultKey = "gamePass",
	list = 0,
	mutate = 0,
	itemIdOf = 0,
	cardFields = 0
}

local v6 = if fFlagBuildExperienceManageMonetizationTool then CreatorAgentChat.StudioManageMonetizationTool.forKind("gamePass") else CreatorAgentChat.StudioManageGamePassTool
v5.tool = v6

function v5.list(p2)
	if store == nil then
		store = createManageGamePassStore()
	end

	return store.list(p2):andThen(function(data)
		return {
			count = #data.gamePasses,
			gamePasses = data.gamePasses,
			nextPageToken = data.nextPageToken,
			truncated = data.isIncomplete == true
		}
	end, function(data)
		if typeof(data) == "table" and data.code == GamePassConfig.INCOMPLETE_LIST_CODE then
			return {
				count = #data.gamePasses,
				gamePasses = data.gamePasses,
				nextPageToken = data.nextPageToken,
				truncated = true,
				truncatedReason = data.message
			}
		end

		return Promise.reject(data)
	end)
end

function v5.mutate(p2, data)
	if data.action == "create" then
		return toolControllerUtils.withGeneratedImage(
			data.imageAssetId,
			"The pass image could not be loaded. No game pass was created.",
			function(p3)
				if store == nil then
					store = createManageGamePassStore()
				end

				return store.create(p2, {
					name = data.name,
					description = data.description,
					priceInRobux = data.priceInRobux,
					isForSale = false,
					imageFile = p3
				})
			end
		)
	end

	if data.action == "update" then
		return toolControllerUtils.withGeneratedImage(
			data.imageAssetId,
			"The pass image could not be loaded. No changes were made.",
			function(p3)
				if store == nil then
					store = createManageGamePassStore()
				end

				return store.update(p2, data.gamePassId, {
					name = data.name,
					description = data.description,
					priceInRobux = data.priceInRobux,
					imageFile = p3
				})
			end
		)
	end

	if data.action == "activate" then
		if store == nil then
			store = createManageGamePassStore()
		end

		return store.activate(p2, data.gamePassId)
	end

	if data.action ~= "deactivate" then
		return Promise.reject({
			errorMessage = ("Unsupported action '%s'."):format((tostring(data.action)))
		})
	end

	if store == nil then
		store = createManageGamePassStore()
	end

	return store.deactivate(p2, data.gamePassId)
end

function v5.itemIdOf(p2)
	if p2.gamePassId == nil then
		return nil
	end

	return (tostring(p2.gamePassId))
end

function v5.cardFields(p2)
	return { imageAssetId = p2.imageAssetId }
end

return function(p2, p3, p4, p5)
	return createMonetizationToolController(v5, p2, p3, p4, p5)
end
