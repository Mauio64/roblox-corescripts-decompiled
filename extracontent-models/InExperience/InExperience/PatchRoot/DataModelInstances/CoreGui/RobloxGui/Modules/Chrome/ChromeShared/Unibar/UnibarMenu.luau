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
local FFlagAddMapToNineDot = SharedFlags.FFlagAddMapToNineDot
local FFlagEnableInExperienceShop = SharedFlags.FFlagEnableInExperienceShop
local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local FFlagUnibarMenuOpenSubmenu = require(script.Parent.Parent.Parent.Flags).FFlagUnibarMenuOpenSubmenu
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
local buildMenuOrder = require(ChromeShared.Unibar.buildMenuOrder)
local useChromeMenuItems = require(ChromeShared.Hooks.useChromeMenuItems)
local useObservableValue = require(ChromeShared.Hooks.useObservableValue)
local useMappedObservableValue = require(ChromeShared.Hooks.useMappedObservableValue)
local IconHost = require(ChromeShared.Unibar.ComponentHosts.IconHost)
local ReactOtter = require(CorePackages.Packages.ReactOtter)
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local FFlagReduceTopBarInsetsWhileHidden = SharedFlags.FFlagReduceTopBarInsetsWhileHidden
local Stores = require(CorePackages.Workspace.Packages.CoreGuiCommon).Stores
local createEffect = require(CorePackages.Packages.Signals).createEffect
local Constants2 = require(ChromeShared.Parent.Integrations.Party.Constants)
local isConnectUnibarEnabled = require(ChromeShared.Parent.Integrations.Connect.isConnectUnibarEnabled)
local isConnectDropdownEnabled = require(ChromeShared.Parent.Integrations.Connect.isConnectDropdownEnabled)
local v39 = if not FFlagEnableConsoleExpControls then nil else require(ChromeShared.Parent.Parent.TopBar.Components.GamepadConnector)
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local Panel3DInSpatialUI = nil
local PanelType = nil
local u43 = nil

if isInExperienceUIVREnabled then
	local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)

	Panel3DInSpatialUI = VrSpatialUi.Panel3DInSpatialUI
	PanelType = VrSpatialUi.Constants.PanelType
	u43 = require(CorePackages.Workspace.Packages.Observable).ObservableValue.new(true)
end

local ArgoPartyExperimentation = require(CorePackages.Workspace.Packages.SocialExperiments).ArgoPartyExperimentation
local FFlagRemoveFriendsChatUnibarEntrypoints = SharedFlags.FFlagRemoveFriendsChatUnibarEntrypoints
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab

if not GetFFlagChromeCentralizedConfiguration() then
	function configureUnibar() -- line: 81
		-- upvalues: FFlagAddMapToNineDot (copy), buildMenuOrder (copy), isConnectDropdownEnabled (copy), FFlagRemoveFriendsChatUnibarEntrypoints (copy), ArgoPartyExperimentation (copy), FFlagExpChatEnableFriendsTab (copy), GetFFlagDebugEnableUnibarDummyIntegrations (copy), isConnectUnibarEnabled (copy), Constants2 (copy), FFlagAppNavMyStatsTab (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), Service (copy), FFlagEnableInExperienceAvatarSwitcher (copy), Constants (copy), GuiService (copy), FFlagEnableInExperienceShop (copy)
		local v52

		if FFlagAddMapToNineDot then
			v52 = buildMenuOrder()
		else
			v52 = {
				"leaderboard",
				"emotes",
				"backpack"
			}
			table.insert(v52, "respawn")
			table.insert(v52, 1, "trust_and_safety")

			if isConnectDropdownEnabled() and (not FFlagRemoveFriendsChatUnibarEntrypoints or not ArgoPartyExperimentation.getIsRenameEnabled() or not FFlagExpChatEnableFriendsTab) then
				table.insert(v52, 1, "connect_dropdown")
			end
		end

		local t1 = {
			"nine_dot",
			"chat",
			"toggle_mic_mute"
		}

		table.insert(t1, 3, "join_voice")

		if GetFFlagDebugEnableUnibarDummyIntegrations() then
			table.insert(t1, "dummy_window")
			table.insert(t1, "dummy_window_2")
		end

		if isConnectUnibarEnabled() then
			table.insert(t1, not ArgoPartyExperimentation.getIsRenameEnabled() and "connect_unibar" or "party_entrypoint")
		end

		local v54 = table.find(t1, "toggle_mic_mute")

		if v54 then
			table.insert(t1, v54, Constants2.TOGGLE_MIC_INTEGRATION_ID)
		end

		if FFlagAppNavMyStatsTab then
			table.insert(t1, "assistant_build")
		end

		if isInExperienceUIVREnabled and isSpatial() then
			Service:configureMenu({
				{
					"vr_toggle_button",
					"vr_safety_bubble"
				},
				t1
			})
		else
			Service:configureMenu({ t1 })
		end

		if not FFlagAddMapToNineDot then
			if isInExperienceUIVREnabled then
				if not isSpatial() then
					table.insert(v52, 2, "camera_entrypoint")
					table.insert(v52, 2, "selfie_view")
				end
			else
				table.insert(v52, 2, "camera_entrypoint")
				table.insert(v52, 2, "selfie_view")
			end

			if FFlagEnableInExperienceAvatarSwitcher then
				table.insert(v52, 3, Constants.AVATAR_SWITCHER_ID)
			end

			if not isSpatial() and not GuiService:IsTenFootInterface() then
				table.insert(v52, 4, "music_entrypoint")
			end

			if FFlagEnableInExperienceShop then
				table.insert(v52, 2, Constants.IN_EXPERIENCE_SHOP_ID)
			end
		end

		Service:configureSubMenu("nine_dot", v52)
	end

	configureUnibar()

	if FFlagEnableConsoleExpControls then
		require(script.Parent.Parent.Shortcuts.ConfigureShortcuts)()
	end
