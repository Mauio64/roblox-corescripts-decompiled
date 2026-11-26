local AvatarEditorService = game:GetService("AvatarEditorService")
local CorePackages = game:GetService("CorePackages")
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface
local module = require("@luauforge/bundled/dKU")

local Cryo = require(CorePackages.Packages.Cryo)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")

local module2 = require("@luauforge/bundled/fCI")
local module3 = require("@luauforge/bundled/dPN")
local module4 = require("@luauforge/bundled/dRO")
local module5 = require("@luauforge/bundled/dFm")
local module6 = require("@luauforge/bundled/dzE")
local removeSaveDelay = module.Actions.RemoveSaveDelay
require("@luauforge/bundled/dPs")
local module7 = require("@luauforge/bundled/fCe")
local module8 = require("@luauforge/bundled/hcC")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local AVATAR_EDITOR_SERVICE_EVENTS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_EVENTS
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceAnalytics.Flags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceAnalytics.Flags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1
local module10 = require("@luauforge/bundled/dPN")

local module11 = require("@luauforge/bundled/dPf")
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2

local module12 = require("@luauforge/bundled/ipz")
local module13 = require("@luauforge/bundled/ipA")

local fFlagAXBackgroundsPersistence = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXBackgroundsPersistence
local fFlagAXSaveManagerOutsideAX = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXSaveManagerOutsideAX
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local fFlagAXSpawnEffectSaveRoundTrip = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSpawnEffectSaveRoundTrip

local fFlagAXTimeoutAcknowledgementGating = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXTimeoutAcknowledgementGating

local fFlagAXMomentsLookTryOnCloseAfterPurchase = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMomentsLookTryOnCloseAfterPurchase

local tenFootInterface = isTenFootInterface()

local v5 = {
	toastMessage = "Feature.Avatar.Message.InvalidAssetsEquipped",
	isLocalized = false,
	toastType = module6.InformationMessage
}

local v6 = if tenFootInterface then require("@game/CoreGui/RobloxGui/Modules/Shell/EventHub") else nil

local class = {}
class.__index = class
local defineFastInt = game:DefineFastInt("AvatarEditorTimeBetweenSaves", 5)

local function getBackgroundAssetId(p2)
	return p2.AvatarExperience.AvatarScene.ProfileConfiguration.BackgroundAssetId
end

function class:setLastSavedVariables()
	local state = self.store:getState()

	self.lastSavedBodyColor3s = state.AvatarExperience.AvatarEditor.Character.BodyColor3s

	self.lastSavedAvatarType = state.AvatarExperience.AvatarEditor.Character.AvatarType
	self.lastSavedScales = state.AvatarExperience.AvatarEditor.Character.AvatarScales
	self.lastSavedAssets = state.AvatarExperience.AvatarEditor.Character.EquippedAssets
	self.lastSavedEmotes = state.AvatarExperience.AvatarEditor.EquippedEmotes.slotInfo

	if fFlagAXBackgroundsPersistence then
		self.lastSavedBackgroundAssetId = state.AvatarExperience.AvatarScene.ProfileConfiguration.BackgroundAssetId
	end
end

function class.new(p2, p3, p4)
	local v7 = {}
	v7.store = p2
	v7.connections = {}
	v7.networking = p3
	v7.analytics = p4

	if fFlagAXSaveManagerOutsideAX then
		v7.running = false
	end

	setmetatable(v7, class)

	v7.timeOfLastSave = 0
	v7:setLastSavedVariables()

	return v7
end

function class:start()
	if fFlagAXSaveManagerOutsideAX and self.running then
		return
	end

	local changedConnection = self.store.changed:connect(function(p2, p3)
		self:update(p2, p3)
	end)
	table.insert(self.connections, changedConnection)

	local closeConnection = game.Close:Connect(function()
		self:save(true)
	end)
	table.insert(self.connections, closeConnection)

	self.timeOfLastSave = 0
	self.waitingForSave = false
	self.characterUpdated = false
	self.characterEquipped = false
	self:setLastSavedVariables()

	if fFlagAXSaveManagerOutsideAX then
		self.running = true
	end
