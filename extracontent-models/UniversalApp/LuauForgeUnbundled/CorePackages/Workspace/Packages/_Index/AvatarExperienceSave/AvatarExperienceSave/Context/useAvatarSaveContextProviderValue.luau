local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/React")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/AvatarExperienceCommon")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/Dash")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/Cryo")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/Signals")
local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/ToastRodux")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/tutils")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/Navigation")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/RoactNavigation")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/AvatarExperienceNavigation")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/AvatarExperienceFlags")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/NavigationRodux")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/RobloxAppEnums")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/Promise")
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/LuauPolyfill")
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout

local useSelectorSignal = AvatarExperienceCommon.Hooks.useSelectorSignal
local useSignal = AvatarExperienceCommon.Hooks.useSignal
local useComputedSignal = AvatarExperienceCommon.Hooks.useComputedSignal
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigation = Navigation.useNavigation

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Context/AvatarSaveContext")
local SaveStatusEnum = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Enums/SaveStatusEnum")
local toastType = ToastRodux.Enums.ToastType
local actions = RoactNavigation.Actions
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local appPage = RobloxAppEnums.AppPage
local customGetStateForAction = AvatarExperienceNavigation.Enums.CustomGetStateForAction

local saveAvatar = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Requests/saveAvatar")
local saveProfileConfiguration = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Requests/saveProfileConfiguration")

local setCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local characterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated
local registerCustomGetStateForAction = AvatarExperienceNavigation.Actions.RegisterCustomGetStateForAction

local shouldInsertNewHistoryEntry = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Utils/shouldInsertNewHistoryEntry")
local shouldReplaceLastHistoryEntry = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Utils/shouldReplaceLastHistoryEntry")
local getSaveDict = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Utils/getSaveDict")
local checkHasChangesToSave = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Utils/checkHasChangesToSave")
local getInvalidAssetIdsToAssetTypeIdMap = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Utils/getInvalidAssetIdsToAssetTypeIdMap")
local removeInvalidAssetsFromCharacterData = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Utils/removeInvalidAssetsFromCharacterData")
local checkCharacterDataHasTryOnItems = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Utils/checkCharacterDataHasTryOnItems")
local selectCharacterData = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Selectors/selectCharacterData")
local selectHasAvatarData = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Selectors/selectHasAvatarData")
local navigateToRoute = NavigationRodux.Thunks.NavigateToRoute
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/RobloxAppNavigation").NavigationCommands else nil

local buildHumanoidDescription = AvatarExperienceCommon.Utils.buildHumanoidDescription
local getGearAssetIdFromEquippedAssets = AvatarExperienceCommon.Utils.getGearAssetIdFromEquippedAssets

local getAssetIdToAssetTypeIdFromHumanoidDescription = AvatarExperienceCommon.Utils.getAssetIdToAssetTypeIdFromHumanoidDescription

local defineFastInt = game:DefineFastInt("FIntAXMinSaveIntervalSeconds", 2)
local defineFastInt2 = game:DefineFastInt("AXMaxUndoRedoHistory", 20)
local fFlagAXEnableManualSavingBlockingPrompt = AvatarExperienceFlags.FFlagAXEnableManualSavingBlockingPrompt
local fFlagAXBackgroundsPersistence = AvatarExperienceFlags.FFlagAXBackgroundsPersistence
local fFlagAXTimeoutAcknowledgementGating = AvatarExperienceFlags.FFlagAXTimeoutAcknowledgementGating
local fFlagAXMomentsLookTryOnDelayAutoSave = AvatarExperienceFlags.FFlagAXMomentsLookTryOnDelayAutoSave

local v5 = {
	toastMessage = "Feature.Avatar.Message.SaveThrottled",
	isLocalized = false,
	toastType = toastType.InformationMessage
}

local v6 = {
	toastMessage = "Feature.Avatar.Message.SaveSuccessWithInvalidAssets",
	isLocalized = false,
	toastType = toastType.SuccessConfirmation
}

local v7 = {
	toastMessage = "Feature.Avatar.Message.SaveSuccess",
	isLocalized = false,
	toastType = toastType.SuccessConfirmation
}

local v8 = {
	toastMessage = "Feature.Avatar.Message.SaveFailure",
	isLocalized = false,
	toastType = toastType.InformationMessage
}

local v9 = {
	Home = appPage.Home,
	More = appPage.More,
	Chat = appPage.Chat,
	Games = appPage.Games
}

