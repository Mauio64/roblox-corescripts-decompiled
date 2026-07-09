local Modules = game:GetService("CoreGui").RobloxGui.Modules
local LocalizationService = game:GetService("LocalizationService")
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local UpdateLookDetails = require(Modules.AvatarExperience.Common.Actions.UpdateLookDetails)
local WebApi = require(Modules.AvatarExperience.AvatarEditor.Http.WebApi)

require(Modules.AvatarExperience.Common.Types)

local AvatarWidgetBlockyUtils = require(Modules.AvatarExperience.Common.Util.AvatarWidgetBlockyUtils)
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2
local Localization = require(CorePackages.Workspace.Packages.RobloxAppLocales).Localization
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local RemoveLook = require(Modules.AvatarExperience.Common.Actions.RemoveLook)
local v18 = game:DefineFastFlag("AXLookPreviewWarningToasts", false)
local FFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse

local function translateString(s1: string, t1: {[any]: any}?) -- line: 33
	-- upvalues: LocalizationService (copy), Localization (copy)
	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local v24 = Localization.new(RobloxLocaleId)

	v24:SetLocale(RobloxLocaleId)

	return v24:Format(s1, t1)
end

return function(p1) -- line: 41
	-- upvalues: PerformFetch (copy), FFlagParseHeadShapeFromAPIResponse (copy), RemoveLook (copy), Constants (copy), WebApi (copy), v18 (copy), SetCurrentToastMessage (copy), ToastType (copy), CatalogConstants (copy), Constants2 (copy), AvatarWidgetBlockyUtils (copy), translateString (copy), UpdateLookDetails (copy), HttpService (copy), sendAXCounterV2 (copy)
	return PerformFetch.Single("PreviewLook", function(p2) -- line: 42
		-- upvalues: FFlagParseHeadShapeFromAPIResponse (copy), RemoveLook (copy), Constants (copy), WebApi (copy), p1 (copy), v18 (copy), SetCurrentToastMessage (copy), ToastType (copy), CatalogConstants (copy), Constants2 (copy), AvatarWidgetBlockyUtils (copy), translateString (copy), UpdateLookDetails (copy), HttpService (copy), sendAXCounterV2 (copy)
		local v27 = p2:getState()
		local EquippedAssets = v27.AvatarExperience.AvatarEditor.Character.EquippedAssets
		local BodyColor3s = v27.AvatarExperience.AvatarEditor.Character.BodyColor3s
		local AvatarScales = v27.AvatarExperience.AvatarEditor.Character.AvatarScales
		local t2 = {}

		for _, v33 in EquippedAssets do
			for v34, v35 in v33 do
				local t3 = {
					id = v34
				}

				if v35.isLayered or FFlagParseHeadShapeFromAPIResponse and v35.headShape ~= nil then
					t3.meta = {
						order = v35.order,
						version = tonumber(v35.version)
					}

					if FFlagParseHeadShapeFromAPIResponse then
						t3.meta.headShape = v35.headShape
					end
				end

				table.insert(t2, t3)
			end
		end

		p2:dispatch(RemoveLook(Constants.DraftLookId))

		return WebApi.GetPreviewLook(p1, t2):andThen(function(p3) -- line: 66
			-- upvalues: v18 (copy), p2 (copy), SetCurrentToastMessage (copy), ToastType (copy), v27 (copy), Constants (copy), CatalogConstants (copy), Constants2 (copy), AvatarScales (copy), AvatarWidgetBlockyUtils (copy), translateString (copy), BodyColor3s (copy), UpdateLookDetails (copy)
			if v18 then
				local v38 = p3 and (p3.responseBody and p3.responseBody.warnings)

				if v38 then
					for _, v40 in v38 do
						p2:dispatch(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v40.errorDescription,
							toastType = ToastType.InformationMessage
						}))
					end
				end
			end

			local v41 = if not p3 or not p3.responseBody then nil else p3.responseBody.look

			if not v41 then
				return
			end

			local LocalUserId = v27.LocalUserId
			local v43 = v27.Users[LocalUserId]
			local t4 = {
				lookType = Constants.LookType.Avatar,
				totalValue = v41.totalValue,
				totalPrice = v41.totalPrice,
				curator = if not v43 then nil else {
					type = CatalogConstants.CreatorType.User,
					id = tonumber(LocalUserId),
					name = v43.displayName,
					hasVerifiedBadge = v43.hasVerifiedBadge
				},
				lookAssetInfos = {},
				lookBundleInfos = {},
				avatarProperties = {
					bodyColor3s = {},
					playerAvatarType = Constants2.AvatarType.R15,
					scale = AvatarScales
				},
				displayProperties = {
					backgroundType = "None"
				}
			}
			local t5 = {}

			for _, v47 in v41.items do
				if v47.itemType == Constants.ItemType.Asset then
					v47.id = tostring(v47.id)
					t4.lookAssetInfos[v47.id] = v47
				elseif v47.itemType == Constants.ItemType.Bundle then
					v47.id = tostring(v47.id)
					t4.lookBundleInfos[v47.id] = v47

					if t5 then
						table.insert(t5, v47)
					end
				end
			end

			if t5 then
				local v48 = AvatarWidgetBlockyUtils.buildBlockyLookDetailItem(t5, translateString)

				if v48 ~= nil then
					t4.lookBundleInfos[v48.id] = v48
				end
			end

			for v49, v50 in BodyColor3s do
				t4.avatarProperties.bodyColor3s[v49] = v50:ToHex()
			end

			p2:dispatch(UpdateLookDetails(Constants.DraftLookId, t4))

			return true
		end):catch(function(p4) -- line: 144
			-- upvalues: HttpService (copy), p2 (copy), SetCurrentToastMessage (copy), ToastType (copy), sendAXCounterV2 (copy), Constants (copy), Constants2 (copy)
			warn("Failed to create draft look", p4)

			local ok, result = pcall(function() -- line: 146
				-- upvalues: p4 (copy), HttpService (copy)
				return p4.Body and (p4.Body ~= "" and HttpService:JSONDecode(p4.Body))
			end)

			if ok and (result and result.errorDescription) then
				p2:dispatch(SetCurrentToastMessage({
					isLocalized = true,
					toastMessage = result.errorDescription,
					toastType = ToastType.InformationMessage
				}))
				sendAXCounterV2(Constants.Counter.LookComposer.PreviewLook, {
					errorCode = result.errorCode
				})
			elseif ok and result and result.errorCode then
				sendAXCounterV2(Constants.Counter.LookComposer.PreviewLook, {
					errorCode = result.errorCode
				})
				p2:dispatch(SetCurrentToastMessage({
					isLocalized = false,
					toastMessage = Constants2.AvatarShareErrorMessagesKeys[result.errorCode] or "Feature.Avatar.Generic.Error",
					toastType = ToastType.InformationMessage
				}))
			else
				sendAXCounterV2(Constants.Counter.LookComposer.PreviewLook, {
					errorCode = "none"
				})
			end

			return false
		end)
	end)
end