end

local function getTimeoutActionKey(data)
	if not data then
		return nil
	end

	if data.decisionEventID and data.decisionEventID ~= "" then
		return data.decisionEventID
	end

	return `{data.featureVector or ""}|{data.startTime or ""}|{data.endTime or ""}`
end

function class:promptTimeoutAcknowledgementOnEdit(p3, p4, p5)
	local status = p5.getStatus(false)
	local timeoutAction = status.timeoutAction
	local v7

	if timeoutAction then
		if timeoutAction.decisionEventID and timeoutAction.decisionEventID ~= "" then
			v7 = timeoutAction.decisionEventID
		else
			v7 = `{timeoutAction.featureVector or ""}|{timeoutAction.startTime or ""}|{timeoutAction.endTime or ""}`
		end
	end

	if
		not status.requiresAcknowledgement
		or v7 == self.lastAcknowledgementPromptTimeoutKey
		or p3.AvatarExperience.AvatarEditor.Character == p4.AvatarExperience.AvatarEditor.Character
	then
		return
	end

	self.lastAcknowledgementPromptTimeoutKey = v7
	AvatarExperienceCommon.Utils.showAvatarChangeFeatureRestriction()
end

function class:update(p2, p3)
	if module13 then
		if not module8(p2) then
			return
		end

		if not module8(p3) then
			self:setLastSavedVariables()
		end
	end

	local timeoutStatusStore = AvatarExperienceCommon.Stores.getTimeoutStatusStore()

	if
		timeoutStatusStore
		and timeoutStatusStore.getIsTimedOut
		and timeoutStatusStore.getIsTimedOut(false)
	then
		if fFlagAXTimeoutAcknowledgementGating then
			self:promptTimeoutAcknowledgementOnEdit(p2, p3, timeoutStatusStore)
		end
	else
		local bodyColor3s = p2.AvatarExperience.AvatarEditor.Character.BodyColor3s
		local avatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType
		local avatarScales = p2.AvatarExperience.AvatarEditor.Character.AvatarScales
		local equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
		local slotInfo = p2.AvatarExperience.AvatarEditor.EquippedEmotes.slotInfo

		local v7 = bodyColor3s ~= self.lastSavedBodyColor3s
			or avatarType ~= self.lastSavedAvatarType
			or avatarScales ~= self.lastSavedScales
			or equippedAssets ~= self.lastSavedAssets
			or slotInfo ~= self.lastSavedEmotes

		if
			(fFlagAXBackgroundsPersistence and p2.AvatarExperience.AvatarScene.ProfileConfiguration.BackgroundAssetId ~= self.lastSavedBackgroundAssetId or v7)
			and not self.saving
		then
			self:save(false)
		end
	end
end

function class:stop()
	if fFlagAXSaveManagerOutsideAX and not self.running then
		return
	end

	self:save(true, fFlagAXMomentsLookTryOnCloseAfterPurchase)

	for k, connection in self.connections do
		connection:disconnect()
	end

	self.connections = {}

	if tenFootInterface then
		spawn(function()
			if self.characterUpdated then
				v6:dispatchEvent(v6.Notifications.CharacterUpdated)
			end

			if self.characterEquipped then
				v6:dispatchEvent(
					v6.Notifications.CharacterEquipped,
					self.store:getState().AvatarExperience.AvatarEditor.Character.EquippedAssets,
					self.characterUpdated
				)
			end

			self.characterUpdated = false
			self.characterEquipped = false
		end)
	end

	if fFlagAXSaveManagerOutsideAX then
		self.running = false
	end
end

local function notifyUserAboutInvalidAssetsInCostume(object)
	object:dispatch(module5(v5))
end

