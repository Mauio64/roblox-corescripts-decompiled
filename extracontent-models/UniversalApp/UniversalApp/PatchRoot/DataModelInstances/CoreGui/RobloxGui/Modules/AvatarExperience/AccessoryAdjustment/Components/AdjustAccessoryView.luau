local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local InsertService = game:GetService("InsertService")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useAdjustmentDataCallbacksContext = require(Modules.AvatarExperience.Common.Context.AdjustmentData.useAdjustmentDataCallbacksContext)
local useAppliedDescriptionValueContext = require(Modules.AvatarExperience.Common.Context.AppliedDescription.useAppliedDescriptionValueContext)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local selectLowerAdjustmentLimits = require(Modules.AvatarExperience.AccessoryAdjustment.Selectors.selectLowerAdjustmentLimits)
local selectUpperAdjustmentLimits = require(Modules.AvatarExperience.AccessoryAdjustment.Selectors.selectUpperAdjustmentLimits)
local GamepadFocusHandlerForPage = require(Modules.AvatarExperience.Common.Components.GamepadFocusHandlerForPage)
local GimbalUtils = require(Modules.AvatarExperience.AccessoryAdjustment.GimbalUtils)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local withAppRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAppRoute)
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local Constants = require(Modules.AvatarExperience.AccessoryAdjustment.Constants)
local AccessoryAdjustmentUtils = require(Modules.AvatarExperience.AccessoryAdjustment.AccessoryAdjustmentUtils)
local SceneInteractionFrame = require(Modules.AvatarExperience.Common.Components.Scene.SceneInteractionFrame)
local SetAdjustmentType = require(Modules.AvatarExperience.AccessoryAdjustment.Actions.SetAdjustmentType)
local BoundInputsUpdater = require(Modules.AvatarExperience.Common.Components.BoundInputsUpdater)
local ControlPanel = require(Modules.AvatarExperience.AccessoryAdjustment.Components.ControlPanel)
local AccessoryAdjustmentResetButton = require(Modules.AvatarExperience.AccessoryAdjustment.Components.AccessoryAdjustmentResetButton)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local SetCurrentToastMessage = require(CorePackages.Workspace.Packages.ToastRodux).Actions.SetCurrentToastMessage
local ToastType = require(CorePackages.Workspace.Packages.ToastRodux).Enums.ToastType
local Analytics = require(Modules.AvatarExperience.AccessoryAdjustment.Services.Analytics)
local SendRefinementAnalytics = require(Modules.AvatarExperience.AccessoryAdjustment.Thunks.SendRefinementAnalytics)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local FFlagAXMigrateSceneGamepadHandlerInputBindings = SharedFlags.FFlagAXMigrateSceneGamepadHandlerInputBindings
local FFlagAvatarJointUpgradeInUA = SharedFlags.FFlagAvatarJointUpgradeInUA
local v45 = if not FFlagAXMigrateSceneGamepadHandlerInputBindings then require(Modules.AvatarExperience.Common.Components.Scene.SceneGamepadHandler_DEPRECATED) else require(Modules.AvatarExperience.Common.Components.Scene.SceneGamepadHandler)
local flaggedMutedError = require(CorePackages.Workspace.Packages.Loggers).flaggedMutedError
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AdjustmentType = require(Modules.AvatarExperience.AccessoryAdjustment.Enum.AdjustmentType)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local FFlagAXMoveResetButtonToControlPanel = require(Modules.AvatarExperience.Flags.FFlagAXMoveResetButtonToControlPanel)
local AXEnableAccessoryAdjustmentDuringTryOnIXP = require(CorePackages.Workspace.Packages.AvatarExperienceExperiments).AXEnableAccessoryAdjustmentDuringTryOnIXP
local FFlagAXMigrateAdjustAccessoryViewToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAdjustAccessoryViewToFocusNavigation
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local t1 = {
	toastMessage = "Feature.Avatar.Generic.Error",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}
