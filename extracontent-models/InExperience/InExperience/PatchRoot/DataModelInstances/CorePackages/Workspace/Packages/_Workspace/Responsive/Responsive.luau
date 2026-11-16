local Responsive = require(script.Responsive)
local React = require(script.Parent.React)
local StandardBreakpoints = require(script.CommonConfigs.StandardBreakpoints)
local ContainerRef = require(script.Context.ContainerRef)
local FindFirstAncestorWithTag = require(script.FindFirstAncestorWithTag)
local useResponsiveImpl = require(script.Hooks.useResponsiveImpl)
local InputMode = require(script.InputMode)
local UIScaleOptions = require(script.UIScaleOptions)
local HardwareSafeAreaInsets = require(script.HardwareSafeAreaInsets)
local useDeviceInsets = require(script.Hooks.useDeviceInsets)
local GetInputModeStore = require(script.Stores.GetInputModeStore)

local useIsInFullScreen = require(script.Hooks.useIsInFullScreen)
local useIsSpatial = require(script.Hooks.useIsSpatial)
local useLastInput = require(script.Hooks.useLastInput)
local usePreferredInput = require(script.Hooks.usePreferredInput)

local getVirtualResolutionScale = require(script.getVirtualResolutionScale)
local getIsCompactTouch = require(script.getIsCompactTouch)

function breakpointCompare(p, p2): boolean
	local keyIndex = StandardBreakpoints.keyIndex

	if p == Responsive.DefaultKey or p2 == Responsive.DefaultKey or keyIndex[p] == nil or keyIndex[p2] == nil then
		return false
	end

	return keyIndex[p] >= keyIndex[p2]
end

function ResponsiveProvider(p)
	local ref = React.useRef(nil)
	return React.createElement(ContainerRef.Provider, { value = ref }, p.children)
end

return {
	UIScaleOptions = UIScaleOptions,
	HardwareSafeAreaInsets = HardwareSafeAreaInsets,
	useDeviceInsets = useDeviceInsets,
	Keys = StandardBreakpoints.Enum,
	Input = InputMode.Enum,
	BreakpointConfig = StandardBreakpoints,
	DefaultKey = Responsive.DefaultKey,
	ContainerRef = ContainerRef,
	ResponsiveProvider = ResponsiveProvider,
	ResponsiveContainerFrame = function(p)
		local ref = React.useContext(ContainerRef)
		local createElement = React.createElement
		local v = {
			ZIndex = not (p and p.ZIndex) and -100 or p.ZIndex,
			Size = 0,
			BackgroundTransparency = 1,
			Visible = false,
			ref = 0
		}
		local size

		if p and p.Size then
			size = p.Size
		else
			size = UDim2.new(1, 0, 1, 0)
		end

		v.Size = size

		v.ref = ref
		return createElement("Frame", v)
	end,
	FindFirstAncestorWithTag = FindFirstAncestorWithTag,
	useBreakpointX = useResponsiveImpl,
	useBreakpointXOrLarger = function(p)
		return useResponsiveImpl(function(p2)
			return breakpointCompare(p2, p)
		end, nil)
	end,
	useBreakpointXOrSmaller = function(p)
		return useResponsiveImpl(function(p2)
			return breakpointCompare(p, p2)
		end, nil)
	end,
	useBreakpointY = function()
		return useResponsiveImpl(nil, nil, "Y")
	end,
	useBreakpointYOrLarger = function(p)
		return useResponsiveImpl(function(p2)
			return breakpointCompare(p2, p)
		end, nil, "Y")
	end,
	useBreakpointYOrSmaller = function(p)
		return useResponsiveImpl(function(p2)
			return breakpointCompare(p, p2)
		end, nil, "Y")
	end,
	useOrientation = function()
		return useResponsiveImpl(nil, nil, "Orientation")
	end,
	useResponsive = function(p)
		return useResponsiveImpl(nil, p)
	end,
	usePreferredInput = usePreferredInput,
	useLastInput = useLastInput,
	useIsInFullScreen = useIsInFullScreen,
	useIsSpatial = useIsSpatial,
	bindContainer = Responsive.bindContainer,
	["jest.config"] = script["jest.config"],
	getVirtualResolutionScale = getVirtualResolutionScale,
	GetInputModeStore = GetInputModeStore,
	getIsCompactTouch = getIsCompactTouch
}
