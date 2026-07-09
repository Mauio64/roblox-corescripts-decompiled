local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local createMakeupLook = require(AvatarExperienceCatalog.Api.CreateMakeupLook.createMakeupLook)
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local AvatarExperienceCommon = require(AvatarExperienceCatalogParent.AvatarExperienceCommon)
local AvatarExperienceFlags = require(AvatarExperienceCatalogParent.AvatarExperienceFlags)
local AvatarExperienceAnalytics = require(AvatarExperienceCatalogParent.AvatarExperienceAnalytics)
local PerformFetch = require(AvatarExperienceCatalogParent.Http).PerformFetch
local Promise = require(AvatarExperienceCatalogParent.Promise)
local ToastRodux = require(AvatarExperienceCatalogParent.ToastRodux)
local mutedError = require(AvatarExperienceCatalogParent.Loggers).mutedError
local Constants = AvatarExperienceCommon.Constants
local AVATAR_EDITOR_CONSTANTS = AvatarExperienceCommon.Constants.AVATAR_EDITOR_CONSTANTS
local ToastType = ToastRodux.Enums.ToastType
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local isMakeupOrEyebrowEyelashAssetType = AvatarExperienceCommon.Utils.isMakeupOrEyebrowEyelashAssetType
local Constants2 = AvatarExperienceAnalytics.Constants
local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEventCounterV1 = AvatarExperienceAnalytics.reportAvatarEventCounterV1
local FIntAXLookOutfitCreationDelayMs = AvatarExperienceFlags.FIntAXLookOutfitCreationDelayMs
local FFlagAXMISSaveWearFix = AvatarExperienceFlags.FFlagAXMISSaveWearFix
local t1 = {
	toastMessage = "Feature.Avatar.Message.UnknownErrorCreatingMakeupLook",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

return function(p1, p2, p3, p4: ((...any) -> ...any)?, p5: ((...any) -> ...any)?) -- line: 35
	-- upvalues: PerformFetch (copy), AVATAR_EDITOR_CONSTANTS (copy), FFlagAXMISSaveWearFix (copy), isMakeupOrEyebrowEyelashAssetType (copy), mutedError (copy), Promise (copy), Constants (copy), FIntAXLookOutfitCreationDelayMs (copy), createMakeupLook (copy), reportAvatarEventCounterV1 (copy), Constants2 (copy), SetCurrentToastMessage (copy), t1 (copy), reportAvatarEventCounterNoAnalyticsArgument (copy)
	return PerformFetch.Single(AVATAR_EDITOR_CONSTANTS.CreateMakeupLookKey, function(p6) -- line: 42
		-- upvalues: FFlagAXMISSaveWearFix (copy), p3 (copy), isMakeupOrEyebrowEyelashAssetType (copy), mutedError (copy), Promise (copy), p5 (copy), Constants (copy), p2 (copy), FIntAXLookOutfitCreationDelayMs (copy), createMakeupLook (copy), p1 (copy), p4 (copy), reportAvatarEventCounterV1 (copy), Constants2 (copy), SetCurrentToastMessage (copy), t1 (copy), reportAvatarEventCounterNoAnalyticsArgument (copy)
		local v28 = p6:getState()
		local BodyColor3s = v28.AvatarExperience.AvatarEditor.Character.BodyColor3s
		local AvatarScales = v28.AvatarExperience.AvatarEditor.Character.AvatarScales
		local AvatarType = v28.AvatarExperience.AvatarEditor.Character.AvatarType
		local v32 = if not FFlagAXMISSaveWearFix then nil else v28.AvatarExperience.AvatarEditor.Character.EquippedAssets
		local t2 = {}

		for v34, v35 in BodyColor3s do
			t2[v34] = v35:ToHex()
		end

		local t3 = {}

		for _, v38 in p3 do
			if v38.itemSubType and isMakeupOrEyebrowEyelashAssetType(v38.itemSubType) and v38.selectedInTryOnManager then
				table.insert(t3, {
					id = tonumber(v38.itemId),
					meta = {
						order = v38.order,
						version = tonumber(v38.version)
					}
				})
			end
		end

		if #t3 == 0 then
			mutedError("SaveAsMakeupLookThunk: No valid makeup assets to save")

			return Promise.resolve()
		end

		if FFlagAXMISSaveWearFix and p5 then
			local v39 = p5(v28, p3)
			local t4 = {}

			if v39 then
				for _, child in v39:GetChildren() do
					if child:IsA("MakeupDescription") then
						t4[tostring(child.assetId)] = child.order
					end
				end
			end

			for v43, _ in Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE do
				if v32 and v32[v43] then
					for v45, v46 in v32[v43] do
						if t4[v45] ~= nil then
							table.insert(t3, {
								id = v45,
								meta = {
									order = t4[v45],
									version = tonumber(v46.version)
								}
							})
						end
					end
				end
			end
		end

		local t5 = {
			outfitType = "Makeup",
			name = p2,
			bodyColor3s = t2,
			assets = t3,
			scale = AvatarScales,
			playerAvatarType = AvatarType
		}

		task.spawn(function() -- line: 117
			-- upvalues: FIntAXLookOutfitCreationDelayMs (copy), createMakeupLook (copy), p1 (copy), t5 (copy), p4 (copy), reportAvatarEventCounterV1 (copy), Constants2 (copy), p6 (copy), SetCurrentToastMessage (copy), t1 (copy), reportAvatarEventCounterNoAnalyticsArgument (copy)
			task.wait(FIntAXLookOutfitCreationDelayMs / 1000)

			local v48, _ = createMakeupLook(p1, t5)

			return v48:andThen(function(_) -- line: 122
				-- upvalues: p4 (copy), reportAvatarEventCounterV1 (copy), Constants2 (copy)
				if p4 then
					p4()
				end

				reportAvatarEventCounterV1(Constants2.AVATAR_EVENT_COUNTER_NAME.AXCreateMakeupLook)
			end):catch(function(p8) -- line: 129
				-- upvalues: p6 (copy), SetCurrentToastMessage (copy), t1 (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy)
				warn("Failed to create makeup look", p8)
				p6:dispatch(SetCurrentToastMessage(t1))
				reportAvatarEventCounterNoAnalyticsArgument(Constants2.AVATAR_EDITOR_SERVICE_ERRORS.CreateOutfit)
			end)
		end)

		return Promise.resolve()
	end)
end
