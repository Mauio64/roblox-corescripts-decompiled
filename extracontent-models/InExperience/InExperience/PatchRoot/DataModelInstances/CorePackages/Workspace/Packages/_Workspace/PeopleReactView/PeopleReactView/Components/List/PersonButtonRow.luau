local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local React = require(parent.React)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local Foundation = require(parent.Foundation)
local PeopleService = require(parent.PeopleService)
local SignalsReact = require(parent.SignalsReact)

local View = Foundation.View
local PersonButton = require(PeopleReactView.Components.Buttons.PersonButton)
local MuteVolumeButton = require(PeopleReactView.Components.Buttons.MuteVolumeButton)
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local useSignalState = SignalsReact.useSignalState
local PersonButtonConfigs = require(PeopleReactView.Configs.PersonButtonConfigs)
local PeoplePageLayoutContext = require(PeopleReactView.PeoplePageLayoutContext)
local SideSheetFocusContext = require(PeopleReactView.SideSheetFocusContext)
local getPersonButtonRowSelectionBehaviorLeft = require(PeopleReactView.Utils.getPersonButtonRowSelectionBehaviorLeft)

local service = PeopleService.getService("Flags")
local getFFlagAddPeoplePageCardLayout = service.GetFFlagAddPeoplePageCardLayout
local fFlagVoiceVolumeControlsPerUserPlayerListButton = service.FFlagVoiceVolumeControlsPerUserPlayerListButton
local SharedFlags = require(parent.SharedFlags)
local FFlagSideSheetOpenPeoplePage = SharedFlags.FFlagSideSheetOpenPeoplePage
local FFlagPeopleListButtonOverflow = require(PeopleReactView.Flags.FFlagPeopleListButtonOverflow)

local function MemoizedButton(data)
	local config = data.config
	local v

	if getFFlagAddPeoplePageCardLayout() then
		v = React.useMemo(function()
			return PeopleService.getService("Constants")
		end, {})
	else
		v = nil
	end

	local onMount = React.useCallback(function(p)
		data.onButtonMount(p, data.buttonId)
	end, { data.onButtonMount })
	local v2

	if getFFlagAddPeoplePageCardLayout() then
		v2 = React.useCallback(function()
			if config.id == v.PERSON_BUTTONS.BLOCK_PLAYER then
				config.onActivated("ingame_menu")
			elseif config.id == v.PERSON_BUTTONS.REPORT_PLAYER then
				config.onActivated("MenuPlayerList")
			else
				config.onActivated(v.ANALYTICS.ENTRY_POINT.PEOPLE_LIST)
			end
		end, { config.id, config.onActivated })
	else
		v2 = nil
	end

	return React.useMemo(function()
		local createElement = React.createElement
		local v3 = {
			text = config.text,
			icon = { on = config.onIcon, off = config.offIcon },
			animatedIcon = config.animatedIcon,
			buttonState = config.buttonState,
			LayoutOrder = config.layoutOrder,
			onActivated = 0,
			isGrayedOut = 0,
			isDisabled = 0,
			isBuilderIcon = 0,
			buttonVariant = 0,
			onMount = 0
		}
		local onActivated

		if getFFlagAddPeoplePageCardLayout() then
			onActivated = v2
		else
			onActivated = config.onActivated
		end

		v3.onActivated = onActivated
		v3.isGrayedOut = config.isGrayedOut
		v3.isDisabled = config.isDisabled
		v3.isBuilderIcon = config.isBuilderIcon
		v3.buttonVariant = config.buttonVariant
		v3.onMount = onMount
		return createElement(PersonButton, v3)
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
		onMount
	})
end

