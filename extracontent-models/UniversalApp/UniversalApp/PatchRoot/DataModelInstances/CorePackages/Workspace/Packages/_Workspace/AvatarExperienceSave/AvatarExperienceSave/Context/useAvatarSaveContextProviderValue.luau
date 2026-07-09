local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")
local AvatarExperienceSaveParent = AvatarExperienceSave.Parent
local React = require(AvatarExperienceSaveParent.React)
local AvatarExperienceCommon = require(AvatarExperienceSaveParent.AvatarExperienceCommon)
local Dash = require(AvatarExperienceSaveParent.Dash)
local Cryo = require(AvatarExperienceSaveParent.Cryo)
local Signals = require(AvatarExperienceSaveParent.Signals)
local ToastRodux = require(AvatarExperienceSaveParent.ToastRodux)
local tutils = require(AvatarExperienceSaveParent.tutils)
local Navigation = require(AvatarExperienceSaveParent.Navigation)
local RoactNavigation = require(AvatarExperienceSaveParent.RoactNavigation)
local AvatarExperienceNavigation = require(AvatarExperienceSaveParent.AvatarExperienceNavigation)
local AvatarExperienceFlags = require(AvatarExperienceSaveParent.AvatarExperienceFlags)
local NavigationRodux = require(AvatarExperienceSaveParent.NavigationRodux)
local RobloxAppEnums = require(AvatarExperienceSaveParent.RobloxAppEnums)
local Promise = require(AvatarExperienceSaveParent.Promise)
local useSelectorSignal = AvatarExperienceCommon.Hooks.useSelectorSignal
local useSignal = AvatarExperienceCommon.Hooks.useSignal
local useComputedSignal = AvatarExperienceCommon.Hooks.useComputedSignal
local useDispatch = require(AvatarExperienceSaveParent.RoactUtils).Hooks.RoactRodux.useDispatch
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
local FFlagSignalsNavP3Dispatch = require(AvatarExperienceSaveParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v44 = if not FFlagSignalsNavP3Dispatch then nil else require(AvatarExperienceSaveParent.RobloxAppNavigation).NavigationCommands
local buildHumanoidDescription = AvatarExperienceCommon.Utils.buildHumanoidDescription
local getGearAssetIdFromEquippedAssets = AvatarExperienceCommon.Utils.getGearAssetIdFromEquippedAssets
local getAssetIdToAssetTypeIdFromHumanoidDescription = AvatarExperienceCommon.Utils.getAssetIdToAssetTypeIdFromHumanoidDescription
local v48 = game:DefineFastInt("FIntAXMinSaveIntervalSeconds", 2)
local v49 = game:DefineFastInt("AXMaxUndoRedoHistory", 20)
local v50 = game:DefineFastFlag("AXEnableMaxUndoRedoHistory", false)
local FFlagAXAvatarTimeoutFlow = AvatarExperienceFlags.FFlagAXAvatarTimeoutFlow
local FFlagAXEnableManualSavingBlockingPrompt = AvatarExperienceFlags.FFlagAXEnableManualSavingBlockingPrompt
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local FFlagAXBackgroundsPersistence = AvatarExperienceFlags.FFlagAXBackgroundsPersistence
local t1 = {
	toastMessage = "Feature.Avatar.Message.SaveThrottled",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}
local t2 = {
	toastMessage = "Feature.Avatar.Message.SaveSuccessWithInvalidAssets",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}
local t3 = {
	toastMessage = "Feature.Avatar.Message.SaveSuccess",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}
local t4 = {
	toastMessage = "Feature.Avatar.Message.SaveFailure",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}
local t5 = {
	Home = AppPage.Home,
	More = AppPage.More,
	Chat = AppPage.Chat,
	Games = AppPage.Games
}

local function buildHumanoidDescriptionForCharacterData(p1) -- line: 100
	-- upvalues: buildHumanoidDescription (copy)
	return buildHumanoidDescription({
		currentAssets = p1.equipped.EquippedAssets,
		avatarScales = p1.equipped.AvatarScales,
		bodyColor3s = p1.equipped.BodyColor3s,
		emotesSlotInfo = p1.equipped.EquippedEmotes.slotInfo
	})
end
local function useAvatarSaveContextProviderValue() -- line: 111
	-- upvalues: useDispatch (copy), useNavigation (copy), useSelectorSignal (copy), selectCharacterData (copy), tutils (copy), selectHasAvatarData (copy), useSignal (copy), React (copy), Signals (copy), shouldInsertNewHistoryEntry (copy), Dash (copy), v50 (copy), v49 (copy), FFlagAXCustomizeMakeupSupport (copy), shouldReplaceLastHistoryEntry (copy), removeInvalidAssetsFromCharacterData (copy), AvatarExperienceCommon (copy), FFlagAXAvatarTimeoutFlow (copy), useComputedSignal (copy), SaveStatusEnum (copy), checkHasChangesToSave (copy), checkCharacterDataHasTryOnItems (copy), getInvalidAssetIdsToAssetTypeIdMap (copy), getAssetIdToAssetTypeIdFromHumanoidDescription (copy), SetCurrentToastMessage (copy), t3 (copy), t2 (copy), CharacterHistoryStateChangeButtonActivated (copy), t1 (copy), t4 (copy), Promise (copy), v48 (copy), buildHumanoidDescription (copy), getSaveDict (copy), FFlagAXBackgroundsPersistence (copy), Cryo (copy), saveProfileConfiguration (copy), getGearAssetIdFromEquippedAssets (copy), saveAvatar (copy), FFlagAXEnableManualSavingBlockingPrompt (copy), FFlagSignalsNavP3Dispatch (copy), v44 (copy), NavigateToRoute (copy), Actions (copy), AvatarScreen (copy), t5 (copy), RegisterCustomGetStateForAction (copy), CustomGetStateForAction (copy)
	local v63 = useDispatch()
	local v64 = useNavigation()
	local v65 = useSelectorSignal(selectCharacterData, tutils.deepEqual)
	local v66 = useSelectorSignal(selectHasAvatarData)
	local v67, v68 = useSignal({})
	local v69, v70 = useSignal(0)
	local v71, v72 = useSignal(nil)
	local v73, v74 = useSignal(nil)
	local v75, v76 = useSignal(0)
	local v77, v78 = useSignal(false)

	React.useEffect(function() -- line: 133
		-- upvalues: Signals (copy), v66 (copy), v65 (copy), v67 (copy), tutils (copy), v68 (copy), v70 (copy), v72 (copy), v74 (copy), v76 (copy)
		return Signals.createEffect(function(p2) -- line: 134
			-- upvalues: v66 (copy), v65 (copy), v67 (copy), tutils (copy), v68 (copy), v70 (copy), v72 (copy), v74 (copy), v76 (copy)
			local v122 = v66(p2)
			local v123 = v65(p2)
			local v124 = v67(false)
			local v125 = v123.equipped.BodyPartRangeIds and tutils.fieldCount(v123.equipped.BodyPartRangeIds) > 0

			if v122 and (v125 and #v124 == 0) then
				v68({ v123 })
				v70(1)
				v72(v123)
				v74(nil)
				v76(0)
			end
		end)
	end, {})
	React.useEffect(function() -- line: 157
		-- upvalues: Signals (copy), v65 (copy), v67 (copy), v69 (copy), shouldInsertNewHistoryEntry (copy), Dash (copy), v50 (copy), v49 (copy), v68 (copy), v70 (copy), FFlagAXCustomizeMakeupSupport (copy), shouldReplaceLastHistoryEntry (copy)
		return Signals.createEffect(function(p3) -- line: 158
			-- upvalues: v65 (copy), v67 (copy), v69 (copy), shouldInsertNewHistoryEntry (copy), Dash (copy), v50 (copy), v49 (copy), v68 (copy), v70 (copy), FFlagAXCustomizeMakeupSupport (copy), shouldReplaceLastHistoryEntry (copy)
			local v127 = v65(p3)
			local v128 = v67(false)
			local v129 = v69(false)
			local v130 = v128[v129] or v127

			if shouldInsertNewHistoryEntry(v130, v127) and #v128 > 0 then
				local v131 = Dash.slice(v128, 1, v129)

				table.insert(v131, v127)

				if v50 then
					local v132 = v129 + 1

					if #v131 > v49 then
						table.remove(v131, 1)
						v132 -= 1
					end

					v68(v131)
					v70(v132)

					return
				end

				v68(v131)
				v70(v129 + 1)

				return
			end

			if FFlagAXCustomizeMakeupSupport and shouldReplaceLastHistoryEntry(v130, v127) and #v128 > 0 then
				local v133 = Dash.slice(v128)

				v133[v129] = v127
				v68(v133)
				v70(v129)
			end
		end)
	end, {})

	local v79 = React.useCallback(function(n1: number) -- line: 195
		-- upvalues: v67 (copy), v70 (copy)
		local v92 = v67(false)

		if n1 < 1 or n1 > #v92 then
			return nil
		end

		v70(n1)

		return v92[n1]
	end, {
		v67,
		v70
	})
	local v80 = React.useCallback(function(t6: {[any]: any}) -- line: 212
		-- upvalues: v67 (copy), v69 (copy), removeInvalidAssetsFromCharacterData (copy), v68 (copy)
		local v94 = v67(false)
		local v95 = v69(false)
		local v96 = v94[v95]

		if not v96 then
			return nil
		end

		local v97, v98 = removeInvalidAssetsFromCharacterData(v96, t6)

		if v98 then
			v94[v95] = v97
			v68(v94)

			return v97
		end

		return nil
	end, {
		v67,
		v68,
		v70
	})
	local getTimeoutStatusStore = AvatarExperienceCommon.Stores.getTimeoutStatusStore
	local v82 = if not FFlagAXAvatarTimeoutFlow then nil else getTimeoutStatusStore()
	local v83 = useComputedSignal(function(p4) -- line: 234
		-- upvalues: FFlagAXAvatarTimeoutFlow (copy), v82 (copy), SaveStatusEnum (copy), v67 (copy), v69 (copy), v71 (copy), v73 (copy), checkHasChangesToSave (copy), checkCharacterDataHasTryOnItems (copy)
		if FFlagAXAvatarTimeoutFlow and (v82 and v82.getIsTimedOut(p4)) then
			return SaveStatusEnum.TimedOut
		end

		local v100 = v67(p4)
		local v101 = v69(p4)
		local v102 = v71(p4)
		local v103 = v73(p4)
		local v104 = v100[v101]

		if not v104 or not v102 then
			return SaveStatusEnum.NoData
		end

		if v103 then
			return SaveStatusEnum.Saving
		end

		if v102 and not checkHasChangesToSave(v104, v102) then
			return SaveStatusEnum.AlreadySaved
		end

		if checkCharacterDataHasTryOnItems(v104) then
			return SaveStatusEnum.HasTryOns
		end

		return SaveStatusEnum.Eligible
	end)
	local v84 = React.useCallback(function(p5, p6, p7, _, p9) -- line: 264
		-- upvalues: SaveStatusEnum (copy), getInvalidAssetIdsToAssetTypeIdMap (copy), getAssetIdToAssetTypeIdFromHumanoidDescription (copy), v80 (copy), removeInvalidAssetsFromCharacterData (copy), v72 (copy), v74 (copy), v63 (copy), SetCurrentToastMessage (copy), t3 (copy), t2 (copy), CharacterHistoryStateChangeButtonActivated (copy)
		local Success = SaveStatusEnum.Success
		local v111 = nil

		if p9.Assets then
			local v112 = getInvalidAssetIdsToAssetTypeIdMap(getAssetIdToAssetTypeIdFromHumanoidDescription(p5), getAssetIdToAssetTypeIdFromHumanoidDescription(p6))

			v111 = v80(v112)
			p7 = removeInvalidAssetsFromCharacterData(p7, v112)
		end

		v72(p7)
		v74(nil)

		if v111 ~= nil then
			Success = SaveStatusEnum.SuccessWithInvalidAssets
		end

		if Success == SaveStatusEnum.Success then
			v63(SetCurrentToastMessage(t3))
		elseif Success == SaveStatusEnum.SuccessWithInvalidAssets then
			v63(SetCurrentToastMessage(t2))
		end

		if v111 then
			v63(CharacterHistoryStateChangeButtonActivated(v111))
		end

		return Success
	end, {
		v67,
		v69,
		v72,
		v74,
		v80
	})
	local v85 = React.useCallback(function(p10) -- line: 316
		-- upvalues: v74 (copy), SaveStatusEnum (copy), v63 (copy), SetCurrentToastMessage (copy), t1 (copy), t4 (copy)
		v74(nil)

		if p10 == SaveStatusEnum.Throttled then
			v63(SetCurrentToastMessage(t1))

			return
		end

		v63(SetCurrentToastMessage(t4))
	end, {
		v74,
		v63
	})
	local v86 = React.useCallback(function() -- line: 326
		-- upvalues: Promise (copy), FFlagAXAvatarTimeoutFlow (copy), v82 (copy), v85 (copy), SaveStatusEnum (copy), v67 (copy), v69 (copy), v71 (copy), v75 (copy), v48 (copy), v74 (copy), v76 (copy), buildHumanoidDescription (copy), getSaveDict (copy), FFlagAXBackgroundsPersistence (copy), Cryo (copy), saveProfileConfiguration (copy), v78 (copy), v84 (copy), getGearAssetIdFromEquippedAssets (copy), saveAvatar (copy)
		return Promise.new(function(resolve, reject) -- line: 327
			-- upvalues: FFlagAXAvatarTimeoutFlow (copy), v82 (copy), v85 (copy), SaveStatusEnum (copy), v67 (copy), v69 (copy), v71 (copy), v75 (copy), v48 (copy), v74 (copy), v76 (copy), buildHumanoidDescription (copy), getSaveDict (copy), FFlagAXBackgroundsPersistence (copy), Cryo (copy), saveProfileConfiguration (copy), v78 (copy), v84 (copy), getGearAssetIdFromEquippedAssets (copy), saveAvatar (copy)
			if FFlagAXAvatarTimeoutFlow and (v82 and v82.getIsTimedOut(false)) then
				v85(SaveStatusEnum.TimedOut)

				return
			end

			local v136 = v67(false)
			local v137 = v69(false)
			local v138 = v71(false)
			local v139 = v136[v137]

			if v139 and v138 then
				local v140 = v75(false)

				if v140 > 0 and os.time() - v140 < v48 then
					v85(SaveStatusEnum.Throttled)

					return
				end

				v74(v139)
				v76(os.time())

				local v141 = buildHumanoidDescription({
					currentAssets = v139.equipped.EquippedAssets,
					avatarScales = v139.equipped.AvatarScales,
					bodyColor3s = v139.equipped.BodyColor3s,
					emotesSlotInfo = v139.equipped.EquippedEmotes.slotInfo
				})
				local v142 = Enum.HumanoidRigType[v139.equipped.AvatarType]
				local u143 = getSaveDict(v139, v138)
				local v144 = if not FFlagAXBackgroundsPersistence then nil else v139.equipped.BackgroundAssetId
				local v145 = u143.Background == true and v144 ~= nil
				local v146 = false

				if FFlagAXBackgroundsPersistence then
					u143 = Cryo.Dictionary.join(u143, {
						Background = Cryo.None
					})

					for _, v148 in u143 do
						if v148 then
							v146 = true

							break
						end
					end
				end

				if v145 and not v146 then
					saveProfileConfiguration(v144):andThen(function() -- line: 382
						-- upvalues: v78 (copy), v84 (copy), v141 (copy), v139 (copy), v138 (copy), u143 (ref), resolve (copy)
						v78(false)
						v84(v141, v141, v139, v138, u143)
						resolve()
					end):catch(function() -- line: 393
						-- upvalues: v78 (copy), v85 (copy), SaveStatusEnum (copy), reject (copy)
						v78(false)
						v85(SaveStatusEnum.Failure)
						reject()
					end)

					return
				end

				local v149 = if not v145 then nil else saveProfileConfiguration(v144)
				local v150 = getGearAssetIdFromEquippedAssets(v139.equipped.EquippedAssets)

				saveAvatar(v141, v142, u143, v150):andThen(function(p11) -- line: 407
					-- upvalues: v78 (copy), v84 (copy), v141 (copy), v138 (copy), u143 (ref), resolve (copy), v149 (copy), v139 (copy), Cryo (copy)
					v78(false)

					local function finishSuccess(p12) -- line: 410
						-- upvalues: v84 (copy), v141 (copy), p11 (copy), v138 (copy), u143 (ref), resolve (copy)
						v84(v141, p11.humanoidDescriptionWithValidAssets, p12, v138, u143)
						resolve()
					end

					if v149 then
						v149:andThen(function() -- line: 424
							-- upvalues: v139 (copy), v84 (copy), v141 (copy), p11 (copy), v138 (copy), u143 (ref), resolve (copy)
							local v160 = v139

							v84(v141, p11.humanoidDescriptionWithValidAssets, v160, v138, u143)
							resolve()
						end, function() -- line: 426
							-- upvalues: Cryo (copy), v139 (copy), v138 (copy), v84 (copy), v141 (copy), p11 (copy), u143 (ref), resolve (copy)
							local v161 = Cryo.Dictionary.join(v139, {
								equipped = Cryo.Dictionary.join(v139.equipped, {
									BackgroundAssetId = if v138.equipped.BackgroundAssetId == nil then Cryo.None else v138.equipped.BackgroundAssetId
								})
							})

							v84(v141, p11.humanoidDescriptionWithValidAssets, v161, v138, u143)
							resolve()
						end)

						return
					end

					local v156 = v139

					v84(v141, p11.humanoidDescriptionWithValidAssets, v156, v138, u143)
					resolve()
				end):catch(function(_) -- line: 439
					-- upvalues: v78 (copy), FFlagAXAvatarTimeoutFlow (copy), v82 (copy), v85 (copy), SaveStatusEnum (copy), reject (copy)
					v78(false)

					if FFlagAXAvatarTimeoutFlow and v82 then
						v82.fetchStatus()
					end

					v85(SaveStatusEnum.Failure)
					reject()
				end)
			end
		end)
	end, {
		if not FFlagAXAvatarTimeoutFlow then nil else v82,
		v67,
		v69,
		v72,
		v74,
		v76,
		v80,
		if not FFlagAXAvatarTimeoutFlow then nil else v85,
		v78
	})

	if FFlagAXEnableManualSavingBlockingPrompt then
		local v87 = React.useCallback(function(s1: string) -- line: 471
			-- upvalues: v86 (copy), FFlagSignalsNavP3Dispatch (copy), v44 (copy), v63 (copy), NavigateToRoute (copy)
			return function() -- line: 472
				-- upvalues: v86 (copy), FFlagSignalsNavP3Dispatch (copy), v44 (copy), s1 (copy), v63 (copy), NavigateToRoute (copy)
				v86():finally(function() -- line: 473
					-- upvalues: FFlagSignalsNavP3Dispatch (copy), v44 (copy), s1 (copy), v63 (copy), NavigateToRoute (copy)
					if FFlagSignalsNavP3Dispatch then
						v44.to(v44.fromLegacyPage({
							skipSaveBlockingPrompt = true,
							name = s1
						}))

						return
					end

					v63(NavigateToRoute({{
						skipSaveBlockingPrompt = true,
						name = s1
					}}))
				end)
			end
		end, {
			v86,
			v63
		})
		local v88 = React.useCallback(function(s2: string) -- line: 483
			-- upvalues: v71 (copy), v63 (copy), CharacterHistoryStateChangeButtonActivated (copy), FFlagSignalsNavP3Dispatch (copy), v44 (copy), NavigateToRoute (copy)
			return function() -- line: 484
				-- upvalues: v71 (copy), v63 (copy), CharacterHistoryStateChangeButtonActivated (copy), FFlagSignalsNavP3Dispatch (copy), v44 (copy), s2 (copy), NavigateToRoute (copy)
				task.spawn(function() -- line: 485
					-- upvalues: v71 (copy), v63 (copy), CharacterHistoryStateChangeButtonActivated (copy), FFlagSignalsNavP3Dispatch (copy), v44 (copy), s2 (copy), NavigateToRoute (copy)
					local v158 = v71(false)

					v63(CharacterHistoryStateChangeButtonActivated(v158))
					task.wait()

					if FFlagSignalsNavP3Dispatch then
						v44.to(v44.fromLegacyPage({
							skipSaveBlockingPrompt = true,
							name = s2
						}))

						return
					end

					v63(NavigateToRoute({{
						skipSaveBlockingPrompt = true,
						name = s2
					}}))
				end)
			end
		end, {
			v63,
			v71
		})
		local v89 = React.useCallback(function(p14, p15) -- line: 506
			-- upvalues: Actions (copy), AvatarScreen (copy), t5 (copy), tutils (copy), v83 (copy), SaveStatusEnum (copy), Cryo (copy), v87 (copy), v88 (copy)
			local routeName = (p14 or {}).routeName
			local params = (p14 or {}).params

			if p14.type == Actions.Back and (not p14.immediate and p15.routes[#p15.routes] and p15.routes[#p15.routes].routeName == AvatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt) then
				return true, nil
			end

			if p14.type == Actions.Navigate and t5[routeName] ~= nil and ((params == nil or tutils.fieldCount(params) == 0) and v83(false) == SaveStatusEnum.Eligible) then
				if p15.routes[#p15.routes] and p15.routes[#p15.routes].routeName == AvatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt then
					return true, nil
				end

				local v120 = Cryo.List.join(p15.routes, {{
					key = AvatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt,
					routeName = AvatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt,
					params = {
						saveAndContinue = v87(routeName),
						continueWithoutSave = v88(routeName)
					}
				}})

				return true, Cryo.Dictionary.join(p15, {
					routes = v120,
					index = #v120
				})
			end

			return false, nil
		end, {
			v83,
			v87,
			v88
		})

		React.useEffect(function() -- line: 569
			-- upvalues: v64 (copy), RegisterCustomGetStateForAction (copy), CustomGetStateForAction (copy), v89 (copy)
			v64.dispatch(RegisterCustomGetStateForAction(CustomGetStateForAction.HandlerId.BlockAXExitOnUnsavedChanges, v89))
		end, {
			v64,
			v89
		})
	end

	React.useEffect(function() -- line: 582
		-- upvalues: Signals (copy), v67 (copy), v77 (copy), v83 (copy), SaveStatusEnum (copy), v86 (copy)
		return Signals.createEffect(function(p16) -- line: 583
			-- upvalues: v67 (copy), v77 (copy), v83 (copy), SaveStatusEnum (copy), v86 (copy)
			local v152 = v67(p16)

			if v152[#v152] and v77(false) then
				local v153 = v83(false)

				if v153 == SaveStatusEnum.Eligible or v153 == SaveStatusEnum.HasTryOns then
					v86()
				end
			end
		end)
	end, {})

	local v90 = React.useCallback(function() -- line: 600
		-- upvalues: v78 (copy)
		v78(true)
	end, { v78 })

	return React.useMemo(function() -- line: 605
		-- upvalues: v67 (copy), v69 (copy), v79 (copy), v71 (copy), v83 (copy), v86 (copy), v90 (copy)
		return {
			getHistorySignal = v67,
			getCurrentHistoryIndexSignal = v69,
			updateHistoryIndexAndGetCharacterData = v79,
			getLastSuccessfullySavedStateSignal = v71,
			getSaveEligibilityStatusSignal = v83,
			trySaveAvatar = v86,
			autoSaveNextNewSaveData = v90
		}
	end, {
		v67,
		v69,
		v79,
		v71,
		v83,
		v86,
		v90
	})
end

return useAvatarSaveContextProviderValue
