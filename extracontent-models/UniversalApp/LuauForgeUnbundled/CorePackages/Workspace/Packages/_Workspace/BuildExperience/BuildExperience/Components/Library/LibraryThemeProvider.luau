local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useSelectedTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/RoactUtils").Hooks.useSelectedTheme

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

local function LibraryThemeProvider(p2)
	local v5 = useSelectedTheme()
	local v6 = useReducedMotion()
	local createElement = React.createElement
	local foundationProvider = Foundation.FoundationProvider
	local v8 = if v5 == "light" then Foundation.Enums.ColorMode.Light else Foundation.Enums.ColorMode.Dark
	return createElement(foundationProvider, {
		colorMode = v8,
		overlayGui = { DisplayOrder = p2.displayOrder },
		preferences = { reducedMotion = v6 }
	}, p2.children)
end

return LibraryThemeProvider
