local ChromeShared = script:FindFirstAncestor("ChromeShared")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local React = require(CorePackages.Packages.React)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagDebugEnableUnibarDummyIntegrations = SharedFlags.GetFFlagDebugEnableUnibarDummyIntegrations
local GetFIntIconSelectionTimeout = SharedFlags.GetFIntIconSelectionTimeout
local GetFFlagChromeCentralizedConfiguration = SharedFlags.GetFFlagChromeCentralizedConfiguration
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagAddUILessMode = SharedFlags.FFlagAddUILessMode
local FIntAddUILessModeVariant = SharedFlags.FIntAddUILessModeVariant
local FFlagEnableInExperienceAvatarSwitcher = SharedFlags.FFlagEnableInExperienceAvatarSwitcher
local FFlagEnableSideSheet = SharedFlags.FFlagEnableSideSheet
local FFlagAddInviteFriendsIntegration = SharedFlags.FFlagAddInviteFriendsIntegration
local FFlagSideSheetSwapGalleryOrder = SharedFlags.FFlagSideSheetSwapGalleryOrder
local FFlagIntegrateTraversalHistoryInSideSheet = SharedFlags.FFlagIntegrateTraversalHistoryInSideSheet
local FFlagEnableInExperienceShop = SharedFlags.FFlagEnableInExperienceShop
local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local FFlagUnibarMenuOpenSubmenu = require(script.Parent.Parent.Parent.Flags).FFlagUnibarMenuOpenSubmenu
local FFlagReverseUnibar = require(script.Parent.Parent.Parent.Flags.FFlagReverseUnibar)
local FFlagTokenizeUnibarConstantsWithStyleProvider = require(ChromeShared.Flags).FFlagTokenizeUnibarConstantsWithStyleProvider
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local Service = require(ChromeShared.Service)
local UnibarStyle = require(CorePackages.Workspace.Packages.Chrome).UnibarStyle

if GetFFlagChromeCentralizedConfiguration() then
else
	require(ChromeShared.Parent.Integrations)
end

local SubMenu = require(ChromeShared.Unibar.SubMenu)
local WindowManager = require(ChromeShared.Unibar.WindowManager)
local ShortcutBar = require(ChromeShared.Shortcuts.ShortcutBar)
local Constants = require(ChromeShared.Unibar.Constants)
local useChromeMenuItems = require(ChromeShared.Hooks.useChromeMenuItems)
local useObservableValue = require(ChromeShared.Hooks.useObservableValue)
local useMappedObservableValue = require(ChromeShared.Hooks.useMappedObservableValue)
local IconHost = require(ChromeShared.Unibar.ComponentHosts.IconHost)
local ReactOtter = require(CorePackages.Packages.ReactOtter)
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local FFlagReduceTopBarInsetsWhileHidden = SharedFlags.FFlagReduceTopBarInsetsWhileHidden
local Stores = require(CorePackages.Workspace.Packages.CoreGuiCommon).Stores
local createEffect = require(CorePackages.Packages.Signals).createEffect
local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)
local Constants2 = require(ChromeShared.Parent.Integrations.Party.Constants)
local isConnectUnibarEnabled = require(ChromeShared.Parent.Integrations.Connect.isConnectUnibarEnabled)
local isConnectDropdownEnabled = require(ChromeShared.Parent.Integrations.Connect.isConnectDropdownEnabled)
local v43 = if not FFlagEnableConsoleExpControls then nil else require(ChromeShared.Parent.Parent.TopBar.Components.GamepadConnector)
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local Panel3DInSpatialUI = nil
local PanelType = nil
local u47 = nil

if isInExperienceUIVREnabled then
	local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)

	Panel3DInSpatialUI = VrSpatialUi.Panel3DInSpatialUI
	PanelType = VrSpatialUi.Constants.PanelType
	u47 = require(CorePackages.Workspace.Packages.Observable).ObservableValue.new(true)
end

local v49 = if not FFlagIntegrateTraversalHistoryInSideSheet then nil else require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon).Traversal
local v50 = not not v49 and v49.Flags.FFlagAddTraversalHistory
local ArgoPartyExperimentation = require(CorePackages.Workspace.Packages.SocialExperiments).ArgoPartyExperimentation
local FFlagRemoveFriendsChatUnibarEntrypoints = SharedFlags.FFlagRemoveFriendsChatUnibarEntrypoints
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab

if not GetFFlagChromeCentralizedConfiguration() then
	function configureUnibar() -- line: 91
		-- upvalues: FFlagEnableSideSheet (copy), isConnectDropdownEnabled (copy), FFlagRemoveFriendsChatUnibarEntrypoints (copy), ArgoPartyExperimentation (copy), FFlagExpChatEnableFriendsTab (copy), FFlagReverseUnibar (copy), GetFFlagDebugEnableUnibarDummyIntegrations (copy), isConnectUnibarEnabled (copy), Constants2 (copy), FFlagAppNavMyStatsTab (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), Service (copy), FFlagEnableInExperienceAvatarSwitcher (copy), Constants (copy), GuiService (copy), FFlagSideSheetSwapGalleryOrder (copy), v50 (copy), FFlagIntegrateTraversalHistoryInSideSheet (copy), FFlagAddInviteFriendsIntegration (copy), InExperienceSideSheet (copy), FFlagEnableInExperienceShop (copy)
		local t1 = {
			"leaderboard",
			"emotes",
			"backpack"
		}

		if not FFlagEnableSideSheet then
			table.insert(t1, "respawn")
		end

		table.insert(t1, 1, "trust_and_safety")

		if isConnectDropdownEnabled() and (not FFlagRemoveFriendsChatUnibarEntrypoints or not ArgoPartyExperimentation.getIsRenameEnabled() or not FFlagExpChatEnableFriendsTab) then
			table.insert(t1, 1, "connect_dropdown")
		end

		local t2 = {
			"nine_dot",
			"chat",
			"toggle_mic_mute"
		}

		if FFlagReverseUnibar then
			table.insert(t2, 3, "join_voice")

			if GetFFlagDebugEnableUnibarDummyIntegrations() then
				table.insert(t2, "dummy_window")
				table.insert(t2, "dummy_window_2")
			end

			if isConnectUnibarEnabled() then
				table.insert(t2, not ArgoPartyExperimentation.getIsRenameEnabled() and "connect_unibar" or "party_entrypoint")
			end

			local v60 = table.find(t2, "toggle_mic_mute")

			if v60 then
				table.insert(t2, v60, Constants2.TOGGLE_MIC_INTEGRATION_ID)
			end
		else
			t2 = {
				"toggle_mic_mute",
				"chat",
				"nine_dot"
			}
			table.insert(t2, 2, "join_voice")

			if GetFFlagDebugEnableUnibarDummyIntegrations() then
				table.insert(t2, 1, "dummy_window")
				table.insert(t2, 1, "dummy_window_2")
			end

			if isConnectUnibarEnabled() then
				table.insert(t2, 1, not ArgoPartyExperimentation.getIsRenameEnabled() and "connect_unibar" or "party_entrypoint")
			end

			local v61 = table.find(t2, "toggle_mic_mute")

			if v61 then
				table.insert(t2, v61 + 1, Constants2.TOGGLE_MIC_INTEGRATION_ID)
			end
		end

		if FFlagAppNavMyStatsTab then
			table.insert(t2, "assistant_build")
		end

		if isInExperienceUIVREnabled and isSpatial() then
			Service:configureMenu({
				{
					"vr_toggle_button",
					"vr_safety_bubble"
				},
				t2
			})
		else
			Service:configureMenu({ t2 })
		end

		if isInExperienceUIVREnabled then
			if not isSpatial() then
				table.insert(t1, 2, "camera_entrypoint")
				table.insert(t1, 2, "selfie_view")
			end
		else
			table.insert(t1, 2, "camera_entrypoint")
			table.insert(t1, 2, "selfie_view")
		end

		if FFlagEnableInExperienceAvatarSwitcher then
			table.insert(t1, 3, Constants.AVATAR_SWITCHER_ID)
		end

		if not isSpatial() and not GuiService:IsTenFootInterface() then
			table.insert(t1, 4, "music_entrypoint")
		end

		if FFlagEnableSideSheet then
			table.insert(t1, "people")
			table.insert(t1, "settings")

			if FFlagSideSheetSwapGalleryOrder then
				table.insert(t1, "gallery")
				table.remove(t1, table.find(t1, "trust_and_safety"))
				table.insert(t1, "trust_and_safety")
			else
				table.remove(t1, table.find(t1, "trust_and_safety"))
				table.insert(t1, "trust_and_safety")
				table.insert(t1, "gallery")
			end

			table.insert(t1, "help")

			if v50 and FFlagIntegrateTraversalHistoryInSideSheet then
				table.insert(t1, "traversal_history")
			end

			if FFlagAddInviteFriendsIntegration then
				table.insert(t1, 2, "invite_friends")
			end

			table.insert(t1, InExperienceSideSheet.Enums.ActionBinding.Leave)
			table.insert(t1, InExperienceSideSheet.Enums.ActionBinding.Respawn)
		end

		if FFlagEnableInExperienceShop then
			table.insert(t1, 2, Constants.IN_EXPERIENCE_SHOP_ID)
		end

		Service:configureSubMenu("nine_dot", t1)
	end

	configureUnibar()

	if FFlagEnableConsoleExpControls then
		require(script.Parent.Parent.Shortcuts.ConfigureShortcuts)()
	end
