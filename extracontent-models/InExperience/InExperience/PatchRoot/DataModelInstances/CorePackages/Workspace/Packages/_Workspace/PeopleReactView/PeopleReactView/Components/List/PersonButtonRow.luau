local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local React = require(PeopleReactViewParent.React)
local RobloxAppEnums = require(PeopleReactViewParent.RobloxAppEnums)
local RobloxAppHooks = require(PeopleReactViewParent.RobloxAppHooks)
local Foundation = require(PeopleReactViewParent.Foundation)
local PeopleService = require(PeopleReactViewParent.PeopleService)
local View = Foundation.View
local PersonButton = require(PeopleReactView.Components.Buttons.PersonButton)
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local PersonButtonConfigs = require(PeopleReactView.Configs.PersonButtonConfigs)
local GetFFlagAddPeoplePageCardLayout = PeopleService.getService("Flags").GetFFlagAddPeoplePageCardLayout

local function MemoizedButton(t1: {[any]: any}) -- line: 22
	-- upvalues: GetFFlagAddPeoplePageCardLayout (copy), React (copy), PeopleService (copy), PersonButton (copy)
	local config = t1.config
	local v16 = if not GetFFlagAddPeoplePageCardLayout() then nil else React.useMemo(function() -- line: 30
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("Constants")
	end, {})
	local v17 = React.useCallback(function(p1) -- line: 35
		-- upvalues: t1 (copy)
		t1.onButtonMount(p1, t1.buttonId)
	end, { t1.onButtonMount })
	local v18 = if not GetFFlagAddPeoplePageCardLayout() then nil else React.useCallback(function() -- line: 40
		-- upvalues: config (copy), v16 (copy)
		if config.id == v16.PERSON_BUTTONS.BLOCK_PLAYER then
			config.onActivated("ingame_menu")

			return
		end

		if config.id == v16.PERSON_BUTTONS.REPORT_PLAYER then
			config.onActivated("MenuPlayerList")

			return
		end

		config.onActivated(v16.ANALYTICS.ENTRY_POINT.PEOPLE_LIST)
	end, {
		config.id,
		config.onActivated
	})

	return React.useMemo(function() -- line: 51
		-- upvalues: React (copy), PersonButton (copy), config (copy), GetFFlagAddPeoplePageCardLayout (copy), v18 (copy), v17 (copy)
		return React.createElement(PersonButton, {
			text = config.text,
			icon = {
				on = config.onIcon,
				off = config.offIcon
			},
			animatedIcon = config.animatedIcon,
			buttonState = config.buttonState,
			LayoutOrder = config.layoutOrder,
			onActivated = if not GetFFlagAddPeoplePageCardLayout() then config.onActivated else v18,
			isGrayedOut = config.isGrayedOut,
			isDisabled = config.isDisabled,
			isBuilderIcon = config.isBuilderIcon,
			buttonVariant = config.buttonVariant,
			onMount = v17
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
		v17
	})
end

return function(t2: {[any]: any}) -- line: 85
	-- upvalues: PersonButtonConfigs (copy), useDeviceOrientation (copy), RobloxAppEnums (copy), React (copy), PeopleService (copy), GetFFlagAddPeoplePageCardLayout (copy), MemoizedButton (copy), View (copy)
	local v20 = PersonButtonConfigs(t2.userId)
	local v21 = useDeviceOrientation() == RobloxAppEnums.DeviceOrientationMode.Portrait
	local v22 = React.useMemo(function() -- line: 90
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("FocusNavigationService")
	end, {})
	local v23 = React.useRef({})
	local v24 = React.useCallback(function(p2, s1: string) -- line: 96
		-- upvalues: v23 (copy)
		if p2 then
			v23.current[s1] = p2

			return
		end

		v23.current[s1] = nil
	end, {})
	local v25 = React.useMemo(function() -- line: 104
		-- upvalues: GetFFlagAddPeoplePageCardLayout (copy), v20 (copy)
		local t3 = {}

		if GetFFlagAddPeoplePageCardLayout() then
			for _, v38 in v20 do
				if v38.shouldShow() then
					table.insert(t3, v38.id)
				end
			end
		else
			for _, v in ipairs(v20) do
				if v.shouldShow() then
					table.insert(t3, v.id)
				end
			end
		end

		table.sort(t3)

		return table.concat(t3, ",")
	end, { v20 })

	React.useEffect(function() -- line: 123
		-- upvalues: GetFFlagAddPeoplePageCardLayout (copy), v20 (copy), v23 (copy), t2 (copy), v22 (copy)
		local t4 = {}

		if GetFFlagAddPeoplePageCardLayout() then
			for _, v43 in v20 do
				if v43.shouldShow() then
					local v44 = v23.current[v43.id]

					if v44 then
						table.insert(t4, v44)
					end
				end
			end
		else
			for _, v in ipairs(v20) do
				if v.shouldShow() then
					local v47 = v23.current[v.id]

					if v47 then
						table.insert(t4, v47)
					end
				end
			end
		end

		if #t4 > 0 then
			table.sort(t4, function(p3, p4) -- line: 148
				return p3.LayoutOrder < p4.LayoutOrder
			end)

			local v48 = t2.index or 0

			v22.registerButtonRow(t2.userId, t4, v48)
		end
	end, {
		t2.userId,
		t2.index,
		v22,
		v25
	})
	React.useEffect(function() -- line: 158
		-- upvalues: v22 (copy), t2 (copy)
		return function() -- line: 159
			-- upvalues: v22 (copy), t2 (copy)
			v22.handlePersonRemoved(t2.userId)
			v22.unregisterButtonRow(t2.userId)
		end
	end, {
		t2.userId,
		v22
	})

	local v26 = React.useMemo(function() -- line: 165
		-- upvalues: v22 (copy), t2 (copy)
		return v22.hasSelectablePlatformButton(t2.userId)
	end, {
		t2.userId,
		v22
	})
	local v27 = React.useMemo(function() -- line: 169
		-- upvalues: v26 (copy)
		if v26 then
			return Enum.SelectionBehavior.Escape
		end

		return Enum.SelectionBehavior.Stop
	end, { v26 })

	if not React.useMemo(function() -- line: 174
		-- upvalues: GetFFlagAddPeoplePageCardLayout (copy), v20 (copy)
		if GetFFlagAddPeoplePageCardLayout() then
			for _, v50 in v20 do
				if v50.shouldShow() then
					return true
				end
			end
		else
			for _, v in ipairs(v20) do
				if v.shouldShow() then
					return true
				end
			end
		end

		return false
	end, { v20 }) then
		return nil
	end

	local t5 = {}

	if GetFFlagAddPeoplePageCardLayout() then
		for _, v30 in v20 do
			if v30.shouldShow() then
				table.insert(t5, React.createElement(MemoizedButton, {
					key = v30.id,
					config = v30,
					buttonId = v30.id,
					onButtonMount = v24
				}))
			end
		end
	else
		for _, v in ipairs(v20) do
			if v.shouldShow() then
				table.insert(t5, React.createElement(MemoizedButton, {
					key = v.id,
					config = v,
					buttonId = v.id,
					onButtonMount = v24
				}))
			end
		end
	end

	return React.createElement(View, {
		LayoutOrder = 1,
		tag = {
			["auto-xy row"] = true,
			["gap-small"] = v21,
			["gap-medium"] = not v21
		},
		selectionGroup = {
			SelectionBehaviorLeft = v27,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		}
	}, t5)
end
