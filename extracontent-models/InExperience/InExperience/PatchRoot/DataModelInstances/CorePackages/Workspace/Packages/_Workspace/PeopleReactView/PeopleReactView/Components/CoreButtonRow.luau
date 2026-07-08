local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local Foundation = require(PeopleReactViewParent.Foundation)
local React = require(PeopleReactViewParent.React)
local PeopleService = require(PeopleReactViewParent.PeopleService)
local View = Foundation.View
local CoreButton = require(PeopleReactView.Components.Buttons.CoreButton)
local CoreButtonConfigs = require(PeopleReactView.Configs.CoreButtonConfigs)
local GetFFlagAddPeoplePageCardLayout = PeopleService.getService("Flags").GetFFlagAddPeoplePageCardLayout

local function MemoizedButton(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), CoreButton (copy)
	local config = t1.config
	local v13 = React.useCallback(function(p1) -- line: 25
		-- upvalues: t1 (copy), config (copy)
		t1.onButtonMount(p1, config.id)
	end, {
		t1.onButtonMount,
		config.id
	})

	return React.useMemo(function() -- line: 29
		-- upvalues: React (copy), CoreButton (copy), config (copy), v13 (copy)
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
			onMount = v13
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
		v13
	})
end

return function(t2: {[any]: any}) -- line: 57
	-- upvalues: CoreButtonConfigs (copy), React (copy), PeopleService (copy), MemoizedButton (copy), View (copy), GetFFlagAddPeoplePageCardLayout (copy)
	local v15 = CoreButtonConfigs(t2.chromeEnabled, t2.buttonActivatedTable)
	local v16 = React.useMemo(function() -- line: 62
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("FocusNavigationService")
	end, {})
	local v17 = React.useRef(nil)
	local v18 = React.useRef({})
	local v19 = React.useCallback(function(p2, s1: string) -- line: 72
		-- upvalues: v18 (copy)
		if p2 then
			v18.current[s1] = p2

			return
		end

		v18.current[s1] = nil
	end, {})
	local v20 = React.useCallback(function(p3) -- line: 80
		-- upvalues: v17 (copy), PeopleService (copy), v16 (copy)
		v17.current = p3

		if p3 then
			v16.registerScrollCallback(-1, function() -- line: 84
				-- upvalues: PeopleService (copy), v17 (copy)
				local v48 = PeopleService.getService("SettingsHubService").hubRef()

				if v48 and (v48.ScrollToFrame and v17.current) then
					v48:ScrollToFrame(v17.current, true)
				end
			end)
		end
	end, { v16 })
	local v21 = React.useMemo(function() -- line: 96
		-- upvalues: v15 (copy)
		local t3 = {}

		for _, v in ipairs(v15) do
			if v.shouldShow() then
				table.insert(t3, v.id)
			end
		end

		table.sort(t3)

		return table.concat(t3, ",")
	end, { v15 })

	React.useEffect(function() -- line: 107
		-- upvalues: v15 (copy), v18 (copy), v16 (copy)
		local t4 = {}

		for _, v in ipairs(v15) do
			if v.shouldShow() then
				local v41 = v18.current[v.id]

				if v41 then
					table.insert(t4, v41)
				end
			end
		end

		if #t4 > 0 then
			table.sort(t4, function(p4, p5) -- line: 121
				return p4.LayoutOrder < p5.LayoutOrder
			end)
			v16.registerButtonRow(-1, t4, 0)
		end
	end, {
		v16,
		v21
	})
	React.useEffect(function() -- line: 130
		-- upvalues: v16 (copy)
		return function() -- line: 131
			-- upvalues: v16 (copy)
			v16.unregisterScrollCallback(-1)
			v16.unregisterButtonRow(-1)
		end
	end, { v16 })

	local v22 = React.useMemo(function() -- line: 138
		-- upvalues: v15 (copy), React (copy), MemoizedButton (copy), v19 (copy)
		local t5 = {}

		for _, v in ipairs(v15) do
			if v.shouldShow() then
				table.insert(t5, React.createElement(MemoizedButton, {
					key = v.id,
					config = v,
					onButtonMount = v19
				}))
			end
		end

		return t5
	end, {
		v15,
		v19
	})

	if #v22 == 0 then
		return nil
	end

	local function getButtonElements() -- line: 164
		-- upvalues: v22 (copy)
		local t6 = {}

		for i, v in ipairs(v22) do
			t6["Button" .. i] = v
		end

		return t6
	end

	local createElement = React.createElement
	local v25 = View
	local t7 = {
		tag = "size-full-0 auto-y row gap-large",
		LayoutOrder = not GetFFlagAddPeoplePageCardLayout() and 1 or t2.LayoutOrder,
		ref = v20
	}
	local t8 = {}
	local t9 = {}

	for i, v in ipairs(v22) do
		t9["Button" .. i] = v
	end

	t8[1] = t9

	return createElement(v25, t7, t8)
end
