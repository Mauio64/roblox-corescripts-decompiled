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
local v40 = if not FFlagEnableConsoleExpControls then nil else require(ChromeShared.Parent.Parent.TopBar.Components.GamepadConnector)
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local Panel3DInSpatialUI = nil
local PanelType = nil
local u44 = nil

if isInExperienceUIVREnabled then
	local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)

	Panel3DInSpatialUI = VrSpatialUi.Panel3DInSpatialUI
	PanelType = VrSpatialUi.Constants.PanelType
	u44 = require(CorePackages.Workspace.Packages.Observable).ObservableValue.new(true)
end

local ArgoPartyExperimentation = require(CorePackages.Workspace.Packages.SocialExperiments).ArgoPartyExperimentation
local FFlagRemoveFriendsChatUnibarEntrypoints = SharedFlags.FFlagRemoveFriendsChatUnibarEntrypoints
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab

if not GetFFlagChromeCentralizedConfiguration() then
	function configureUnibar() -- line: 82
		-- upvalues: FFlagAddMapToNineDot (copy), buildMenuOrder (copy), isConnectDropdownEnabled (copy), FFlagRemoveFriendsChatUnibarEntrypoints (copy), ArgoPartyExperimentation (copy), FFlagExpChatEnableFriendsTab (copy), FFlagReverseUnibar (copy), GetFFlagDebugEnableUnibarDummyIntegrations (copy), isConnectUnibarEnabled (copy), Constants2 (copy), FFlagAppNavMyStatsTab (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), Service (copy), FFlagEnableInExperienceAvatarSwitcher (copy), Constants (copy), GuiService (copy), FFlagEnableInExperienceShop (copy)
		local v53

		if FFlagAddMapToNineDot then
			v53 = buildMenuOrder()
		else
			v53 = {
				"leaderboard",
				"emotes",
				"backpack"
			}
			table.insert(v53, "respawn")
			table.insert(v53, 1, "trust_and_safety")

			if isConnectDropdownEnabled() and (not FFlagRemoveFriendsChatUnibarEntrypoints or not ArgoPartyExperimentation.getIsRenameEnabled() or not FFlagExpChatEnableFriendsTab) then
				table.insert(v53, 1, "connect_dropdown")
			end
		end

		local t1 = {
			"nine_dot",
			"chat",
			"toggle_mic_mute"
		}

		if FFlagReverseUnibar then
			table.insert(t1, 3, "join_voice")

			if GetFFlagDebugEnableUnibarDummyIntegrations() then
				table.insert(t1, "dummy_window")
				table.insert(t1, "dummy_window_2")
			end

			if isConnectUnibarEnabled() then
				table.insert(t1, not ArgoPartyExperimentation.getIsRenameEnabled() and "connect_unibar" or "party_entrypoint")
			end

			local v55 = table.find(t1, "toggle_mic_mute")

			if v55 then
				table.insert(t1, v55, Constants2.TOGGLE_MIC_INTEGRATION_ID)
			end
		else
			t1 = {
				"toggle_mic_mute",
				"chat",
				"nine_dot"
			}
			table.insert(t1, 2, "join_voice")

			if GetFFlagDebugEnableUnibarDummyIntegrations() then
				table.insert(t1, 1, "dummy_window")
				table.insert(t1, 1, "dummy_window_2")
			end

			if isConnectUnibarEnabled() then
				table.insert(t1, 1, not ArgoPartyExperimentation.getIsRenameEnabled() and "connect_unibar" or "party_entrypoint")
			end

			local v56 = table.find(t1, "toggle_mic_mute")

			if v56 then
				table.insert(t1, v56 + 1, Constants2.TOGGLE_MIC_INTEGRATION_ID)
			end
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
					table.insert(v53, 2, "camera_entrypoint")
					table.insert(v53, 2, "selfie_view")
				end
			else
				table.insert(v53, 2, "camera_entrypoint")
				table.insert(v53, 2, "selfie_view")
			end

			if FFlagEnableInExperienceAvatarSwitcher then
				table.insert(v53, 3, Constants.AVATAR_SWITCHER_ID)
			end

			if not isSpatial() and not GuiService:IsTenFootInterface() then
				table.insert(v53, 4, "music_entrypoint")
			end

			if FFlagEnableInExperienceShop then
				table.insert(v53, 2, Constants.IN_EXPERIENCE_SHOP_ID)
			end
		end

		Service:configureSubMenu("nine_dot", v53)
	end

	configureUnibar()

	if FFlagEnableConsoleExpControls then
		require(script.Parent.Parent.Shortcuts.ConfigureShortcuts)()
	end
