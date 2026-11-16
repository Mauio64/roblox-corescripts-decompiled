local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local PeopleService = require(parent.PeopleService)

local View = Foundation.View
local CoreButton = require(PeopleReactView.Components.Buttons.CoreButton)
local CoreButtonConfigs = require(PeopleReactView.Configs.CoreButtonConfigs)

local service = PeopleService.getService("Flags")
local getFFlagAddPeoplePageCardLayout = service.GetFFlagAddPeoplePageCardLayout
local fFlagEnablePeoplePageButtonOnMount = service.FFlagEnablePeoplePageButtonOnMount

local function MemoizedButton(p)
	local config = p.config

	local onMount = React.useCallback(function(p2)
		p.onButtonMount(p2, config.id)

		if fFlagEnablePeoplePageButtonOnMount and p2 and config.onMount then
			config.onMount()
		end
	end, { config.onMount, p.onButtonMount, config.id })

	return React.useMemo(function()
		return React.createElement(CoreButton, {
			text = config.text,
			icon = { on = config.onIcon, off = config.offIcon },
			animatedIcon = config.animatedIcon,
			buttonState = config.buttonState,
			isNewIcon = config.isNewIcon,
			LayoutOrder = config.layoutOrder,
			onActivated = config.onActivated,
			onMount = onMount
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
		onMount
	})
end

return function(props)
	local coreButtonConfigs = CoreButtonConfigs(props.chromeEnabled, props.buttonActivatedTable)

	local v = React.useMemo(function()
		return PeopleService.getService("FocusNavigationService")
	end, {})

	local ref = React.useRef(nil)
	local ref2 = React.useRef({})

	local onButtonMount = React.useCallback(function(p, p2: string)
		if p then
			ref2.current[p2] = p
		else
			ref2.current[p2] = nil
		end
	end, {})

	local ref3 = React.useCallback(function(current)
		ref.current = current

		if current then
			v.registerScrollCallback(-1, function()
				local hubRef = PeopleService.getService("SettingsHubService").hubRef()

				if hubRef and hubRef.ScrollToFrame and ref.current then
					hubRef:ScrollToFrame(ref.current, true)
				end
			end)
		end
	end, { v })

	local v2 = {
		v,
		(React.useMemo(function()
			local ids = {}

			for _, v2 in ipairs(coreButtonConfigs) do
				if v2.shouldShow() then
					table.insert(ids, v2.id)
				end
			end

			table.sort(ids)
			return table.concat(ids, ",")
		end, { coreButtonConfigs }))
	}
	React.useEffect(function()
		local v3 = {}

		for _, v4 in ipairs(coreButtonConfigs) do
			if not v4.shouldShow() then
				continue
			end

			local v5 = ref2.current[v4.id]

			if v5 then
				table.insert(v3, v5)
			end
		end

		if #v3 > 0 then
			table.sort(v3, function(a, b): boolean
				return a.LayoutOrder < b.LayoutOrder
			end)

			v.registerButtonRow(-1, v3, 0)
		end
	end, v2)

	React.useEffect(function()
		return function()
			v.unregisterScrollCallback(-1)
			v.unregisterButtonRow(-1)
		end
	end, { v })

	local v3 = React.useMemo(function()
		local children = {}

		for _, config in ipairs(coreButtonConfigs) do
			if config.shouldShow() then
				table.insert(
					children,
					React.createElement(MemoizedButton, {
						key = config.id,
						config = config,
						onButtonMount = onButtonMount
					})
				)
			end
		end

		return children
	end, { coreButtonConfigs, onButtonMount })

	if #v3 == 0 then
		return nil
	end

	local function getButtonElements()
		local buttonElements = {}

		for i, v4 in ipairs(v3) do
			buttonElements["Button" .. i] = v4
		end

		return buttonElements
	end

	local createElement = React.createElement
	local v4 = {
		tag = "size-full-0 auto-y row gap-large",
		LayoutOrder = not getFFlagAddPeoplePageCardLayout() and 1 or props.LayoutOrder,
		ref = ref3
	}
	local v5 = {}

	local v6 = { nil }

	for i, v7 in ipairs(v3) do
		v5["Button" .. i] = v7
	end

	v6[1] = v5

	return createElement(View, v4, v6)
end