local function buildHumanoidDescriptionForCharacterData(p2)
	return buildHumanoidDescription({
		currentAssets = p2.equipped.EquippedAssets,
		avatarScales = p2.equipped.AvatarScales,
		bodyColor3s = p2.equipped.BodyColor3s,
		emotesSlotInfo = p2.equipped.EquippedEmotes.slotInfo
	})
end

local function useAvatarSaveContextProviderValue()
	local v10 = useDispatch()
	local v11 = useNavigation()

	local v12 = useSelectorSignal(selectCharacterData, tutils.deepEqual)
	local v13 = useSelectorSignal(selectHasAvatarData)

	local v14, v15 = useSignal({})
	local v16, v17 = useSignal(0)

	local v18, v19 = useSignal(nil)

	local v20, v21 = useSignal(nil)
	local v22, v23 = useSignal(0)
	local v24, v25 = useSignal(false)
	local v26, v27

	if fFlagAXMomentsLookTryOnDelayAutoSave then
		v26, v27 = useSignal(nil)
	else
		v26 = nil
		v27 = nil
	end

	React.useEffect(function()
		return Signals.createEffect(function(p2)
			local v28 = v13(p2)
			local v29 = v12(p2)
			local v30 = v14(false)

			local v31 = v29.equipped.BodyPartRangeIds
				and tutils.fieldCount(v29.equipped.BodyPartRangeIds) > 0

			if v28 and v31 and #v30 == 0 then
				v15({ v29 })
				v17(1)

				v19(v29)
				v21(nil)
				v23(0)
			end
		end)
	end, {})

	React.useEffect(function()
		return Signals.createEffect(function(p2)
			local v28 = v12(p2)
			local v29 = v14(false)
			local v30 = v16(false)
			local v31 = v29[v30] or v28

			if shouldInsertNewHistoryEntry(v31, v28) and #v29 > 0 then
				local slice = Dash.slice(v29, 1, v30)
				table.insert(slice, v28)
				local v32 = v30 + 1

				if defineFastInt2 < #slice then
					table.remove(slice, 1)
					v32 -= 1
				end

				v15(slice)
				v17(v32)
			elseif shouldReplaceLastHistoryEntry(v31, v28) and #v29 > 0 then
				local slice = Dash.slice(v29)
				slice[v30] = v28
				v15(slice)
				v17(v30)
			end
		end)
	end, {})

	local v28 = React.useCallback(function(p2)
		local v29 = v14(false)

		if p2 < 1 or #v29 < p2 then
			return nil
		end

		v17(p2)
		return v29[p2]
	end, { v14, v17 })

	local v29 = React.useCallback(function(p2)
		local v30 = v14(false)
		local v31 = v16(false)
		local v32 = v30[v31]

		if not v32 then
			return nil
		end

		local v33, v34 = removeInvalidAssetsFromCharacterData(v32, p2)

		if not v34 then
			return nil
		end

		v30[v31] = v33
		v15(v30)
		return v33
	end, { v14, v15, v17 })

	local timeoutStatusStore = AvatarExperienceCommon.Stores.getTimeoutStatusStore()

	local v30 = useComputedSignal(function(p2)
		if timeoutStatusStore and timeoutStatusStore.getIsTimedOut(p2) then
			return SaveStatusEnum.TimedOut
		end

		local v31 = v14(p2)
		local v32 = v16(p2)
		local v33 = v18(p2)
		local v34 = v20(p2)
		local v35 = v31[v32]

		if not (v35 and v33) then
			return SaveStatusEnum.NoData
		end

		if v34 then
			return SaveStatusEnum.Saving
		end

		if v33 and not checkHasChangesToSave(v35, v33) then
			return SaveStatusEnum.AlreadySaved
		end

		if checkCharacterDataHasTryOnItems(v35) then
			return SaveStatusEnum.HasTryOns
		end

		return SaveStatusEnum.Eligible
	end)

	local v31 = React.useCallback(function(p2, p3, p4, p5, p6)
		local v32 = SaveStatusEnum.Success
		local v33

		if p6.Assets then
			local v34 = getInvalidAssetIdsToAssetTypeIdMap(
				getAssetIdToAssetTypeIdFromHumanoidDescription(p2),
				getAssetIdToAssetTypeIdFromHumanoidDescription(p3)
			)

			v33 = v29(v34)

			p4 = removeInvalidAssetsFromCharacterData(p4, v34)
		end

		v19(p4)
		v21(nil)

		if v33 ~= nil then
			v32 = SaveStatusEnum.SuccessWithInvalidAssets
		end

		if v32 == SaveStatusEnum.Success then
			v10(setCurrentToastMessage(v7))
		elseif v32 == SaveStatusEnum.SuccessWithInvalidAssets then
			v10(setCurrentToastMessage(v6))
		end

		if v33 then
			v10(characterHistoryStateChangeButtonActivated(v33))
		end

		return v32
	end, { v14, v16, v19, v21, v29 })

	local v32 = React.useCallback(function(p2)
		v21(nil)

		if p2 == SaveStatusEnum.Throttled then
			v10(setCurrentToastMessage(v5))
		else
			v10(setCurrentToastMessage(v8))
		end
	end, { v21, v10 })

	local v33 = React.useCallback(function()
		return Promise.new(function(callback, callback2)
			if timeoutStatusStore and timeoutStatusStore.getIsTimedOut(false) then
				if
					fFlagAXTimeoutAcknowledgementGating
					and timeoutStatusStore.getStatus(false).requiresAcknowledgement
				then
					AvatarExperienceCommon.Utils.showAvatarChangeFeatureRestriction()
				else
					v32(SaveStatusEnum.TimedOut)
				end
			else
				local v34 = v14(false)
				local v35 = v16(false)
				local v36 = v18(false)
				local v37 = v34[v35]

				if v37 and v36 then
					local v38 = v22(false)

					if v38 > 0 and os.time() - v38 < defineFastInt then
						v32(SaveStatusEnum.Throttled)
						return
					end

					v21(v37)
					v23(os.time())
					local humanoidDescription = buildHumanoidDescription({
						currentAssets = v37.equipped.EquippedAssets,
						avatarScales = v37.equipped.AvatarScales,
						bodyColor3s = v37.equipped.BodyColor3s,
						emotesSlotInfo = v37.equipped.EquippedEmotes.slotInfo
					})

					local v39 = Enum.HumanoidRigType[v37.equipped.AvatarType]
					local joined = getSaveDict(v37, v36)

					local backgroundAssetId = if fFlagAXBackgroundsPersistence then v37.equipped.BackgroundAssetId else nil

					local v40 = joined.Background == true and backgroundAssetId ~= nil
					local v41 = AvatarExperienceFlags.FFlagAXProfileConfigurationMultiFieldApply
						and { BackgroundAssetId = backgroundAssetId }
						or backgroundAssetId

					local v42 = false

					if fFlagAXBackgroundsPersistence then
						joined = Cryo.Dictionary.join(joined, {
							Background = Cryo.None
						})

						for k, v44 in joined do
							if v44 then
								v42 = true
								break
							end
						end
					end

					if v40 and not v42 then
						saveProfileConfiguration(v41):andThen(function()
							v25(false)
							v31(humanoidDescription, humanoidDescription, v37, v36, joined)

							callback()
						end):catch(function()
							v25(false)
							v32(SaveStatusEnum.Failure)
							callback2()
						end)
						return
					end

					local v43 = if v40 then saveProfileConfiguration(v41) else nil

					saveAvatar(
						humanoidDescription,
						v39,
						joined,
						(getGearAssetIdFromEquippedAssets(v37.equipped.EquippedAssets))
					):andThen(function(p2)
						v25(false)

						local function finishSuccess(p3)
							v31(humanoidDescription, p2.humanoidDescriptionWithValidAssets, p3, v36, joined)

							callback()
						end

						if v43 then
							v43:andThen(function()
								v31(
									humanoidDescription,
									p2.humanoidDescriptionWithValidAssets,
									v37,
									v36,
									joined
								)

								callback()
							end, function()
								local join = Cryo.Dictionary.join
								local join2 = Cryo.Dictionary.join
								local equipped = v37.equipped
								local v47 = if v36.equipped.BackgroundAssetId == nil then Cryo.None else v36.equipped.BackgroundAssetId
								local v48 = join(v37, {
									equipped = join2(equipped, {
										BackgroundAssetId = v47
									})
								})
								v31(
									humanoidDescription,
									p2.humanoidDescriptionWithValidAssets,
									v48,
									v36,
									joined
								)

								callback()
							end)
							return
						end

						v31(humanoidDescription, p2.humanoidDescriptionWithValidAssets, v37, v36, joined)

						callback()
					end):catch(function(p2)
						v25(false)

						if timeoutStatusStore then
							timeoutStatusStore.fetchStatus()
						end

						v32(SaveStatusEnum.Failure)
						callback2()
					end)
				end
			end
		end)
	end, {
		timeoutStatusStore,
		v14,
		v16,
		v19,
		v21,
		v23,
		v29,
		v32,
		v25
	})

	if fFlagAXEnableManualSavingBlockingPrompt then
		local v34 = React.useCallback(function(p2)
			return function()
				v33():finally(function()
					if fFlagSignalsNavP3Dispatch then
						navigationCommands.to(navigationCommands.fromLegacyPage({
							name = p2,
							skipSaveBlockingPrompt = true
						}))
					else
						v10(navigateToRoute({
							{ name = p2, skipSaveBlockingPrompt = true }
						}))
					end
				end)
			end
		end, { v33, v10 })

		local v35 = React.useCallback(function(p2)
			return function()
				task.spawn(function()
					v10(characterHistoryStateChangeButtonActivated((v18(false))))

					task.wait()

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.to(navigationCommands.fromLegacyPage({
							name = p2,
							skipSaveBlockingPrompt = true
						}))
					else
						v10(navigateToRoute({
							{ name = p2, skipSaveBlockingPrompt = true }
						}))
					end
				end)
			end
		end, { v10, v18 })

		local v36 = React.useCallback(function(options, p2)
			local routeName = (options or {}).routeName
			local params = (options or {}).params

			if
				options.type == actions.Back
				and not options.immediate
				and p2.routes[#p2.routes]
				and p2.routes[#p2.routes].routeName == avatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt
			then
				return true, nil
			end

			if
				options.type ~= actions.Navigate
				or v9[routeName] == nil
				or params ~= nil and tutils.fieldCount(params) ~= 0
				or v30(false) ~= SaveStatusEnum.Eligible
			then
				return false, nil
			end

			if
				p2.routes[#p2.routes]
				and p2.routes[#p2.routes].routeName == avatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt
			then
				return true, nil
			end

			local joined = Cryo.List.join(p2.routes, {
				{
					key = avatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt,
					routeName = avatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt,
					params = {
						saveAndContinue = v34(routeName),
						continueWithoutSave = v35(routeName)
					}
				}
			})

			return true, Cryo.Dictionary.join(p2, {
				routes = joined,
				index = #joined
			})
		end, { v30, v34, v35 })

		React.useEffect(function()
			v11.dispatch(registerCustomGetStateForAction(
				customGetStateForAction.HandlerId.BlockAXExitOnUnsavedChanges,
				v36
			))
		end, { v11, v36 })
	end

	local v34, v35

	if fFlagAXMomentsLookTryOnDelayAutoSave then
		local ref = React.useRef(nil)

		local v36 = React.useCallback(function(p2)
			if ref.current ~= nil then
				clearTimeout(ref.current)
				ref.current = nil
			end

			if p2 == nil then
				return
			end

			ref.current = setTimeout(function()
				ref.current = nil
				local v37 = v30(false)

				if v37 == SaveStatusEnum.Eligible or v37 == SaveStatusEnum.HasTryOns then
					v33()
				end
			end, p2)
		end, { v33, v30 })

		React.useEffect(function()
			return function()
				v36(nil)
			end
		end, {})
		v34 = v36
		v35 = ref
	else
		v35 = nil
		v34 = nil
	end

	React.useEffect(function()
		return Signals.createEffect(function(p2)
			local v36 = v14(p2)

			if v36[#v36] and v24(false) then
				local v37 = v30(false)

				if v37 == SaveStatusEnum.Eligible or v37 == SaveStatusEnum.HasTryOns then
					if
						fFlagAXMomentsLookTryOnDelayAutoSave
						and v35
						and v34
						and v26
						and v26(false) ~= nil
					then
						if v35.current == nil then
							v34(v26(false))
						end
					else
						v33()
					end
				end
			end
		end)
	end, {})

	local useCallback = React.useCallback
	local function fn(p2)
		if fFlagAXMomentsLookTryOnDelayAutoSave and v27 then
			v27(p2)

			if v35 and v35.current ~= nil and v34 then
				v34(p2)
			end
		end

		v25(true)
	end

	local v37 = if fFlagAXMomentsLookTryOnDelayAutoSave then v27 else nil
	local v39 = useCallback(fn, { v25, v37, if fFlagAXMomentsLookTryOnDelayAutoSave then v34 else nil })

	return React.useMemo(function()
		return {
			getHistorySignal = v14,
			getCurrentHistoryIndexSignal = v16,
			updateHistoryIndexAndGetCharacterData = v28,
			getLastSuccessfullySavedStateSignal = v18,
			getSaveEligibilityStatusSignal = v30,
			trySaveAvatar = v33,
			autoSaveNextNewSaveData = v39
		}
	end, { v14, v16, v28, v18, v30, v33, v39 })
end

return useAvatarSaveContextProviderValue