end

function IconDivider(t2: {[any]: any}) -- line: 211
	-- upvalues: useStyle (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy)
	local v58 = useStyle()
	local v59 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.ICON_DIVIDER_POSITION else UnibarStyle.use().ICON_DIVIDER_POSITION

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Position = t2.position,
		Size = UDim2.new(0, Constants.DIVIDER_CELL_WIDTH, 1, 0)
	}, {
		DividerBar = React.createElement("Frame", {
			BorderSizePixel = 0,
			Position = v59,
			AnchorPoint = Vector2.new(0, 0.5),
			Size = Constants.ICON_DIVIDER_SIZE,
			BackgroundColor3 = v58.Theme.Divider.Color,
			BackgroundTransparency = if not t2.toggleTransition then v58.Theme.Divider.Transparency else t2.toggleTransition:map(function(p1) -- line: 235
				-- upvalues: v58 (copy)
				return v58.Theme.Divider.Transparency + (1 - p1) * (1 - v58.Theme.Divider.Transparency)
			end),
			Visible = t2.visible or true
		})
	})
end

local function getSelectedChild(t3: {[any]: any}, s1: string?) -- line: 244
	-- upvalues: Constants (copy)
	return t3.current:FindFirstChild(Constants.ICON_NAME_PREFIX .. tostring(s1), true)
end

