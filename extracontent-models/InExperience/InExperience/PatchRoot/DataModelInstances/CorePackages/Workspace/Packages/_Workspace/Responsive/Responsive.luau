local Responsive = require(script.Responsive)
local React = require(script.Parent.React)
local StandardBreakpoints = require(script.CommonConfigs.StandardBreakpoints)
local ContainerRef = require(script.Context.ContainerRef)
local FindFirstAncestorWithTag = require(script.FindFirstAncestorWithTag)
local useResponsiveImpl = require(script.Hooks.useResponsiveImpl)
local InputMode = require(script.InputMode)
local HardwareSafeAreaInsets = require(script.HardwareSafeAreaInsets)
local useDeviceInsets = require(script.Hooks.useDeviceInsets)
local GetInputModeStore = require(script.Stores.GetInputModeStore)
local useIsInFullScreen = require(script.Hooks.useIsInFullScreen)
local useIsSpatial = require(script.Hooks.useIsSpatial)
local useLastInput = require(script.Hooks.useLastInput)
local usePreferredInput = require(script.Hooks.usePreferredInput)
local getVirtualResolutionScale = require(script.getVirtualResolutionScale)
local getIsCompactTouch = require(script.getIsCompactTouch)

function breakpointCompare(p1, p2) -- line: 24
	-- upvalues: StandardBreakpoints (copy), Responsive (copy)
	local keyIndex = StandardBreakpoints.keyIndex

	if p1 == Responsive.DefaultKey or (p2 == Responsive.DefaultKey or keyIndex[p1] == nil or keyIndex[p2] == nil) then
		return false
	end

	return keyIndex[p1] >= keyIndex[p2]
end
function ResponsiveProvider(p3) -- line: 32
	-- upvalues: React (copy), ContainerRef (copy)
	local v21 = React.useRef(nil)

	return React.createElement(ContainerRef.Provider, {
		value = v21
	}, p3.children)
end

return {
	HardwareSafeAreaInsets = HardwareSafeAreaInsets,
	useDeviceInsets = useDeviceInsets,
	Keys = StandardBreakpoints.Enum,
	Input = InputMode.Enum,
	BreakpointConfig = StandardBreakpoints,
	DefaultKey = Responsive.DefaultKey,
	ContainerRef = ContainerRef,
	ResponsiveProvider = ResponsiveProvider,
	ResponsiveContainerFrame = function(p4) -- line: 39
		-- upvalues: React (copy), ContainerRef (copy)
		local v23 = React.useContext(ContainerRef)

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Visible = false,
			ZIndex = (not p4 or not p4.ZIndex) and -100 or p4.ZIndex,
			Size = if not p4 or not p4.Size then UDim2.new(1, 0, 1, 0) else p4.Size,
			ref = v23
		})
	end,
	FindFirstAncestorWithTag = FindFirstAncestorWithTag,
	useBreakpointX = useResponsiveImpl,
	useBreakpointXOrLarger = function(p5) -- line: 62
		-- upvalues: useResponsiveImpl (copy)
		return useResponsiveImpl(function(p6) -- line: 63
			-- upvalues: p5 (copy)
			return breakpointCompare(p6, p5)
		end, nil)
	end,
	useBreakpointXOrSmaller = function(p7) -- line: 67
		-- upvalues: useResponsiveImpl (copy)
		return useResponsiveImpl(function(p8) -- line: 68
			-- upvalues: p7 (copy)
			return breakpointCompare(p7, p8)
		end, nil)
	end,
	useBreakpointY = function() -- line: 72
		-- upvalues: useResponsiveImpl (copy)
		return useResponsiveImpl(nil, nil, "Y")
	end,
	useBreakpointYOrLarger = function(p9) -- line: 75
		-- upvalues: useResponsiveImpl (copy)
		return useResponsiveImpl(function(p10) -- line: 76
			-- upvalues: p9 (copy)
			return breakpointCompare(p10, p9)
		end, nil, "Y")
	end,
	useBreakpointYOrSmaller = function(p11) -- line: 80
		-- upvalues: useResponsiveImpl (copy)
		return useResponsiveImpl(function(p12) -- line: 81
			-- upvalues: p11 (copy)
			return breakpointCompare(p11, p12)
		end, nil, "Y")
	end,
	useOrientation = function() -- line: 85
		-- upvalues: useResponsiveImpl (copy)
		return useResponsiveImpl(nil, nil, "Orientation")
	end,
	useResponsive = function(p13) -- line: 88
		-- upvalues: useResponsiveImpl (copy)
		return useResponsiveImpl(nil, p13)
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
