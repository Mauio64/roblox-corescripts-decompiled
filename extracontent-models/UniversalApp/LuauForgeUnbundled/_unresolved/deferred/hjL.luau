local LocalizationService = game:GetService("LocalizationService")

local HttpService = game:GetService("HttpService")

local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local module = require("@luauforge/bundled/dPN")
local module2 = require("@luauforge/bundled/dRg")
local module3 = require("@luauforge/bundled/dPU")
local module4 = require("@luauforge/bundled/dPv")
local module5 = require("@luauforge/bundled/fDG")
require("@luauforge/bundled/dPs")
local module6 = require("@luauforge/bundled/gKU")
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXCounterV2
local localization = require("@game/CorePackages/Workspace/Packages/RobloxAppLocales").Localization
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module8 = require("@luauforge/bundled/dKU")

local module9 = require("@luauforge/bundled/dFm")
local module10 = require("@luauforge/bundled/dzE")
local removeLook = module8.Actions.RemoveLook
local defineFastFlag = game:DefineFastFlag("AXLookPreviewWarningToasts", false)
local fFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse

local function translateString(p2, p3)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v5 = localization.new(robloxLocaleId)
	v5:SetLocale(robloxLocaleId)

	return v5:Format(p2, p3)
end

return function(p2)
	return performFetch.Single("PreviewLook", function(object)
		local state = object:getState()
		local equippedAssets = state.AvatarExperience.AvatarEditor.Character.EquippedAssets
		local bodyColor3s = state.AvatarExperience.AvatarEditor.Character.BodyColor3s
		local avatarScales = state.AvatarExperience.AvatarEditor.Character.AvatarScales

		local v5 = {}

		for k, equippedAsset in equippedAssets do
			for k2, v6 in equippedAsset do
				local v7 = { id = k2 }

				if v6.isLayered or fFlagParseHeadShapeFromAPIResponse and v6.headShape ~= nil then
					v7.meta = { order = v6.order, version = tonumber(v6.version) }

					if fFlagParseHeadShapeFromAPIResponse then
						v7.meta.headShape = v6.headShape
					end
				end

				table.insert(v5, v7)
			end
		end

		object:dispatch(removeLook(module.DraftLookId))

		return module5.GetPreviewLook(p2, v5):andThen(function(p3)
			if defineFastFlag then
				local warnings = p3 and p3.responseBody and p3.responseBody.warnings

				if warnings then
					for k, warning in warnings do
						object:dispatch(module9({
							toastMessage = warning.errorDescription,
							isLocalized = true,
							toastType = module10.InformationMessage
						}))
					end
				end
			end

			local look = if p3 and p3.responseBody then p3.responseBody.look else nil

			if not look then
				return
			end

			local localUserId = state.LocalUserId
			local user = state.Users[localUserId]

			local v6 = {
				lookType = module.LookType.Avatar,
				totalValue = look.totalValue,
				totalPrice = look.totalPrice,
				curator = user and {
					type = module3.CreatorType.User,
					id = tonumber(localUserId),
					name = user.displayName,
					hasVerifiedBadge = user.hasVerifiedBadge
				} or nil,
				lookAssetInfos = {},
				lookBundleInfos = {},
				avatarProperties = {
					bodyColor3s = {},
					playerAvatarType = module2.AvatarType.R15,
					scale = avatarScales
				},
				displayProperties = { backgroundType = "None" }
			}

			local v7 = {}

			for k, item in look.items do
				if item.itemType == module.ItemType.Asset then
					item.id = tostring(item.id)
					v6.lookAssetInfos[item.id] = item
				elseif item.itemType == module.ItemType.Bundle then
					item.id = tostring(item.id)
					v6.lookBundleInfos[item.id] = item

					if v7 then
						table.insert(v7, item)
					end
				end
			end

			if v7 then
				local blockyLookDetailItem = module6.buildBlockyLookDetailItem(v7, translateString)

				if blockyLookDetailItem ~= nil then
					v6.lookBundleInfos[blockyLookDetailItem.id] = blockyLookDetailItem
				end
			end

			for k, bodyColor3 in bodyColor3s do
				v6.avatarProperties.bodyColor3s[k] = bodyColor3:ToHex()
			end

			object:dispatch(module4(module.DraftLookId, v6))
			return true
		end):catch(function(p3): boolean
			warn("Failed to create draft look", p3)
			local success, result = pcall(function()
				local v6 = p3.Body

				if v6 then
					v6 = not (p3.Body == "") and HttpService:JSONDecode(p3.Body)
				end

				return v6
			end)

			if success and result and result.errorDescription then
				object:dispatch(module9({
					toastMessage = result.errorDescription,
					isLocalized = true,
					toastType = module10.InformationMessage
				}))

				sendAXCounterV2(module.Counter.LookComposer.PreviewLook, {
					errorCode = result.errorCode
				})
			elseif success and result and result.errorCode then
				sendAXCounterV2(module.Counter.LookComposer.PreviewLook, {
					errorCode = result.errorCode
				})

				object:dispatch(module9({
					toastMessage = module2.AvatarShareErrorMessagesKeys[result.errorCode] or "Feature.Avatar.Generic.Error",
					isLocalized = false,
					toastType = module10.InformationMessage
				}))
			else
				sendAXCounterV2(module.Counter.LookComposer.PreviewLook, {
					errorCode = "none"
				})
			end

			return false
		end)
	end)
end