end

function IconDivider(t2: {[any]: any}) -- line: 187
	-- upvalues: useStyle (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy)
	local v56 = useStyle()
	local v57 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.ICON_DIVIDER_POSITION else UnibarStyle.use().ICON_DIVIDER_POSITION

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Position = t2.position,
		Size = UDim2.new(0, Constants.DIVIDER_CELL_WIDTH, 1, 0)
	}, {
		DividerBar = React.createElement("Frame", {
			BorderSizePixel = 0,
			Position = v57,
			AnchorPoint = Vector2.new(0, 0.5),
			Size = Constants.ICON_DIVIDER_SIZE,
			BackgroundColor3 = v56.Theme.Divider.Color,
			BackgroundTransparency = if not t2.toggleTransition then v56.Theme.Divider.Transparency else t2.toggleTransition:map(function(p1) -- line: 211
				-- upvalues: v56 (copy)
				return v56.Theme.Divider.Transparency + (1 - p1) * (1 - v56.Theme.Divider.Transparency)
			end),
			Visible = t2.visible or true
		})
	})
end

local function getSelectedChild(t3: {[any]: any}, s1: string?) -- line: 220
	-- upvalues: Constants (copy)
	return t3.current:FindFirstChild(Constants.ICON_NAME_PREFIX .. tostring(s1), true)
end