local function getAssetIdsFromDescription(object)
	local result = {}

	local result2 = {}

	for k, v7 in module3.AssetTypeIdStringToHumanoidDescriptionProp do
		if module3.AssetTypeIdToAccessoryTypeEnum[k] ~= nil then
			continue
		end

		local v8 = object[v7]

		if typeof(v8) == "number" and v8 > 0 then
			table.insert(result, v8)
			result2[v8] = tostring(k)
		elseif typeof(v8) == "string" and v8 ~= "" then
			for k2 in v8:gmatch("([%d]+),?") do
				table.insert(result, (tonumber(k2)))
				result2[tonumber(k2)] = tostring(k)
			end
		end
	end

	local accessories = object:GetAccessories(true)

	for k, accessory in accessories do
		table.insert(result, accessory.AssetId)
		local accessoryType = accessory.AccessoryType
		result2[accessory.AssetId] = module3.AccessoryTypeEnumToAssetTypeId[accessoryType]
	end

	return result, result2
end

local function removeInvalidAssetsWithHumanoidDescription(store, humanoidDescriptionFromState, p2, equippedAssets)
	local assetIdsFromDescription, v7 = getAssetIdsFromDescription(humanoidDescriptionFromState)
	local assetIdsFromDescription2 = getAssetIdsFromDescription(p2)
	local set = Cryo.List.toSet(assetIdsFromDescription2)

	local filtered = Cryo.List.filter(assetIdsFromDescription, function(p3): boolean
		return set[p3] == nil
	end)

	for k, v8 in filtered do
		if not module2.isAssetEquipped(tostring(v8), v7[v8], equippedAssets) then
			continue
		end

		store:dispatch(module4(v7[v8], (tostring(v8))))
	end

	if #filtered > 0 then
		store:dispatch(module5(v5))
	end
end

function class:shouldDelaySaveManager()
	return self.store:getState().AvatarExperience.AvatarScene.Character.ShouldDelaySaveManager
end

function class:refreshAvatarThumbnails()
	if module12 and game:GetEngineFeature("AvatarEditorServiceRefreshAvatarThumbnailEnabled") then
		AvatarEditorService:refreshAvatarThumbnails({ "AvatarHeadShot", "AvatarBust", "Avatar" })
	end
end

function class:persistProfileConfiguration(lastSavedBackgroundAssetId)
	local v7 = { BackgroundAssetId = lastSavedBackgroundAssetId }

	if fFlagAXAvatarEditorServiceTelemetryV2 then
		reportAvatarEditorServiceCounter(
			AVATAR_EDITOR_SERVICE_EVENTS.NoPromptApplyProfileConfiguration,
			AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
		)
	end

	local v8 = AvatarEditorService:NoPromptApplyProfileConfiguration(v7)

	while not v8 do
		if fFlagAXAvatarEditorServiceTelemetryV2 then
			reportAvatarEditorServiceCounter(
				AVATAR_EDITOR_SERVICE_EVENTS.NoPromptApplyProfileConfiguration,
				AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error
			)
		end

		AvatarEditorService.PromptApplyProfileConfigurationCompleted:Wait()

		if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
			reportAvatarEventCounterNoAnalyticsArgument(module10.Counter.AvatarEditorServiceErrors.NoPromptApplyProfileConfiguration)
		end

		if fFlagAXAvatarEditorServiceTelemetryV2 then
			reportAvatarEditorServiceCounter(
				AVATAR_EDITOR_SERVICE_EVENTS.NoPromptApplyProfileConfiguration,
				AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
			)
		end

		v8 = AvatarEditorService:NoPromptApplyProfileConfiguration(v7)
	end

	local v9 = AvatarEditorService.PromptApplyProfileConfigurationCompleted:Wait()

	if v9 == Enum.AvatarPromptResult.Success then
		if fFlagAXAvatarEditorServiceTelemetryV2 then
			reportAvatarEditorServiceCounter(
				AVATAR_EDITOR_SERVICE_EVENTS.NoPromptApplyProfileConfiguration,
				AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
			)
		end

		self.lastSavedBackgroundAssetId = lastSavedBackgroundAssetId

		if module12 then
			self:refreshAvatarThumbnails()
		end
	else
		if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
			reportAvatarEventCounterNoAnalyticsArgument(module10.Counter.AvatarEditorServiceErrors.PromptApplyProfileConfigurationCompleted)
		end

		if fFlagAXAvatarEditorServiceTelemetryV2 then
			reportAvatarEditorServiceCounter(
				AVATAR_EDITOR_SERVICE_EVENTS.NoPromptApplyProfileConfiguration,
				AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
				v9
			)
		end
	end