local t2 = {
	toastMessage = "Feature.Avatar.Label.AccessoryCannotBeAdjustedWarning",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}
local t3 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonY] = FocusNavigationEventNameEnum.AdjustAccessoryViewReset
}

local function useFocusNavigationBindings(p1, p2: ((...any) -> ...any), p3: ((...any) -> ...any)) -- line: 107
	-- upvalues: ReactFocusNavigation (copy), t3 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v67 = ReactFocusNavigation.useEventMap(t3, p1)
	local v68 = React.useMemo(function() -- line: 109
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p2 (copy), p3 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p4) -- line: 112
					-- upvalues: p2 (copy)
					p4.cancelled = true
					p2()
				end)
			},
			[FocusNavigationEventNameEnum.AdjustAccessoryViewReset] = {
				handler = InputHandlers.onRelease(p3)
			}
		}
	end, {
		p2,
		p3
	})

	return ReactFocusNavigation.useEventHandlerMap(v68, v67)
end
local function mapTokens(p5) -- line: 134
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
	return {
		smallIconSize = if not FFlagRenameDeprecatedUIBloxTokens then p5.Semantic.Icon.Size.Small else p5.Size.Size_400,
		buttonSize = if not FFlagRenameDeprecatedUIBloxTokens then p5.Global.Size_400 else p5.Size.Size_800,
		portraitPadding = if not FFlagRenameDeprecatedUIBloxTokens then p5.Global.Size_100 else p5.Size.Size_200,
		landscapePadding = if not FFlagRenameDeprecatedUIBloxTokens then p5.Global.Size_150 else p5.Size.Size_300,
		sidePadding = if not FFlagRenameDeprecatedUIBloxTokens then p5.Global.Size_150 else p5.Size.Size_300,
		cornerRadius = if not FFlagRenameDeprecatedUIBloxTokens then p5.Semantic.Radius.Medium else p5.Radius.Medium,
		panelMargin = if not FFlagRenameDeprecatedUIBloxTokens then p5.Global.Size_450 else p5.Size.Size_900
	}
end
local function selectAdjustmentTypeSelected(p6) -- line: 150
	return p6.AvatarExperience.AccessoryAdjustment.AdjustmentTypeSelected
end
local function selectTopBarHeight(p7) -- line: 154
	return p7.TopBar.topBarHeight
end
local function selectSelectedAccessory(p8) -- line: 158
	return p8.AvatarExperience.AccessoryAdjustment.SelectedAccessory
end
local function selectEquippedAssets(p9) -- line: 163
	return p9.AvatarExperience.AvatarEditor.Character.EquippedAssets
end
local function selectTryOns(p10) -- line: 167
	return p10.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end