end

function IconDivider(t3: {[any]: any}) -- line: 245
	-- upvalues: useStyle (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy)
	local v63 = useStyle()
	local v64 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.ICON_DIVIDER_POSITION else UnibarStyle.use().ICON_DIVIDER_POSITION

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Position = t3.position,
		Size = UDim2.new(0, Constants.DIVIDER_CELL_WIDTH, 1, 0)
	}, {
		DividerBar = React.createElement("Frame", {
			BorderSizePixel = 0,
			Position = v64,
			AnchorPoint = Vector2.new(0, 0.5),
			Size = Constants.ICON_DIVIDER_SIZE,
			BackgroundColor3 = v63.Theme.Divider.Color,
			BackgroundTransparency = if not t3.toggleTransition then v63.Theme.Divider.Transparency else t3.toggleTransition:map(function(p1) -- line: 269
				-- upvalues: v63 (copy)
				return v63.Theme.Divider.Transparency + (1 - p1) * (1 - v63.Theme.Divider.Transparency)
			end),
			Visible = t3.visible or true
		})
	})
end

local function getSelectedChild(t4: {[any]: any}, s1: string?) -- line: 278
	-- upvalues: Constants (copy)
	return t4.current:FindFirstChild(Constants.ICON_NAME_PREFIX .. tostring(s1), true)
end

function AnimationStateHelper(p2) -- line: 284
	-- upvalues: useObservableValue (copy), Service (copy), React (copy), FFlagEnableConsoleExpControls (copy), ContextActionService (copy), GuiService (copy), Constants (copy), FFlagUnibarMenuOpenSubmenu (copy), ReactOtter (copy), GetFIntIconSelectionTimeout (copy)
	local v68 = useObservableValue(Service:currentSubMenu())
	local v69 = useObservableValue(Service:selectedItem())
	local v70 = useObservableValue(Service:inFocusNav())

	React.useEffect(function() -- line: 290
		-- upvalues: v70 (copy), FFlagEnableConsoleExpControls (copy), ContextActionService (copy), Service (copy), GuiService (copy), p2 (copy), v69 (copy), Constants (copy), FFlagUnibarMenuOpenSubmenu (copy)
		if v70 then
			if not FFlagEnableConsoleExpControls then
				ContextActionService:BindCoreAction("RBXEscapeUnibar", function(_, p4, _) -- line: 293
					-- upvalues: FFlagEnableConsoleExpControls (copy), Service (copy), GuiService (copy)
					if FFlagEnableConsoleExpControls then
						if p4 == Enum.UserInputState.End then
							Service:disableFocusNav()
							GuiService.SelectedCoreObject = nil

							return
						end
					else
						Service:disableFocusNav()
					end
				end, false, Enum.KeyCode.ButtonB)
			end

			if FFlagEnableConsoleExpControls then
				if p2.menuFrameRef.current then
					local menuFrameRef = p2.menuFrameRef
					local v173 = v69
					local v174 = menuFrameRef.current:FindFirstChild(Constants.ICON_NAME_PREFIX .. tostring(v173), true)

					if v174 then
						GuiService.SelectedCoreObject = v174

						return
					end

					if FFlagUnibarMenuOpenSubmenu then
						if FFlagEnableConsoleExpControls then
							Service:selectedItem():set("nine_dot")
						end

						Service:toggleSubMenu("nine_dot")

						return
					end

					GuiService:Select(p2.menuFrameRef.current)

					return
				end
			elseif p2.menuFrameRef.current then
				GuiService:Select(p2.menuFrameRef.current)

				return
			end
		else
			ContextActionService:UnbindCoreAction("RBXEscapeUnibar")

			if GuiService.SelectedCoreObject and p2.menuFrameRef.current:IsAncestorOf(GuiService.SelectedCoreObject) then
				GuiService.SelectedCoreObject = nil
			end
		end
	end, { v70 })
	React.useEffect(function() -- line: 338
		-- upvalues: v68 (copy), FFlagUnibarMenuOpenSubmenu (copy), v70 (copy), GuiService (copy), p2 (copy), ReactOtter (copy), Constants (copy)
		if v68 == "nine_dot" then
			if FFlagUnibarMenuOpenSubmenu and v70 then
				GuiService:Select(p2.subMenuHostRef.current)
			end

			p2.setToggleSubmenuTransition((ReactOtter.spring(1, Constants.MENU_ANIMATION_SPRING)))

			return
		end

		p2.setToggleSubmenuTransition((ReactOtter.spring(0, Constants.MENU_ANIMATION_SPRING)))
	end, { v68 })
	React.useEffect(function() -- line: 349
		-- upvalues: FFlagEnableConsoleExpControls (copy), v68 (copy), v69 (copy), GetFIntIconSelectionTimeout (copy), p2 (copy), Constants (copy), GuiService (copy)
		if FFlagEnableConsoleExpControls and v68 == v69 then
			return
		end

		local co = coroutine.create(function() -- line: 354
			-- upvalues: GetFIntIconSelectionTimeout (copy), p2 (copy), v69 (copy), FFlagEnableConsoleExpControls (copy), Constants (copy), GuiService (copy)
			local n1 = 0
			local v204

			repeat
				repeat
					if not (n1 < GetFIntIconSelectionTimeout()) then
						return
					end

					n1 += 1
					task.wait()
				until p2.menuFrameRef.current and v69

				if FFlagEnableConsoleExpControls then
					local menuFrameRef = p2.menuFrameRef
					local v203 = v69

					v204 = menuFrameRef.current:FindFirstChild(Constants.ICON_NAME_PREFIX .. tostring(v203), true)
				else
					v204 = p2.menuFrameRef.current:FindFirstChild("IconHitArea_" .. v69, true)
				end
			until v204

			GuiService.SelectedCoreObject = v204
		end)

		coroutine.resume(co)
	end, {
		v69,
		if not FFlagEnableConsoleExpControls then nil else v68
	})

	return nil