function AnimationStateHelper(p2) -- line: 226
	-- upvalues: useObservableValue (copy), Service (copy), React (copy), FFlagEnableConsoleExpControls (copy), ContextActionService (copy), GuiService (copy), Constants (copy), FFlagUnibarMenuOpenSubmenu (copy), ReactOtter (copy), GetFIntIconSelectionTimeout (copy)
	local v61 = useObservableValue(Service:currentSubMenu())
	local v62 = useObservableValue(Service:selectedItem())
	local v63 = useObservableValue(Service:inFocusNav())

	React.useEffect(function() -- line: 232
		-- upvalues: v63 (copy), FFlagEnableConsoleExpControls (copy), ContextActionService (copy), Service (copy), GuiService (copy), p2 (copy), v62 (copy), Constants (copy), FFlagUnibarMenuOpenSubmenu (copy)
		if v63 then
			if not FFlagEnableConsoleExpControls then
				ContextActionService:BindCoreAction("RBXEscapeUnibar", function(_, p4, _) -- line: 235
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
					local v166 = v62
					local v167 = menuFrameRef.current:FindFirstChild(Constants.ICON_NAME_PREFIX .. tostring(v166), true)

					if v167 then
						GuiService.SelectedCoreObject = v167

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
	end, { v63 })
	React.useEffect(function() -- line: 280
		-- upvalues: v61 (copy), FFlagUnibarMenuOpenSubmenu (copy), v63 (copy), GuiService (copy), p2 (copy), ReactOtter (copy), Constants (copy)
		if v61 == "nine_dot" then
			if FFlagUnibarMenuOpenSubmenu and v63 then
				GuiService:Select(p2.subMenuHostRef.current)
			end

			p2.setToggleSubmenuTransition((ReactOtter.spring(1, Constants.MENU_ANIMATION_SPRING)))

			return
		end

		p2.setToggleSubmenuTransition((ReactOtter.spring(0, Constants.MENU_ANIMATION_SPRING)))
	end, { v61 })
	React.useEffect(function() -- line: 291
		-- upvalues: FFlagEnableConsoleExpControls (copy), v61 (copy), v62 (copy), GetFIntIconSelectionTimeout (copy), p2 (copy), Constants (copy), GuiService (copy)
		if FFlagEnableConsoleExpControls and v61 == v62 then
			return
		end

		local co = coroutine.create(function() -- line: 296
			-- upvalues: GetFIntIconSelectionTimeout (copy), p2 (copy), v62 (copy), FFlagEnableConsoleExpControls (copy), Constants (copy), GuiService (copy)
			local n1 = 0
			local v197

			repeat
				repeat
					if not (n1 < GetFIntIconSelectionTimeout()) then
						return
					end

					n1 += 1
					task.wait()
				until p2.menuFrameRef.current and v62

				if FFlagEnableConsoleExpControls then
					local menuFrameRef = p2.menuFrameRef
					local v196 = v62

					v197 = menuFrameRef.current:FindFirstChild(Constants.ICON_NAME_PREFIX .. tostring(v196), true)
				else
					v197 = p2.menuFrameRef.current:FindFirstChild("IconHitArea_" .. v62, true)
				end
			until v197

			GuiService.SelectedCoreObject = v197
		end)

		coroutine.resume(co)
	end, {
		v62,
		if not FFlagEnableConsoleExpControls then nil else v61
	})

	return nil
end
function linearInterpolation(n2: number, n3: number, n4: number) -- line: 322
	return n2 * (1 - n4) + n3 * n4
end
function IconPositionBinding(p6, n5: number, n6: number, n7: number, p7, p8, b1: boolean, b2: boolean?, p9) -- line: 326
	-- upvalues: FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy)
	local u76 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.UNIBAR_END_PADDING else UnibarStyle.use().UNIBAR_END_PADDING

	return (React.joinBindings({
		p6,
		p7,
		p8
	}):map(function(t4: {[any]: any}) -- line: 346
		-- upvalues: p9 (copy), n6 (copy), n5 (copy), n7 (copy), b2 (copy), b1 (copy), u76 (ref)
		local v170 = if not p9.current then linearInterpolation(n5, n6, t4[2]) else linearInterpolation(n6, n5, t4[2])
		local v171 = n7

		if b2 and not b1 then
			v171 = n7 - t4[3]
		end

		local v172 = v170 - v171

		return UDim2.new(0, u76 + v171 + v172 * t4[1], 0, 0)
	end))
end

local function onUnibarSelectionChanged(p10, _: boolean, _, p12) -- line: 364
	-- upvalues: Service (copy)
	if not p10:IsAncestorOf(p12) then
		Service:disableFocusNav()
	end
end

function isLeft(p13) -- line: 383
	return p13 == Enum.HorizontalAlignment.Left