end

function class:save(p2, p3)
	self.saving = true

	sendAXCounterV2(module3.Counter.SaveManager.Attempt, {
		skipWait = tostring(p2),
		shouldDelay = tostring(self:shouldDelaySaveManager()),
		timeBetweenSaves = tostring(defineFastInt)
	})

	task.spawn(function()
		local v7 = tick() - self.timeOfLastSave

		if p2 then
			if p3 and self:shouldDelaySaveManager() then
				task.wait(defineFastInt)
			end

			if self:shouldDelaySaveManager() then
				self.store:dispatch(removeSaveDelay())
			end
		elseif v7 < defineFastInt then
			task.wait(defineFastInt - v7)

			if self:shouldDelaySaveManager() then
				self.store:dispatch(removeSaveDelay())
			end
		elseif self:shouldDelaySaveManager() then
			wait(defineFastInt)
			self.store:dispatch(removeSaveDelay())
		end

		if module13 and not module8(self.store:getState()) then
			self.saving = false
			return
		end

		local bodyColor3s = self.store:getState().AvatarExperience.AvatarEditor.Character.BodyColor3s

		local avatarType = self.store:getState().AvatarExperience.AvatarEditor.Character.AvatarType
		local avatarScales = self.store:getState().AvatarExperience.AvatarEditor.Character.AvatarScales
		local equippedAssets = self.store:getState().AvatarExperience.AvatarEditor.Character.EquippedAssets
		local slotInfo = self.store:getState().AvatarExperience.AvatarEditor.EquippedEmotes.slotInfo
		local v8 = {}

		v8.BodyColors = bodyColor3s ~= self.lastSavedBodyColor3s
		v8.AvatarType = avatarType ~= self.lastSavedAvatarType
		v8.Scales = avatarScales ~= self.lastSavedScales
		v8.Assets = equippedAssets and equippedAssets ~= self.lastSavedAssets
		v8.Emotes = slotInfo ~= self.lastSavedEmotes

		local bodyColors = v8.BodyColors or v8.AvatarType or v8.Scales or v8.Assets or v8.Emotes
		local backgroundAssetId

		if fFlagAXBackgroundsPersistence then
			backgroundAssetId = self.store:getState().AvatarExperience.AvatarScene.ProfileConfiguration.BackgroundAssetId
		else
			backgroundAssetId = nil
		end

		local v9 = fFlagAXBackgroundsPersistence

		if v9 then
			v9 = not (backgroundAssetId == nil) and backgroundAssetId ~= self.lastSavedBackgroundAssetId
		end

		if bodyColors or v9 then
			local timeoutStatusStore = AvatarExperienceCommon.Stores.getTimeoutStatusStore()

			if
				timeoutStatusStore
				and timeoutStatusStore.getIsTimedOut
				and timeoutStatusStore.getIsTimedOut(false)
			then
				self.saving = false
				return
			end

			if v9 then
				task.spawn(function()
					self:persistProfileConfiguration(backgroundAssetId)

					if not bodyColors then
						self.timeOfLastSave = tick()
						self.saving = false
					end
				end)

				if not bodyColors then
					return
				end
			end

			local humanoidDescriptionFromState = module2.getHumanoidDescriptionFromState(self.store:getState().AvatarExperience)

			if fFlagAXSpawnEffectSaveRoundTrip and equippedAssets then
				AvatarExperienceCommon.Utils.setAvatarEffectDescriptions(humanoidDescriptionFromState, equippedAssets)
			end

			local v10 = Enum.HumanoidRigType[avatarType]
			task.spawn(function()
				local v11 = 0

				if v8.Assets then
					local equippedAsset = equippedAssets[tostring(Enum.AssetType.Gear.Value)]

					if equippedAsset then
						local v12, v13 = next(equippedAsset)

						if v12 then
							v11 = tonumber(v12)
						end
					end
				end

				if fFlagAXAvatarEditorServiceTelemetryV2 then
					reportAvatarEditorServiceCounter(
						AVATAR_EDITOR_SERVICE_EVENTS.NoPromptSaveAvatar,
						AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
					)
				end

				local v12 = AvatarEditorService:NoPromptSaveAvatar(
					humanoidDescriptionFromState,
					v10,
					v8,
					v11
				)
				local count = 0

				while not v12 do
					count += 1

					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.NoPromptSaveAvatar,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error
						)
					end

					AvatarEditorService.PromptSaveAvatarCompleted:Wait()

					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.NoPromptSaveAvatar,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
						)
					end

					v12 = AvatarEditorService:NoPromptSaveAvatar(humanoidDescriptionFromState, v10, v8)

					if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
						reportAvatarEventCounterNoAnalyticsArgument(module10.Counter.AvatarEditorServiceErrors.NoPromptSaveAvatar)
					end
				end

				if count > 0 then
					sendAXCounterV2(module3.Counter.SaveManager.BlockedByOngoingSave, {
						blockedCount = tostring(count)
					})
				end

				local v13, v14 = AvatarEditorService.PromptSaveAvatarCompleted:Wait()

				if v13 == Enum.AvatarPromptResult.Success then
					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.NoPromptSaveAvatar,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
						)
					end

					if bodyColor3s ~= self.lastSavedBodyColor3s then
						self.lastSavedBodyColor3s = bodyColor3s
						self.characterUpdated = true
					end

					if avatarType ~= self.lastSavedAvatarType then
						self.lastSavedAvatarType = avatarType
						self.characterUpdated = true
					end

					if avatarScales ~= self.lastSavedScales then
						self.lastSavedScales = avatarScales
						self.characterUpdated = true
					end

					if equippedAssets and equippedAssets ~= self.lastSavedAssets then
						self.lastSavedAssets = equippedAssets
						self.characterUpdated = true
						self.characterEquipped = true

						removeInvalidAssetsWithHumanoidDescription(
							self.store,
							humanoidDescriptionFromState,
							v14,
							equippedAssets
						)
					end

					if slotInfo ~= self.lastSavedEmotes then
						self.lastSavedEmotes = slotInfo
						self.characterUpdated = true
						self.characterEquipped = true
					end

					if module12 and self.characterUpdated then
						self:refreshAvatarThumbnails()
					end

					sendAXCounterV2(module3.Counter.SaveManager.Success)
				else
					warn("Failure saving.")
					sendAXCounterV2(module3.Counter.SaveManager.Failure)

					if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
						reportAvatarEventCounterNoAnalyticsArgument(module10.Counter.AvatarEditorServiceErrors.PromptSaveAvatarCompleted)
					end

					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.NoPromptSaveAvatar,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
							v13
						)
					end

					local timeoutStatusStore2 = AvatarExperienceCommon.Stores.getTimeoutStatusStore()

					if timeoutStatusStore2 and timeoutStatusStore2.fetchStatus then
						timeoutStatusStore2.fetchStatus()
					end
				end

				self.store:dispatch(module11())

				self.timeOfLastSave = tick()
				self.saving = false
			end)
		else
			self.timeOfLastSave = tick()
			self.saving = false
		end
	end)
end

function class:updateAvatarRoute(p2, p3)
	if module7.didLeaveAvatarEditor(p2, p3) then
		self:save(true, fFlagAXMomentsLookTryOnCloseAfterPurchase)
	end
end

function class:onDestroy() end

return class
