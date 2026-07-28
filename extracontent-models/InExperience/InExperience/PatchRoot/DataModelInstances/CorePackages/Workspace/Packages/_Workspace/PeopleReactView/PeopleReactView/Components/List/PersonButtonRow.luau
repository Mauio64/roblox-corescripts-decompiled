local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local React = require(PeopleReactViewParent.React)
local RobloxAppEnums = require(PeopleReactViewParent.RobloxAppEnums)
local RobloxAppHooks = require(PeopleReactViewParent.RobloxAppHooks)
local Foundation = require(PeopleReactViewParent.Foundation)
local PeopleService = require(PeopleReactViewParent.PeopleService)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)
local View = Foundation.View
local PersonButton = require(PeopleReactView.Components.Buttons.PersonButton)
local MuteVolumeButton = require(PeopleReactView.Components.Buttons.MuteVolumeButton)
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local useSignalState = SignalsReact.useSignalState
local PersonButtonConfigs = require(PeopleReactView.Configs.PersonButtonConfigs)
local v15 = PeopleService.getService("Flags")
local GetFFlagAddPeoplePageCardLayout = v15.GetFFlagAddPeoplePageCardLayout
local FFlagVoiceVolumeControlsPerUserPlayerListButton = v15.FFlagVoiceVolumeControlsPerUserPlayerListButton

local function MemoizedButton(t1: {[any]: any}) -- line: 28
	-- upvalues: GetFFlagAddPeoplePageCardLayout (copy), React (copy), PeopleService (copy), PersonButton (copy)
	local config = t1.config
	local v21 = if not GetFFlagAddPeoplePageCardLayout() then nil else React.useMemo(function() -- line: 36
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("Constants")
	end, {})
	local v22 = React.useCallback(function(p1) -- line: 41
		-- upvalues: t1 (copy)
		t1.onButtonMount(p1, t1.buttonId)
	end, { t1.onButtonMount })
	local v23 = if not GetFFlagAddPeoplePageCardLayout() then nil else React.useCallback(function() -- line: 46
		-- upvalues: config (copy), v21 (copy)
		if config.id == v21.PERSON_BUTTONS.BLOCK_PLAYER then
			config.onActivated("ingame_menu")

			return
		end

		if config.id == v21.PERSON_BUTTONS.REPORT_PLAYER then
			config.onActivated("MenuPlayerList")

			return
		end

		config.onActivated(v21.ANALYTICS.ENTRY_POINT.PEOPLE_LIST)
	end, {
		config.id,
		config.onActivated
	})

	return React.useMemo(function() -- line: 57
		-- upvalues: React (copy), PersonButton (copy), config (copy), GetFFlagAddPeoplePageCardLayout (copy), v23 (copy), v22 (copy)
		return React.createElement(PersonButton, {
			text = config.text,
			icon = {
				on = config.onIcon,
				off = config.offIcon
			},
			animatedIcon = config.animatedIcon,
			buttonState = config.buttonState,
			LayoutOrder = config.layoutOrder,
			onActivated = if not GetFFlagAddPeoplePageCardLayout() then config.onActivated else v23,
			isGrayedOut = config.isGrayedOut,
			isDisabled = config.isDisabled,
			isBuilderIcon = config.isBuilderIcon,
			buttonVariant = config.buttonVariant,
			onMount = v22
		})
	end, {
		config.text,
		config.onIcon,
		config.offIcon,
		config.animatedIcon,
		config.buttonState,
		config.layoutOrder,
		config.onActivated,
		config.isGrayedOut,
		config.isDisabled,
		config.isBuilderIcon,
		config.buttonVariant,
		v22
	})
end