end
function Unibar(t5: {[any]: any}) -- line: 387
	-- upvalues: FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy), FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), Stores (copy), useChromeMenuItems (copy), ReactOtter (copy), Service (copy), FFlagReduceTopBarInsetsWhileHidden (copy), v39 (copy), useMappedObservableValue (copy), IconHost (copy), createEffect (copy), useStyle (copy), FFlagUnibarMenuOpenSubmenu (copy)
	local ICON_CELL_WIDTH, UNIBAR_END_PADDING

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		local v83 = UnibarStyle.use()

		ICON_CELL_WIDTH = v83.ICON_CELL_WIDTH
		UNIBAR_END_PADDING = v83.UNIBAR_END_PADDING
	else
		ICON_CELL_WIDTH = Constants.ICON_CELL_WIDTH
		UNIBAR_END_PADDING = Constants.UNIBAR_END_PADDING
	end

	local t6 = {}
	local v87 = React.useRef({})
	local v88 = React.useRef(Vector2.zero)
	local v89 = React.useRef(Vector2.zero)
	local u90 = nil

	if FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and Stores.GetUILessStore then
		u90 = React.useRef(Stores.GetUILessStore(false))
	end

	local v91 = false
	local v92 = v87.current or {}
	local v93 = useChromeMenuItems()
	local v94, v95 = ReactOtter.useAnimatedBinding(1)
	local v96, v97 = ReactOtter.useAnimatedBinding(1)
	local v98, v99 = ReactOtter.useAnimatedBinding(0)
	local v100 = React.useRef(0)
	local v101, v102 = ReactOtter.useAnimatedBinding(1)
	local v103 = React.useRef(false)
	local v104 = React.useRef(0)
	local v105 = Service:currentSubMenu():get() == "nine_dot"
	local v106, v107 = ReactOtter.useAnimatedBinding(not v105 and 0 or 1)
	local t7 = {}
	local n8 = 0
	local n9 = 0
	local n10 = 0
	local n11 = 0
	local v113 = React.useCallback(function(p14) -- line: 435
		-- upvalues: v88 (copy), Service (copy), FFlagReduceTopBarInsetsWhileHidden (copy), v89 (copy), FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), u90 (ref), v39 (copy), t5 (copy), Constants (copy)
		local zero = Vector2.zero
		local zero2 = Vector2.zero

		if p14 then
			zero = p14.AbsolutePosition
			zero2 = p14.AbsoluteSize

			if zero ~= v88.current then
				v88.current = zero
				Service:setMenuAbsolutePosition(zero)
			end

			if FFlagReduceTopBarInsetsWhileHidden and zero2 ~= v89.current then
				v89.current = zero2
			end

			if FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and u90.current.getUILessModeEnabled(false) then
				if zero ~= v88.current then
					v88.current = zero
					Service:setMenuAbsolutePosition(zero)
				end

				if zero2 ~= v89.current then
					v89.current = zero2
				end
			end
		end

		if FFlagReduceTopBarInsetsWhileHidden and v39 then
			if p14 and t5.onAreaChanged and v39:getShowTopBar():get() then
				t5.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, zero, zero2)

				return
			end
		elseif FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and u90.current.getUILessModeEnabled(false) then
			if p14 and t5.onAreaChanged and u90.current.getUIVisible(false) then
				t5.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, zero, zero2)

				return
			end
		elseif p14 and t5.onAreaChanged then
			t5.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, zero, p14.AbsoluteSize)
		end
	end, {})
	local v114 = React.joinBindings({
		v96,
		v98
	}):map(function(t8: {[any]: any}) -- line: 484
		-- upvalues: n11 (ref), ICON_CELL_WIDTH (ref)
		return UDim2.new(0, linearInterpolation(n11, t8[2], t8[1]), 0, ICON_CELL_WIDTH)
	end)
	local v115 = useMappedObservableValue(Service:orderAlignment(), isLeft)

	for _, v117 in v93 do
		if v117.integration.availability:get() == Service.AvailabilitySignal.Pinned then
			n8 += 1
		end
	end

	local v118 = if not v115 then math.max(n8 - 1, 0) else 1

	for v119, v120 in v93 do
		if v120.isDivider then
			local v121 = n9 + ICON_CELL_WIDTH * v118
			local v122 = v92[v120.id] or n9

			t6[v120.id] = n9
			v91 = v91 or v122 ~= n9

			local v123 = IconPositionBinding(v94, v122, n9, v121, v101, v98, false, v115, v103)
			local v124 = if not v115 then React.joinBindings({
				v123,
				v114
			}):map(function(p15) -- line: 531
				-- upvalues: ICON_CELL_WIDTH (ref)
				local v179 = p15[1]
				local v180 = p15[2]

				return v179.X.Offset <= v180.X.Offset - ICON_CELL_WIDTH
			end) else React.joinBindings({
				v123,
				v114
			}):map(function(p16) -- line: 526
				-- upvalues: ICON_CELL_WIDTH (ref)
				return p16[1].X.Offset >= ICON_CELL_WIDTH * 0.5
			end)

			t7[v120.id or "icon" .. v119] = React.createElement(IconDivider, {
				position = v123,
				visible = v124,
				toggleTransition = v96
			})
			n9 += Constants.DIVIDER_CELL_WIDTH
		elseif v120.integration then
			local v125 = false
			local v126 = n9 + ICON_CELL_WIDTH * v118

			if v120.integration.availability:get() == Service.AvailabilitySignal.Pinned then
				v125 = true
				v126 = n10
			end

			local v127 = if v92[v120.id] ~= nil then v92[v120.id] else n9

			t6[v120.id] = n9
			v91 = v91 or v127 ~= n9

			local v128 = IconPositionBinding(v94, v127, n9, v126, v101, v98, v125, v115, v103)
			local v129 = if not v115 then React.joinBindings({
				v128,
				v114
			}):map(function(p17) -- line: 575
				-- upvalues: ICON_CELL_WIDTH (ref)
				local v183 = p17[1]
				local v184 = p17[2]

				return v183.X.Offset <= v184.X.Offset - ICON_CELL_WIDTH * 1.5
			end) else React.joinBindings({
				v128,
				v114
			}):map(function(p18) -- line: 570
				-- upvalues: ICON_CELL_WIDTH (ref)
				return p18[1].X.Offset >= ICON_CELL_WIDTH * 0.5
			end)

			t7[v120.id or "icon" .. v119] = React.createElement(IconHost, {
				position = v128,
				visible = v125 or v129,
				toggleTransition = v106,
				integration = v120
			})
			n9 += ICON_CELL_WIDTH

			if v125 then
				n10 += ICON_CELL_WIDTH
			end
		end
	end

	n11 = n9

	if t5.onMinWidthChanged then
		t5.onMinWidthChanged(n11)
	end

	local u130 = UNIBAR_END_PADDING * 2 + n9

	React.useEffect(function() -- line: 601
		-- upvalues: v100 (copy), v98 (copy), v99 (copy), ReactOtter (copy), u130 (ref), Constants (copy), Service (copy), ICON_CELL_WIDTH (ref)
		local current = v100.current

		if v98:getValue() == 0 then
			v99((ReactOtter.instant(u130)))
			v100.current = u130
		elseif current ~= u130 then
			v99(ReactOtter.spring(u130, Constants.MENU_ANIMATION_SPRING))
			v100.current = u130
		end

		Service:setMenuAbsoluteSize(Vector2.new(u130, ICON_CELL_WIDTH))
	end, { u130 })

	if v91 then
		v104.current = (v104.current or 0) + 1
	end

	v87.current = t6
	React.useEffect(function() -- line: 619
		-- upvalues: v103 (copy), v102 (copy), ReactOtter (copy), Constants (copy)
		if not v103.current then
			v102(ReactOtter.spring(0, Constants.MENU_ANIMATION_SPRING))
			v103.current = true

			return
		end

		v102(ReactOtter.spring(1, Constants.MENU_ANIMATION_SPRING))
		v103.current = false
	end, {
		v104.current,
		v103
	})
	React.useEffect(function() -- line: 631
		-- upvalues: FFlagReduceTopBarInsetsWhileHidden (copy), v39 (copy), t5 (copy), Constants (copy), v88 (copy), v89 (copy)
		if FFlagReduceTopBarInsetsWhileHidden and v39 then
			local v186 = v39:getShowTopBar()

			v186:connect(function() -- line: 634
				-- upvalues: v186 (copy), t5 (copy), Constants (copy), v88 (copy), v89 (copy)
				if v186:get() then
					t5.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, v88.current, v89.current)

					return
				end

				t5.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, Vector2.zero, Vector2.zero)
			end)
			t5.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, Vector2.zero, Vector2.zero)
		end
	end, {})
	React.useEffect(function() -- line: 649
		-- upvalues: FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), u90 (ref), createEffect (copy), t5 (copy), Constants (copy), v88 (copy), v89 (copy)
		local u187 = nil

		if FFlagAddUILessMode and (FIntAddUILessModeVariant ~= 0 and u90.current.getUILessModeEnabled(false)) then
			u187 = createEffect(function(p19) -- line: 652
				-- upvalues: u90 (ref), t5 (copy), Constants (copy), v88 (copy), v89 (copy)
				if u90.current.getUIVisible(p19) then
					t5.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, v88.current, v89.current)

					return
				end

				t5.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, Vector2.zero, Vector2.zero)
			end)
			t5.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, Vector2.zero, Vector2.zero)
		end

		return function() -- line: 666
			-- upvalues: u187 (ref)
			if u187 then
				u187()
			end
		end
	end, {})

	local v131 = useStyle()

	return React.createElement("Frame", {
		Size = v114,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		SelectionGroup = true,
		ref = t5.menuFrameRef,
		[React.Change.AbsoluteSize] = v113,
		[React.Change.AbsolutePosition] = v113
	}, {
		React.createElement(AnimationStateHelper, {
			setToggleIconTransition = v95,
			setToggleWidthTransition = v97,
			setToggleSubmenuTransition = v107,
			menuFrameRef = t5.menuFrameRef,
			subMenuHostRef = if not FFlagUnibarMenuOpenSubmenu then nil else t5.subMenuHostRef
		}),
		React.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = v131.Theme.BackgroundUIContrast.Color,
			BackgroundTransparency = v131.Theme.BackgroundUIContrast.Transparency * v131.Settings.PreferredTransparency
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			})
		}),
		React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, t7)
	})
