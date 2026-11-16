local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/Responsive")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/React")
local StandardBreakpoints = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/CommonConfigs/StandardBreakpoints")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/Context/ContainerRef")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/FindFirstAncestorWithTag")
local useResponsiveImpl = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/Hooks/useResponsiveImpl")
local InputMode = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/InputMode")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/UIScaleOptions")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/HardwareSafeAreaInsets")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/Hooks/useDeviceInsets")
local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/Stores/GetInputModeStore")

local module12 = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/Hooks/useIsInFullScreen")
local module13 = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/Hooks/useIsSpatial")
local module14 = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/Hooks/useLastInput")
local module15 = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/Hooks/usePreferredInput")

local module16 = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/getVirtualResolutionScale")
local module17 = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/getIsCompactTouch")

function LUAUFORGE_MODULE_GLOBALS_xH_breakpointCompare(p2, p3): boolean
	local keyIndex = StandardBreakpoints.keyIndex

	if p2 == Responsive.DefaultKey or p3 == Responsive.DefaultKey or keyIndex[p2] == nil or keyIndex[p3] == nil then
		return false
	end

	return keyIndex[p2] >= keyIndex[p3]
end

function LUAUFORGE_MODULE_GLOBALS_xH_ResponsiveProvider(p2)
	local ref = React.useRef(nil)
	return React.createElement(module4.Provider, { value = ref }, p2.children)
end

return {
	UIScaleOptions = module8,
	HardwareSafeAreaInsets = module9,
	useDeviceInsets = module10,
	Keys = StandardBreakpoints.Enum,
	Input = InputMode.Enum,
	BreakpointConfig = StandardBreakpoints,
	DefaultKey = Responsive.DefaultKey,
	ContainerRef = module4,
	ResponsiveProvider = LUAUFORGE_MODULE_GLOBALS_xH_ResponsiveProvider,
	ResponsiveContainerFrame = function(p2)
		local v5 = React.useContext(module4)
		local createElement = React.createElement
		local v7 = {
			ZIndex = not (p2 and p2.ZIndex) and -100 or p2.ZIndex,
			Size = 0,
			BackgroundTransparency = 1,
			Visible = false,
			ref = 0
		}
		local v8 = if p2 and p2.Size then p2.Size else UDim2.new(1, 0, 1, 0)
		v7.Size = v8

		v7.ref = v5
		return createElement("Frame", v7)
	end,
	FindFirstAncestorWithTag = module5,
	useBreakpointX = useResponsiveImpl,
	useBreakpointXOrLarger = function(p2)
		return useResponsiveImpl(function(p3)
			return LUAUFORGE_MODULE_GLOBALS_xH_breakpointCompare(p3, p2)
		end, nil)
	end,
	useBreakpointXOrSmaller = function(p2)
		return useResponsiveImpl(function(p3)
			return LUAUFORGE_MODULE_GLOBALS_xH_breakpointCompare(p2, p3)
		end, nil)
	end,
	useBreakpointY = function()
		return useResponsiveImpl(nil, nil, "Y")
	end,
	useBreakpointYOrLarger = function(p2)
		return useResponsiveImpl(function(p3)
			return LUAUFORGE_MODULE_GLOBALS_xH_breakpointCompare(p3, p2)
		end, nil, "Y")
	end,
	useBreakpointYOrSmaller = function(p2)
		return useResponsiveImpl(function(p3)
			return LUAUFORGE_MODULE_GLOBALS_xH_breakpointCompare(p2, p3)
		end, nil, "Y")
	end,
	useOrientation = function()
		return useResponsiveImpl(nil, nil, "Orientation")
	end,
	useResponsive = function(p2)
		return useResponsiveImpl(nil, p2)
	end,
	usePreferredInput = module15,
	useLastInput = module14,
	useIsInFullScreen = module12,
	useIsSpatial = module13,
	bindContainer = Responsive.bindContainer,
	getVirtualResolutionScale = module16,
	GetInputModeStore = module11,
	getIsCompactTouch = module17
}
