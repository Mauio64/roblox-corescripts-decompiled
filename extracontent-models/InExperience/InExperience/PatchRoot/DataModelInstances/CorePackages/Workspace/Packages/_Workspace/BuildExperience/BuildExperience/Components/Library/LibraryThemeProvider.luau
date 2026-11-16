local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelectedTheme = RoactUtils.Hooks.useSelectedTheme

local UserGameSettings = UserSettings():GetService("UserGameSettings")

local function useReducedMotion()
	local state, setState = React.useState(UserGameSettings.ReducedMotion)
	React.useEffect(function()
		setState(UserGameSettings.ReducedMotion)
		local reducedMotionChangedConnection = UserGameSettings:GetPropertyChangedSignal("ReducedMotion"):Connect(function()
			setState(UserGameSettings.ReducedMotion)
		end)
		return function()
			reducedMotionChangedConnection:Disconnect()
		end
	end, {})
	return state
end

local function LibraryThemeProvider(p)
	local v = useSelectedTheme()
	local reducedMotion = useReducedMotion()
	local createElement = React.createElement
	local foundationProvider = Foundation.FoundationProvider
	local colorMode

	if v == "light" then
		colorMode = Foundation.Enums.ColorMode.Light
	else
		colorMode = Foundation.Enums.ColorMode.Dark
	end

	return createElement(foundationProvider, {
		colorMode = colorMode,
		overlayGui = { DisplayOrder = p.displayOrder },
		preferences = { reducedMotion = reducedMotion }
	}, p.children)
end

return LibraryThemeProvider