end
function linearInterpolation(n2: number, n3: number, n4: number) -- line: 380
	return n2 * (1 - n4) + n3 * n4
end
function IconPositionBinding(p6, n5: number, n6: number, n7: number, p7, p8, b1: boolean, b2: boolean?, p9) -- line: 384
	-- upvalues: FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy)
	local u83 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.UNIBAR_END_PADDING else UnibarStyle.use().UNIBAR_END_PADDING

	return (React.joinBindings({
		p6,
		p7,
		p8
	}):map(function(t5: {[any]: any}) -- line: 404
		-- upvalues: p9 (copy), n6 (copy), n5 (copy), n7 (copy), b2 (copy), b1 (copy), u83 (ref)
		local v177 = if not p9.current then linearInterpolation(n5, n6, t5[2]) else linearInterpolation(n6, n5, t5[2])
		local v178 = n7

		if b2 and not b1 then
			v178 = n7 - t5[3]
		end

		local v179 = v177 - v178

		return UDim2.new(0, u83 + v178 + v179 * t5[1], 0, 0)
	end))
end

local function onUnibarSelectionChanged(p10, _: boolean, _, p12) -- line: 422
	-- upvalues: Service (copy)
	if not p10:IsAncestorOf(p12) then
		Service:disableFocusNav()
	end
end

function isLeft(p13) -- line: 441
	return p13 == Enum.HorizontalAlignment.Left