end

local function UnibarPills(t9: {[any]: any}) -- line: 721
	-- upvalues: useStyle (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), useChromeMenuItems (copy), Service (copy), ReactOtter (copy), React (copy), IconHost (copy)
	local v133 = useStyle()
	local UNIBAR_END_PADDING, MENU_SUBMENU_PADDING

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		local v134 = UnibarStyle.use()

		UNIBAR_END_PADDING = v134.UNIBAR_END_PADDING
		MENU_SUBMENU_PADDING = v134.MENU_SUBMENU_PADDING
	else
		UNIBAR_END_PADDING = Constants.UNIBAR_END_PADDING
		MENU_SUBMENU_PADDING = Constants.MENU_SUBMENU_PADDING
	end

	local v137 = useChromeMenuItems()
	local v138 = Service:currentSubMenu():get() == "nine_dot"
	local v139, v140 = ReactOtter.useAnimatedBinding(not v138 and 0 or 1)

	assert(v137 ~= nil, "Menu items should not be nil")

	local t10 = {}
	local t11 = {}

	for v143, v144 in v137 do
		if v144.integration and v144.isDivider == false then
			t11["icon_host" .. v143] = React.createElement(IconHost, {
				toggleTransition = v139,
				integration = v144
			})
		end

		if v144.isDivider or v143 == #v137 then
			local v145 = React.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundColor3 = v133.Theme.BackgroundUIContrast.Color,
				BackgroundTransparency = v133.Theme.BackgroundUIContrast.Transparency * v133.Settings.PreferredTransparency
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
			}, t11)

			t10["pill_" .. v143] = v145
			t11 = {}
		end
	end

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		SelectionGroup = true,
		ref = t9.menuFrameRef,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		React.createElement(AnimationStateHelper, {
			setToggleSubmenuTransition = v140,
			menuFrameRef = t9.menuFrameRef,
			subMenuHostRef = t9.subMenuHostRef
		}),
		React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, MENU_SUBMENU_PADDING)
		})
	}, t10)
