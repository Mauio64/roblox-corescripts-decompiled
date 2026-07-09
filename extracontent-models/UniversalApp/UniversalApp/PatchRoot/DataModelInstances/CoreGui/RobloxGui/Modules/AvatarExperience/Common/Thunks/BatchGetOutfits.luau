local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local OutfitInfo = require(Modules.AvatarExperience.AvatarEditor.Models.OutfitInfo)
local Utils = require(Modules.AvatarExperience.Common.Utils)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local OutfitInformationReceived = require(Modules.AvatarExperience.Common.Actions.OutfitInformationReceived)

require(Modules.AvatarExperience.Common.Types)
require(Modules.LuaApp.Types.RoduxTypes)

local mutedError = require(Modules.LuaApp.mutedError)
local reportAvatarEventCounterNoAnalyticsArgument = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).reportAvatarEventCounterNoAnalyticsArgument
local Constants = require(Modules.AvatarExperience.Common.Constants)
local GetFFlagEnableAvatarEditorServiceAPIErrorLogging = require(Modules.AvatarExperience.Flags.GetFFlagEnableAvatarEditorServiceAPIErrorLogging)
local v11 = game:DefineFastFlag("AXSilenceCombineGetOutfitDispatchesMutedError2", false)
local v12 = game:DefineFastInt("AXCombineGetOutfitDispatchesChunkSize", 3)
local FFlagAXModeratedItemsFlow = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXModeratedItemsFlow
local FFlagAXEnableModeratedItemsFlowForDurables = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXEnableModeratedItemsFlowForDurables
local WebApi = require(Modules.AvatarExperience.AvatarEditor.Http.WebApi)

local function getShouldRefetchAsset(p1, p2) -- line: 44
	local v23 = p1.AvatarExperience.Common.AssetInfos[p2]

	if v23 and v23.receivedFromOutfitDetails then
		if v23.outfitModerationStatus == Enum.ModerationStatus.NotReviewed then
			return false
		end

		return true
	end

	return false
end
local function getOutfit(p3, p4, p5, p6) -- line: 58
	-- upvalues: Promise (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), WebApi (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), Utils (copy), OutfitInfo (copy)
	local avatarEditorService = p4.avatarEditorService
	local v29 = p3:getState()

	if v29.AvatarExperience.AvatarEditor.OutfitInfos[p5] then
		return Promise.resolve()
	end

	return Promise.new(function(resolve, reject) -- line: 67
		-- upvalues: FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), p6 (copy), avatarEditorService (copy), p5 (copy), WebApi (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), Utils (copy), v29 (copy), OutfitInfo (copy)
		local v43 = FFlagAXModeratedItemsFlow or FFlagAXEnableModeratedItemsFlowForDurables
		local ok, result = pcall(function() -- line: 69
			-- upvalues: v43 (copy), p6 (copy), avatarEditorService (copy), p5 (copy), WebApi (copy), reject (copy)
			if not v43 or not p6 then
				if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
					return avatarEditorService:GetOutfitDetailsAsync(tonumber(p5) or 0)
				end

				return avatarEditorService:GetOutfitDetails(tonumber(p5) or 0)
			end

			local v68, v69 = WebApi.GetOutfit(p6, p5, {
				checkAssetAvailability = true
			}):await()

			if not v68 then
				reject(`AvatarEditorWebApi failure in GetOutfit: { tostring(v69) }`)
			end

			return v69[1]
		end)

		if not ok then
			if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
				reportAvatarEventCounterNoAnalyticsArgument(Constants.Counter.AvatarEditorServiceErrors.GetOutfitDetails)
			end

			return reject(`AvatarEditorService failure in GetOutfitDetails: { tostring(result) }`)
		end

		local v46 = Utils.tableToCamelCaseKeys(result)

		if not v46 then
			return reject("AvatarEditorService returned no data for GetOutfitDetails")
		end

		if not v43 or not p6 then
			v46.bodyColor3s = {}

			if v46.bodyColors then
				for v47, v48 in v46.bodyColors do
					v46.bodyColor3s[`{ v47 }3`] = v48:ToHex()
				end

				v46.bodyColors = nil
			end
		end

		local t1 = {}

		if v46.assets then
			for v50, v51 in v46.assets do
				local v52 = v29.AvatarExperience.Common.AssetInfos[v50]

				if not v52 or (not v52.receivedFromOutfitDetails or v52.outfitModerationStatus == Enum.ModerationStatus.NotReviewed) then
					t1[#t1 + 1] = v51
				end
			end
		end

		local v53 = OutfitInfo.fromWebApi(p5, nil, v46)

		resolve({
			outfitId = p5,
			outfitInfo = v53,
			assetsToUpdate = t1,
			moderationStatus = v53.moderationStatus
		})
	end)
end
local function failureHandler(p7, p8) -- line: 143
	-- upvalues: v11 (copy), mutedError (copy)
	if not v11 then
		mutedError(`[AvatarExperience] Error fetching outfit details for ID { p7 }. Reason: { tostring(p8) }`)
	end

	return nil
end
local function processPromises(p9, p10) -- line: 150
	-- upvalues: Promise (copy), OutfitInformationReceived (copy)
	return Promise.allSettled(p10):andThen(function(p11) -- line: 151
		-- upvalues: Promise (copy), p10 (copy), p9 (copy), OutfitInformationReceived (copy)
		local t2 = {}

		for v56, v57 in p11 do
			if v57 == Promise.Status.Resolved then
				local v58 = p10[v56]:expect()

				if v57 == Promise.Status.Resolved and v58 then
					t2[v58.outfitId] = v58
				end
			end
		end

		if next(t2) then
			p9:dispatch(OutfitInformationReceived(t2))
		end
	end)
end
local function splitTableIntoChunks(p12, p13) -- line: 170
	local t3 = {}

	for i = 1, #p12, p13 do
		local t4 = {}

		table.move(p12, i, math.min(i + p13 - 1, #p12), 1, t4)
		table.insert(t3, t4)
	end

	return t3
end

return function(t5: {[any]: any}, p14) -- line: 180
	-- upvalues: getOutfit (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), v11 (copy), mutedError (copy), splitTableIntoChunks (copy), v12 (copy), Promise (copy), processPromises (copy)
	return function(p15, p16) -- line: 181
		-- upvalues: t5 (copy), getOutfit (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), p14 (copy), v11 (copy), mutedError (copy), splitTableIntoChunks (copy), v12 (copy), Promise (copy), processPromises (copy)
		local t6 = {}

		for _, v63 in t5 do
			table.insert(t6, (getOutfit(p15, p16, v63, (if not FFlagAXModeratedItemsFlow and not FFlagAXEnableModeratedItemsFlowForDurables then nil else p14)):catch(function(p17) -- line: 189
				-- upvalues: v63 (copy), v11 (copy), mutedError (copy)
				local v71 = v63

				if not v11 then
					mutedError(`[AvatarExperience] Error fetching outfit details for ID { v71 }. Reason: { tostring(p17) }`)
				end

				return nil
			end)))
		end

		local v64 = splitTableIntoChunks(t6, v12)
		local v65 = Promise.resolve()

		for _, v67 in v64 do
			v65 = v65:andThen(function() -- line: 200
				-- upvalues: processPromises (copy), p15 (copy), v67 (copy)
				return processPromises(p15, v67)
			end)
		end

		return v65
	end
end
