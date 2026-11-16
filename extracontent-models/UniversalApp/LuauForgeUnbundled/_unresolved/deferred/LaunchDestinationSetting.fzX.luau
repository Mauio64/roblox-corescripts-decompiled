local CorePackages = game:GetService("CorePackages")

local Workspace = game:GetService("Workspace")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useLocalUserId
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local dropdownMenu = UIBlox.App.Menu.DropdownMenu
local module = require("@luauforge/deferred/fyH")
local module2 = require("@luauforge/deferred/fzY")
local module3 = require("@luauforge/deferred/fzZ")
local launchDestinationEnum = module2.LaunchDestinationEnum

local function findRecentGameByPlaceId(items, p2)
	if not p2 then
		return nil
	end

	for k, item in items do
		if item.placeId == p2 then
			return item
		end
	end

	return nil
end

local function LaunchDestinationSetting(props)
	local v5 = useStyle()
	local v6 = useTokens()
	local v7 = useLocalUserId()
	local udim = UDim.new(0, v6.Size.Size_1200)
	local screenSize = props.screenSize
		or Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize
		or Vector2.new(0, 0)
	local v8 = useLocalization({
		launchDestinationHeading = "Feature.Accessibility.Heading.LaunchDestination",
		launchDestinationDescription = "Feature.Accessibility.Description.LaunchDestination",
		launchDestinationHome = "Feature.Accessibility.LaunchDestination.Home",
		launchDestinationMostRecentGame = "Feature.Accessibility.LaunchDestination.MostRecentGame"
	})

	local state, setState = React.useState(function()
		return module2.getCachedLaunchDestination(v7)
	end)

	local state2, setState2 = React.useState({})
	local ref = React.useRef(false)
	local ref2 = React.useRef(true)

	React.useEffect(function()
		setState(module2.getCachedLaunchDestination(v7))
	end, { v7 })

	React.useEffect(function()
		return function()
			ref2.current = false
		end
	end, {})

	local v9 = React.useCallback(function()
		if ref.current then
			return
		end

		ref.current = true
		module3.fetch():andThen(function(p2)
			if ref2.current then
				setState2(p2)
			end
		end):catch(function(p2)
			warn("[LaunchDestinationSetting] Failed to fetch recent games: " .. tostring(p2))
		end)
	end, {})

	local v10 = React.useCallback(function(p2)
		if p2 then
			v9()
		end

		props.onMenuOpenChange(p2)
	end, { v9, props.onMenuOpenChange })
	local v11

	if state.destination == launchDestinationEnum.SpecificGame then
		v11 = state.placeId
	else
		v11 = state.destination
	end

	local v12

	if state.destination == launchDestinationEnum.Home then
		v12 = v8.launchDestinationHome
	elseif state.destination == launchDestinationEnum.MostRecentGame then
		v12 = v8.launchDestinationMostRecentGame
	else
		v12 = (state.destination ~= launchDestinationEnum.SpecificGame or not state.name) and ""
			or state.name
	end

	local v13 = React.useCallback(function(p2)
		local v14 = state2
		local v15

		if p2 then
			for k, v17 in v14 do
				if v17.placeId == p2 then
					v15 = v17
					break
				end
			end
		end

		if v15 then
			setState({
				destination = launchDestinationEnum.SpecificGame,
				placeId = p2,
				name = v15.name
			})
			module2.setCachedSpecificGame(v7, p2, v15.name)
		else
			local launchDestinationFromName = module2.getLaunchDestinationFromName(p2)

			if
				not launchDestinationFromName
				or launchDestinationFromName == launchDestinationEnum.SpecificGame
			then
				return
			end

			setState({ destination = launchDestinationFromName })
			module2.setCachedLaunchDestination(v7, launchDestinationFromName)
		end
	end, { v7, state2 })

	local v14 = {
		{ key = launchDestinationEnum.Home, text = v8.launchDestinationHome },
		{
			key = launchDestinationEnum.MostRecentGame,
			text = v8.launchDestinationMostRecentGame
		}
	}

	local v15 = {}

	if state.destination == launchDestinationEnum.SpecificGame and state.placeId and state.name then
		local placeId = state.placeId
		local v16

		if placeId then
			for k, v18 in state2 do
				if v18.placeId == placeId then
					v16 = v18
					break
				end
			end
		end

		if not v16 then
			table.insert(v15, { key = state.placeId, text = state.name })
		end
	end

	for k, v16 in state2 do
		if #v15 >= module3.MAX_RECENT_GAMES then
			break
		end

		table.insert(v15, { key = v16.placeId, text = v16.name })
	end

	for k, v16 in v15 do
		table.insert(v14, v16)
	end

	local createElement = React.createElement
	local v17 = {
		style = v5,
		header = v8.launchDestinationHeading,
		description = v8.launchDestinationDescription,
		layoutOrder = props.layoutOrder,
		zIndex = props.zIndex,
		topToBottom = not props.isWideView,
		Control = 0
	}
	local createElement2 = React.createElement
	local v20 = if props.isWideView then UDim2.new(0, props.contextualSliderWidth, 0, udim.Offset) else UDim2.new(1, 0, 0, udim.Offset)
	v17.Control = createElement2("Frame", {
		Size = v20,
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}, {
		React.createElement(dropdownMenu, {
			placeholder = v12,
			onChange = v13,
			height = udim,
			screenSize = screenSize,
			errorState = false,
			showDropShadow = false,
			dropdownMenuListPositionFixed = true,
			onMenuOpenChange = v10,
			defaultKey = v11,
			cellDatas = v14
		})
	})
	return createElement(module, v17)
end

return LaunchDestinationSetting