end
local function SubMenuWrapper(p20) -- line: 813
	-- upvalues: isInExperienceUIVREnabled (copy), isSpatial (copy), Panel3DInSpatialUI (ref), useObservableValue (copy), Service (copy), u43 (ref), React (copy), SubMenu (copy), PanelType (ref)
	if isInExperienceUIVREnabled and (isSpatial() and Panel3DInSpatialUI) then
		local v147 = useObservableValue(Service:currentSubMenu())

		u43:set(v147 ~= nil)
	end

	local v148 = React.useCallback(function(vector2: Vector2) -- line: 818
		-- upvalues: React (copy), SubMenu (copy), p20 (copy)
		return (React.createElement(SubMenu, {
			subMenuHostRef = p20.subMenuHostRef,
			panelSize = vector2
		}))
	end, { p20.subMenuHostRef })

	if isInExperienceUIVREnabled and isSpatial() and Panel3DInSpatialUI then
		return (React.createElement(Panel3DInSpatialUI, {
			panelType = PanelType.ChromeSubMenu,
			renderFunction = v148,
			visibilityObservable = u43
		}))
	end

	return (React.createElement(SubMenu, {
		subMenuHostRef = p20.subMenuHostRef
	}))
end

return React.memo(function(t12: {[any]: any}) -- line: 837
	-- upvalues: FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy), FFlagEnableConsoleExpControls (copy), FFlagUnibarMenuOpenSubmenu (copy), useMappedObservableValue (copy), Service (copy), v39 (copy), FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), Stores (copy), createEffect (copy), onUnibarSelectionChanged (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), UnibarPills (copy), SubMenuWrapper (copy), SubMenu (copy), ShortcutBar (copy), WindowManager (copy)
	local v150 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.MENU_SUBMENU_PADDING else UnibarStyle.use().MENU_SUBMENU_PADDING
	local u151 = React.useRef(nil)

	if FFlagEnableConsoleExpControls and t12.menuRef then
		u151 = t12.menuRef
	end

	local v152 = React.useRef(nil)
	local v153 = nil

	if FFlagUnibarMenuOpenSubmenu then
		v153 = React.useRef(nil)
	end

	local function updateSize() -- line: 859
		-- upvalues: v152 (copy), u151 (ref)
		if v152.current and u151.current then
			v152.current.Size = u151.current.Size
		end
	end

	local v155 = useMappedObservableValue(Service:orderAlignment(), isLeft)
	local v156 = nil
	local u157 = nil
	local u158 = nil

	if FFlagEnableConsoleExpControls and v39 then
		local v159

		v156, v159 = React.useBinding(v39:getShowTopBar():get())
		u157 = v159
		u158 = v39:getShowTopBar()
	end

	local u160 = nil

	if FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and Stores.GetUILessStore then
		u160 = React.useRef(Stores.GetUILessStore(false))

		if u160.current.getUILessModeEnabled(false) then
			local v161

			v156, v161 = React.useBinding(true)
			u157 = v161
		end
	end

	React.useEffect(function() -- line: 884
		-- upvalues: u151 (ref), updateSize (copy), v152 (copy), FFlagEnableConsoleExpControls (copy), u158 (ref), u157 (ref)
		local connection = nil

		if u151 and u151.current then
			connection = u151.current:GetPropertyChangedSignal("Size"):Connect(updateSize)
		end

		if v152.current and u151.current then
			v152.current.Size = u151.current.Size
		end

		if FFlagEnableConsoleExpControls then
			u158:connect(function() -- line: 893
				-- upvalues: u157 (ref), u158 (ref)
				u157(u158:get())
			end)
		end

		return function() -- line: 898
			-- upvalues: connection (ref)
			if connection then
				connection:disconnect()
			end
		end
	end)
	React.useEffect(function() -- line: 905
		-- upvalues: FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), u160 (ref), createEffect (copy), u157 (ref)
		local u190 = nil

		if FFlagAddUILessMode and (FIntAddUILessModeVariant ~= 0 and u160.current.getUILessModeEnabled(false)) then
			u190 = createEffect(function(p21) -- line: 908
				-- upvalues: u157 (ref), u160 (ref)
				u157(u160.current.getUIVisible(p21))
			end)
		end

		return function() -- line: 913
			-- upvalues: u190 (ref)
			if u190 then
				u190()
			end
		end
	end, {})

	return { React.createElement("Frame", {
		Name = "UnibarMenu",
		AutomaticSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		LayoutOrder = t12.layoutOrder,
		SelectionGroup = true,
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
		SelectionBehaviorLeft = if not FFlagEnableConsoleExpControls then Enum.SelectionBehavior.Stop else nil,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
		ref = v152,
		[React.Event.SelectionChanged] = if not FFlagEnableConsoleExpControls then nil else onUnibarSelectionChanged,
		Visible = if not FFlagEnableConsoleExpControls and (not FFlagAddUILessMode or (FIntAddUILessModeVariant == 0 or not u160.current.getUILessModeEnabled(false))) then nil else v156
	}, {
		React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = if not v155 then Enum.HorizontalAlignment.Right else Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, v150)
		}),
		if not isInExperienceUIVREnabled or not isSpatial() then React.createElement(Unibar, {
			menuFrameRef = u151,
			subMenuHostRef = if not FFlagUnibarMenuOpenSubmenu then nil else v153,
			onAreaChanged = t12.onAreaChanged,
			onMinWidthChanged = t12.onMinWidthChanged
		}) else React.createElement(UnibarPills, {
			menuFrameRef = u151,
			subMenuHostRef = v153
		}),
		if not isInExperienceUIVREnabled then React.createElement(SubMenu, {
			subMenuHostRef = v153
		}) else React.createElement(SubMenuWrapper, {
			subMenuHostRef = v153
		}),
		if not FFlagEnableConsoleExpControls then nil else React.createElement(ShortcutBar),
		(React.createElement(WindowManager))
	}) }
end, function(_, _) -- line: 971
	return true
end)
