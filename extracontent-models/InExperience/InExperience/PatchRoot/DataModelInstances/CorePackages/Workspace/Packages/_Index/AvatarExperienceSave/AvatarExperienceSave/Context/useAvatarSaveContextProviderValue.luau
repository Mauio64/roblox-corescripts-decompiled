local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")

local parent = AvatarExperienceSave.Parent

local React = require(parent.React)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local Dash = require(parent.Dash)
local Cryo = require(parent.Cryo)
local Signals = require(parent.Signals)
local ToastRodux = require(parent.ToastRodux)
local tutils = require(parent.tutils)
local Navigation = require(parent.Navigation)
local RoactNavigation = require(parent.RoactNavigation)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local NavigationRodux = require(parent.NavigationRodux)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local Promise = require(parent.Promise)

local useSelectorSignal = AvatarExperienceCommon.Hooks.useSelectorSignal
local useSignal = AvatarExperienceCommon.Hooks.useSignal
local useComputedSignal = AvatarExperienceCommon.Hooks.useComputedSignal
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = Navigation.useNavigation

require(script.Parent.AvatarSaveContext)
local SaveStatusEnum = require(AvatarExperienceSave.Enums.SaveStatusEnum)
local ToastType = ToastRodux.Enums.ToastType
local Actions = RoactNavigation.Actions
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AppPage = RobloxAppEnums.AppPage
local CustomGetStateForAction = AvatarExperienceNavigation.Enums.CustomGetStateForAction

local saveAvatar = require(AvatarExperienceSave.Requests.saveAvatar)
local saveProfileConfiguration = require(AvatarExperienceSave.Requests.saveProfileConfiguration)

local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local CharacterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated
local RegisterCustomGetStateForAction = AvatarExperienceNavigation.Actions.RegisterCustomGetStateForAction

local shouldInsertNewHistoryEntry = require(AvatarExperienceSave.Utils.shouldInsertNewHistoryEntry)
local shouldReplaceLastHistoryEntry = require(AvatarExperienceSave.Utils.shouldReplaceLastHistoryEntry)
local getSaveDict = require(AvatarExperienceSave.Utils.getSaveDict)
local checkHasChangesToSave = require(AvatarExperienceSave.Utils.checkHasChangesToSave)
local getInvalidAssetIdsToAssetTypeIdMap = require(AvatarExperienceSave.Utils.getInvalidAssetIdsToAssetTypeIdMap)
local removeInvalidAssetsFromCharacterData = require(AvatarExperienceSave.Utils.removeInvalidAssetsFromCharacterData)
local checkCharacterDataHasTryOnItems = require(AvatarExperienceSave.Utils.checkCharacterDataHasTryOnItems)
local selectCharacterData = require(AvatarExperienceSave.Selectors.selectCharacterData)
local selectHasAvatarData = require(AvatarExperienceSave.Selectors.selectHasAvatarData)
local NavigateToRoute = NavigationRodux.Thunks.NavigateToRoute
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local buildHumanoidDescription = AvatarExperienceCommon.Utils.buildHumanoidDescription
local getGearAssetIdFromEquippedAssets = AvatarExperienceCommon.Utils.getGearAssetIdFromEquippedAssets

local getAssetIdToAssetTypeIdFromHumanoidDescription = AvatarExperienceCommon.Utils.getAssetIdToAssetTypeIdFromHumanoidDescription

local defineFastInt = game:DefineFastInt("FIntAXMinSaveIntervalSeconds", 2)
local defineFastInt2 = game:DefineFastInt("AXMaxUndoRedoHistory", 20)
local FFlagAXEnableManualSavingBlockingPrompt = AvatarExperienceFlags.FFlagAXEnableManualSavingBlockingPrompt
local FFlagAXBackgroundsPersistence = AvatarExperienceFlags.FFlagAXBackgroundsPersistence
local FFlagAXTimeoutAcknowledgementGating = AvatarExperienceFlags.FFlagAXTimeoutAcknowledgementGating

