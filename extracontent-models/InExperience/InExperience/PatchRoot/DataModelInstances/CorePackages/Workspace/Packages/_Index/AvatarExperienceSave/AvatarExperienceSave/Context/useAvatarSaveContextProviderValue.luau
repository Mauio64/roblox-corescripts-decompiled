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

local function buildHumanoidDescriptionForCharacterData(p1) -- line: 99
	-- upvalues: buildHumanoidDescription (copy)
	return buildHumanoidDescription({
		currentAssets = p1.equipped.EquippedAssets,
		avatarScales = p1.equipped.AvatarScales,
		bodyColor3s = p1.equipped.BodyColor3s,
		emotesSlotInfo = p1.equipped.EquippedEmotes.slotInfo
	})
end
local function useAvatarSaveContextProviderValue() -- line: 110
	-- upvalues: useDispatch (copy), useNavigation (copy), useSelectorSignal (copy), selectCharacterData (copy), tutils (copy), selectHasAvatarData (copy), useSignal (copy), React (copy), Signals (copy), shouldInsertNewHistoryEntry (copy), Dash (copy), v50 (copy), v49 (copy), shouldReplaceLastHistoryEntry (copy), removeInvalidAssetsFromCharacterData (copy), AvatarExperienceCommon (copy), FFlagAXAvatarTimeoutFlow (copy), useComputedSignal (copy), SaveStatusEnum (copy), checkHasChangesToSave (copy), checkCharacterDataHasTryOnItems (copy), getInvalidAssetIdsToAssetTypeIdMap (copy), getAssetIdToAssetTypeIdFromHumanoidDescription (copy), SetCurrentToastMessage (copy), t3 (copy), t2 (copy), CharacterHistoryStateChangeButtonActivated (copy), t1 (copy), t4 (copy), Promise (copy), v48 (copy), buildHumanoidDescription (copy), getSaveDict (copy), FFlagAXBackgroundsPersistence (copy), Cryo (copy), saveProfileConfiguration (copy), getGearAssetIdFromEquippedAssets (copy), saveAvatar (copy), FFlagAXEnableManualSavingBlockingPrompt (copy), FFlagSignalsNavP3Dispatch (copy), v44 (copy), NavigateToRoute (copy), Actions (copy), AvatarScreen (copy), t5 (copy), RegisterCustomGetStateForAction (copy), CustomGetStateForAction (copy)
	local v62 = useDispatch()
	local v63 = useNavigation()
	local v64 = useSelectorSignal(selectCharacterData, tutils.deepEqual)
	local v65 = useSelectorSignal(selectHasAvatarData)
	local v66, v67 = useSignal({})
	local v68, v69 = useSignal(0)
	local v70, v71 = useSignal(nil)
	local v72, v73 = useSignal(nil)
	local v74, v75 = useSignal(0)
	local v76, v77 = useSignal(false)

	React.useEffect(function() -- line: 132
		-- upvalues: Signals (copy), v65 (copy), v64 (copy), v66 (copy), tutils (copy), v67 (copy), v69 (copy), v71 (copy), v73 (copy), v75 (copy)
		return Signals.createEffect(function(p2) -- line: 133
			-- upvalues: v65 (copy), v64 (copy), v66 (copy), tutils (copy), v67 (copy), v69 (copy), v71 (copy), v73 (copy), v75 (copy)
			local v121 = v65(p2)
			local v122 = v64(p2)
			local v123 = v66(false)
			local v124 = v122.equipped.BodyPartRangeIds and tutils.fieldCount(v122.equipped.BodyPartRangeIds) > 0

			if v121 and (v124 and #v123 == 0) then
				v67({ v122 })
				v69(1)
				v71(v122)
				v73(nil)
				v75(0)
			end
		end)
	end, {})
	React.useEffect(function() -- line: 156
		-- upvalues: Signals (copy), v64 (copy), v66 (copy), v68 (copy), shouldInsertNewHistoryEntry (copy), Dash (copy), v50 (copy), v49 (copy), v67 (copy), v69 (copy), shouldReplaceLastHistoryEntry (copy)
		return Signals.createEffect(function(p3) -- line: 157
			-- upvalues: v64 (copy), v66 (copy), v68 (copy), shouldInsertNewHistoryEntry (copy), Dash (copy), v50 (copy), v49 (copy), v67 (copy), v69 (copy), shouldReplaceLastHistoryEntry (copy)
			local v126 = v64(p3)
			local v127 = v66(false)
			local v128 = v68(false)
			local v129 = v127[v128] or v126

			if shouldInsertNewHistoryEntry(v129, v126) and #v127 > 0 then
				local v130 = Dash.slice(v127, 1, v128)

				table.insert(v130, v126)

				if v50 then
					local v131 = v128 + 1

					if #v130 > v49 then
						table.remove(v130, 1)
						v131 -= 1
					end

					v67(v130)
					v69(v131)

					return
				end

				v67(v130)
				v69(v128 + 1)

				return
			end

			if shouldReplaceLastHistoryEntry(v129, v126) and #v127 > 0 then
				local v132 = Dash.slice(v127)

				v132[v128] = v126
				v67(v132)
				v69(v128)
			end
		end)
	end, {})

	local v78 = React.useCallback(function(n1: number) -- line: 190
		-- upvalues: v66 (copy), v69 (copy)
		local v91 = v66(false)

		if n1 < 1 or n1 > #v91 then
			return nil
		end

		v69(n1)

		return v91[n1]
	end, {
		v66,
		v69
	})
	local v79 = React.useCallback(function(t6: {[any]: any}) -- line: 207
		-- upvalues: v66 (copy), v68 (copy), removeInvalidAssetsFromCharacterData (copy), v67 (copy)
		local v93 = v66(false)
		local v94 = v68(false)
		local v95 = v93[v94]

		if not v95 then
			return nil
		end

		local v96, v97 = removeInvalidAssetsFromCharacterData(v95, t6)

		if v97 then
			v93[v94] = v96
			v67(v93)

			return v96
		end

		return nil
	end, {
		v66,
		v67,
		v69
	})
	local getTimeoutStatusStore = AvatarExperienceCommon.Stores.getTimeoutStatusStore
	local v81 = if not FFlagAXAvatarTimeoutFlow then nil else getTimeoutStatusStore()
	local v82 = useComputedSignal(function(p4) -- line: 229
		-- upvalues: FFlagAXAvatarTimeoutFlow (copy), v81 (copy), SaveStatusEnum (copy), v66 (copy), v68 (copy), v70 (copy), v72 (copy), checkHasChangesToSave (copy), checkCharacterDataHasTryOnItems (copy)
		if FFlagAXAvatarTimeoutFlow and (v81 and v81.getIsTimedOut(p4)) then
			return SaveStatusEnum.TimedOut
		end

		local v99 = v66(p4)
		local v100 = v68(p4)
		local v101 = v70(p4)
		local v102 = v72(p4)
		local v103 = v99[v100]

		if not v103 or not v101 then
			return SaveStatusEnum.NoData
		end

		if v102 then
			return SaveStatusEnum.Saving
		end

		if v101 and not checkHasChangesToSave(v103, v101) then
			return SaveStatusEnum.AlreadySaved
		end

		if checkCharacterDataHasTryOnItems(v103) then
			return SaveStatusEnum.HasTryOns
		end

		return SaveStatusEnum.Eligible
	end)
	local v83 = React.useCallback(function(p5, p6, p7, _, p9) -- line: 259
		-- upvalues: SaveStatusEnum (copy), getInvalidAssetIdsToAssetTypeIdMap (copy), getAssetIdToAssetTypeIdFromHumanoidDescription (copy), v79 (copy), removeInvalidAssetsFromCharacterData (copy), v71 (copy), v73 (copy), v62 (copy), SetCurrentToastMessage (copy), t3 (copy), t2 (copy), CharacterHistoryStateChangeButtonActivated (copy)
		local Success = SaveStatusEnum.Success
		local v110 = nil

		if p9.Assets then
			local v111 = getInvalidAssetIdsToAssetTypeIdMap(getAssetIdToAssetTypeIdFromHumanoidDescription(p5), getAssetIdToAssetTypeIdFromHumanoidDescription(p6))

			v110 = v79(v111)
			p7 = removeInvalidAssetsFromCharacterData(p7, v111)
		end

		v71(p7)
		v73(nil)

		if v110 ~= nil then
			Success = SaveStatusEnum.SuccessWithInvalidAssets
		end

		if Success == SaveStatusEnum.Success then
			v62(SetCurrentToastMessage(t3))
		elseif Success == SaveStatusEnum.SuccessWithInvalidAssets then
			v62(SetCurrentToastMessage(t2))
		end

		if v110 then
			v62(CharacterHistoryStateChangeButtonActivated(v110))
		end

		return Success
	end, {
		v66,
		v68,
		v71,
		v73,
		v79
	})
	local v84 = React.useCallback(function(p10) -- line: 311
		-- upvalues: v73 (copy), SaveStatusEnum (copy), v62 (copy), SetCurrentToastMessage (copy), t1 (copy), t4 (copy)
		v73(nil)

		if p10 == SaveStatusEnum.Throttled then
			v62(SetCurrentToastMessage(t1))

			return
		end

		v62(SetCurrentToastMessage(t4))
	end, {
		v73,
		v62
	})
	local v85 = React.useCallback(function() -- line: 321
		-- upvalues: Promise (copy), FFlagAXAvatarTimeoutFlow (copy), v81 (copy), v84 (copy), SaveStatusEnum (copy), v66 (copy), v68 (copy), v70 (copy), v74 (copy), v48 (copy), v73 (copy), v75 (copy), buildHumanoidDescription (copy), getSaveDict (copy), FFlagAXBackgroundsPersistence (copy), Cryo (copy), saveProfileConfiguration (copy), v77 (copy), v83 (copy), getGearAssetIdFromEquippedAssets (copy), saveAvatar (copy)
		return Promise.new(function(resolve, reject) -- line: 322
			-- upvalues: FFlagAXAvatarTimeoutFlow (copy), v81 (copy), v84 (copy), SaveStatusEnum (copy), v66 (copy), v68 (copy), v70 (copy), v74 (copy), v48 (copy), v73 (copy), v75 (copy), buildHumanoidDescription (copy), getSaveDict (copy), FFlagAXBackgroundsPersistence (copy), Cryo (copy), saveProfileConfiguration (copy), v77 (copy), v83 (copy), getGearAssetIdFromEquippedAssets (copy), saveAvatar (copy)
			if FFlagAXAvatarTimeoutFlow and (v81 and v81.getIsTimedOut(false)) then
				v84(SaveStatusEnum.TimedOut)

				return
			end

			local v135 = v66(false)
			local v136 = v68(false)
			local v137 = v70(false)
			local v138 = v135[v136]

			if v138 and v137 then
				local v139 = v74(false)

				if v139 > 0 and os.time() - v139 < v48 then
					v84(SaveStatusEnum.Throttled)

					return
				end

				v73(v138)
				v75(os.time())

				local v140 = buildHumanoidDescription({
					currentAssets = v138.equipped.EquippedAssets,
					avatarScales = v138.equipped.AvatarScales,
					bodyColor3s = v138.equipped.BodyColor3s,
					emotesSlotInfo = v138.equipped.EquippedEmotes.slotInfo
				})
				local v141 = Enum.HumanoidRigType[v138.equipped.AvatarType]
				local u142 = getSaveDict(v138, v137)
				local v143 = if not FFlagAXBackgroundsPersistence then nil else v138.equipped.BackgroundAssetId
				local v144 = u142.Background == true and v143 ~= nil
				local v145 = false

				if FFlagAXBackgroundsPersistence then
					u142 = Cryo.Dictionary.join(u142, {
						Background = Cryo.None
					})

					for _, v147 in u142 do
						if v147 then
							v145 = true

							break
						end
					end
				end

				if v144 and not v145 then
					saveProfileConfiguration(v143):andThen(function() -- line: 377
						-- upvalues: v77 (copy), v83 (copy), v140 (copy), v138 (copy), v137 (copy), u142 (ref), resolve (copy)
						v77(false)
						v83(v140, v140, v138, v137, u142)
						resolve()
					end):catch(function() -- line: 388
						-- upvalues: v77 (copy), v84 (copy), SaveStatusEnum (copy), reject (copy)
						v77(false)
						v84(SaveStatusEnum.Failure)
						reject()
					end)

					return
				end

				local v148 = if not v144 then nil else saveProfileConfiguration(v143)
				local v149 = getGearAssetIdFromEquippedAssets(v138.equipped.EquippedAssets)

				saveAvatar(v140, v141, u142, v149):andThen(function(p11) -- line: 402
					-- upvalues: v77 (copy), v83 (copy), v140 (copy), v137 (copy), u142 (ref), resolve (copy), v148 (copy), v138 (copy), Cryo (copy)
					v77(false)

					local function finishSuccess(p12) -- line: 405
						-- upvalues: v83 (copy), v140 (copy), p11 (copy), v137 (copy), u142 (ref), resolve (copy)
						v83(v140, p11.humanoidDescriptionWithValidAssets, p12, v137, u142)
						resolve()
					end

					if v148 then
						v148:andThen(function() -- line: 419
							-- upvalues: v138 (copy), v83 (copy), v140 (copy), p11 (copy), v137 (copy), u142 (ref), resolve (copy)
							local v159 = v138

							v83(v140, p11.humanoidDescriptionWithValidAssets, v159, v137, u142)
							resolve()
						end, function() -- line: 421
							-- upvalues: Cryo (copy), v138 (copy), v137 (copy), v83 (copy), v140 (copy), p11 (copy), u142 (ref), resolve (copy)
							local v160 = Cryo.Dictionary.join(v138, {
								equipped = Cryo.Dictionary.join(v138.equipped, {
									BackgroundAssetId = if v137.equipped.BackgroundAssetId == nil then Cryo.None else v137.equipped.BackgroundAssetId
								})
							})

							v83(v140, p11.humanoidDescriptionWithValidAssets, v160, v137, u142)
							resolve()
						end)

						return
					end

					local v155 = v138

					v83(v140, p11.humanoidDescriptionWithValidAssets, v155, v137, u142)
					resolve()
				end):catch(function(_) -- line: 434
					-- upvalues: v77 (copy), FFlagAXAvatarTimeoutFlow (copy), v81 (copy), v84 (copy), SaveStatusEnum (copy), reject (copy)
					v77(false)

					if FFlagAXAvatarTimeoutFlow and v81 then
						v81.fetchStatus()
					end

					v84(SaveStatusEnum.Failure)
					reject()
				end)
			end
		end)
	end, {
		if not FFlagAXAvatarTimeoutFlow then nil else v81,
		v66,
		v68,
		v71,
		v73,
		v75,
		v79,
		if not FFlagAXAvatarTimeoutFlow then nil else v84,
		v77
	})

	if FFlagAXEnableManualSavingBlockingPrompt then
		local v86 = React.useCallback(function(s1: string) -- line: 466
			-- upvalues: v85 (copy), FFlagSignalsNavP3Dispatch (copy), v44 (copy), v62 (copy), NavigateToRoute (copy)
			return function() -- line: 467
				-- upvalues: v85 (copy), FFlagSignalsNavP3Dispatch (copy), v44 (copy), s1 (copy), v62 (copy), NavigateToRoute (copy)
				v85():finally(function() -- line: 468
					-- upvalues: FFlagSignalsNavP3Dispatch (copy), v44 (copy), s1 (copy), v62 (copy), NavigateToRoute (copy)
					if FFlagSignalsNavP3Dispatch then
						v44.to(v44.fromLegacyPage({
							skipSaveBlockingPrompt = true,
							name = s1
						}))

						return
					end

					v62(NavigateToRoute({{
						skipSaveBlockingPrompt = true,
						name = s1
					}}))
				end)
			end
		end, {
			v85,
			v62
		})
		local v87 = React.useCallback(function(s2: string) -- line: 478
			-- upvalues: v70 (copy), v62 (copy), CharacterHistoryStateChangeButtonActivated (copy), FFlagSignalsNavP3Dispatch (copy), v44 (copy), NavigateToRoute (copy)
			return function() -- line: 479
				-- upvalues: v70 (copy), v62 (copy), CharacterHistoryStateChangeButtonActivated (copy), FFlagSignalsNavP3Dispatch (copy), v44 (copy), s2 (copy), NavigateToRoute (copy)
				task.spawn(function() -- line: 480
					-- upvalues: v70 (copy), v62 (copy), CharacterHistoryStateChangeButtonActivated (copy), FFlagSignalsNavP3Dispatch (copy), v44 (copy), s2 (copy), NavigateToRoute (copy)
					local v157 = v70(false)

					v62(CharacterHistoryStateChangeButtonActivated(v157))
					task.wait()

					if FFlagSignalsNavP3Dispatch then
						v44.to(v44.fromLegacyPage({
							skipSaveBlockingPrompt = true,
							name = s2
						}))

						return
					end

					v62(NavigateToRoute({{
						skipSaveBlockingPrompt = true,
						name = s2
					}}))
				end)
			end
		end, {
			v62,
			v70
		})
		local v88 = React.useCallback(function(p14, p15) -- line: 501
			-- upvalues: Actions (copy), AvatarScreen (copy), t5 (copy), tutils (copy), v82 (copy), SaveStatusEnum (copy), Cryo (copy), v86 (copy), v87 (copy)
			local routeName = (p14 or {}).routeName
			local params = (p14 or {}).params

			if p14.type == Actions.Back and (not p14.immediate and p15.routes[#p15.routes] and p15.routes[#p15.routes].routeName == AvatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt) then
				return true, nil
			end

			if p14.type == Actions.Navigate and t5[routeName] ~= nil and ((params == nil or tutils.fieldCount(params) == 0) and v82(false) == SaveStatusEnum.Eligible) then
				if p15.routes[#p15.routes] and p15.routes[#p15.routes].routeName == AvatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt then
					return true, nil
				end

				local v119 = Cryo.List.join(p15.routes, {{
					key = AvatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt,
					routeName = AvatarScreen.SaveAvatarOnLeaveAvatarExperiencePrompt,
					params = {
						saveAndContinue = v86(routeName),
						continueWithoutSave = v87(routeName)
					}
				}})

				return true, Cryo.Dictionary.join(p15, {
					routes = v119,
					index = #v119
				})
			end

			return false, nil
		end, {
			v82,
			v86,
			v87
		})

		React.useEffect(function() -- line: 564
			-- upvalues: v63 (copy), RegisterCustomGetStateForAction (copy), CustomGetStateForAction (copy), v88 (copy)
			v63.dispatch(RegisterCustomGetStateForAction(CustomGetStateForAction.HandlerId.BlockAXExitOnUnsavedChanges, v88))
		end, {
			v63,
			v88
		})
	end

	React.useEffect(function() -- line: 577
		-- upvalues: Signals (copy), v66 (copy), v76 (copy), v82 (copy), SaveStatusEnum (copy), v85 (copy)
		return Signals.createEffect(function(p16) -- line: 578
			-- upvalues: v66 (copy), v76 (copy), v82 (copy), SaveStatusEnum (copy), v85 (copy)
			local v151 = v66(p16)

			if v151[#v151] and v76(false) then
				local v152 = v82(false)

				if v152 == SaveStatusEnum.Eligible or v152 == SaveStatusEnum.HasTryOns then
					v85()
				end
			end
		end)
	end, {})

	local v89 = React.useCallback(function() -- line: 595
		-- upvalues: v77 (copy)
		v77(true)
	end, { v77 })

	return React.useMemo(function() -- line: 600
		-- upvalues: v66 (copy), v68 (copy), v78 (copy), v70 (copy), v82 (copy), v85 (copy), v89 (copy)
		return {
			getHistorySignal = v66,
			getCurrentHistoryIndexSignal = v68,
			updateHistoryIndexAndGetCharacterData = v78,
			getLastSuccessfullySavedStateSignal = v70,
			getSaveEligibilityStatusSignal = v82,
			trySaveAvatar = v85,
			autoSaveNextNewSaveData = v89
		}
	end, {
		v66,
		v68,
		v78,
		v70,
		v82,
		v85,
		v89
	})
end

return useAvatarSaveContextProviderValue
