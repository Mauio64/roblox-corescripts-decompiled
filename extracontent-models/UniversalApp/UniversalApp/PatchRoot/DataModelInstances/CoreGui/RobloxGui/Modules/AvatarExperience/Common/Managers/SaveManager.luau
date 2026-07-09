local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GuiService = game:GetService("GuiService")
local AvatarEditorService = game:GetService("AvatarEditorService")
local CorePackages = game:GetService("CorePackages")
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local Cryo = require(CorePackages.Packages.Cryo)

require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)

local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local ToggleEquipAsset = require(Modules.AvatarExperience.AvatarEditor.Actions.ToggleEquipAsset)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local RemoveSaveDelay = AvatarExperienceRodux.Actions.RemoveSaveDelay

require(Modules.AvatarExperience.Common.Types)

local Utils2 = require(Modules.AvatarExperience.Common.Utils)
local reportAvatarEventCounterNoAnalyticsArgument = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).reportAvatarEventCounterNoAnalyticsArgument
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local tutils = require(CorePackages.Packages.tutils)
local IncrementSavedCharacterModelVersion = require(Modules.AvatarExperience.Common.Actions.IncrementSavedCharacterModelVersion)
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2
local PreventSaveAvatar = require(Modules.AvatarExperience.AvatarEditor.Actions.PreventSaveAvatar)
local GetFFlagAXEnableAvatarDataRefresh = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableAvatarDataRefresh)
local GetFFlagEnableAvatarEditorServiceAPIErrorLogging = require(Modules.AvatarExperience.Flags.GetFFlagEnableAvatarEditorServiceAPIErrorLogging)
local v22 = game:DefineFastFlag("AXFixSaveManagerOnAXExit", false)
local FFlagAXAvatarTimeoutFlow = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXAvatarTimeoutFlow
local FFlagAXBackgroundsPersistence = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXBackgroundsPersistence
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local v26 = GuiService:IsTenFootInterface()
local t1 = {
	toastMessage = "Feature.Avatar.Message.InvalidAssetsEquipped",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}
local EventHub = nil

if v26 then
	EventHub = require(Modules.Shell.EventHub)
end

local t2 = {}

t2.__index = t2

local v30 = game:DefineFastInt("AvatarEditorTimeBetweenSaves", 5)

local function getBackgroundAssetId(p1) -- line: 58
	return p1.AvatarExperience.AvatarScene.ProfileConfiguration.BackgroundAssetId
end

function t2.setLastSavedVariables(p2) -- line: 62
	-- upvalues: FFlagAXBackgroundsPersistence (copy)
	local v37 = p2.store:getState()

	p2.lastSavedBodyColor3s = v37.AvatarExperience.AvatarEditor.Character.BodyColor3s
	p2.lastSavedAvatarType = v37.AvatarExperience.AvatarEditor.Character.AvatarType
	p2.lastSavedScales = v37.AvatarExperience.AvatarEditor.Character.AvatarScales
	p2.lastSavedAssets = v37.AvatarExperience.AvatarEditor.Character.EquippedAssets
	p2.lastSavedEmotes = v37.AvatarExperience.AvatarEditor.EquippedEmotes.slotInfo

	if FFlagAXBackgroundsPersistence then
		p2.lastSavedBackgroundAssetId = v37.AvatarExperience.AvatarScene.ProfileConfiguration.BackgroundAssetId
	end
end
function t2.new(p3, p4, p5) -- line: 77
	-- upvalues: t2 (copy)
	local t3 = {
		store = p3,
		connections = {},
		networking = p4,
		analytics = p5
	}

	setmetatable(t3, t2)
	t3.timeOfLastSave = 0
	t3:setLastSavedVariables()

	return t3
