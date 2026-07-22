local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local Foundation = require(PeopleReactViewParent.Foundation)
local React = require(PeopleReactViewParent.React)
local PeopleService = require(PeopleReactViewParent.PeopleService)
local View = Foundation.View
local CoreButton = require(PeopleReactView.Components.Buttons.CoreButton)
local CoreButtonConfigs = require(PeopleReactView.Configs.CoreButtonConfigs)
local v9 = PeopleService.getService("Flags")
local GetFFlagAddPeoplePageCardLayout = v9.GetFFlagAddPeoplePageCardLayout
local FFlagEnablePeoplePageButtonOnMount = v9.FFlagEnablePeoplePageButtonOnMount

local function MemoizedButton(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), FFlagEnablePeoplePageButtonOnMount (copy), CoreButton (copy)
	local config = t1.config
	local v15 = React.useCallback(function(p1) -- line: 27
		-- upvalues: t1 (copy), config (copy), FFlagEnablePeoplePageButtonOnMount (copy)
		t1.onButtonMount(p1, config.id)

		if FFlagEnablePeoplePageButtonOnMount and (p1 and config.onMount) then
			config.onMount()
		end
	end, {
		config.onMount,
		t1.onButtonMount,
		config.id
	})

	return React.useMemo(function() -- line: 34
		-- upvalues: React (copy), CoreButton (copy), config (copy), v15 (copy)
		return React.createElement(CoreButton, {
			text = config.text,
			icon = {
				on = config.onIcon,
				off = config.offIcon
			},
			animatedIcon = config.animatedIcon,
			buttonState = config.buttonState,
			isNewIcon = config.isNewIcon,
			LayoutOrder = config.layoutOrder,
			onActivated = config.onActivated,
			onMount = v15
		})
	end, {
		config.text,
		config.onIcon,
		config.offIcon,
		config.animatedIcon,
		config.buttonState,
		config.isNewIcon,
		config.layoutOrder,
		config.onActivated,
		v15
	})
end

return function(t2: {[any]: any}) -- line: 62
	-- upvalues: CoreButtonConfigs (copy), React (copy), PeopleService (copy), MemoizedButton (copy), View (copy), GetFFlagAddPeoplePageCardLayout (copy)
	local v17 = CoreButtonConfigs(t2.chromeEnabled, t2.buttonActivatedTable)
	local v18 = React.useMemo(function() -- line: 67
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("FocusNavigationService")
	end, {})
	local v19 = React.useRef(nil)
	local v20 = React.useRef({})
	local v21 = React.useCallback(function(p2, s1: string) -- line: 77
		-- upvalues: v20 (copy)
		if p2 then
			v20.current[s1] = p2

			return
		end

		v20.current[s1] = nil
	end, {})
	local v22 = React.useCallback(function(p3) -- line: 85
		-- upvalues: v19 (copy), PeopleService (copy), v18 (copy)
		v19.current = p3

		if p3 then
			v18.registerScrollCallback(-1, function() -- line: 89
				-- upvalues: PeopleService (copy), v19 (copy)
				local v50 = PeopleService.getService("SettingsHubService").hubRef()

				if v50 and (v50.ScrollToFrame and v19.current) then
					v50:ScrollToFrame(v19.current, true)
				end
			end)
		end
	end, { v18 })
	local v23 = React.useMemo(function() -- line: 101
		-- upvalues: v17 (copy)
		local t3 = {}

		for _, v in ipairs(v17) do
			if v.shouldShow() then
				table.insert(t3, v.id)
			end
		end

		table.sort(t3)

		return table.concat(t3, ",")
	end, { v17 })

	React.useEffect(function() -- line: 112
		-- upvalues: v17 (copy), v20 (copy), v18 (copy)
		local t4 = {}

		for _, v in ipairs(v17) do
			if v.shouldShow() then
				local v43 = v20.current[v.id]

				if v43 then
					table.insert(t4, v43)
				end
			end
		end

		if #t4 > 0 then
			table.sort(t4, function(p4, p5) -- line: 126
				return p4.LayoutOrder < p5.LayoutOrder
			end)
			v18.registerButtonRow(-1, t4, 0)
		end
	end, {
		v18,
		v23
	})
	React.useEffect(function() -- line: 135
		-- upvalues: v18 (copy)
		return function() -- line: 136
			-- upvalues: v18 (copy)
			v18.unregisterScrollCallback(-1)
			v18.unregisterButtonRow(-1)
		end
	end, { v18 })

	local v24 = React.useMemo(function() -- line: 143
		-- upvalues: v17 (copy), React (copy), MemoizedButton (copy), v21 (copy)
		local t5 = {}

		for _, v in ipairs(v17) do
			if v.shouldShow() then
				table.insert(t5, React.createElement(MemoizedButton, {
					key = v.id,
					config = v,
					onButtonMount = v21
				}))
			end
		end

		return t5
	end, {
		v17,
		v21
	})

	if #v24 == 0 then
		return nil
	end

	local function getButtonElements() -- line: 169
		-- upvalues: v24 (copy)
		local t6 = {}

		for i, v in ipairs(v24) do
			t6["Button" .. i] = v
		end

		return t6
	end

	local createElement = React.createElement
	local v27 = View
	local t7 = {
		tag = "size-full-0 auto-y row gap-large",
		LayoutOrder = not GetFFlagAddPeoplePageCardLayout() and 1 or t2.LayoutOrder,
		ref = v22
	}
	local t8 = {}
	local t9 = {}

	for i, v in ipairs(v24) do
		t9["Button" .. i] = v
	end

	t8[1] = t9

	return createElement(v27, t7, t8)
end
