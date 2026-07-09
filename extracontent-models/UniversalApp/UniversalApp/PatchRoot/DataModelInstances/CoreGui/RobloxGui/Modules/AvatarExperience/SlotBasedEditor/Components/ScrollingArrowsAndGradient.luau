local CorePackages = game:GetService("CorePackages")
local Otter = require(CorePackages.Packages.Otter)
local ReactOtter = require(CorePackages.Packages.ReactOtter)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local React = require(CorePackages.Packages.React)
local useEffect = React.useEffect
local useCallback = React.useCallback
local useRef = React.useRef
local useMotor = ReactOtter.useMotor
local ScrollingListWithArrowsAndGradient = require(Modules.AvatarExperience.Common.Components.ScrollingListWithArrowsAndGradient)

require(CorePackages.Workspace.Packages.AppCommonLib)

local FFlagAXSlotsFixLeftScroll = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXSlotsFixLeftScroll
local t1 = {
	frequency = 2,
	dampingRatio = 0.9,
	restingPositionLimit = 0.5,
	restingVelocityLimit = 0.1
}

local function getScrollToLocation(n1: number?, p1, p2) -- line: 48
	-- upvalues: FFlagAXSlotsFixLeftScroll (copy)
	if typeof(p1) == "table" and (p1.current ~= nil and p2 ~= nil) then
		local AbsolutePositionX = p1.current.AbsolutePosition.X
		local AbsoluteWindowSizeX = p1.current.AbsoluteWindowSize.X
		local CanvasPositionX = p1.current.CanvasPosition.X
		local AbsolutePositionX2 = p2.AbsolutePosition.X
		local v22 = p2.AbsoluteSize.X + (n1 or 0)
		local v23 = math.floor(AbsoluteWindowSizeX / 2) - math.floor(v22 / 2)
		local v24 = if not FFlagAXSlotsFixLeftScroll then AbsolutePositionX2 < AbsolutePositionX and v22 < AbsolutePositionX - math.abs(AbsolutePositionX2) else AbsolutePositionX2 < AbsolutePositionX
		local v25 = v22 > AbsoluteWindowSizeX - (AbsolutePositionX2 - AbsolutePositionX)

		if v24 then
			return (math.max(CanvasPositionX - (AbsolutePositionX - AbsolutePositionX2) - v23, 0))
		end

		if v25 then
			return CanvasPositionX + (v22 - (AbsoluteWindowSizeX - (AbsolutePositionX2 - AbsolutePositionX))) + v23
		end
	end

	return nil
end

return React.memo(function(t2: {[any]: any}) -- line: 99
	-- upvalues: RoactGamepad (copy), useRef (copy), React (copy), useMotor (copy), useCallback (copy), getScrollToLocation (copy), Otter (copy), t1 (copy), useEffect (copy), ScrollingListWithArrowsAndGradient (copy)
	local v27 = RoactGamepad.useRefCache()
	local v28 = useRef(nil)
	local v29, v30 = React.useState(nil)
	local v31 = React.useCallback(function(n2: number) -- line: 107
		-- upvalues: v28 (copy)
		if v28.current then
			v28.current.CanvasPosition = Vector2.new(n2, 0)
		end
	end, {})
	local v32 = useMotor(not v28.current and 0 or v28.current.CanvasPosition.X, v31)
	local v33 = useCallback(function(b1: boolean?) -- line: 123
		-- upvalues: t2 (copy), v27 (copy), v30 (copy), getScrollToLocation (copy), v28 (copy), v32 (copy), Otter (copy), t1 (copy)
		if t2.selectedItemKey then
			local v41 = v27[t2.selectedItemKey]

			if v41 then
				v30(v41.current)

				if t2.enableSnapToSelectedItem or b1 then
					local v42 = getScrollToLocation(t2.buttonPadding, v28, v41.current)

					if v42 then
						v32(Otter.spring(v42, t1))
					end
				end
			end
		end
	end, {
		t2.selectedItemKey,
		t2.enableSnapToSelectedItem,
		t2.buttonPadding
	})

	useEffect(function() -- line: 139
		-- upvalues: v33 (copy)
		v33()
	end, {
		v33,
		t2.selectedItemKey,
		t2.enableSnapToSelectedItem,
		t2.buttonPadding
	})

	local resetPositionSignal = t2.resetPositionSignal
	local v35 = useCallback(function() -- line: 146
		-- upvalues: v33 (copy)
		v33(true)
	end, {
		v33,
		t2.buttonPadding,
		t2.selectedItemKey
	})

	useEffect(function() -- line: 150
		-- upvalues: resetPositionSignal (copy), v35 (copy)
		local u43 = nil

		if resetPositionSignal then
			u43 = resetPositionSignal:connect(v35)
		end

		return function() -- line: 155
			-- upvalues: u43 (ref)
			if u43 then
				u43:disconnect()
			end
		end
	end, {
		nil,
		resetPositionSignal,
		t2.selectedItemKey
	})

	local v36 = useCallback(function(p3) -- line: 162
		-- upvalues: v27 (copy)
		return v27[p3]
	end, {})
	local v37 = useCallback(function(p4) -- line: 166
		-- upvalues: v28 (copy)
		if v28.current then
			v28.current.CanvasSize = UDim2.new(0, p4.AbsoluteSize.X, 1, 0)
		end
	end, {})
	local v38 = useCallback(function() -- line: 172
		-- upvalues: v28 (copy)
		return v28
	end, {})

	return React.createElement("Frame", {
		ClipsDescendants = true,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = t2.LayoutOrder,
		AutomaticSize = if not t2.AutomaticSize then nil else t2.AutomaticSize,
		Size = if not t2.navHeight then UDim2.new(1, 0, 1, 0) else UDim2.new(1, 0, 0, t2.navHeight),
		ZIndex = t2.ZIndex
	}, {
		ScrollingList = React.createElement(ScrollingListWithArrowsAndGradient, {
			getScollingListContent = useCallback(function() -- line: 187
				-- upvalues: t2 (copy), v36 (copy), v38 (copy), v37 (copy), v29 (copy)
				return t2.renderScrollingListContent({
					getScrollingFrameItemRef = v36,
					getScrollingFrameRef = v38,
					onNavFrameSizeChanged = v37,
					selectedItemInstance = v29
				})
			end, {
				t2.renderScrollingListContent,
				v36,
				v38,
				v37,
				v29
			}),
			scrollingFrameRef = v28,
			buttonRefs = v27,
			buttonPadding = t2.buttonPadding or 0,
			childWidgetIndex = if not t2.enableIntroScroll then nil else tostring(t2.index),
			useIntroScroll = t2.enableIntroScroll or false
		})
	})
end)