return function(t2: {[any]: any}) -- line: 91
	-- upvalues: PersonButtonConfigs (copy), useDeviceOrientation (copy), RobloxAppEnums (copy), React (copy), PeopleService (copy), FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), useSignalState (copy), GetFFlagAddPeoplePageCardLayout (copy), MuteVolumeButton (copy), MemoizedButton (copy), View (copy)
	local v25 = PersonButtonConfigs(t2.userId)
	local v26 = useDeviceOrientation() == RobloxAppEnums.DeviceOrientationMode.Portrait
	local v27 = React.useMemo(function() -- line: 96
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("FocusNavigationService")
	end, {})
	local v28 = if not FFlagVoiceVolumeControlsPerUserPlayerListButton then nil else React.useMemo(function() -- line: 101
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("Constants")
	end, {})
	local v29 = if not FFlagVoiceVolumeControlsPerUserPlayerListButton then nil else React.useMemo(function() -- line: 107
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("PeopleVoiceChatStore")
	end, {})
	local v30 = not not FFlagVoiceVolumeControlsPerUserPlayerListButton and useSignalState(v29.getShowVolumeControl)
	local v31 = React.useRef({})
	local v32 = React.useCallback(function(p2, s1: string) -- line: 118
		-- upvalues: v31 (copy)
		if p2 then
			v31.current[s1] = p2

			return
		end

		v31.current[s1] = nil
	end, {})
	local v33 = React.useMemo(function() -- line: 126
		-- upvalues: GetFFlagAddPeoplePageCardLayout (copy), v25 (copy)
		local t3 = {}

		if GetFFlagAddPeoplePageCardLayout() then
			for _, v46 in v25 do
				if v46.shouldShow() then
					table.insert(t3, v46.id)
				end
			end
		else
			for _, v in ipairs(v25) do
				if v.shouldShow() then
					table.insert(t3, v.id)
				end
			end
		end

		table.sort(t3)

		return table.concat(t3, ",")
	end, { v25 })

	React.useEffect(function() -- line: 146
		-- upvalues: FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), v31 (copy), v30 (copy), v28 (copy), GetFFlagAddPeoplePageCardLayout (copy), v25 (copy), t2 (copy), v27 (copy)
		local t4 = {}

		if FFlagVoiceVolumeControlsPerUserPlayerListButton then
			local function appendVisibleConfig(p3) -- line: 151
				-- upvalues: v31 (copy), t4 (copy), v30 (copy), v28 (copy)
				if not p3.shouldShow() then
					return
				end

				local v71 = v31.current[p3.id]

				if v71 then
					table.insert(t4, v71)
				end

				if v30 and p3.id == v28.PERSON_BUTTONS.MUTE_PLAYER then
					local v72 = v31.current[p3.id .. "_volume"]

					if v72 then
						table.insert(t4, v72)
					end
				end
			end

			if GetFFlagAddPeoplePageCardLayout() then
				for _, v52 in v25 do
					if v52.shouldShow() then
						local v53 = v31.current[v52.id]

						if v53 then
							table.insert(t4, v53)
						end

						if v30 and v52.id == v28.PERSON_BUTTONS.MUTE_PLAYER then
							local v54 = v31.current[v52.id .. "_volume"]

							if v54 then
								table.insert(t4, v54)
							end
						end
					end
				end
			else
				for _, v in ipairs(v25) do
					if v.shouldShow() then
						local v57 = v31.current[v.id]

						if v57 then
							table.insert(t4, v57)
						end

						if v30 and v.id == v28.PERSON_BUTTONS.MUTE_PLAYER then
							local v58 = v31.current[v.id .. "_volume"]

							if v58 then
								table.insert(t4, v58)
							end
						end
					end
				end
			end
		elseif GetFFlagAddPeoplePageCardLayout() then
			for _, v60 in v25 do
				if v60.shouldShow() then
					local v61 = v31.current[v60.id]

					if v61 then
						table.insert(t4, v61)
					end
				end
			end
		else
			for _, v in ipairs(v25) do
				if v.shouldShow() then
					local v64 = v31.current[v.id]

					if v64 then
						table.insert(t4, v64)
					end
				end
			end
		end

		if #t4 > 0 then
			table.sort(t4, function(p4, p5) -- line: 199
				return p4.LayoutOrder < p5.LayoutOrder
			end)

			local v65 = t2.index or 0

			v27.registerButtonRow(t2.userId, t4, v65)
		end
	end, if not FFlagVoiceVolumeControlsPerUserPlayerListButton then {
		t2.userId,
		t2.index,
		v27,
		v33
	} else {
		t2.userId,
		t2.index,
		v27,
		v33,
		v30
	})
	React.useEffect(function() -- line: 224
		-- upvalues: v27 (copy), t2 (copy)
		return function() -- line: 225
			-- upvalues: v27 (copy), t2 (copy)
			v27.handlePersonRemoved(t2.userId)
			v27.unregisterButtonRow(t2.userId)
		end
	end, {
		t2.userId,
		v27
	})

	local v34 = React.useMemo(function() -- line: 231
		-- upvalues: v27 (copy), t2 (copy)
		return v27.hasSelectablePlatformButton(t2.userId)
	end, {
		t2.userId,
		v27
	})
	local v35 = React.useMemo(function() -- line: 235
		-- upvalues: v34 (copy)
		if v34 then
			return Enum.SelectionBehavior.Escape
		end

		return Enum.SelectionBehavior.Stop
	end, { v34 })

	if not React.useMemo(function() -- line: 240
		-- upvalues: GetFFlagAddPeoplePageCardLayout (copy), v25 (copy)
		if GetFFlagAddPeoplePageCardLayout() then
			for _, v67 in v25 do
				if v67.shouldShow() then
					return true
				end
			end
		else
			for _, v in ipairs(v25) do
				if v.shouldShow() then
					return true
				end
			end
		end

		return false
	end, { v25 }) then
		return nil
	end

	local t5 = {}

	if GetFFlagAddPeoplePageCardLayout() then
		for _, v38 in v25 do
			if v38.shouldShow() then
				if FFlagVoiceVolumeControlsPerUserPlayerListButton and v30 and v38.id == v28.PERSON_BUTTONS.MUTE_PLAYER then
					table.insert(t5, React.createElement(MuteVolumeButton, {
						key = v38.id,
						config = v38,
						userId = t2.userId,
						entryPoint = v28.ANALYTICS.ENTRY_POINT.PEOPLE_LIST,
						muteButtonName = v38.id,
						volumeButtonName = v38.id .. "_volume",
						onButtonMount = v32
					}))
				else
					table.insert(t5, React.createElement(MemoizedButton, {
						key = v38.id,
						config = v38,
						buttonId = v38.id,
						onButtonMount = v32
					}))
				end
			end
		end
	else
		for _, v in ipairs(v25) do
			if v.shouldShow() then
				if FFlagVoiceVolumeControlsPerUserPlayerListButton and v30 and v.id == v28.PERSON_BUTTONS.MUTE_PLAYER then
					table.insert(t5, React.createElement(MuteVolumeButton, {
						key = v.id,
						config = v,
						userId = t2.userId,
						entryPoint = v28.ANALYTICS.ENTRY_POINT.PEOPLE_LIST,
						muteButtonName = v.id,
						volumeButtonName = v.id .. "_volume",
						onButtonMount = v32
					}))
				else
					table.insert(t5, React.createElement(MemoizedButton, {
						key = v.id,
						config = v,
						buttonId = v.id,
						onButtonMount = v32
					}))
				end
			end
		end
	end

	return React.createElement(View, {
		LayoutOrder = 1,
		tag = {
			["auto-xy row"] = true,
			["gap-small"] = v26,
			["gap-medium"] = not v26
		},
		selectionGroup = {
			SelectionBehaviorLeft = v35,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		}
	}, t5)
end