local function AdjustAccessoryView(t4: {[any]: any}) -- line: 171
	-- upvalues: useDesignTokens (copy), mapTokens (copy), useDispatch (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), useAdjustmentDataCallbacksContext (copy), useAppliedDescriptionValueContext (copy), useSelector (copy), selectSelectedAccessory (copy), selectEquippedAssets (copy), selectTryOns (copy), useRoactService (copy), Analytics (copy), React (copy), selectLowerAdjustmentLimits (copy), selectUpperAdjustmentLimits (copy), useLocalization (copy), AXEnableAccessoryAdjustmentDuringTryOnIXP (copy), AccessoryAdjustmentUtils (copy), Cryo (copy), Utils (copy), flaggedMutedError (copy), selectAdjustmentTypeSelected (copy), selectTopBarHeight (copy), IxpUtils (copy), useNavigation (copy), AvatarScreen (copy), SendRefinementAnalytics (copy), Constants (copy), useFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), InsertService (copy), SetAdjustmentType (copy), AdjustmentType (copy), SetCurrentToastMessage (copy), t1 (copy), FFlagAvatarJointUpgradeInUA (copy), t2 (copy), GimbalUtils (copy), GamepadFocusHandlerForPage (copy), TopBar (copy), FFlagAXMigrateAdjustAccessoryViewToFocusNavigation (copy), SceneInteractionFrame (copy), FFlagAXMoveResetButtonToControlPanel (copy), AccessoryAdjustmentResetButton (copy), ControlPanel (copy), Focusable (copy), v45 (copy), BoundInputsUpdater (copy)
	local v76 = useDesignTokens(mapTokens)
	local v77 = useDispatch()
	local v78 = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.useRootFocusController() else nil
	local v79 = useAdjustmentDataCallbacksContext()
	local v80 = useAppliedDescriptionValueContext()
	local v81 = v80.appliedDescriptionBinding:getValue()
	local v82 = useSelector(selectSelectedAccessory)

	assert(v82, "Assert selectedAccessory exists")

	local v83 = useSelector(selectEquippedAssets)
	local v84 = useSelector(selectTryOns)
	local v85 = useRoactService(Analytics)
	local v86 = React.useRef(false)
	local v87 = useSelector(selectLowerAdjustmentLimits)
	local v88 = useSelector(selectUpperAdjustmentLimits)
	local v89 = useLocalization({
		apply = "CommonUI.Messages.Action.Apply",
		topBarTitle = if not AXEnableAccessoryAdjustmentDuringTryOnIXP.isEnabled() then nil else "Feature.Avatar.Heading.AccessoryAdjustmentTitle"
	})
	local v90, v91 = React.useState(AccessoryAdjustmentUtils.getSliderValuesWithDefault(v83, v84, v82))
	local v92 = React.useRef(AccessoryAdjustmentUtils.getSliderValuesWithDefault(v83, v84, v82))

	React.useEffect(function() -- line: 203
		-- upvalues: v92 (copy), v90 (copy)
		v92.current = v90
	end, { v90 })

	local v93 = React.useCallback(function(p11, p12) -- line: 207
		-- upvalues: Cryo (copy), v92 (copy), v91 (copy)
		local v119 = Cryo.Dictionary.join(v92.current, {
			[p12] = p11
		})

		v91(v119)
	end, { v92 })
	local v94 = React.useCallback(function(p13, p14) -- line: 214
		-- upvalues: Cryo (copy), v92 (copy), AccessoryAdjustmentUtils (copy), v79 (copy)
		local v122 = Cryo.Dictionary.join(v92.current, {
			[p14] = p13
		})
		local v123, v124, v125 = AccessoryAdjustmentUtils.sliderInfoToVector3s(v122)

		v79.setAdjustments(v123, v124, v125)
	end, { v92 })
	local v95, v96 = React.useState(false)
	local u97 = nil
	local v98, v99 = React.useState(nil)

	React.useEffect(function() -- line: 226
		-- upvalues: v80 (copy), v82 (copy), u97 (ref), Utils (copy), v99 (copy), flaggedMutedError (copy)
		local v126 = v80.appliedDescriptionBinding:getValue()

		if v126 and v82 then
			u97 = Utils.getSelectedAccessoryDescription(v126, v82)

			if u97 then
				local ok, result = pcall(function() -- line: 233
					-- upvalues: u97 (ref)
					return u97:GetAppliedInstance()
				end)

				if ok then
					v99(result)

					return
				end

				flaggedMutedError("AdjustAccessoryView", "AdjustAccessoryView accessoryDescription:GetAppliedInstance error: " .. tostring(result))
			end
		end
	end, {
		v81,
		v82
	})

	local v100 = useSelector(selectAdjustmentTypeSelected)
	local v101 = useSelector(selectTopBarHeight)
	local v102, v103 = React.useState(nil)
	local v104 = React.useRef(nil)
	local v105 = React.useRef(nil)
	local v106 = React.useRef(nil)
	local v107 = React.useRef(nil)
	local v108 = React.useRef(nil)
	local v109 = if not AXEnableAccessoryAdjustmentDuringTryOnIXP.isEnabled() then nil else IxpUtils.readTestVariable(AXEnableAccessoryAdjustmentDuringTryOnIXP.EnabledForUser)
	local v110 = if not AXEnableAccessoryAdjustmentDuringTryOnIXP.isEnabled() then nil else useNavigation().state.params
	local v111 = React.useCallback(function() -- line: 269
		-- upvalues: AccessoryAdjustmentUtils (copy), v83 (copy), v84 (copy), v82 (copy), v92 (copy), t4 (copy), AvatarScreen (copy), v79 (copy), v109 (copy), v110 (copy)
		local v129 = AccessoryAdjustmentUtils.getSliderValuesWithDefault(v83, v84, v82)

		if AccessoryAdjustmentUtils.checkSliderValuesChanged(v92.current, v129) then
			t4.navigation.navigate(AvatarScreen.AccessoryAdjustmentUnsavedPrompt, {
				exitCallback = function() -- line: 274
					-- upvalues: AccessoryAdjustmentUtils (copy), v129 (copy), v79 (copy), v109 (copy), v110 (copy), t4 (copy)
					local v150, v151, v152 = AccessoryAdjustmentUtils.sliderInfoToVector3s(v129)

					v79.setAdjustments(v150, v151, v152)

					if v109 and (v110 and v110.fromRoute) then
						t4.navigation.popToTop()
						t4.navigation.navigate(v110.fromRoute)

						return
					end

					t4.navigation.pop()
				end
			})

			return
		end

		if v109 and v110 and v110.fromRoute then
			t4.navigation.popToTop()
			t4.navigation.navigate(v110.fromRoute)

			return
		end

		t4.navigation.pop()
	end, {
		v83,
		v84,
		v82,
		v79,
		t4.navigation
	})
	local v112 = React.useCallback(function() -- line: 305
		-- upvalues: t4 (copy), AvatarScreen (copy), v77 (copy), SendRefinementAnalytics (copy), v85 (copy), AccessoryAdjustmentUtils (copy), Constants (copy), v79 (copy), v91 (copy)
		t4.navigation.navigate(AvatarScreen.AccessoryAdjustmentResetPrompt, {
			resetCallback = function() -- line: 307
				-- upvalues: v77 (copy), SendRefinementAnalytics (copy), v85 (copy), AccessoryAdjustmentUtils (copy), Constants (copy), v79 (copy), v91 (copy)
				v77(SendRefinementAnalytics(v85.avatarRefineAccessoryResetConfirm))

				local v153, v154, v155 = AccessoryAdjustmentUtils.sliderInfoToVector3s(Constants.DefaultSliderValues)

				v79.setAdjustments(v153, v154, v155)
				v91(Constants.DefaultSliderValues)
			end
		})
	end, {
		t4.navigation,
		v79,
		v91,
		v85
	})
	local v113 = React.useMemo(function() -- line: 322
		-- upvalues: RoactGamepad (copy), v111 (copy), v112 (copy)
		return {
			Back = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, v111),
			OpenResetPrompt = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonY, v112, {
				key = "CommonUI.Messages.Action.Reset"
			})
		}
	end, {
		v111,
		v112
	})
	local v114 = useFocusNavigationBindings(nil, v111, v112)
	local v115 = useTableWrappedCallbackRef(v114)

	React.useEffect(function() -- line: 334
		-- upvalues: v103 (copy), InsertService (copy), v77 (copy), SetAdjustmentType (copy), AdjustmentType (copy), v102 (copy), v86 (copy), AccessoryAdjustmentUtils (copy), v83 (copy), v84 (copy), v82 (copy), v79 (copy)
		v103(InsertService:LoadLocalAsset("rbxasset://models/AccessoryAdjustment/Ring.rbxm"))

		return function() -- line: 336
			-- upvalues: v77 (copy), SetAdjustmentType (copy), AdjustmentType (copy), v102 (copy), v86 (copy), AccessoryAdjustmentUtils (copy), v83 (copy), v84 (copy), v82 (copy), v79 (copy)
			v77(SetAdjustmentType(AdjustmentType.Position))

			if v102 then
				v102:Destroy()
			end

			if not v86.current then
				local v156 = AccessoryAdjustmentUtils.getSliderValuesWithDefault(v83, v84, v82)
				local v157, v158, v159 = AccessoryAdjustmentUtils.sliderInfoToVector3s(v156)

				v79.setAdjustments(v157, v158, v159)
			end
		end
	end, {})
	React.useEffect(function() -- line: 354
		-- upvalues: v102 (copy), v77 (copy), SetCurrentToastMessage (copy), v96 (copy), t4 (copy), v98 (copy), t1 (copy), FFlagAvatarJointUpgradeInUA (copy), Utils (copy), t2 (copy), GimbalUtils (copy), v100 (copy), AdjustmentType (copy), v76 (copy), v87 (copy), v88 (copy)
		if not v102 then
			return
		end

		local function exitWithToast(p15) -- line: 360
			-- upvalues: v77 (copy), SetCurrentToastMessage (copy), v96 (copy), t4 (copy)
			v77(SetCurrentToastMessage(p15))
			v96(false)
			t4.navigation.pop()
		end

		if not v98 then
			local v131 = t1

			v77(SetCurrentToastMessage(v131))
			v96(false)
			t4.navigation.pop()

			return
		end

		local Handle = v98:FindFirstChild("Handle")

		if not Handle then
			local v133 = t1

			v77(SetCurrentToastMessage(v133))
			v96(false)
			t4.navigation.pop()

			return
		end

		local v134 = nil
		local v135 = nil
		local v136 = nil
		local Weld = Handle:FindFirstChildOfClass("Weld")
		local v138 = if not FFlagAvatarJointUpgradeInUA then nil else Handle:FindFirstChildOfClass("RigidConstraint")

		if FFlagAvatarJointUpgradeInUA then
			if v138 then
				v134 = if not v138.Attachment0 then nil else v138.Attachment0:FindFirstAncestorWhichIsA("BasePart")
				v135 = if not v138.Attachment1 then nil else v138.Attachment1:FindFirstAncestorWhichIsA("BasePart")
				v136 = if not v138.Attachment1 then nil else Utils.getRecursiveAttachmentCFrame(v138.Attachment1)
			elseif Weld then
				v134 = Weld.Part0
				v135 = Weld.Part1
				v136 = Weld.C1
			end

			if not v134 or not v135 or not v136 then
				local v139 = t1

				v77(SetCurrentToastMessage(v139))
				v96(false)
				t4.navigation.pop()

				return
			end
		elseif not Weld then
			local v140 = t1

			v77(SetCurrentToastMessage(v140))
			v96(false)
			t4.navigation.pop()

			return
		end

		if Handle:IsA("MeshPart") and Handle.HasSkinnedMesh then
			local v141 = t2

			v77(SetCurrentToastMessage(v141))
			v96(false)
			t4.navigation.pop()

			return
		end

		v96(true)

		local v142 = GimbalUtils.getLargestAxisSize(Handle.Size)
		local Folder = Instance.new("Folder")

		if v100 == AdjustmentType.Position then
			GimbalUtils.createPositionAxis(Folder, v76.smallIconSize, v142, v87.position, v88.position)
			GimbalUtils.createBillboardRing(Handle, Folder, "rbxasset://textures/ui/AvatarExperience/SelectionRing.png", "Selection")
		elseif v100 == AdjustmentType.Rotation then
			assert(v102:IsA("MeshPart"), "Assert ringPart is a MeshPart")
			GimbalUtils.createRotationAxis(Folder, v142, v76.smallIconSize, v102)
		elseif v100 == AdjustmentType.Scale then
			GimbalUtils.createBillboardRing(Handle, Folder, "rbxasset://textures/ui/AvatarExperience/GlowRing.png", "Scale")
			GimbalUtils.createSelectionDot(Folder, "rbxasset://textures/ui/AvatarExperience/CenterPoint.png", "SelectionDot")
		end

		Folder.Parent = workspace

		local Part = Instance.new("Part")

		Part.Transparency = 1
		Part.Name = "Anchor"
		Part.Parent = Folder

		local Weld2 = Instance.new("Weld")

		Weld2.Part0 = Part
		Weld2.Part1 = if not FFlagAvatarJointUpgradeInUA then Weld.Part1 else v135
		Weld2.C1 = CFrame.new(if not FFlagAvatarJointUpgradeInUA then Weld.C1.Position else v136.Position)

		if v100 == AdjustmentType.Position then
			GimbalUtils.setPositionAdornee(Folder, Handle, Part)
		elseif v100 == AdjustmentType.Rotation then
			local Weld2Part1 = Weld2.Part1
			local v147 = if not FFlagAvatarJointUpgradeInUA then Weld.Part0 else v134

			assert(Weld2Part1, "Assert head not nil")
			assert(v147, "Accessory not nil")
			Weld2.C1 = CFrame.new((Weld2Part1.CFrame:Inverse() * v147.CFrame).Position)
			GimbalUtils.setRotationAdornee(Folder, Part)
		elseif v100 == AdjustmentType.Scale then
			GimbalUtils.setScaleAdornee(Folder, Handle)
		end

		Weld2.Parent = Part

		local t5 = {}

		table.insert(t5, GimbalUtils.setUpSizeConnection(Handle, Folder))
		table.insert(t5, GimbalUtils.setUpCameraConnection(Handle, Folder))

		return function() -- line: 462
			-- upvalues: Folder (copy), t5 (copy)
			if Folder then
				Folder:Destroy()
			end

			for _, v162 in t5 do
				v162:Disconnect()
			end
		end
	end, {
		v100,
		v82,
		v98,
		v102,
		v87,
		v88,
		t4.navigation,
		v77
	})

	local t6 = {
		GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then React.createElement(GamepadFocusHandlerForPage, {
			captureFocusOnMount = true,
			focusController = v78
		}) else nil,
		TopBar = React.createElement(TopBar.Container, {
			transparentBackground = true,
			ZIndex = 1,
			titleText = not v109 and "" or v89.topBarTitle,
			leftItem = TopBar.makeBackButton(v111),
			ref = v105,
			NextSelectionDown = v108
		}),
		PageContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -v101),
			Position = UDim2.fromOffset(0, v101),
			ref = if not FFlagAXMigrateAdjustAccessoryViewToFocusNavigation then nil else v115
		}, {
			SceneInteractionFrame = React.createElement(SceneInteractionFrame),
			ResetButton = if FFlagAXMoveResetButtonToControlPanel then nil else React.createElement(AccessoryAdjustmentResetButton, {
				onResetButtonPressed = v112,
				NextSelectionLeft = v105
			}),
			ControlPanel = if not v95 then nil else React.createElement(ControlPanel, {
				setSliderValuesCallback = v93,
				updateCharacterCallback = v94,
				onResetButtonPressed = if not FFlagAXMoveResetButtonToControlPanel then nil else v112,
				adjustmentTypeFrameRef = v108,
				sliderFrameRef = v104,
				topBarRef = v105,
				resetRef = if FFlagAXMoveResetButtonToControlPanel then nil else v107,
				applyButtonRef = v106,
				sliderValues = v90,
				isApplyingAdjustment = v86
			})
		})
	}

	return React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v78 else nil,
		defaultChild = v108,
		inputBindings = if not FFlagAXMigrateAdjustAccessoryViewToFocusNavigation then v113 else nil
	}, {
		SceneGamepadHandler = React.createElement(v45, nil, t6),
		BoundInputsUpdater = if FFlagAXMigrateAXToGlobalAutofocus then nil else React.createElement(BoundInputsUpdater)
	})
end

return (withStackVisibilityWrapper((withAppRoute(AdjustAccessoryView))))
