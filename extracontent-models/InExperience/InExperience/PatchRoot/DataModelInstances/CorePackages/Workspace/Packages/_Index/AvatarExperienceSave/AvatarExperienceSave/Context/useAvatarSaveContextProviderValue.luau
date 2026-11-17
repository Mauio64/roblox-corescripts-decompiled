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
local LuauPolyfill = require(parent.LuauPolyfill)
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout

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
local FFlagAXMomentsLookTryOnDelayAutoSave = AvatarExperienceFlags.FFlagAXMomentsLookTryOnDelayAutoSave

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
	local v19, v20

	if FFlagAXMomentsLookTryOnDelayAutoSave then
		v19, v20 = useSignal(nil)
	else
		v19 = nil
		v20 = nil
	end

	React.useEffect(function()
		return Signals.createEffect(function(p)
			local v21 = v9(p)
			local v22 = v8(p)
			local v23 = getHistorySignal(false)

			local v24 = v22.equipped.BodyPartRangeIds and tutils.fieldCount(v22.equipped.BodyPartRangeIds) > 0

			if v21 and v24 and #v23 == 0 then
				v10({ v22 })
				v11(1)

				v12(v22)
				v14(nil)
				v16(0)
			end
		end)
	end, {})

	React.useEffect(function()
		return Signals.createEffect(function(p)
			local v21 = v8(p)
			local v22 = getHistorySignal(false)
			local v23 = getCurrentHistoryIndexSignal(false)
			local v24 = v22[v23] or v21

			if shouldInsertNewHistoryEntry(v24, v21) and #v22 > 0 then
				local slice = Dash.slice(v22, 1, v23)
				table.insert(slice, v21)
				local v25 = v23 + 1

				if defineFastInt2 < #slice then
					table.remove(slice, 1)
					v25 -= 1
				end

				v10(slice)
				v11(v25)
			elseif shouldReplaceLastHistoryEntry(v24, v21) and #v22 > 0 then
				local slice = Dash.slice(v22)
				slice[v23] = v21
				v10(slice)
				v11(v23)
			end
		end)
	end, {})

	local updateHistoryIndexAndGetCharacterData = React.useCallback(function(p: number)
		local v21 = getHistorySignal(false)

		if p < 1 or #v21 < p then
			return nil
		end

		v11(p)
		return v21[p]
	end, { getHistorySignal, v11 })

	local v21 = React.useCallback(function(p)
		local v21 = getHistorySignal(false)
		local v22 = getCurrentHistoryIndexSignal(false)
		local v23 = v21[v22]

		if not v23 then
			return nil
		end

		local v24, v25 = removeInvalidAssetsFromCharacterData(v23, p)

		if not v25 then
			return nil
		end

		v21[v22] = v24
		v10(v21)
		return v24
	end, { getHistorySignal, v10, v11 })

	local timeoutStatusStore = AvatarExperienceCommon.Stores.getTimeoutStatusStore()

	local getSaveEligibilityStatusSignal = useComputedSignal(function(p)
		if timeoutStatusStore and timeoutStatusStore.getIsTimedOut(p) then
			return SaveStatusEnum.TimedOut
		end

		local v22 = getHistorySignal(p)
		local v23 = getCurrentHistoryIndexSignal(p)
		local v24 = getLastSuccessfullySavedStateSignal(p)
		local v25 = v13(p)
		local v26 = v22[v23]

		if not (v26 and v24) then
			return SaveStatusEnum.NoData
		end

		if v25 then
			return SaveStatusEnum.Saving
		end

		if v24 and not checkHasChangesToSave(v26, v24) then
			return SaveStatusEnum.AlreadySaved
		end

		if checkCharacterDataHasTryOnItems(v26) then
			return SaveStatusEnum.HasTryOns
		end

		return SaveStatusEnum.Eligible
	end)

	local v22 = React.useCallback(function(p, p2, p3, _, p4)
		local v22 = SaveStatusEnum.Success
		local v23

		if p4.Assets then
			local invalidAssetIdsToAssetTypeIdMap = getInvalidAssetIdsToAssetTypeIdMap(
				getAssetIdToAssetTypeIdFromHumanoidDescription(p),
				getAssetIdToAssetTypeIdFromHumanoidDescription(p2)
			)

			v23 = v21(invalidAssetIdsToAssetTypeIdMap)

			p3 = removeInvalidAssetsFromCharacterData(p3, invalidAssetIdsToAssetTypeIdMap)
		end

		v12(p3)
		v14(nil)

		if v23 ~= nil then
			v22 = SaveStatusEnum.SuccessWithInvalidAssets
		end

		if v22 == SaveStatusEnum.Success then
			v6(SetCurrentToastMessage(v3))
		elseif v22 == SaveStatusEnum.SuccessWithInvalidAssets then
			v6(SetCurrentToastMessage(v2))
		end

		if v23 then
			v6(CharacterHistoryStateChangeButtonActivated(v23))
		end

		return v22
	end, { getHistorySignal, getCurrentHistoryIndexSignal, v12, v14, v21 })

	local v23 = React.useCallback(function(p)
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
					v23(SaveStatusEnum.TimedOut)
				end
			else
				local v24 = getHistorySignal(false)
				local v25 = getCurrentHistoryIndexSignal(false)
				local v26 = getLastSuccessfullySavedStateSignal(false)
				local v27 = v24[v25]

				if v27 and v26 then
					local v28 = v15(false)

					if v28 > 0 and os.time() - v28 < defineFastInt then
						v23(SaveStatusEnum.Throttled)
						return
					end

					v14(v27)
					v16(os.time())
					local humanoidDescriptionForCharacterData = buildHumanoidDescriptionForCharacterData(v27) -- inferred equivalent call
					local v29 = Enum.HumanoidRigType[v27.equipped.AvatarType]
					local saveDict = getSaveDict(v27, v26)
					local backgroundAssetId

					if FFlagAXBackgroundsPersistence then
						backgroundAssetId = v27.equipped.BackgroundAssetId
					end

					local v30

					if saveDict.Background == true then
						v30 = backgroundAssetId ~= nil
					else
						v30 = false
					end

					local v31 = AvatarExperienceFlags.FFlagAXProfileConfigurationMultiFieldApply
						and { BackgroundAssetId = backgroundAssetId }
						or backgroundAssetId

					local v32 = false

					if FFlagAXBackgroundsPersistence then
						saveDict = Cryo.Dictionary.join(saveDict, { Background = Cryo.None })

						for _, save in saveDict do
							if save then
								v32 = true
								break
							end
						end
					end

					if v30 and not v32 then
						saveProfileConfiguration(v31):andThen(function()
							v18(false)
							v22(
								humanoidDescriptionForCharacterData,
								humanoidDescriptionForCharacterData,
								v27,
								v26,
								saveDict
							)

							callback()
						end):catch(function()
							v18(false)
							v23(SaveStatusEnum.Failure)
							callback2()
						end)
						return
					end

					local v39

					if v30 then
						v39 = saveProfileConfiguration(v31)
					else
						v39 = nil
					end

					saveAvatar(
						humanoidDescriptionForCharacterData,
						v29,
						saveDict,
						(getGearAssetIdFromEquippedAssets(v27.equipped.EquippedAssets))
					):andThen(function(p)
						v18(false)

						local function finishSuccess(p2) -- 3 equivalent calls inferred from this helper
							v22(
								humanoidDescriptionForCharacterData,
								p.humanoidDescriptionWithValidAssets,
								p2,
								v26,
								saveDict
							)

							callback()
						end

						if v39 then
							v39:andThen(function()
								finishSuccess(v27) -- inferred equivalent call
							end, function()
								local join = Cryo.Dictionary.join
								local join2 = Cryo.Dictionary.join
								local equipped = v27.equipped
								local backgroundAssetId2

								if v26.equipped.BackgroundAssetId == nil then
									backgroundAssetId2 = Cryo.None
								else
									backgroundAssetId2 = v26.equipped.BackgroundAssetId
								end

								finishSuccess(join(v27, { -- inferred equivalent call
									equipped = join2(equipped, {
										BackgroundAssetId = backgroundAssetId2
									})
								}))
							end)
							return
						end

						finishSuccess(v27) -- inferred equivalent call
					end):catch(function(_)
						v18(false)

						if timeoutStatusStore then
							timeoutStatusStore.fetchStatus()
						end

						v23(SaveStatusEnum.Failure)
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
		v21,
		v23,
		v18
	})

	if FFlagAXEnableManualSavingBlockingPrompt then
		local v24 = React.useCallback(function(name: string)
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

		local v25 = React.useCallback(function(name: string)
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

		local v26 = React.useCallback(function(options, p)
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
						saveAndContinue = v24(routeName),
						continueWithoutSave = v25(routeName)
					}
				}
			})

			return true, Cryo.Dictionary.join(p, {
				routes = joined,
				index = #joined
			})
		end, { getSaveEligibilityStatusSignal, v24, v25 })

		React.useEffect(function()
			v7.dispatch(RegisterCustomGetStateForAction(
				CustomGetStateForAction.HandlerId.BlockAXExitOnUnsavedChanges,
				v26
			))
		end, { v7, v26 })
	end

	local v24, v25

	if FFlagAXMomentsLookTryOnDelayAutoSave then
		local ref = React.useRef(nil)

		local v26 = React.useCallback(function(p: number?)
			if ref.current ~= nil then
				clearTimeout(ref.current)
				ref.current = nil
			end

			if p == nil then
				return
			end

			ref.current = setTimeout(function()
				ref.current = nil
				local v26 = getSaveEligibilityStatusSignal(false)

				if v26 == SaveStatusEnum.Eligible or v26 == SaveStatusEnum.HasTryOns then
					trySaveAvatar()
				end
			end, p)
		end, { trySaveAvatar, getSaveEligibilityStatusSignal })

		React.useEffect(function()
			return function()
				v26(nil)
			end
		end, {})
		v24 = v26
		v25 = ref
	else
		v25 = nil
		v24 = nil
	end

	React.useEffect(function()
		return Signals.createEffect(function(p)
			local v26 = getHistorySignal(p)

			if v26[#v26] and v17(false) then
				local v27 = getSaveEligibilityStatusSignal(false)

				if v27 == SaveStatusEnum.Eligible or v27 == SaveStatusEnum.HasTryOns then
					if FFlagAXMomentsLookTryOnDelayAutoSave and v25 and v24 and v19 and v19(false) ~= nil then
						if v25.current == nil then
							v24(v19(false))
						end
					else
						trySaveAvatar()
					end
				end
			end
		end)
	end, {})

	local useCallback = React.useCallback
	local function fn(p: number?)
		if FFlagAXMomentsLookTryOnDelayAutoSave and v20 then
			v20(p)

			if v25 and v25.current ~= nil and v24 then
				v24(p)
			end
		end

		v18(true)
	end

	local v26

	if FFlagAXMomentsLookTryOnDelayAutoSave then
		v26 = v20
	end

	local v27

	if FFlagAXMomentsLookTryOnDelayAutoSave then
		v27 = v24
	end

	local autoSaveNextNewSaveData = useCallback(fn, { v18, v26, v27 })

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