return function(p)
	local v = React.useContext(PeoplePageLayoutContext)

	local userId = p.userId
	local v2

	if FFlagPeopleListButtonOverflow then
		v2 = v.isCompact
	else
		v2 = false
	end

	local personButtonConfigs = PersonButtonConfigs(userId, v2)

	local gapsmall = useDeviceOrientation() == RobloxAppEnums.DeviceOrientationMode.Portrait
		or FFlagPeopleListButtonOverflow and v.isCompact

	local v3 = React.useMemo(function()
		return PeopleService.getService("FocusNavigationService")
	end, {})
	local v4

	if fFlagVoiceVolumeControlsPerUserPlayerListButton then
		v4 = React.useMemo(function()
			return PeopleService.getService("Constants")
		end, {})
	else
		v4 = nil
	end

	local v5

	if fFlagVoiceVolumeControlsPerUserPlayerListButton then
		v5 = React.useMemo(function()
			return PeopleService.getService("PeopleVoiceChatStore")
		end, {})
	end

	local v6

	if fFlagVoiceVolumeControlsPerUserPlayerListButton then
		v6 = useSignalState(v5.getShowVolumeControl)
	else
		v6 = false
	end

	local ref = React.useRef({})

	local onButtonMount = React.useCallback(function(p2, p3: string)
		if p2 then
			ref.current[p3] = p2
		else
			ref.current[p3] = nil
		end
	end, {})

	local v7 = React.useMemo(function()
		local ids = {}

		if getFFlagAddPeoplePageCardLayout() then
			for _, v7 in personButtonConfigs do
				if v7.shouldShow() then
					table.insert(ids, v7.id)
				end
			end
		else
			for _, v7 in ipairs(personButtonConfigs) do
				if v7.shouldShow() then
					table.insert(ids, v7.id)
				end
			end
		end

		table.sort(ids)
		return table.concat(ids, ",")
	end, { personButtonConfigs })

	local useEffect = React.useEffect
	local function fn()
		local v8 = {}

		if fFlagVoiceVolumeControlsPerUserPlayerListButton then
			local function appendVisibleConfig(p2)
				if not p2.shouldShow() then
					return
				end

				local v9 = ref.current[p2.id]

				if v9 then
					table.insert(v8, v9)
				end

				local v10 = v6 and p2.id == v4.PERSON_BUTTONS.MUTE_PLAYER and ref.current[p2.id .. "_volume"]

				if v10 then
					table.insert(v8, v10)
				end
			end

			if getFFlagAddPeoplePageCardLayout() then
				for _, v9 in personButtonConfigs do
					if not v9.shouldShow() then
						continue
					end

					local v10 = ref.current[v9.id]

					if v10 then
						table.insert(v8, v10)
					end

					if not (v6 and v9.id == v4.PERSON_BUTTONS.MUTE_PLAYER) then
						continue
					end

					local v11 = ref.current[v9.id .. "_volume"]

					if v11 then
						table.insert(v8, v11)
					end
				end
			else
				for _, v9 in ipairs(personButtonConfigs) do
					if not v9.shouldShow() then
						continue
					end

					local v10 = ref.current[v9.id]

					if v10 then
						table.insert(v8, v10)
					end

					if not (v6 and v9.id == v4.PERSON_BUTTONS.MUTE_PLAYER) then
						continue
					end

					local v11 = ref.current[v9.id .. "_volume"]

					if v11 then
						table.insert(v8, v11)
					end
				end
			end
		elseif getFFlagAddPeoplePageCardLayout() then
			for _, v9 in personButtonConfigs do
				if not v9.shouldShow() then
					continue
				end

				local v10 = ref.current[v9.id]

				if v10 then
					table.insert(v8, v10)
				end
			end
		else
			for _, v9 in ipairs(personButtonConfigs) do
				if not v9.shouldShow() then
					continue
				end

				local v10 = ref.current[v9.id]

				if v10 then
					table.insert(v8, v10)
				end
			end
		end

		if #v8 > 0 then
			table.sort(v8, function(a, b): boolean
				return a.LayoutOrder < b.LayoutOrder
			end)

			local index = p.index or 0
			v3.registerButtonRow(p.userId, v8, index)
		end
	end

	local v8

	if fFlagVoiceVolumeControlsPerUserPlayerListButton then
		v8 = { p.userId, p.index, v3, v7, v6 }
	else
		v8 = { p.userId, p.index, v3, v7 }
	end

	useEffect(fn, v8)

	React.useEffect(function()
		return function()
			v3.handlePersonRemoved(p.userId)
			v3.unregisterButtonRow(p.userId)
		end
	end, { p.userId, v3 })

	local v9 = React.useMemo(function()
		return v3.hasSelectablePlatformButton(p.userId)
	end, { p.userId, v3 })
	local v10

	if FFlagSideSheetOpenPeoplePage then
		v10 = React.useContext(SideSheetFocusContext)
	else
		v10 = false
	end

	local selectionBehaviorLeft = React.useMemo(function()
		if FFlagSideSheetOpenPeoplePage then
			return getPersonButtonRowSelectionBehaviorLeft(v9, v10)
		end

		if v9 then
			return Enum.SelectionBehavior.Escape
		end

		return Enum.SelectionBehavior.Stop
	end, { v10, v9 })

	if not React.useMemo(function(): boolean
		if getFFlagAddPeoplePageCardLayout() then
			for _, v11 in personButtonConfigs do
				if v11.shouldShow() then
					return true
				end
			end
		else
			for _, v11 in ipairs(personButtonConfigs) do
				if v11.shouldShow() then
					return true
				end
			end
		end

		return false
	end, { personButtonConfigs }) then
		return nil
	end

	local children = {}

	if getFFlagAddPeoplePageCardLayout() then
		for _, config in personButtonConfigs do
			if not config.shouldShow() then
				continue
			end

			if
				fFlagVoiceVolumeControlsPerUserPlayerListButton
				and v6
				and config.id == v4.PERSON_BUTTONS.MUTE_PLAYER
			then
				table.insert(children, React.createElement(MuteVolumeButton, {
					key = config.id,
					config = config,
					userId = p.userId,
					entryPoint = v4.ANALYTICS.ENTRY_POINT.PEOPLE_LIST,
					muteButtonName = config.id,
					volumeButtonName = config.id .. "_volume",
					onButtonMount = onButtonMount
				}))
			else
				table.insert(
					children,
					React.createElement(MemoizedButton, {
						key = config.id,
						config = config,
						buttonId = config.id,
						onButtonMount = onButtonMount
					})
				)
			end
		end
	else
		for _, config in ipairs(personButtonConfigs) do
			if not config.shouldShow() then
				continue
			end

			if
				fFlagVoiceVolumeControlsPerUserPlayerListButton
				and v6
				and config.id == v4.PERSON_BUTTONS.MUTE_PLAYER
			then
				table.insert(children, React.createElement(MuteVolumeButton, {
					key = config.id,
					config = config,
					userId = p.userId,
					entryPoint = v4.ANALYTICS.ENTRY_POINT.PEOPLE_LIST,
					muteButtonName = config.id,
					volumeButtonName = config.id .. "_volume",
					onButtonMount = onButtonMount
				}))
			else
				table.insert(
					children,
					React.createElement(MemoizedButton, {
						key = config.id,
						config = config,
						buttonId = config.id,
						onButtonMount = onButtonMount
					})
				)
			end
		end
	end

	return React.createElement(View, {
		tag = {
			["auto-xy row"] = true,
			["gap-small"] = gapsmall,
			["gap-medium"] = not gapsmall
		},
		LayoutOrder = 1,
		selectionGroup = {
			SelectionBehaviorLeft = selectionBehaviorLeft,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		}
	}, children)
end