end
function Unibar(t6: {[any]: any}) -- line: 445
	-- upvalues: FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy), FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), Stores (copy), useChromeMenuItems (copy), ReactOtter (copy), Service (copy), FFlagReduceTopBarInsetsWhileHidden (copy), v43 (copy), useMappedObservableValue (copy), IconHost (copy), createEffect (copy), useStyle (copy), FFlagUnibarMenuOpenSubmenu (copy)
	local ICON_CELL_WIDTH, UNIBAR_END_PADDING

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		local v90 = UnibarStyle.use()

		ICON_CELL_WIDTH = v90.ICON_CELL_WIDTH
		UNIBAR_END_PADDING = v90.UNIBAR_END_PADDING
	else
		ICON_CELL_WIDTH = Constants.ICON_CELL_WIDTH
		UNIBAR_END_PADDING = Constants.UNIBAR_END_PADDING
	end

	local t7 = {}
	local v94 = React.useRef({})
	local v95 = React.useRef(Vector2.zero)
	local v96 = React.useRef(Vector2.zero)
	local u97 = nil

	if FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and Stores.GetUILessStore then
		u97 = React.useRef(Stores.GetUILessStore(false))
	end

	local v98 = false
	local v99 = v94.current or {}
	local v100 = useChromeMenuItems()
	local v101, v102 = ReactOtter.useAnimatedBinding(1)
	local v103, v104 = ReactOtter.useAnimatedBinding(1)
	local v105, v106 = ReactOtter.useAnimatedBinding(0)
	local v107 = React.useRef(0)
	local v108, v109 = ReactOtter.useAnimatedBinding(1)
	local v110 = React.useRef(false)
	local v111 = React.useRef(0)
	local v112 = Service:currentSubMenu():get() == "nine_dot"
	local v113, v114 = ReactOtter.useAnimatedBinding(not v112 and 0 or 1)
	local t8 = {}
	local n8 = 0
	local n9 = 0
	local n10 = 0
	local n11 = 0
	local v120 = React.useCallback(function(p14) -- line: 493
		-- upvalues: v95 (copy), Service (copy), FFlagReduceTopBarInsetsWhileHidden (copy), v96 (copy), FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), u97 (ref), v43 (copy), t6 (copy), Constants (copy)
		local zero = Vector2.zero
		local zero2 = Vector2.zero

		if p14 then
			zero = p14.AbsolutePosition
			zero2 = p14.AbsoluteSize

			if zero ~= v95.current then
				v95.current = zero
				Service:setMenuAbsolutePosition(zero)
			end

			if FFlagReduceTopBarInsetsWhileHidden and zero2 ~= v96.current then
				v96.current = zero2
			end

			if FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and u97.current.getUILessModeEnabled(false) then
				if zero ~= v95.current then
					v95.current = zero
					Service:setMenuAbsolutePosition(zero)
				end

				if zero2 ~= v96.current then
					v96.current = zero2
				end
			end
		end

		if FFlagReduceTopBarInsetsWhileHidden and v43 then
			if p14 and t6.onAreaChanged and v43:getShowTopBar():get() then
				t6.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, zero, zero2)

				return
			end
		elseif FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and u97.current.getUILessModeEnabled(false) then
			if p14 and t6.onAreaChanged and u97.current.getUIVisible(false) then
				t6.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, zero, zero2)

				return
			end
		elseif p14 and t6.onAreaChanged then
			t6.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, zero, p14.AbsoluteSize)
		end
	end, {})
	local v121 = React.joinBindings({
		v103,
		v105
	}):map(function(t9: {[any]: any}) -- line: 542
		-- upvalues: n11 (ref), ICON_CELL_WIDTH (ref)
		return UDim2.new(0, linearInterpolation(n11, t9[2], t9[1]), 0, ICON_CELL_WIDTH)
	end)
	local v122 = useMappedObservableValue(Service:orderAlignment(), isLeft)

	for _, v124 in v100 do
		if v124.integration.availability:get() == Service.AvailabilitySignal.Pinned then
			n8 += 1
		end
	end

	local v125 = if not v122 then math.max(n8 - 1, 0) else 1

	for v126, v127 in v100 do
		if v127.isDivider then
			local v128 = n9 + ICON_CELL_WIDTH * v125
			local v129 = v99[v127.id] or n9

			t7[v127.id] = n9
			v98 = v98 or v129 ~= n9

			local v130 = IconPositionBinding(v101, v129, n9, v128, v108, v105, false, v122, v110)
			local v131 = if not v122 then React.joinBindings({
				v130,
				v121
			}):map(function(p15) -- line: 589
				-- upvalues: ICON_CELL_WIDTH (ref)
				local v186 = p15[1]
				local v187 = p15[2]

				return v186.X.Offset <= v187.X.Offset - ICON_CELL_WIDTH
			end) else React.joinBindings({
				v130,
				v121
			}):map(function(p16) -- line: 584
				-- upvalues: ICON_CELL_WIDTH (ref)
				return p16[1].X.Offset >= ICON_CELL_WIDTH * 0.5
			end)

			t8[v127.id or "icon" .. v126] = React.createElement(IconDivider, {
				position = v130,
				visible = v131,
				toggleTransition = v103
			})
			n9 += Constants.DIVIDER_CELL_WIDTH
		elseif v127.integration then
			local v132 = false
			local v133 = n9 + ICON_CELL_WIDTH * v125

			if v127.integration.availability:get() == Service.AvailabilitySignal.Pinned then
				v132 = true
				v133 = n10
			end

			local v134 = if v99[v127.id] ~= nil then v99[v127.id] else n9

			t7[v127.id] = n9
			v98 = v98 or v134 ~= n9

			local v135 = IconPositionBinding(v101, v134, n9, v133, v108, v105, v132, v122, v110)
			local v136 = if not v122 then React.joinBindings({
				v135,
				v121
			}):map(function(p17) -- line: 633
				-- upvalues: ICON_CELL_WIDTH (ref)
				local v190 = p17[1]
				local v191 = p17[2]

				return v190.X.Offset <= v191.X.Offset - ICON_CELL_WIDTH * 1.5
			end) else React.joinBindings({
				v135,
				v121
			}):map(function(p18) -- line: 628
				-- upvalues: ICON_CELL_WIDTH (ref)
				return p18[1].X.Offset >= ICON_CELL_WIDTH * 0.5
			end)

			t8[v127.id or "icon" .. v126] = React.createElement(IconHost, {
				position = v135,
				visible = v132 or v136,
				toggleTransition = v113,
				integration = v127
			})
			n9 += ICON_CELL_WIDTH

			if v132 then
				n10 += ICON_CELL_WIDTH
			end
		end
	end

	n11 = n9

	if t6.onMinWidthChanged then
		t6.onMinWidthChanged(n11)
	end

	local u137 = UNIBAR_END_PADDING * 2 + n9

	React.useEffect(function() -- line: 659
		-- upvalues: v107 (copy), v105 (copy), v106 (copy), ReactOtter (copy), u137 (ref), Constants (copy), Service (copy), ICON_CELL_WIDTH (ref)
		local current = v107.current

		if v105:getValue() == 0 then
			v106((ReactOtter.instant(u137)))
			v107.current = u137
		elseif current ~= u137 then
			v106(ReactOtter.spring(u137, Constants.MENU_ANIMATION_SPRING))
			v107.current = u137
		end

		Service:setMenuAbsoluteSize(Vector2.new(u137, ICON_CELL_WIDTH))
	end, { u137 })

	if v98 then
		v111.current = (v111.current or 0) + 1
	end

	v94.current = t7
	React.useEffect(function() -- line: 677
		-- upvalues: v110 (copy), v109 (copy), ReactOtter (copy), Constants (copy)
		if not v110.current then
			v109(ReactOtter.spring(0, Constants.MENU_ANIMATION_SPRING))
			v110.current = true

			return
		end

		v109(ReactOtter.spring(1, Constants.MENU_ANIMATION_SPRING))
		v110.current = false
	end, {
		v111.current,
		v110
	})
	React.useEffect(function() -- line: 689
		-- upvalues: FFlagReduceTopBarInsetsWhileHidden (copy), v43 (copy), t6 (copy), Constants (copy), v95 (copy), v96 (copy)
		if FFlagReduceTopBarInsetsWhileHidden and v43 then
			local v193 = v43:getShowTopBar()

			v193:connect(function() -- line: 692
				-- upvalues: v193 (copy), t6 (copy), Constants (copy), v95 (copy), v96 (copy)
				if v193:get() then
					t6.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, v95.current, v96.current)

					return
				end

				t6.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, Vector2.zero, Vector2.zero)
			end)
			t6.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, Vector2.zero, Vector2.zero)
		end
	end, {})
	React.useEffect(function() -- line: 707
		-- upvalues: FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), u97 (ref), createEffect (copy), t6 (copy), Constants (copy), v95 (copy), v96 (copy)
		local u194 = nil

		if FFlagAddUILessMode and (FIntAddUILessModeVariant ~= 0 and u97.current.getUILessModeEnabled(false)) then
			u194 = createEffect(function(p19) -- line: 710
				-- upvalues: u97 (ref), t6 (copy), Constants (copy), v95 (copy), v96 (copy)
				if u97.current.getUIVisible(p19) then
					t6.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, v95.current, v96.current)

					return
				end

				t6.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, Vector2.zero, Vector2.zero)
			end)
			t6.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, Vector2.zero, Vector2.zero)
		end

		return function() -- line: 724
			-- upvalues: u194 (ref)
			if u194 then
				u194()
			end
		end
	end, {})

	local v138 = useStyle()

	return React.createElement("Frame", {
		Size = v121,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		SelectionGroup = true,
		ref = t6.menuFrameRef,
		[React.Change.AbsoluteSize] = v120,
		[React.Change.AbsolutePosition] = v120
	}, {
		React.createElement(AnimationStateHelper, {
			setToggleIconTransition = v102,
			setToggleWidthTransition = v104,
			setToggleSubmenuTransition = v114,
			menuFrameRef = t6.menuFrameRef,
			subMenuHostRef = if not FFlagUnibarMenuOpenSubmenu then nil else t6.subMenuHostRef
		}),
		React.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = v138.Theme.BackgroundUIContrast.Color,
			BackgroundTransparency = v138.Theme.BackgroundUIContrast.Transparency * v138.Settings.PreferredTransparency
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			})
		}),
		React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, t8)
	})
