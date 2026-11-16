local parent = script:FindFirstAncestor("BuildExperience").Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local GamePassConfig = require(parent.DataHydration.GamePassConfig)
local Promise = require(parent.Promise)

local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceManageMonetizationTool = SharedFlags.FFlagBuildExperienceManageMonetizationTool

require(script.Parent.chatTypes)
require(script.Parent.localToolOverlay)
local createManageGamePassStore = require(script.Parent.createManageGamePassStore)
local createMonetizationToolController = require(script.Parent.createMonetizationToolController)
local toolControllerUtils = require(script.Parent.toolControllerUtils)

local store = nil

local function getStore() -- 5 equivalent calls inferred from this helper
	if store == nil then
		store = createManageGamePassStore()
	end

	return store
end

local v = {
	tool = 0,
	itemKind = "gamePass",
	resultKey = "gamePass",
	list = 0,
	mutate = 0,
	itemIdOf = 0,
	cardFields = 0
}
local tool

if FFlagBuildExperienceManageMonetizationTool then
	tool = CreatorAgentChat.StudioManageMonetizationTool.forKind("gamePass")
else
	tool = CreatorAgentChat.StudioManageGamePassTool
end

v.tool = tool

function v.list(p: number)
	return getStore().list(p):andThen(function(data) -- inferred equivalent call
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

function v.mutate(p: number, data)
	if data.action == "create" then
		return toolControllerUtils.withGeneratedImage(
			data.imageAssetId,
			"The pass image could not be loaded. No game pass was created.",
			function(imageFile)
				return getStore().create(p, { -- inferred equivalent call
					name = data.name,
					description = data.description,
					priceInRobux = data.priceInRobux,
					isForSale = false,
					imageFile = imageFile
				})
			end
		)
	end

	if data.action == "update" then
		return toolControllerUtils.withGeneratedImage(
			data.imageAssetId,
			"The pass image could not be loaded. No changes were made.",
			function(imageFile)
				return getStore().update(p, data.gamePassId, { -- inferred equivalent call
					name = data.name,
					description = data.description,
					priceInRobux = data.priceInRobux,
					imageFile = imageFile
				})
			end
		)
	end

	if data.action == "activate" then
		return getStore().activate(p, data.gamePassId) -- inferred equivalent call
	end

	if data.action ~= "deactivate" then
		return Promise.reject({
			errorMessage = ("Unsupported action '%s'."):format((tostring(data.action)))
		})
	end

	return getStore().deactivate(p, data.gamePassId) -- inferred equivalent call
end

function v.itemIdOf(p)
	if p.gamePassId == nil then
		return nil
	end

	return (tostring(p.gamePassId))
end

function v.cardFields(p)
	return { imageAssetId = p.imageAssetId }
end

return function(p, p2, p3, p4)
	return createMonetizationToolController(v, p, p2, p3, p4)
end
