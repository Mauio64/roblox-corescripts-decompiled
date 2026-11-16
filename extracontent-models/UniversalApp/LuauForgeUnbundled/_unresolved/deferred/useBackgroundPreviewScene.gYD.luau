local CorePackages = game:GetService("CorePackages")
local AssetService = game:GetService("AssetService")

local React = require(CorePackages.Packages.React)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local colorMode = Foundation.Enums.ColorMode

local module = require("@luauforge/bundled/dHL")
local toggleTryOn = module.Actions.ToggleTryOn
local removeFromTryOn = module.Actions.RemoveFromTryOn
local setBackgroundPreview = module.Actions.SetBackgroundPreview

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module3 = require("@luauforge/bundled/dMd")
local previewImageRegistry = AvatarExperienceCommon.Backgrounds.previewImageRegistry
local itemTypeEnum = module3.Enums.ItemTypeEnum

local avatarBackground = AvatarExperienceCommon.Constants.ASSET_TYPE_NAME_TO_ID_STRING.AvatarBackground

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local fStringAXBackgroundGenerationCanvasAssetIdDark = AvatarExperienceFlags.FStringAXBackgroundGenerationCanvasAssetIdDark

local fStringAXBackgroundGenerationCanvasAssetIdLight = AvatarExperienceFlags.FStringAXBackgroundGenerationCanvasAssetIdLight

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2
local sendAXStat = AvatarExperienceAnalytics.sendAXStat
local constants = require("@luauforge/deferred/gQI").Constants

local count = 0

local function getCanvasAssetId(p2)
	if not avatarBackground then
		return nil
	end

	local v5

	if p2 == colorMode.Dark then
		v5 = fStringAXBackgroundGenerationCanvasAssetIdDark
	else
		v5 = fStringAXBackgroundGenerationCanvasAssetIdLight
	end

	local v6 = tonumber(v5)

	if v6 and v6 > 0 then
		return v6
	end

	return nil
end

local function useBackgroundPreviewScene(p2)
	local v5 = useDispatch()
	local name = useTokens().Config.ColorMode.Name
	local state, setState = React.useState("idle")

	React.useEffect(function()
		local v6 = name
		local v7

		if avatarBackground then
			local v8

			if v6 == colorMode.Dark then
				v8 = fStringAXBackgroundGenerationCanvasAssetIdDark
			else
				v8 = fStringAXBackgroundGenerationCanvasAssetIdLight
			end

			v7 = tonumber(v8)

			if not (v7 and v7 > 0) then
				v7 = nil
			end
		else
			v7 = nil
		end

		if v7 then
			v5(toggleTryOn(itemTypeEnum.Asset, avatarBackground, tostring(v7), false))
		end

		return function()
			if v7 then
				v5(removeFromTryOn(tostring(v7), itemTypeEnum.Asset))
			end
		end
	end, { v5, name })

	React.useEffect(function()
		if p2 then
			setState("preparing")
			sendAXCounterV2(constants.PREVIEW_RENDER_COUNTER_NAME, {
				status = "attempt"
			})
			local lastTime = os.clock()

			local flag = false
			task.spawn(function()
				local success, result = pcall(function()
					return AssetService:CreateEditableImageFromDownloadAsync(p2)
				end)

				if flag then
					if success and result then
						result:Destroy()
					end
				elseif success and result then
					count += 1
					local formatted = `ai-bg-preview-{count}`
					previewImageRegistry.register(formatted, result)

					v5(setBackgroundPreview(formatted))
					sendAXCounterV2(constants.PREVIEW_RENDER_COUNTER_NAME, {
						status = "success"
					})
					sendAXStat({
						statName = constants.PREVIEW_RENDER_DURATION_STAT_NAME,
						deltaMs = (os.clock() - lastTime) * 1000
					})

					setState("rendered")
				else
					local v6 = success and "CreateEditableImageFromDownloadAsync returned no image"
						or tostring(result)

					warn(`[BackgroundGeneration] Failed to load preview image: {v6}`)
					sendAXCounterV2(constants.PREVIEW_RENDER_COUNTER_NAME, {
						status = "error"
					})
					setState("failed")
				end
			end)

			return function()
				flag = true

				v5(setBackgroundPreview(nil))
			end
		end

		setState("idle")
		v5(setBackgroundPreview(nil))
	end, { p2, v5 })

	return state
end

return useBackgroundPreviewScene