end

local function UnibarPills(t10: {[any]: any}) -- line: 779
	-- upvalues: useStyle (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), useChromeMenuItems (copy), Service (copy), ReactOtter (copy), React (copy), IconHost (copy)
	local v140 = useStyle()
	local UNIBAR_END_PADDING, MENU_SUBMENU_PADDING

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		local v141 = UnibarStyle.use()

		UNIBAR_END_PADDING = v141.UNIBAR_END_PADDING
		MENU_SUBMENU_PADDING = v141.MENU_SUBMENU_PADDING
	else
		UNIBAR_END_PADDING = Constants.UNIBAR_END_PADDING
		MENU_SUBMENU_PADDING = Constants.MENU_SUBMENU_PADDING
	end

	local v144 = useChromeMenuItems()
	local v145 = Service:currentSubMenu():get() == "nine_dot"
	local v146, v147 = ReactOtter.useAnimatedBinding(not v145 and 0 or 1)

	assert(v144 ~= nil, "Menu items should not be nil")

	local t11 = {}
	local t12 = {}

	for v150, v151 in v144 do
		if v151.integration and v151.isDivider == false then
			t12["icon_host" .. v150] = React.createElement(IconHost, {
				toggleTransition = v146,
				integration = v151
			})
		end

		if v151.isDivider or v150 == #v144 then
			local v152 = React.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundColor3 = v140.Theme.BackgroundUIContrast.Color,
				BackgroundTransparency = v140.Theme.BackgroundUIContrast.Transparency * v140.Settings.PreferredTransparency
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				}),
				Padding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, UNIBAR_END_PADDING),
					PaddingRight = UDim.new(0, UNIBAR_END_PADDING)
				}),
				PillsHorizontalList = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				})
			}, t12)

			t11["pill_" .. v150] = v152
			t12 = {}
		end
	end

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		SelectionGroup = true,
		ref = t10.menuFrameRef,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		React.createElement(AnimationStateHelper, {
			setToggleSubmenuTransition = v147,
			menuFrameRef = t10.menuFrameRef,
			subMenuHostRef = t10.subMenuHostRef
		}),
		React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, MENU_SUBMENU_PADDING)
		})
	}, t11)