local v = {
	toastMessage = "Feature.Avatar.Message.SaveThrottled",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

local v2 = {
	toastMessage = "Feature.Avatar.Message.SaveSuccessWithInvalidAssets",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}

local v3 = {
	toastMessage = "Feature.Avatar.Message.SaveSuccess",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}

local v4 = {
	toastMessage = "Feature.Avatar.Message.SaveFailure",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

local v5 = { Home = AppPage.Home, More = AppPage.More, Chat = AppPage.Chat, Games = AppPage.Games }

local function buildHumanoidDescriptionForCharacterData(p) -- 1 equivalent call inferred from this helper
	return buildHumanoidDescription({
		currentAssets = p.equipped.EquippedAssets,
		avatarScales = p.equipped.AvatarScales,
		bodyColor3s = p.equipped.BodyColor3s,
		emotesSlotInfo = p.equipped.EquippedEmotes.slotInfo
	})
end

local function useAvatarSaveContextProviderValue()
	local v6 = useDispatch()
	local v7 = useNavigation()

	local v8 = useSelectorSignal(selectCharacterData, tutils.deepEqual)
	local v9 = useSelectorSignal(selectHasAvatarData)

	local getHistorySignal, v10 = useSignal({})
	local getCurrentHistoryIndexSignal, v11 = useSignal(0)

	local getLastSuccessfullySavedStateSignal, v12 = useSignal(nil)

	local v13, v14 = useSignal(nil)
	local v15, v16 = useSignal(0)
	local v17, v18 = useSignal(false)

	React.useEffect(function()
		return Signals.createEffect(function(p)
			local v19 = v9(p)
			local v20 = v8(p)
			local v21 = getHistorySignal(false)

			local v22 = v20.equipped.BodyPartRangeIds and tutils.fieldCount(v20.equipped.BodyPartRangeIds) > 0

			if v19 and v22 and #v21 == 0 then
				v10({ v20 })
				v11(1)

				v12(v20)
				v14(nil)
				v16(0)
			end
		end)
	end, {})

	React.useEffect(function()
		return Signals.createEffect(function(p)
			local v19 = v8(p)
			local v20 = getHistorySignal(false)
			local v21 = getCurrentHistoryIndexSignal(false)
			local v22 = v20[v21] or v19

			if shouldInsertNewHistoryEntry(v22, v19) and #v20 > 0 then
				local slice = Dash.slice(v20, 1, v21)
				table.insert(slice, v19)
				local v23 = v21 + 1

				if defineFastInt2 < #slice then
					table.remove(slice, 1)
					v23 -= 1
				end

				v10(slice)
				v11(v23)
			elseif shouldReplaceLastHistoryEntry(v22, v19) and #v20 > 0 then
				local slice = Dash.slice(v20)
				slice[v21] = v19
				v10(slice)
				v11(v21)
			end
		end)
	end, {})

	local updateHistoryIndexAndGetCharacterData = React.useCallback(function(p: number)
		local v19 = getHistorySignal(false)

		if p < 1 or #v19 < p then
			return nil
		end

		v11(p)
		return v19[p]
	end, { getHistorySignal, v11 })

	local v19 = React.useCallback(function(p)
		local v19 = getHistorySignal(false)
		local v20 = getCurrentHistoryIndexSignal(false)
		local v21 = v19[v20]

		if not v21 then
			return nil
		end

		local v22, v23 = removeInvalidAssetsFromCharacterData(v21, p)

		if not v23 then
			return nil
		end

		v19[v20] = v22
		v10(v19)
		return v22
	end, { getHistorySignal, v10, v11 })

	local timeoutStatusStore = AvatarExperienceCommon.Stores.getTimeoutStatusStore()

	local getSaveEligibilityStatusSignal = useComputedSignal(function(p)
		if timeoutStatusStore and timeoutStatusStore.getIsTimedOut(p) then
			return SaveStatusEnum.TimedOut
		end

		local v20 = getHistorySignal(p)
		local v21 = getCurrentHistoryIndexSignal(p)
		local v22 = getLastSuccessfullySavedStateSignal(p)
		local v23 = v13(p)
		local v24 = v20[v21]

		if not (v24 and v22) then
			return SaveStatusEnum.NoData
		end

		if v23 then
			return SaveStatusEnum.Saving
		end

		if v22 and not checkHasChangesToSave(v24, v22) then
			return SaveStatusEnum.AlreadySaved
		end

		if checkCharacterDataHasTryOnItems(v24) then
			return SaveStatusEnum.HasTryOns
		end

		return SaveStatusEnum.Eligible
	end)

	local v20 = React.useCallback(function(p, p2, p3, _, p4)
		local v20 = SaveStatusEnum.Success
		local v21

		if p4.Assets then
			local invalidAssetIdsToAssetTypeIdMap = getInvalidAssetIdsToAssetTypeIdMap(
				getAssetIdToAssetTypeIdFromHumanoidDescription(p),
				getAssetIdToAssetTypeIdFromHumanoidDescription(p2)
			)

			v21 = v19(invalidAssetIdsToAssetTypeIdMap)

			p3 = removeInvalidAssetsFromCharacterData(p3, invalidAssetIdsToAssetTypeIdMap)
		end

		v12(p3)
		v14(nil)

		if v21 ~= nil then
			v20 = SaveStatusEnum.SuccessWithInvalidAssets
		end

		if v20 == SaveStatusEnum.Success then
			v6(SetCurrentToastMessage(v3))
		elseif v20 == SaveStatusEnum.SuccessWithInvalidAssets then
			v6(SetCurrentToastMessage(v2))
		end

		if v21 then
			v6(CharacterHistoryStateChangeButtonActivated(v21))
		end

		return v20
	end, { getHistorySignal, getCurrentHistoryIndexSignal, v12, v14, v19 })

	local v21 = React.useCallback(function(p)
		v14(nil)

		if p == SaveStatusEnum.Throttled then
			v6(SetCurrentToastMessage(v))
		else
			v6(SetCurrentToastMessage(v4))
		end
	end, { v14, v6 })

	local trySaveAvatar = React.useCallback(function()
		return Promise.new(function(callback, callback2)
			if timeoutStatusStore and timeoutStatusStore.getIsTimedOut(false) then
				if
					FFlagAXTimeoutAcknowledgementGating
					and timeoutStatusStore.getStatus(false).requiresAcknowledgement
				then
					AvatarExperienceCommon.Utils.showAvatarChangeFeatureRestriction()
				else
					v21(SaveStatusEnum.TimedOut)
				end
			else
				local v22 = getHistorySignal(false)
				local v23 = getCurrentHistoryIndexSignal(false)
				local v24 = getLastSuccessfullySavedStateSignal(false)
				local v25 = v22[v23]

				if v25 and v24 then
					local v26 = v15(false)

					if v26 > 0 and os.time() - v26 < defineFastInt then
						v21(SaveStatusEnum.Throttled)
						return
					end

					v14(v25)
					v16(os.time())
					local humanoidDescriptionForCharacterData = buildHumanoidDescriptionForCharacterData(v25) -- inferred equivalent call
					local v27 = Enum.HumanoidRigType[v25.equipped.AvatarType]
					local saveDict = getSaveDict(v25, v24)
					local backgroundAssetId

					if FFlagAXBackgroundsPersistence then
						backgroundAssetId = v25.equipped.BackgroundAssetId
					end

					local v28

					if saveDict.Background == true then
						v28 = backgroundAssetId ~= nil
					else
						v28 = false
					end

					local v29 = AvatarExperienceFlags.FFlagAXProfileConfigurationMultiFieldApply
						and { BackgroundAssetId = backgroundAssetId }
						or backgroundAssetId

					local v30 = false

					if FFlagAXBackgroundsPersistence then
						saveDict = Cryo.Dictionary.join(saveDict, { Background = Cryo.None })

						for _, save in saveDict do
							if save then
								v30 = true
								break
							end
						end
					end

					if v28 and not v30 then
						saveProfileConfiguration(v29):andThen(function()
							v18(false)
							v20(
								humanoidDescriptionForCharacterData,
								humanoidDescriptionForCharacterData,
								v25,
								v24,
								saveDict
							)

							callback()
						end):catch(function()
							v18(false)
							v21(SaveStatusEnum.Failure)
							callback2()
						end)
						return
					end

					local v31

					if v28 then
						v31 = saveProfileConfiguration(v29)
					else
						v31 = nil
					end

					saveAvatar(
						humanoidDescriptionForCharacterData,
						v27,
						saveDict,
						(getGearAssetIdFromEquippedAssets(v25.equipped.EquippedAssets))
					):andThen(function(p)
						v18(false)

						local function finishSuccess(p2) -- 3 equivalent calls inferred from this helper
							v20(
								humanoidDescriptionForCharacterData,
								p.humanoidDescriptionWithValidAssets,
								p2,
								v24,
								saveDict
							)

							callback()
						end

						if v31 then
							v31:andThen(function()
								finishSuccess(v25) -- inferred equivalent call
							end, function()
								local join = Cryo.Dictionary.join
								local join2 = Cryo.Dictionary.join
								local equipped = v25.equipped
								local backgroundAssetId2

								if v24.equipped.BackgroundAssetId == nil then
									backgroundAssetId2 = Cryo.None
								else
									backgroundAssetId2 = v24.equipped.BackgroundAssetId
								end

								finishSuccess(join(v25, { -- inferred equivalent call
									equipped = join2(equipped, {
										BackgroundAssetId = backgroundAssetId2
									})
								}))
							end)
							return
						end

						finishSuccess(v25) -- inferred equivalent call
					end):catch(function(_)
						v18(false)

						if timeoutStatusStore then
							timeoutStatusStore.fetchStatus()
						end

						v21(SaveStatusEnum.Failure)
						callback2()
					end)
				end
			end
		end)
	end, {
		timeoutStatusStore,
		getHistorySignal,
		getCurrentHistoryIndexSignal,
		v12,
		v14,
		v16,
		v19,
		v21,
		v18
	})

	if FFlagAXEnableManualSavingBlockingPrompt then
		local v22 = React.useCallback(function(name: string)
			return function()
				trySaveAvatar():finally(function()
					if FFlagSignalsNavP3Dispatch then
						navigationCommands.to(navigationCommands.fromLegacyPage({
							name = name,
							skipSaveBlockingPrompt = true
						}))
					else
						v6(NavigateToRoute({
							{ name = name, skipSaveBlockingPrompt = true }
						}))
					end
				end)
			end
		end, { trySaveAvatar, v6 })

		local v23 = React.useCallback(function(name: string)
			return function()
				task.spawn(function()
					v6(CharacterHistoryStateChangeButtonActivated((getLastSuccessfullySavedStateSignal(false))))

					task.wait()

					if FFlagSignalsNavP3Dispatch then
						navigationCommands.to(navigationCommands.fromLegacyPage({
							name = name,
							skipSaveBlockingPrompt = true
						}))
					else
						v6(NavigateToRoute({
							{ name = name, skipSaveBlockingPrompt = true }
						}))
					end
				end)
			end
		end, { v6, getLastSuccessfullySavedStateSignal })

		local v24 = React.useCallback(function(options, p)
			local routeName = (options or {}).routeName
			local params = (options or {}).params

			if
				options.type == Actions.Back
				and not options.immediate
				and p.routes[#p.routes]
				and p.routes[#p.routes].routeName == AvatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt
			then
				return true, nil
			end

			if
				options.type ~= Actions.Navigate
				or v5[routeName] == nil
				or params ~= nil and tutils.fieldCount(params) ~= 0
				or getSaveEligibilityStatusSignal(false) ~= SaveStatusEnum.Eligible
			then
				return false, nil
			end

			if
				p.routes[#p.routes]
				and p.routes[#p.routes].routeName == AvatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt
			then
				return true, nil
			end

			local joined = Cryo.List.join(p.routes, {
				{
					key = AvatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt,
					routeName = AvatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt,
					params = {
						saveAndContinue = v22(routeName),
						continueWithoutSave = v23(routeName)
					}
				}
			})

			return true, Cryo.Dictionary.join(p, {
				routes = joined,
				index = #joined
			})
		end, { getSaveEligibilityStatusSignal, v22, v23 })

		React.useEffect(function()
			v7.dispatch(RegisterCustomGetStateForAction(
				CustomGetStateForAction.HandlerId.BlockAXExitOnUnsavedChanges,
				v24
			))
		end, { v7, v24 })
	end

	React.useEffect(function()
		return Signals.createEffect(function(p)
			local v22 = getHistorySignal(p)

			if v22[#v22] and v17(false) then
				local v23 = getSaveEligibilityStatusSignal(false)

				if v23 == SaveStatusEnum.Eligible or v23 == SaveStatusEnum.HasTryOns then
					trySaveAvatar()
				end
			end
		end)
	end, {})

	local autoSaveNextNewSaveData = React.useCallback(function()
		v18(true)
	end, { v18 })

	return React.useMemo(function()
		return {
			getHistorySignal = getHistorySignal,
			getCurrentHistoryIndexSignal = getCurrentHistoryIndexSignal,
			updateHistoryIndexAndGetCharacterData = updateHistoryIndexAndGetCharacterData,
			getLastSuccessfullySavedStateSignal = getLastSuccessfullySavedStateSignal,
			getSaveEligibilityStatusSignal = getSaveEligibilityStatusSignal,
			trySaveAvatar = trySaveAvatar,
			autoSaveNextNewSaveData = autoSaveNextNewSaveData
		}
	end, {
		getHistorySignal,
		getCurrentHistoryIndexSignal,
		updateHistoryIndexAndGetCharacterData,
		getLastSuccessfullySavedStateSignal,
		getSaveEligibilityStatusSignal,
		trySaveAvatar,
		autoSaveNextNewSaveData
	})
end

return useAvatarSaveContextProviderValue