end
function t2.start(p6) -- line: 91
	local v43 = p6.store.changed:connect(function(p7, p8) -- line: 92
		-- upvalues: p6 (copy)
		p6:update(p7, p8)
	end)

	table.insert(p6.connections, v43)

	local connection = game.Close:Connect(function() -- line: 97
		-- upvalues: p6 (copy)
		p6:save(true)
	end)

	table.insert(p6.connections, connection)
	p6.timeOfLastSave = 0
	p6.waitingForSave = false
	p6.characterUpdated = false
	p6.characterEquipped = false
	p6:setLastSavedVariables()
end
function t2.update(p9, p10, _) -- line: 109
	-- upvalues: GetFFlagAXEnableAvatarDataRefresh (copy), PreventSaveAvatar (copy), FFlagAXAvatarTimeoutFlow (copy), AvatarExperienceCommon (copy), tutils (copy), FFlagAXBackgroundsPersistence (copy)
	if GetFFlagAXEnableAvatarDataRefresh() and p10.AvatarExperience.AvatarEditor.PreventSaveAvatar then
		p9.store:dispatch(PreventSaveAvatar(false))

		return
	end

	if FFlagAXAvatarTimeoutFlow then
		local v48 = AvatarExperienceCommon.Stores.getTimeoutStatusStore()

		if v48 and v48.getIsTimedOut and v48.getIsTimedOut(false) then
			return
		end
	end

	local BodyColor3s = p10.AvatarExperience.AvatarEditor.Character.BodyColor3s
	local AvatarType = p10.AvatarExperience.AvatarEditor.Character.AvatarType
	local AvatarScales = p10.AvatarExperience.AvatarEditor.Character.AvatarScales
	local EquippedAssets = p10.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local slotInfo = p10.AvatarExperience.AvatarEditor.EquippedEmotes.slotInfo
	local v54 = false
	local v55 = if not GetFFlagAXEnableAvatarDataRefresh() then BodyColor3s ~= p9.lastSavedBodyColor3s else not tutils.deepEqual(BodyColor3s, p9.lastSavedBodyColor3s)

	if GetFFlagAXEnableAvatarDataRefresh() then
		if v55 or not tutils.deepEqual(AvatarType, p9.lastSavedAvatarType) or not tutils.deepEqual(AvatarScales, p9.lastSavedScales) or not tutils.deepEqual(EquippedAssets, p9.lastSavedAssets) or not tutils.deepEqual(slotInfo, p9.lastSavedEmotes) then
			v54 = true
		end
	elseif v55 or AvatarType ~= p9.lastSavedAvatarType or AvatarScales ~= p9.lastSavedScales or EquippedAssets ~= p9.lastSavedAssets or slotInfo ~= p9.lastSavedEmotes then
		v54 = true
	end

	if FFlagAXBackgroundsPersistence and p10.AvatarExperience.AvatarScene.ProfileConfiguration.BackgroundAssetId ~= p9.lastSavedBackgroundAssetId then
		v54 = true
	end

	if v54 and not p9.saving then
		p9:save(false)
	end
end
function t2.stop(p12) -- line: 169
	-- upvalues: v26 (copy), EventHub (ref)
	p12:save(true)

	for _, v58 in p12.connections do
		v58:disconnect()
	end

	p12.connections = {}

	if v26 then
		spawn(function() -- line: 178
			-- upvalues: p12 (copy), EventHub (ref)
			if p12.characterUpdated then
				EventHub:dispatchEvent(EventHub.Notifications.CharacterUpdated)
			end

			if p12.characterEquipped then
				EventHub:dispatchEvent(EventHub.Notifications.CharacterEquipped, p12.store:getState().AvatarExperience.AvatarEditor.Character.EquippedAssets, p12.characterUpdated)
			end

			p12.characterUpdated = false
			p12.characterEquipped = false
		end)
	end
end

local function notifyUserAboutInvalidAssetsInCostume(p13) -- line: 197
	-- upvalues: SetCurrentToastMessage (copy), t1 (copy)
	p13:dispatch(SetCurrentToastMessage(t1))