function AnimationStateHelper(p2) -- line: 250
	-- upvalues: useObservableValue (copy), Service (copy), React (copy), FFlagEnableConsoleExpControls (copy), ContextActionService (copy), GuiService (copy), Constants (copy), FFlagUnibarMenuOpenSubmenu (copy), ReactOtter (copy), GetFIntIconSelectionTimeout (copy)
	local v63 = useObservableValue(Service:currentSubMenu())
	local v64 = useObservableValue(Service:selectedItem())
	local v65 = useObservableValue(Service:inFocusNav())

	React.useEffect(function() -- line: 256
		-- upvalues: v65 (copy), FFlagEnableConsoleExpControls (copy), ContextActionService (copy), Service (copy), GuiService (copy), p2 (copy), v64 (copy), Constants (copy), FFlagUnibarMenuOpenSubmenu (copy)
		if v65 then
			if not FFlagEnableConsoleExpControls then
				ContextActionService:BindCoreAction("RBXEscapeUnibar", function(_, p4, _) -- line: 259
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
					local v168 = v64
					local v169 = menuFrameRef.current:FindFirstChild(Constants.ICON_NAME_PREFIX .. tostring(v168), true)

					if v169 then
						GuiService.SelectedCoreObject = v169

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
	end, { v65 })
	React.useEffect(function() -- line: 304
		-- upvalues: v63 (copy), FFlagUnibarMenuOpenSubmenu (copy), v65 (copy), GuiService (copy), p2 (copy), ReactOtter (copy), Constants (copy)
		if v63 == "nine_dot" then
			if FFlagUnibarMenuOpenSubmenu and v65 then
				GuiService:Select(p2.subMenuHostRef.current)
			end

			p2.setToggleSubmenuTransition((ReactOtter.spring(1, Constants.MENU_ANIMATION_SPRING)))

			return
		end

		p2.setToggleSubmenuTransition((ReactOtter.spring(0, Constants.MENU_ANIMATION_SPRING)))
	end, { v63 })
	React.useEffect(function() -- line: 315
		-- upvalues: FFlagEnableConsoleExpControls (copy), v63 (copy), v64 (copy), GetFIntIconSelectionTimeout (copy), p2 (copy), Constants (copy), GuiService (copy)
		if FFlagEnableConsoleExpControls and v63 == v64 then
			return
		end

		local co = coroutine.create(function() -- line: 320
			-- upvalues: GetFIntIconSelectionTimeout (copy), p2 (copy), v64 (copy), FFlagEnableConsoleExpControls (copy), Constants (copy), GuiService (copy)
			local n1 = 0
			local v199

			repeat
				repeat
					if not (n1 < GetFIntIconSelectionTimeout()) then
						return
					end

					n1 += 1
					task.wait()
				until p2.menuFrameRef.current and v64

				if FFlagEnableConsoleExpControls then
					local menuFrameRef = p2.menuFrameRef
					local v198 = v64

					v199 = menuFrameRef.current:FindFirstChild(Constants.ICON_NAME_PREFIX .. tostring(v198), true)
				else
					v199 = p2.menuFrameRef.current:FindFirstChild("IconHitArea_" .. v64, true)
				end
			until v199

			GuiService.SelectedCoreObject = v199
		end)

		coroutine.resume(co)
	end, {
		v64,
		if not FFlagEnableConsoleExpControls then nil else v63
	})

	return nil
end
function linearInterpolation(n2: number, n3: number, n4: number) -- line: 346
	return n2 * (1 - n4) + n3 * n4
end
function IconPositionBinding(p6, n5: number, n6: number, n7: number, p7, p8, b1: boolean, b2: boolean?, p9) -- line: 350
	-- upvalues: FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy)
	local u78 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.UNIBAR_END_PADDING else UnibarStyle.use().UNIBAR_END_PADDING

	return (React.joinBindings({
		p6,
		p7,
		p8
	}):map(function(t4: {[any]: any}) -- line: 370
		-- upvalues: p9 (copy), n6 (copy), n5 (copy), n7 (copy), b2 (copy), b1 (copy), u78 (ref)
		local v172 = if not p9.current then linearInterpolation(n5, n6, t4[2]) else linearInterpolation(n6, n5, t4[2])
		local v173 = n7

		if b2 and not b1 then
			v173 = n7 - t4[3]
		end

		local v174 = v172 - v173

		return UDim2.new(0, u78 + v173 + v174 * t4[1], 0, 0)
	end))
end

local function onUnibarSelectionChanged(p10, _: boolean, _, p12) -- line: 388
	-- upvalues: Service (copy)
	if not p10:IsAncestorOf(p12) then
		Service:disableFocusNav()
	end
end

function isLeft(p13) -- line: 407
	return p13 == Enum.HorizontalAlignment.Left