end
local function SubMenuWrapper(p20) -- line: 871
	-- upvalues: isInExperienceUIVREnabled (copy), isSpatial (copy), Panel3DInSpatialUI (ref), useObservableValue (copy), Service (copy), u47 (ref), React (copy), SubMenu (copy), PanelType (ref)
	if isInExperienceUIVREnabled and (isSpatial() and Panel3DInSpatialUI) then
		local v154 = useObservableValue(Service:currentSubMenu())

		u47:set(v154 ~= nil)
	end

	local v155 = React.useCallback(function(vector2: Vector2) -- line: 876
		-- upvalues: React (copy), SubMenu (copy), p20 (copy)
		return (React.createElement(SubMenu, {
			subMenuHostRef = p20.subMenuHostRef,
			panelSize = vector2
		}))
	end, { p20.subMenuHostRef })

	if isInExperienceUIVREnabled and isSpatial() and Panel3DInSpatialUI then
		return (React.createElement(Panel3DInSpatialUI, {
			panelType = PanelType.ChromeSubMenu,
			renderFunction = v155,
			visibilityObservable = u47
		}))
	end

	return (React.createElement(SubMenu, {
		subMenuHostRef = p20.subMenuHostRef
	}))
end

return React.memo(function(t13: {[any]: any}) -- line: 895
	-- upvalues: FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy), FFlagEnableConsoleExpControls (copy), FFlagUnibarMenuOpenSubmenu (copy), useMappedObservableValue (copy), Service (copy), v43 (copy), FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), Stores (copy), createEffect (copy), onUnibarSelectionChanged (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), UnibarPills (copy), SubMenuWrapper (copy), SubMenu (copy), ShortcutBar (copy), WindowManager (copy)
	local v157 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.MENU_SUBMENU_PADDING else UnibarStyle.use().MENU_SUBMENU_PADDING
	local u158 = React.useRef(nil)

	if FFlagEnableConsoleExpControls and t13.menuRef then
		u158 = t13.menuRef
	end

	local v159 = React.useRef(nil)
	local v160 = nil

	if FFlagUnibarMenuOpenSubmenu then
		v160 = React.useRef(nil)
	end

	local function updateSize() -- line: 917
		-- upvalues: v159 (copy), u158 (ref)
		if v159.current and u158.current then
			v159.current.Size = u158.current.Size
		end
	end

	local v162 = useMappedObservableValue(Service:orderAlignment(), isLeft)
	local v163 = nil
	local u164 = nil
	local u165 = nil

	if FFlagEnableConsoleExpControls and v43 then
		local v166

		v163, v166 = React.useBinding(v43:getShowTopBar():get())
		u164 = v166
		u165 = v43:getShowTopBar()
	end

	local u167 = nil

	if FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and Stores.GetUILessStore then
		u167 = React.useRef(Stores.GetUILessStore(false))

		if u167.current.getUILessModeEnabled(false) then
			local v168

			v163, v168 = React.useBinding(true)
			u164 = v168
		end
	end

	React.useEffect(function() -- line: 942
		-- upvalues: u158 (ref), updateSize (copy), v159 (copy), FFlagEnableConsoleExpControls (copy), u165 (ref), u164 (ref)
		local connection = nil

		if u158 and u158.current then
			connection = u158.current:GetPropertyChangedSignal("Size"):Connect(updateSize)
		end

		if v159.current and u158.current then
			v159.current.Size = u158.current.Size
		end

		if FFlagEnableConsoleExpControls then
			u165:connect(function() -- line: 951
				-- upvalues: u164 (ref), u165 (ref)
				u164(u165:get())
			end)
		end

		return function() -- line: 956
			-- upvalues: connection (ref)
			if connection then
				connection:disconnect()
			end
		end
	end)
	React.useEffect(function() -- line: 963
		-- upvalues: FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), u167 (ref), createEffect (copy), u164 (ref)
		local u197 = nil

		if FFlagAddUILessMode and (FIntAddUILessModeVariant ~= 0 and u167.current.getUILessModeEnabled(false)) then
			u197 = createEffect(function(p21) -- line: 966
				-- upvalues: u164 (ref), u167 (ref)
				u164(u167.current.getUIVisible(p21))
			end)
		end

		return function() -- line: 971
			-- upvalues: u197 (ref)
			if u197 then
				u197()
			end
		end
	end, {})

	return { React.createElement("Frame", {
		Name = "UnibarMenu",
		AutomaticSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		LayoutOrder = t13.layoutOrder,
		SelectionGroup = true,
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
		SelectionBehaviorLeft = if not FFlagEnableConsoleExpControls then Enum.SelectionBehavior.Stop else nil,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
		ref = v159,
		[React.Event.SelectionChanged] = if not FFlagEnableConsoleExpControls then nil else onUnibarSelectionChanged,
		Visible = if not FFlagEnableConsoleExpControls and (not FFlagAddUILessMode or (FIntAddUILessModeVariant == 0 or not u167.current.getUILessModeEnabled(false))) then nil else v163
	}, {
		React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = if not v162 then Enum.HorizontalAlignment.Right else Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, v157)
		}),
		if not isInExperienceUIVREnabled or not isSpatial() then React.createElement(Unibar, {
			menuFrameRef = u158,
			subMenuHostRef = if not FFlagUnibarMenuOpenSubmenu then nil else v160,
			onAreaChanged = t13.onAreaChanged,
			onMinWidthChanged = t13.onMinWidthChanged
		}) else React.createElement(UnibarPills, {
			menuFrameRef = u158,
			subMenuHostRef = v160
		}),
		if not isInExperienceUIVREnabled then React.createElement(SubMenu, {
			subMenuHostRef = v160
		}) else React.createElement(SubMenuWrapper, {
			subMenuHostRef = v160
		}),
		if not FFlagEnableConsoleExpControls then nil else React.createElement(ShortcutBar),
		(React.createElement(WindowManager))
	}) }
end, function(_, _) -- line: 1029
	return true
end)