end
local function getAssetIdsFromDescription(p14) -- line: 201
	-- upvalues: Constants (copy)
	local t4 = {}
	local t5 = {}

	for v63, v64 in Constants.AssetTypeIdStringToHumanoidDescriptionProp do
		if Constants.AssetTypeIdToAccessoryTypeEnum[v63] == nil then
			local v65 = p14[v64]

			if typeof(v65) == "number" and v65 > 0 then
				table.insert(t4, v65)
				t5[v65] = tostring(v63)
			elseif typeof(v65) == "string" and v65 ~= "" then
				for match in v65:gmatch("([%d]+),?") do
					table.insert(t4, (tonumber(match)))
					t5[tonumber(match)] = tostring(v63)
				end
			end
		end
	end

	for _, v68 in (p14:GetAccessories(true)) do
		table.insert(t4, v68.AssetId)

		local AccessoryType = v68.AccessoryType

		t5[v68.AssetId] = Constants.AccessoryTypeEnumToAssetTypeId[AccessoryType]
	end

	return t4, t5
end
local function removeInvalidAssetsWithHumanoidDescription(p15, p16, p17, p18) -- line: 235
	-- upvalues: getAssetIdsFromDescription (copy), Cryo (copy), Utils (copy), ToggleEquipAsset (copy), SetCurrentToastMessage (copy), t1 (copy)
	local v74, v75 = getAssetIdsFromDescription(p16)
	local v76 = getAssetIdsFromDescription(p17)
	local v77 = Cryo.List.toSet(v76)
	local v78 = Cryo.List.filter(v74, function(p19) -- line: 242
		-- upvalues: v77 (copy)
		return v77[p19] == nil
	end)

	for _, v80 in v78 do
		if Utils.isAssetEquipped(tostring(v80), v75[v80], p18) then
			p15:dispatch(ToggleEquipAsset(v75[v80], (tostring(v80))))
		end
	end

	if #v78 > 0 then
		p15:dispatch(SetCurrentToastMessage(t1))
	end
end

function t2.shouldDelaySaveManager(p20) -- line: 263
	return p20.store:getState().AvatarExperience.AvatarScene.Character.ShouldDelaySaveManager
end
function t2.persistProfileConfiguration(t6: {[any]: any}, n1: number) -- line: 268
	-- upvalues: AvatarEditorService (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy)
	local t7 = {
		BackgroundAssetId = n1
	}
	local v85 = AvatarEditorService:NoPromptApplyProfileConfiguration(t7)

	while not v85 do
		AvatarEditorService.PromptApplyProfileConfigurationCompleted:Wait()

		if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
			reportAvatarEventCounterNoAnalyticsArgument(Constants2.Counter.AvatarEditorServiceErrors.NoPromptApplyProfileConfiguration)
		end

		v85 = AvatarEditorService:NoPromptApplyProfileConfiguration(t7)
	end

	if AvatarEditorService.PromptApplyProfileConfigurationCompleted:Wait() == Enum.AvatarPromptResult.Success then
		t6.lastSavedBackgroundAssetId = n1

		return
	end

	if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
		reportAvatarEventCounterNoAnalyticsArgument(Constants2.Counter.AvatarEditorServiceErrors.PromptApplyProfileConfigurationCompleted)
	end