end
function Unibar(t5: {[any]: any}) -- line: 411
	-- upvalues: FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy), FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), Stores (copy), useChromeMenuItems (copy), ReactOtter (copy), Service (copy), FFlagReduceTopBarInsetsWhileHidden (copy), v40 (copy), useMappedObservableValue (copy), IconHost (copy), createEffect (copy), useStyle (copy), FFlagUnibarMenuOpenSubmenu (copy)
	local ICON_CELL_WIDTH, UNIBAR_END_PADDING

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		local v85 = UnibarStyle.use()

		ICON_CELL_WIDTH = v85.ICON_CELL_WIDTH
		UNIBAR_END_PADDING = v85.UNIBAR_END_PADDING
	else
		ICON_CELL_WIDTH = Constants.ICON_CELL_WIDTH
		UNIBAR_END_PADDING = Constants.UNIBAR_END_PADDING
	end

	local t6 = {}
	local v89 = React.useRef({})
	local v90 = React.useRef(Vector2.zero)
	local v91 = React.useRef(Vector2.zero)
	local u92 = nil

	if FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and Stores.GetUILessStore then
		u92 = React.useRef(Stores.GetUILessStore(false))
	end

	local v93 = false
	local v94 = v89.current or {}
	local v95 = useChromeMenuItems()
	local v96, v97 = ReactOtter.useAnimatedBinding(1)
	local v98, v99 = ReactOtter.useAnimatedBinding(1)
	local v100, v101 = ReactOtter.useAnimatedBinding(0)
	local v102 = React.useRef(0)
	local v103, v104 = ReactOtter.useAnimatedBinding(1)
	local v105 = React.useRef(false)
	local v106 = React.useRef(0)
	local v107 = Service:currentSubMenu():get() == "nine_dot"
	local v108, v109 = ReactOtter.useAnimatedBinding(not v107 and 0 or 1)
	local t7 = {}
	local n8 = 0
	local n9 = 0
	local n10 = 0
	local n11 = 0
	local v115 = React.useCallback(function(p14) -- line: 459
		-- upvalues: v90 (copy), Service (copy), FFlagReduceTopBarInsetsWhileHidden (copy), v91 (copy), FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), u92 (ref), v40 (copy), t5 (copy), Constants (copy)
		local zero = Vector2.zero
		local zero2 = Vector2.zero

		if p14 then
			zero = p14.AbsolutePosition
			zero2 = p14.AbsoluteSize

			if zero ~= v90.current then
				v90.current = zero
				Service:setMenuAbsolutePosition(zero)
			end

			if FFlagReduceTopBarInsetsWhileHidden and zero2 ~= v91.current then
				v91.current = zero2
			end

			if FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and u92.current.getUILessModeEnabled(false) then
				if zero ~= v90.current then
					v90.current = zero
					Service:setMenuAbsolutePosition(zero)
				end

				if zero2 ~= v91.current then
					v91.current = zero2
				end
			end
		end

		if FFlagReduceTopBarInsetsWhileHidden and v40 then
			if p14 and t5.onAreaChanged and v40:getShowTopBar():get() then
				t5.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, zero, zero2)

				return
			end
		elseif FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and u92.current.getUILessModeEnabled(false) then
			if p14 and t5.onAreaChanged and u92.current.getUIVisible(false) then
				t5.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, zero, zero2)

				return
			end
		elseif p14 and t5.onAreaChanged then
			t5.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, zero, p14.AbsoluteSize)
		end
	end, {})
	local v116 = React.joinBindings({
		v98,
		v100
	}):map(function(t8: {[any]: any}) -- line: 508
		-- upvalues: n11 (ref), ICON_CELL_WIDTH (ref)
		return UDim2.new(0, linearInterpolation(n11, t8[2], t8[1]), 0, ICON_CELL_WIDTH)
	end)
	local v117 = useMappedObservableValue(Service:orderAlignment(), isLeft)

	for _, v119 in v95 do
		if v119.integration.availability:get() == Service.AvailabilitySignal.Pinned then
			n8 += 1
		end
	end

	local v120 = if not v117 then math.max(n8 - 1, 0) else 1

	for v121, v122 in v95 do
		if v122.isDivider then
			local v123 = n9 + ICON_CELL_WIDTH * v120
			local v124 = v94[v122.id] or n9

			t6[v122.id] = n9
			v93 = v93 or v124 ~= n9

			local v125 = IconPositionBinding(v96, v124, n9, v123, v103, v100, false, v117, v105)
			local v126 = if not v117 then React.joinBindings({
				v125,
				v116
			}):map(function(p15) -- line: 555
				-- upvalues: ICON_CELL_WIDTH (ref)
				local v181 = p15[1]
				local v182 = p15[2]

				return v181.X.Offset <= v182.X.Offset - ICON_CELL_WIDTH
			end) else React.joinBindings({
				v125,
				v116
			}):map(function(p16) -- line: 550
				-- upvalues: ICON_CELL_WIDTH (ref)
				return p16[1].X.Offset >= ICON_CELL_WIDTH * 0.5
			end)

			t7[v122.id or "icon" .. v121] = React.createElement(IconDivider, {
				position = v125,
				visible = v126,
				toggleTransition = v98
			})
			n9 += Constants.DIVIDER_CELL_WIDTH
		elseif v122.integration then
			local v127 = false
			local v128 = n9 + ICON_CELL_WIDTH * v120

			if v122.integration.availability:get() == Service.AvailabilitySignal.Pinned then
				v127 = true
				v128 = n10
			end

			local v129 = if v94[v122.id] ~= nil then v94[v122.id] else n9

			t6[v122.id] = n9
			v93 = v93 or v129 ~= n9

			local v130 = IconPositionBinding(v96, v129, n9, v128, v103, v100, v127, v117, v105)
			local v131 = if not v117 then React.joinBindings({
				v130,
				v116
			}):map(function(p17) -- line: 599
				-- upvalues: ICON_CELL_WIDTH (ref)
				local v185 = p17[1]
				local v186 = p17[2]

				return v185.X.Offset <= v186.X.Offset - ICON_CELL_WIDTH * 1.5
			end) else React.joinBindings({
				v130,
				v116
			}):map(function(p18) -- line: 594
				-- upvalues: ICON_CELL_WIDTH (ref)
				return p18[1].X.Offset >= ICON_CELL_WIDTH * 0.5
			end)

			t7[v122.id or "icon" .. v121] = React.createElement(IconHost, {
				position = v130,
				visible = v127 or v131,
				toggleTransition = v108,
				integration = v122
			})
			n9 += ICON_CELL_WIDTH

			if v127 then
				n10 += ICON_CELL_WIDTH
			end
		end
	end

	n11 = n9

	if t5.onMinWidthChanged then
		t5.onMinWidthChanged(n11)
	end

	local u132 = UNIBAR_END_PADDING * 2 + n9

	React.useEffect(function() -- line: 625
		-- upvalues: v102 (copy), v100 (copy), v101 (copy), ReactOtter (copy), u132 (ref), Constants (copy), Service (copy), ICON_CELL_WIDTH (ref)
		local current = v102.current

		if v100:getValue() == 0 then
			v101((ReactOtter.instant(u132)))
			v102.current = u132
		elseif current ~= u132 then
			v101(ReactOtter.spring(u132, Constants.MENU_ANIMATION_SPRING))
			v102.current = u132
		end

		Service:setMenuAbsoluteSize(Vector2.new(u132, ICON_CELL_WIDTH))
	end, { u132 })

	if v93 then
		v106.current = (v106.current or 0) + 1
	end

	v89.current = t6
	React.useEffect(function() -- line: 643
		-- upvalues: v105 (copy), v104 (copy), ReactOtter (copy), Constants (copy)
		if not v105.current then
			v104(ReactOtter.spring(0, Constants.MENU_ANIMATION_SPRING))
			v105.current = true

			return
		end

		v104(ReactOtter.spring(1, Constants.MENU_ANIMATION_SPRING))
		v105.current = false
	end, {
		v106.current,
		v105
	})
	React.useEffect(function() -- line: 655
		-- upvalues: FFlagReduceTopBarInsetsWhileHidden (copy), v40 (copy), t5 (copy), Constants (copy), v90 (copy), v91 (copy)
		if FFlagReduceTopBarInsetsWhileHidden and v40 then
			local v188 = v40:getShowTopBar()

			v188:connect(function() -- line: 658
				-- upvalues: v188 (copy), t5 (copy), Constants (copy), v90 (copy), v91 (copy)
				if v188:get() then
					t5.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, v90.current, v91.current)

					return
				end

				t5.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, Vector2.zero, Vector2.zero)
			end)
			t5.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, Vector2.zero, Vector2.zero)
		end
	end, {})
	React.useEffect(function() -- line: 673
		-- upvalues: FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), u92 (ref), createEffect (copy), t5 (copy), Constants (copy), v90 (copy), v91 (copy)
		local u189 = nil

		if FFlagAddUILessMode and (FIntAddUILessModeVariant ~= 0 and u92.current.getUILessModeEnabled(false)) then
			u189 = createEffect(function(p19) -- line: 676
				-- upvalues: u92 (ref), t5 (copy), Constants (copy), v90 (copy), v91 (copy)
				if u92.current.getUIVisible(p19) then
					t5.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, v90.current, v91.current)

					return
				end

				t5.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, Vector2.zero, Vector2.zero)
			end)
			t5.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, Vector2.zero, Vector2.zero)
		end

		return function() -- line: 690
			-- upvalues: u189 (ref)
			if u189 then
				u189()
			end
		end
	end, {})

	local v133 = useStyle()

	return React.createElement("Frame", {
		Size = v116,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		SelectionGroup = true,
		ref = t5.menuFrameRef,
		[React.Change.AbsoluteSize] = v115,
		[React.Change.AbsolutePosition] = v115
	}, {
		React.createElement(AnimationStateHelper, {
			setToggleIconTransition = v97,
			setToggleWidthTransition = v99,
			setToggleSubmenuTransition = v109,
			menuFrameRef = t5.menuFrameRef,
			subMenuHostRef = if not FFlagUnibarMenuOpenSubmenu then nil else t5.subMenuHostRef
		}),
		React.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = v133.Theme.BackgroundUIContrast.Color,
			BackgroundTransparency = v133.Theme.BackgroundUIContrast.Transparency * v133.Settings.PreferredTransparency
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

local function UnibarPills(t9: {[any]: any}) -- line: 745
	-- upvalues: useStyle (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), useChromeMenuItems (copy), Service (copy), ReactOtter (copy), React (copy), IconHost (copy)
	local v135 = useStyle()
	local UNIBAR_END_PADDING, MENU_SUBMENU_PADDING

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		local v136 = UnibarStyle.use()

		UNIBAR_END_PADDING = v136.UNIBAR_END_PADDING
		MENU_SUBMENU_PADDING = v136.MENU_SUBMENU_PADDING
	else
		UNIBAR_END_PADDING = Constants.UNIBAR_END_PADDING
		MENU_SUBMENU_PADDING = Constants.MENU_SUBMENU_PADDING
	end

	local v139 = useChromeMenuItems()
	local v140 = Service:currentSubMenu():get() == "nine_dot"
	local v141, v142 = ReactOtter.useAnimatedBinding(not v140 and 0 or 1)

	assert(v139 ~= nil, "Menu items should not be nil")

	local t10 = {}
	local t11 = {}

	for v145, v146 in v139 do
		if v146.integration and v146.isDivider == false then
			t11["icon_host" .. v145] = React.createElement(IconHost, {
				toggleTransition = v141,
				integration = v146
			})
		end

		if v146.isDivider or v145 == #v139 then
			local v147 = React.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundColor3 = v135.Theme.BackgroundUIContrast.Color,
				BackgroundTransparency = v135.Theme.BackgroundUIContrast.Transparency * v135.Settings.PreferredTransparency
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

			t10["pill_" .. v145] = v147
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
			setToggleSubmenuTransition = v142,
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
local function SubMenuWrapper(p20) -- line: 837
	-- upvalues: isInExperienceUIVREnabled (copy), isSpatial (copy), Panel3DInSpatialUI (ref), useObservableValue (copy), Service (copy), u44 (ref), React (copy), SubMenu (copy), PanelType (ref)
	if isInExperienceUIVREnabled and (isSpatial() and Panel3DInSpatialUI) then
		local v149 = useObservableValue(Service:currentSubMenu())

		u44:set(v149 ~= nil)
	end

	local v150 = React.useCallback(function(vector2: Vector2) -- line: 842
		-- upvalues: React (copy), SubMenu (copy), p20 (copy)
		return (React.createElement(SubMenu, {
			subMenuHostRef = p20.subMenuHostRef,
			panelSize = vector2
		}))
	end, { p20.subMenuHostRef })

	if isInExperienceUIVREnabled and isSpatial() and Panel3DInSpatialUI then
		return (React.createElement(Panel3DInSpatialUI, {
			panelType = PanelType.ChromeSubMenu,
			renderFunction = v150,
			visibilityObservable = u44
		}))
	end

	return (React.createElement(SubMenu, {
		subMenuHostRef = p20.subMenuHostRef
	}))
end

return React.memo(function(t12: {[any]: any}) -- line: 861
	-- upvalues: FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy), FFlagEnableConsoleExpControls (copy), FFlagUnibarMenuOpenSubmenu (copy), useMappedObservableValue (copy), Service (copy), v40 (copy), FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), Stores (copy), createEffect (copy), onUnibarSelectionChanged (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), UnibarPills (copy), SubMenuWrapper (copy), SubMenu (copy), ShortcutBar (copy), WindowManager (copy)
	local v152 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.MENU_SUBMENU_PADDING else UnibarStyle.use().MENU_SUBMENU_PADDING
	local u153 = React.useRef(nil)

	if FFlagEnableConsoleExpControls and t12.menuRef then
		u153 = t12.menuRef
	end

	local v154 = React.useRef(nil)
	local v155 = nil

	if FFlagUnibarMenuOpenSubmenu then
		v155 = React.useRef(nil)
	end

	local function updateSize() -- line: 883
		-- upvalues: v154 (copy), u153 (ref)
		if v154.current and u153.current then
			v154.current.Size = u153.current.Size
		end
	end

	local v157 = useMappedObservableValue(Service:orderAlignment(), isLeft)
	local v158 = nil
	local u159 = nil
	local u160 = nil

	if FFlagEnableConsoleExpControls and v40 then
		local v161

		v158, v161 = React.useBinding(v40:getShowTopBar():get())
		u159 = v161
		u160 = v40:getShowTopBar()
	end

	local u162 = nil

	if FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and Stores.GetUILessStore then
		u162 = React.useRef(Stores.GetUILessStore(false))

		if u162.current.getUILessModeEnabled(false) then
			local v163

			v158, v163 = React.useBinding(true)
			u159 = v163
		end
	end

	React.useEffect(function() -- line: 908
		-- upvalues: u153 (ref), updateSize (copy), v154 (copy), FFlagEnableConsoleExpControls (copy), u160 (ref), u159 (ref)
		local connection = nil

		if u153 and u153.current then
			connection = u153.current:GetPropertyChangedSignal("Size"):Connect(updateSize)
		end

		if v154.current and u153.current then
			v154.current.Size = u153.current.Size
		end

		if FFlagEnableConsoleExpControls then
			u160:connect(function() -- line: 917
				-- upvalues: u159 (ref), u160 (ref)
				u159(u160:get())
			end)
		end

		return function() -- line: 922
			-- upvalues: connection (ref)
			if connection then
				connection:disconnect()
			end
		end
	end)
	React.useEffect(function() -- line: 929
		-- upvalues: FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), u162 (ref), createEffect (copy), u159 (ref)
		local u192 = nil

		if FFlagAddUILessMode and (FIntAddUILessModeVariant ~= 0 and u162.current.getUILessModeEnabled(false)) then
			u192 = createEffect(function(p21) -- line: 932
				-- upvalues: u159 (ref), u162 (ref)
				u159(u162.current.getUIVisible(p21))
			end)
		end

		return function() -- line: 937
			-- upvalues: u192 (ref)
			if u192 then
				u192()
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
		ref = v154,
		[React.Event.SelectionChanged] = if not FFlagEnableConsoleExpControls then nil else onUnibarSelectionChanged,
		Visible = if not FFlagEnableConsoleExpControls and (not FFlagAddUILessMode or (FIntAddUILessModeVariant == 0 or not u162.current.getUILessModeEnabled(false))) then nil else v158
	}, {
		React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = if not v157 then Enum.HorizontalAlignment.Right else Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, v152)
		}),
		if not isInExperienceUIVREnabled or not isSpatial() then React.createElement(Unibar, {
			menuFrameRef = u153,
			subMenuHostRef = if not FFlagUnibarMenuOpenSubmenu then nil else v155,
			onAreaChanged = t12.onAreaChanged,
			onMinWidthChanged = t12.onMinWidthChanged
		}) else React.createElement(UnibarPills, {
			menuFrameRef = u153,
			subMenuHostRef = v155
		}),
		if not isInExperienceUIVREnabled then React.createElement(SubMenu, {
			subMenuHostRef = v155
		}) else React.createElement(SubMenuWrapper, {
			subMenuHostRef = v155
		}),
		if not FFlagEnableConsoleExpControls then nil else React.createElement(ShortcutBar),
		(React.createElement(WindowManager))
	}) }
end, function(_, _) -- line: 995
	return true
end)
