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
local FFlagAXEnableManualSavingBlockingPrompt = AvatarExperienceFlags.FFlagAXEnableManualSavingBlockingPrompt
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

local function buildHumanoidDescriptionForCharacterData(p1) -- line: 98
	-- upvalues: buildHumanoidDescription (copy)
	return buildHumanoidDescription({
		currentAssets = p1.equipped.EquippedAssets,
		avatarScales = p1.equipped.AvatarScales,
		bodyColor3s = p1.equipped.BodyColor3s,
		emotesSlotInfo = p1.equipped.EquippedEmotes.slotInfo
	})
end
local function useAvatarSaveContextProviderValue() -- line: 109
	-- upvalues: useDispatch (copy), useNavigation (copy), useSelectorSignal (copy), selectCharacterData (copy), tutils (copy), selectHasAvatarData (copy), useSignal (copy), React (copy), Signals (copy), shouldInsertNewHistoryEntry (copy), Dash (copy), v50 (copy), v49 (copy), shouldReplaceLastHistoryEntry (copy), removeInvalidAssetsFromCharacterData (copy), AvatarExperienceCommon (copy), useComputedSignal (copy), SaveStatusEnum (copy), checkHasChangesToSave (copy), checkCharacterDataHasTryOnItems (copy), getInvalidAssetIdsToAssetTypeIdMap (copy), getAssetIdToAssetTypeIdFromHumanoidDescription (copy), SetCurrentToastMessage (copy), t3 (copy), t2 (copy), CharacterHistoryStateChangeButtonActivated (copy), t1 (copy), t4 (copy), Promise (copy), v48 (copy), buildHumanoidDescription (copy), getSaveDict (copy), FFlagAXBackgroundsPersistence (copy), Cryo (copy), saveProfileConfiguration (copy), getGearAssetIdFromEquippedAssets (copy), saveAvatar (copy), FFlagAXEnableManualSavingBlockingPrompt (copy), FFlagSignalsNavP3Dispatch (copy), v44 (copy), NavigateToRoute (copy), Actions (copy), AvatarScreen (copy), t5 (copy), RegisterCustomGetStateForAction (copy), CustomGetStateForAction (copy)
	local v61 = useDispatch()
	local v62 = useNavigation()
	local v63 = useSelectorSignal(selectCharacterData, tutils.deepEqual)
	local v64 = useSelectorSignal(selectHasAvatarData)
	local v65, v66 = useSignal({})
	local v67, v68 = useSignal(0)
	local v69, v70 = useSignal(nil)
	local v71, v72 = useSignal(nil)
	local v73, v74 = useSignal(0)
	local v75, v76 = useSignal(false)

	React.useEffect(function() -- line: 131
		-- upvalues: Signals (copy), v64 (copy), v63 (copy), v65 (copy), tutils (copy), v66 (copy), v68 (copy), v70 (copy), v72 (copy), v74 (copy)
		return Signals.createEffect(function(p2) -- line: 132
			-- upvalues: v64 (copy), v63 (copy), v65 (copy), tutils (copy), v66 (copy), v68 (copy), v70 (copy), v72 (copy), v74 (copy)
			local v119 = v64(p2)
			local v120 = v63(p2)
			local v121 = v65(false)
			local v122 = v120.equipped.BodyPartRangeIds and tutils.fieldCount(v120.equipped.BodyPartRangeIds) > 0

			if v119 and (v122 and #v121 == 0) then
				v66({ v120 })
				v68(1)
				v70(v120)
				v72(nil)
				v74(0)
			end
		end)
	end, {})
	React.useEffect(function() -- line: 155
		-- upvalues: Signals (copy), v63 (copy), v65 (copy), v67 (copy), shouldInsertNewHistoryEntry (copy), Dash (copy), v50 (copy), v49 (copy), v66 (copy), v68 (copy), shouldReplaceLastHistoryEntry (copy)
		return Signals.createEffect(function(p3) -- line: 156
			-- upvalues: v63 (copy), v65 (copy), v67 (copy), shouldInsertNewHistoryEntry (copy), Dash (copy), v50 (copy), v49 (copy), v66 (copy), v68 (copy), shouldReplaceLastHistoryEntry (copy)
			local v124 = v63(p3)
			local v125 = v65(false)
			local v126 = v67(false)
			local v127 = v125[v126] or v124

			if shouldInsertNewHistoryEntry(v127, v124) and #v125 > 0 then
				local v128 = Dash.slice(v125, 1, v126)

				table.insert(v128, v124)

				if v50 then
					local v129 = v126 + 1

					if #v128 > v49 then
						table.remove(v128, 1)
						v129 -= 1
					end

					v66(v128)
					v68(v129)

					return
				end

				v66(v128)
				v68(v126 + 1)

				return
			end

			if shouldReplaceLastHistoryEntry(v127, v124) and #v125 > 0 then
				local v130 = Dash.slice(v125)

				v130[v126] = v124
				v66(v130)
				v68(v126)
			end
		end)
	end, {})

	local v77 = React.useCallback(function(n1: number) -- line: 189
		-- upvalues: v65 (copy), v68 (copy)
		local v89 = v65(false)

		if n1 < 1 or n1 > #v89 then
			return nil
		end

		v68(n1)

		return v89[n1]
	end, {
		v65,
		v68
	})
	local v78 = React.useCallback(function(t6: {[any]: any}) -- line: 206
		-- upvalues: v65 (copy), v67 (copy), removeInvalidAssetsFromCharacterData (copy), v66 (copy)
		local v91 = v65(false)
		local v92 = v67(false)
		local v93 = v91[v92]

		if not v93 then
			return nil
		end

		local v94, v95 = removeInvalidAssetsFromCharacterData(v93, t6)

		if v95 then
			v91[v92] = v94
			v66(v91)

			return v94
		end

		return nil
	end, {
		v65,
		v66,
		v68
	})
	local v79 = AvatarExperienceCommon.Stores.getTimeoutStatusStore()
	local v80 = useComputedSignal(function(p4) -- line: 228
		-- upvalues: v79 (copy), SaveStatusEnum (copy), v65 (copy), v67 (copy), v69 (copy), v71 (copy), checkHasChangesToSave (copy), checkCharacterDataHasTryOnItems (copy)
		if v79 and v79.getIsTimedOut(p4) then
			return SaveStatusEnum.TimedOut
		end

		local v97 = v65(p4)
		local v98 = v67(p4)
		local v99 = v69(p4)
		local v100 = v71(p4)
		local v101 = v97[v98]

		if not v101 or not v99 then
			return SaveStatusEnum.NoData
		end

		if v100 then
			return SaveStatusEnum.Saving
		end

		if v99 and not checkHasChangesToSave(v101, v99) then
			return SaveStatusEnum.AlreadySaved
		end

		if checkCharacterDataHasTryOnItems(v101) then
			return SaveStatusEnum.HasTryOns
		end

		return SaveStatusEnum.Eligible
	end)
	local v81 = React.useCallback(function(p5, p6, p7, _, p9) -- line: 258
		-- upvalues: SaveStatusEnum (copy), getInvalidAssetIdsToAssetTypeIdMap (copy), getAssetIdToAssetTypeIdFromHumanoidDescription (copy), v78 (copy), removeInvalidAssetsFromCharacterData (copy), v70 (copy), v72 (copy), v61 (copy), SetCurrentToastMessage (copy), t3 (copy), t2 (copy), CharacterHistoryStateChangeButtonActivated (copy)
		local Success = SaveStatusEnum.Success
		local v108 = nil

		if p9.Assets then
			local v109 = getInvalidAssetIdsToAssetTypeIdMap(getAssetIdToAssetTypeIdFromHumanoidDescription(p5), getAssetIdToAssetTypeIdFromHumanoidDescription(p6))

			v108 = v78(v109)
			p7 = removeInvalidAssetsFromCharacterData(p7, v109)
		end

		v70(p7)
		v72(nil)

		if v108 ~= nil then
			Success = SaveStatusEnum.SuccessWithInvalidAssets
		end

		if Success == SaveStatusEnum.Success then
			v61(SetCurrentToastMessage(t3))
		elseif Success == SaveStatusEnum.SuccessWithInvalidAssets then
			v61(SetCurrentToastMessage(t2))
		end

		if v108 then
			v61(CharacterHistoryStateChangeButtonActivated(v108))
		end

		return Success
	end, {
		v65,
		v67,
		v70,
		v72,
		v78
	})
	local v82 = React.useCallback(function(p10) -- line: 310
		-- upvalues: v72 (copy), SaveStatusEnum (copy), v61 (copy), SetCurrentToastMessage (copy), t1 (copy), t4 (copy)
		v72(nil)

		if p10 == SaveStatusEnum.Throttled then
			v61(SetCurrentToastMessage(t1))

			return
		end

		v61(SetCurrentToastMessage(t4))
	end, {
		v72,
		v61
	})
	local v83 = React.useCallback(function() -- line: 320
		-- upvalues: Promise (copy), v79 (copy), v82 (copy), SaveStatusEnum (copy), v65 (copy), v67 (copy), v69 (copy), v73 (copy), v48 (copy), v72 (copy), v74 (copy), buildHumanoidDescription (copy), getSaveDict (copy), FFlagAXBackgroundsPersistence (copy), Cryo (copy), saveProfileConfiguration (copy), v76 (copy), v81 (copy), getGearAssetIdFromEquippedAssets (copy), saveAvatar (copy)
		return Promise.new(function(resolve, reject) -- line: 321
			-- upvalues: v79 (copy), v82 (copy), SaveStatusEnum (copy), v65 (copy), v67 (copy), v69 (copy), v73 (copy), v48 (copy), v72 (copy), v74 (copy), buildHumanoidDescription (copy), getSaveDict (copy), FFlagAXBackgroundsPersistence (copy), Cryo (copy), saveProfileConfiguration (copy), v76 (copy), v81 (copy), getGearAssetIdFromEquippedAssets (copy), saveAvatar (copy)
			if v79 and v79.getIsTimedOut(false) then
				v82(SaveStatusEnum.TimedOut)

				return
			end

			local v133 = v65(false)
			local v134 = v67(false)
			local v135 = v69(false)
			local v136 = v133[v134]

			if v136 and v135 then
				local v137 = v73(false)

				if v137 > 0 and os.time() - v137 < v48 then
					v82(SaveStatusEnum.Throttled)

					return
				end

				v72(v136)
				v74(os.time())

				local v138 = buildHumanoidDescription({
					currentAssets = v136.equipped.EquippedAssets,
					avatarScales = v136.equipped.AvatarScales,
					bodyColor3s = v136.equipped.BodyColor3s,
					emotesSlotInfo = v136.equipped.EquippedEmotes.slotInfo
				})
				local v139 = Enum.HumanoidRigType[v136.equipped.AvatarType]
				local u140 = getSaveDict(v136, v135)
				local v141 = if not FFlagAXBackgroundsPersistence then nil else v136.equipped.BackgroundAssetId
				local v142 = u140.Background == true and v141 ~= nil
				local v143 = false

				if FFlagAXBackgroundsPersistence then
					u140 = Cryo.Dictionary.join(u140, {
						Background = Cryo.None
					})

					for _, v145 in u140 do
						if v145 then
							v143 = true

							break
						end
					end
				end

				if v142 and not v143 then
					saveProfileConfiguration(v141):andThen(function() -- line: 376
						-- upvalues: v76 (copy), v81 (copy), v138 (copy), v136 (copy), v135 (copy), u140 (ref), resolve (copy)
						v76(false)
						v81(v138, v138, v136, v135, u140)
						resolve()
					end):catch(function() -- line: 387
						-- upvalues: v76 (copy), v82 (copy), SaveStatusEnum (copy), reject (copy)
						v76(false)
						v82(SaveStatusEnum.Failure)
						reject()
					end)

					return
				end

				local v146 = if not v142 then nil else saveProfileConfiguration(v141)
				local v147 = getGearAssetIdFromEquippedAssets(v136.equipped.EquippedAssets)

				saveAvatar(v138, v139, u140, v147):andThen(function(p11) -- line: 401
					-- upvalues: v76 (copy), v81 (copy), v138 (copy), v135 (copy), u140 (ref), resolve (copy), v146 (copy), v136 (copy), Cryo (copy)
					v76(false)

					local function finishSuccess(p12) -- line: 404
						-- upvalues: v81 (copy), v138 (copy), p11 (copy), v135 (copy), u140 (ref), resolve (copy)
						v81(v138, p11.humanoidDescriptionWithValidAssets, p12, v135, u140)
						resolve()
					end

					if v146 then
						v146:andThen(function() -- line: 418
							-- upvalues: v136 (copy), v81 (copy), v138 (copy), p11 (copy), v135 (copy), u140 (ref), resolve (copy)
							local v157 = v136

							v81(v138, p11.humanoidDescriptionWithValidAssets, v157, v135, u140)
							resolve()
						end, function() -- line: 420
							-- upvalues: Cryo (copy), v136 (copy), v135 (copy), v81 (copy), v138 (copy), p11 (copy), u140 (ref), resolve (copy)
							local v158 = Cryo.Dictionary.join(v136, {
								equipped = Cryo.Dictionary.join(v136.equipped, {
									BackgroundAssetId = if v135.equipped.BackgroundAssetId == nil then Cryo.None else v135.equipped.BackgroundAssetId
								})
							})

							v81(v138, p11.humanoidDescriptionWithValidAssets, v158, v135, u140)
							resolve()
						end)

						return
					end

					local v153 = v136

					v81(v138, p11.humanoidDescriptionWithValidAssets, v153, v135, u140)
					resolve()
				end):catch(function(_) -- line: 433
					-- upvalues: v76 (copy), v79 (copy), v82 (copy), SaveStatusEnum (copy), reject (copy)
					v76(false)

					if v79 then
						v79.fetchStatus()
					end

					v82(SaveStatusEnum.Failure)
					reject()
				end)
			end
		end)
	end, {
		v79,
		v65,
		v67,
		v70,
		v72,
		v74,
		v78,
		v82,
		v76
	})

	if FFlagAXEnableManualSavingBlockingPrompt then
		local v84 = React.useCallback(function(s1: string) -- line: 465
			-- upvalues: v83 (copy), FFlagSignalsNavP3Dispatch (copy), v44 (copy), v61 (copy), NavigateToRoute (copy)
			return function() -- line: 466
				-- upvalues: v83 (copy), FFlagSignalsNavP3Dispatch (copy), v44 (copy), s1 (copy), v61 (copy), NavigateToRoute (copy)
				v83():finally(function() -- line: 467
					-- upvalues: FFlagSignalsNavP3Dispatch (copy), v44 (copy), s1 (copy), v61 (copy), NavigateToRoute (copy)
					if FFlagSignalsNavP3Dispatch then
						v44.to(v44.fromLegacyPage({
							skipSaveBlockingPrompt = true,
							name = s1
						}))

						return
					end

					v61(NavigateToRoute({{
						skipSaveBlockingPrompt = true,
						name = s1
					}}))
				end)
			end
		end, {
			v83,
			v61
		})
		local v85 = React.useCallback(function(s2: string) -- line: 477
			-- upvalues: v69 (copy), v61 (copy), CharacterHistoryStateChangeButtonActivated (copy), FFlagSignalsNavP3Dispatch (copy), v44 (copy), NavigateToRoute (copy)
			return function() -- line: 478
				-- upvalues: v69 (copy), v61 (copy), CharacterHistoryStateChangeButtonActivated (copy), FFlagSignalsNavP3Dispatch (copy), v44 (copy), s2 (copy), NavigateToRoute (copy)
				task.spawn(function() -- line: 479
					-- upvalues: v69 (copy), v61 (copy), CharacterHistoryStateChangeButtonActivated (copy), FFlagSignalsNavP3Dispatch (copy), v44 (copy), s2 (copy), NavigateToRoute (copy)
					local v155 = v69(false)

					v61(CharacterHistoryStateChangeButtonActivated(v155))
					task.wait()

					if FFlagSignalsNavP3Dispatch then
						v44.to(v44.fromLegacyPage({
							skipSaveBlockingPrompt = true,
							name = s2
						}))

						return
					end

					v61(NavigateToRoute({{
						skipSaveBlockingPrompt = true,
						name = s2
					}}))
				end)
			end
		end, {
			v61,
			v69
		})
		local v86 = React.useCallback(function(p14, p15) -- line: 500
			-- upvalues: Actions (copy), AvatarScreen (copy), t5 (copy), tutils (copy), v80 (copy), SaveStatusEnum (copy), Cryo (copy), v84 (copy), v85 (copy)
			local routeName = (p14 or {}).routeName
			local params = (p14 or {}).params

			if p14.type == Actions.Back and (not p14.immediate and p15.routes[#p15.routes] and p15.routes[#p15.routes].routeName == AvatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt) then
				return true, nil
			end

			if p14.type == Actions.Navigate and t5[routeName] ~= nil and ((params == nil or tutils.fieldCount(params) == 0) and v80(false) == SaveStatusEnum.Eligible) then
				if p15.routes[#p15.routes] and p15.routes[#p15.routes].routeName == AvatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt then
					return true, nil
				end

				local v117 = Cryo.List.join(p15.routes, {{
					key = AvatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt,
					routeName = AvatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt,
					params = {
						saveAndContinue = v84(routeName),
						continueWithoutSave = v85(routeName)
					}
				}})

				return true, Cryo.Dictionary.join(p15, {
					routes = v117,
					index = #v117
				})
			end

			return false, nil
		end, {
			v80,
			v84,
			v85
		})

		React.useEffect(function() -- line: 563
			-- upvalues: v62 (copy), RegisterCustomGetStateForAction (copy), CustomGetStateForAction (copy), v86 (copy)
			v62.dispatch(RegisterCustomGetStateForAction(CustomGetStateForAction.HandlerId.BlockAXExitOnUnsavedChanges, v86))
		end, {
			v62,
			v86
		})
	end

	React.useEffect(function() -- line: 576
		-- upvalues: Signals (copy), v65 (copy), v75 (copy), v80 (copy), SaveStatusEnum (copy), v83 (copy)
		return Signals.createEffect(function(p16) -- line: 577
			-- upvalues: v65 (copy), v75 (copy), v80 (copy), SaveStatusEnum (copy), v83 (copy)
			local v149 = v65(p16)

			if v149[#v149] and v75(false) then
				local v150 = v80(false)

				if v150 == SaveStatusEnum.Eligible or v150 == SaveStatusEnum.HasTryOns then
					v83()
				end
			end
		end)
	end, {})

	local v87 = React.useCallback(function() -- line: 594
		-- upvalues: v76 (copy)
		v76(true)
	end, { v76 })

	return React.useMemo(function() -- line: 599
		-- upvalues: v65 (copy), v67 (copy), v77 (copy), v69 (copy), v80 (copy), v83 (copy), v87 (copy)
		return {
			getHistorySignal = v65,
			getCurrentHistoryIndexSignal = v67,
			updateHistoryIndexAndGetCharacterData = v77,
			getLastSuccessfullySavedStateSignal = v69,
			getSaveEligibilityStatusSignal = v80,
			trySaveAvatar = v83,
			autoSaveNextNewSaveData = v87
		}
	end, {
		v65,
		v67,
		v77,
		v69,
		v80,
		v83,
		v87
	})
end

return useAvatarSaveContextProviderValue