end
function t2.save(p21, p22) -- line: 293
	-- upvalues: sendAXCounterV2 (copy), Constants (copy), v30 (copy), v22 (copy), RemoveSaveDelay (copy), GetFFlagAXEnableAvatarDataRefresh (copy), tutils (copy), FFlagAXBackgroundsPersistence (copy), FFlagAXAvatarTimeoutFlow (copy), AvatarExperienceCommon (copy), Utils (copy), AvatarEditorService (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), removeInvalidAssetsWithHumanoidDescription (copy), IncrementSavedCharacterModelVersion (copy)
	p21.saving = true
	sendAXCounterV2(Constants.Counter.SaveManager.Attempt, {
		skipWait = tostring(p22),
		shouldDelay = tostring(p21:shouldDelaySaveManager()),
		timeBetweenSaves = tostring(v30)
	})
	task.spawn(function() -- line: 302
		-- upvalues: p21 (copy), v22 (copy), p22 (copy), v30 (copy), RemoveSaveDelay (copy), GetFFlagAXEnableAvatarDataRefresh (copy), tutils (copy), FFlagAXBackgroundsPersistence (copy), FFlagAXAvatarTimeoutFlow (copy), AvatarExperienceCommon (copy), Utils (copy), AvatarEditorService (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), sendAXCounterV2 (copy), Constants (copy), removeInvalidAssetsWithHumanoidDescription (copy), IncrementSavedCharacterModelVersion (copy)
		local v95 = tick() - p21.timeOfLastSave

		if v22 then
			if not p22 then
				if v95 < v30 then
					task.wait(v30 - v95)

					if p21:shouldDelaySaveManager() then
						p21.store:dispatch(RemoveSaveDelay())
					end
				elseif p21:shouldDelaySaveManager() then
					wait(v30)
					p21.store:dispatch(RemoveSaveDelay())
				end
			elseif p21:shouldDelaySaveManager() then
				p21.store:dispatch(RemoveSaveDelay())
			end
		elseif not p22 and v95 < v30 then
			task.wait(v30 - v95)

			if p21:shouldDelaySaveManager() then
				p21.store:dispatch(RemoveSaveDelay())
			end
		elseif p21:shouldDelaySaveManager() then
			wait(v30)
			p21.store:dispatch(RemoveSaveDelay())
		end

		local BodyColor3s = p21.store:getState().AvatarExperience.AvatarEditor.Character.BodyColor3s
		local AvatarType = p21.store:getState().AvatarExperience.AvatarEditor.Character.AvatarType
		local AvatarScales = p21.store:getState().AvatarExperience.AvatarEditor.Character.AvatarScales
		local EquippedAssets = p21.store:getState().AvatarExperience.AvatarEditor.Character.EquippedAssets
		local slotInfo = p21.store:getState().AvatarExperience.AvatarEditor.EquippedEmotes.slotInfo
		local t8 = {}

		if GetFFlagAXEnableAvatarDataRefresh() then
			t8.BodyColors = not tutils.deepEqual(BodyColor3s, p21.lastSavedBodyColor3s)
			t8.AvatarType = not tutils.deepEqual(p21.lastSavedAvatarType, AvatarType)
			t8.Scales = not tutils.deepEqual(AvatarScales, p21.lastSavedScales)
			t8.Assets = EquippedAssets and not tutils.deepEqual(EquippedAssets, p21.lastSavedAssets)
			t8.Emotes = not tutils.deepEqual(slotInfo, p21.lastSavedEmotes)
		else
			t8.BodyColors = BodyColor3s ~= p21.lastSavedBodyColor3s
			t8.AvatarType = AvatarType ~= p21.lastSavedAvatarType
			t8.Scales = AvatarScales ~= p21.lastSavedScales
			t8.Assets = EquippedAssets and EquippedAssets ~= p21.lastSavedAssets
			t8.Emotes = slotInfo ~= p21.lastSavedEmotes
		end

		local v102 = t8.BodyColors or (t8.AvatarType or (t8.Scales or (t8.Assets or t8.Emotes)))
		local v103 = if not FFlagAXBackgroundsPersistence then nil else p21.store:getState().AvatarExperience.AvatarScene.ProfileConfiguration.BackgroundAssetId
		local v104 = FFlagAXBackgroundsPersistence and (v103 ~= nil and v103 ~= p21.lastSavedBackgroundAssetId)

		if not v102 and not v104 then
			p21.timeOfLastSave = tick()
			p21.saving = false

			return
		end

		if FFlagAXAvatarTimeoutFlow then
			local v105 = AvatarExperienceCommon.Stores.getTimeoutStatusStore()

			if v105 and v105.getIsTimedOut and v105.getIsTimedOut(false) then
				p21.saving = false

				return
			end
		end

		if v104 then
			task.spawn(function() -- line: 409
				-- upvalues: p21 (copy), v103 (copy), v102 (copy)
				p21:persistProfileConfiguration(v103)

				if not v102 then
					p21.timeOfLastSave = tick()
					p21.saving = false
				end
			end)

			if not v102 then
				return
			end
		end

		local v106 = Utils.getHumanoidDescriptionFromState(p21.store:getState().AvatarExperience)
		local v107 = Enum.HumanoidRigType[AvatarType]

		task.spawn(function() -- line: 425
			-- upvalues: t8 (copy), EquippedAssets (copy), AvatarEditorService (copy), v106 (copy), v107 (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), sendAXCounterV2 (copy), Constants (copy), BodyColor3s (copy), p21 (copy), AvatarType (copy), AvatarScales (copy), removeInvalidAssetsWithHumanoidDescription (copy), slotInfo (copy), FFlagAXAvatarTimeoutFlow (copy), AvatarExperienceCommon (copy), IncrementSavedCharacterModelVersion (copy)
			local n2 = 0

			if t8.Assets then
				local v109 = EquippedAssets[tostring(Enum.AssetType.Gear.Value)]

				if v109 then
					local v110, _ = next(v109)

					if v110 then
						n2 = tonumber(v110)
					end
				end
			end

			local v112 = AvatarEditorService:NoPromptSaveAvatar(v106, v107, t8, n2)
			local n3 = 0

			while not v112 do
				n3 += 1
				AvatarEditorService.PromptSaveAvatarCompleted:Wait()
				v112 = AvatarEditorService:NoPromptSaveAvatar(v106, v107, t8)

				if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
					reportAvatarEventCounterNoAnalyticsArgument(Constants2.Counter.AvatarEditorServiceErrors.NoPromptSaveAvatar)
				end
			end

			if n3 > 0 then
				sendAXCounterV2(Constants.Counter.SaveManager.BlockedByOngoingSave, {
					blockedCount = tostring(n3)
				})
			end

			local v114, v115 = AvatarEditorService.PromptSaveAvatarCompleted:Wait()

			if v114 == Enum.AvatarPromptResult.Success then
				if BodyColor3s ~= p21.lastSavedBodyColor3s then
					p21.lastSavedBodyColor3s = BodyColor3s
					p21.characterUpdated = true
				end

				if AvatarType ~= p21.lastSavedAvatarType then
					p21.lastSavedAvatarType = AvatarType
					p21.characterUpdated = true
				end

				if AvatarScales ~= p21.lastSavedScales then
					p21.lastSavedScales = AvatarScales
					p21.characterUpdated = true
				end

				if EquippedAssets and EquippedAssets ~= p21.lastSavedAssets then
					p21.lastSavedAssets = EquippedAssets
					p21.characterUpdated = true
					p21.characterEquipped = true
					removeInvalidAssetsWithHumanoidDescription(p21.store, v106, v115, EquippedAssets)
				end

				if slotInfo ~= p21.lastSavedEmotes then
					p21.lastSavedEmotes = slotInfo
					p21.characterUpdated = true
					p21.characterEquipped = true
				end

				sendAXCounterV2(Constants.Counter.SaveManager.Success)
			else
				warn("Failure saving.")
				sendAXCounterV2(Constants.Counter.SaveManager.Failure)

				if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
					reportAvatarEventCounterNoAnalyticsArgument(Constants2.Counter.AvatarEditorServiceErrors.PromptSaveAvatarCompleted)
				end

				if FFlagAXAvatarTimeoutFlow then
					local v116 = AvatarExperienceCommon.Stores.getTimeoutStatusStore()

					if v116 and v116.fetchStatus then
						v116.fetchStatus()
					end
				end
			end

			p21.store:dispatch(IncrementSavedCharacterModelVersion())
			p21.timeOfLastSave = tick()
			p21.saving = false
		end)
	end)
end
function t2.updateAvatarRoute(p23, p24, p25) -- line: 527
	-- upvalues: Utils2 (copy)
	if Utils2.didLeaveAvatarEditor(p24, p25) then
		p23:save(true)
	end
end
function t2.onDestroy(_) -- line: 536
end

return t2
