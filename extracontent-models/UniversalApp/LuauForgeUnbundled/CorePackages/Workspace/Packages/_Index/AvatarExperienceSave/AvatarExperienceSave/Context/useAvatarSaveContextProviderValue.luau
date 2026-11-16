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

	React.useEffect(function()
		return Signals.createEffect(function(p2)
			local v26 = v13(p2)
			local v27 = v12(p2)
			local v28 = v14(false)

			local v29 = v27.equipped.BodyPartRangeIds
				and tutils.fieldCount(v27.equipped.BodyPartRangeIds) > 0

			if v26 and v29 and #v28 == 0 then
				v15({ v27 })
				v17(1)

				v19(v27)
				v21(nil)
				v23(0)
			end
		end)
	end, {})

	React.useEffect(function()
		return Signals.createEffect(function(p2)
			local v26 = v12(p2)
			local v27 = v14(false)
			local v28 = v16(false)
			local v29 = v27[v28] or v26

			if shouldInsertNewHistoryEntry(v29, v26) and #v27 > 0 then
				local slice = Dash.slice(v27, 1, v28)
				table.insert(slice, v26)
				local v30 = v28 + 1

				if defineFastInt2 < #slice then
					table.remove(slice, 1)
					v30 -= 1
				end

				v15(slice)
				v17(v30)
			elseif shouldReplaceLastHistoryEntry(v29, v26) and #v27 > 0 then
				local slice = Dash.slice(v27)
				slice[v28] = v26
				v15(slice)
				v17(v28)
			end
		end)
	end, {})

	local v26 = React.useCallback(function(p2)
		local v27 = v14(false)

		if p2 < 1 or #v27 < p2 then
			return nil
		end

		v17(p2)
		return v27[p2]
	end, { v14, v17 })

	local v27 = React.useCallback(function(p2)
		local v28 = v14(false)
		local v29 = v16(false)
		local v30 = v28[v29]

		if not v30 then
			return nil
		end

		local v31, v32 = removeInvalidAssetsFromCharacterData(v30, p2)

		if not v32 then
			return nil
		end

		v28[v29] = v31
		v15(v28)
		return v31
	end, { v14, v15, v17 })

	local timeoutStatusStore = AvatarExperienceCommon.Stores.getTimeoutStatusStore()

	local v28 = useComputedSignal(function(p2)
		if timeoutStatusStore and timeoutStatusStore.getIsTimedOut(p2) then
			return SaveStatusEnum.TimedOut
		end

		local v29 = v14(p2)
		local v30 = v16(p2)
		local v31 = v18(p2)
		local v32 = v20(p2)
		local v33 = v29[v30]

		if not (v33 and v31) then
			return SaveStatusEnum.NoData
		end

		if v32 then
			return SaveStatusEnum.Saving
		end

		if v31 and not checkHasChangesToSave(v33, v31) then
			return SaveStatusEnum.AlreadySaved
		end

		if checkCharacterDataHasTryOnItems(v33) then
			return SaveStatusEnum.HasTryOns
		end

		return SaveStatusEnum.Eligible
	end)

	local v29 = React.useCallback(function(p2, p3, p4, p5, p6)
		local v30 = SaveStatusEnum.Success
		local v31

		if p6.Assets then
			local v32 = getInvalidAssetIdsToAssetTypeIdMap(
				getAssetIdToAssetTypeIdFromHumanoidDescription(p2),
				getAssetIdToAssetTypeIdFromHumanoidDescription(p3)
			)

			v31 = v27(v32)

			p4 = removeInvalidAssetsFromCharacterData(p4, v32)
		end

		v19(p4)
		v21(nil)

		if v31 ~= nil then
			v30 = SaveStatusEnum.SuccessWithInvalidAssets
		end

		if v30 == SaveStatusEnum.Success then
			v10(setCurrentToastMessage(v7))
		elseif v30 == SaveStatusEnum.SuccessWithInvalidAssets then
			v10(setCurrentToastMessage(v6))
		end

		if v31 then
			v10(characterHistoryStateChangeButtonActivated(v31))
		end

		return v30
	end, { v14, v16, v19, v21, v27 })

	local v30 = React.useCallback(function(p2)
		v21(nil)

		if p2 == SaveStatusEnum.Throttled then
			v10(setCurrentToastMessage(v5))
		else
			v10(setCurrentToastMessage(v8))
		end
	end, { v21, v10 })

	local v31 = React.useCallback(function()
		return Promise.new(function(callback, callback2)
			if timeoutStatusStore and timeoutStatusStore.getIsTimedOut(false) then
				if
					fFlagAXTimeoutAcknowledgementGating
					and timeoutStatusStore.getStatus(false).requiresAcknowledgement
				then
					AvatarExperienceCommon.Utils.showAvatarChangeFeatureRestriction()
				else
					v30(SaveStatusEnum.TimedOut)
				end
			else
				local v32 = v14(false)
				local v33 = v16(false)
				local v34 = v18(false)
				local v35 = v32[v33]

				if v35 and v34 then
					local v36 = v22(false)

					if v36 > 0 and os.time() - v36 < defineFastInt then
						v30(SaveStatusEnum.Throttled)
						return
					end

					v21(v35)
					v23(os.time())
					local humanoidDescription = buildHumanoidDescription({
						currentAssets = v35.equipped.EquippedAssets,
						avatarScales = v35.equipped.AvatarScales,
						bodyColor3s = v35.equipped.BodyColor3s,
						emotesSlotInfo = v35.equipped.EquippedEmotes.slotInfo
					})

					local v37 = Enum.HumanoidRigType[v35.equipped.AvatarType]
					local joined = getSaveDict(v35, v34)

					local backgroundAssetId = if fFlagAXBackgroundsPersistence then v35.equipped.BackgroundAssetId else nil

					local v38 = joined.Background == true and backgroundAssetId ~= nil
					local v39 = AvatarExperienceFlags.FFlagAXProfileConfigurationMultiFieldApply
						and { BackgroundAssetId = backgroundAssetId }
						or backgroundAssetId

					local v40 = false

					if fFlagAXBackgroundsPersistence then
						joined = Cryo.Dictionary.join(joined, {
							Background = Cryo.None
						})

						for k, v42 in joined do
							if v42 then
								v40 = true
								break
							end
						end
					end

					if v38 and not v40 then
						saveProfileConfiguration(v39):andThen(function()
							v25(false)
							v29(humanoidDescription, humanoidDescription, v35, v34, joined)

							callback()
						end):catch(function()
							v25(false)
							v30(SaveStatusEnum.Failure)
							callback2()
						end)
						return
					end

					local v41 = if v38 then saveProfileConfiguration(v39) else nil

					saveAvatar(
						humanoidDescription,
						v37,
						joined,
						(getGearAssetIdFromEquippedAssets(v35.equipped.EquippedAssets))
					):andThen(function(p2)
						v25(false)

						local function finishSuccess(p3)
							v29(humanoidDescription, p2.humanoidDescriptionWithValidAssets, p3, v34, joined)

							callback()
						end

						if v41 then
							v41:andThen(function()
								v29(
									humanoidDescription,
									p2.humanoidDescriptionWithValidAssets,
									v35,
									v34,
									joined
								)

								callback()
							end, function()
								local join = Cryo.Dictionary.join
								local join2 = Cryo.Dictionary.join
								local equipped = v35.equipped
								local v45 = if v34.equipped.BackgroundAssetId == nil then Cryo.None else v34.equipped.BackgroundAssetId
								local v46 = join(v35, {
									equipped = join2(equipped, {
										BackgroundAssetId = v45
									})
								})
								v29(
									humanoidDescription,
									p2.humanoidDescriptionWithValidAssets,
									v46,
									v34,
									joined
								)

								callback()
							end)
							return
						end

						v29(humanoidDescription, p2.humanoidDescriptionWithValidAssets, v35, v34, joined)

						callback()
					end):catch(function(p2)
						v25(false)

						if timeoutStatusStore then
							timeoutStatusStore.fetchStatus()
						end

						v30(SaveStatusEnum.Failure)
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
		v27,
		v30,
		v25
	})

	if fFlagAXEnableManualSavingBlockingPrompt then
		local v32 = React.useCallback(function(p2)
			return function()
				v31():finally(function()
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
		end, { v31, v10 })

		local v33 = React.useCallback(function(p2)
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

		local v34 = React.useCallback(function(options, p2)
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
				or v28(false) ~= SaveStatusEnum.Eligible
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
						saveAndContinue = v32(routeName),
						continueWithoutSave = v33(routeName)
					}
				}
			})

			return true, Cryo.Dictionary.join(p2, {
				routes = joined,
				index = #joined
			})
		end, { v28, v32, v33 })

		React.useEffect(function()
			v11.dispatch(registerCustomGetStateForAction(
				customGetStateForAction.HandlerId.BlockAXExitOnUnsavedChanges,
				v34
			))
		end, { v11, v34 })
	end

	React.useEffect(function()
		return Signals.createEffect(function(p2)
			local v32 = v14(p2)

			if v32[#v32] and v24(false) then
				local v33 = v28(false)

				if v33 == SaveStatusEnum.Eligible or v33 == SaveStatusEnum.HasTryOns then
					v31()
				end
			end
		end)
	end, {})

	local v32 = React.useCallback(function()
		v25(true)
	end, { v25 })

	return React.useMemo(function()
		return {
			getHistorySignal = v14,
			getCurrentHistoryIndexSignal = v16,
			updateHistoryIndexAndGetCharacterData = v26,
			getLastSuccessfullySavedStateSignal = v18,
			getSaveEligibilityStatusSignal = v28,
			trySaveAvatar = v31,
			autoSaveNextNewSaveData = v32
		}
	end, { v14, v16, v26, v18, v28, v31, v32 })
end

return useAvatarSaveContextProviderValue
