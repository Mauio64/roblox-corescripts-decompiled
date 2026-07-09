local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local RefreshScrollingFrame = require(Modules.LuaApp.Components.RefreshScrollingFrame)
local debounce = require(Modules.LuaApp.Util.debounce)
local useAXAnimateScrollFrame = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.AnimatedScrollingFrame.useAXAnimateScrollFrame
local FFlagAXScrollingFramesShouldAnimateOnFocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXScrollingFramesShouldAnimateOnFocus
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local v10 = GetFFlagAXEnableSlotBasedEditor() and game:DefineFastFlag("AXScrollingFramePreloadDistanceProp2", false)
local v11 = GetFFlagAXEnableSlotBasedEditor() and game:DefineFastFlag("AXScrollingFramePreventInitialLoadMore3", false)
local v12 = game:DefineFastInt("AXScrollingPreloadDistance", 2000)
local FFlagAXFixGamepadNavigationOnOutfitManagement = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXFixGamepadNavigationOnOutfitManagement

return React.forwardRef(function(t1: {[any]: any}, p1) -- line: 48
	-- upvalues: v11 (copy), React (copy), debounce (copy), v10 (copy), v12 (copy), FFlagAXScrollingFramesShouldAnimateOnFocus (copy), useAXAnimateScrollFrame (copy), Cryo (copy), FFlagAXFixGamepadNavigationOnOutfitManagement (copy), RefreshScrollingFrame (copy)
	local u16 = nil
	local u17 = nil

	if v11 then
		u16 = React.useRef(not t1.preventInitialLoadMore)
		u17 = React.useCallback(debounce(function() -- line: 58
			-- upvalues: u16 (ref)
			u16.current = true
		end, 0.5), {})
	end

	local function onScrollingFrameChanged(p2) -- line: 65
		-- upvalues: t1 (copy), v11 (copy), u16 (ref), v10 (copy), v12 (copy)
		local onThresholdReached = t1.onThresholdReached
		local v27 = nil

		if v11 then
			v27 = not t1.preventInitialLoadMore or u16.current
		end

		if onThresholdReached then
			if v11 and not v27 then
				return
			end

			if p2.CanvasPosition.Y > p2.CanvasSize.Y.Offset - p2.AbsoluteWindowSize.Y - if not v10 or not t1.preloadDistance then v12 else t1.preloadDistance then
				onThresholdReached()
			end
		end
	end
	local function onCanvasPositionChanged(p3) -- line: 95
		-- upvalues: onScrollingFrameChanged (copy), t1 (copy)
		onScrollingFrameChanged(p3)

		if t1.onCanvasPositionChanged then
			t1.onCanvasPositionChanged(p3)
		end
	end
	local function onCanvasSizeChanged(p4) -- line: 102
		-- upvalues: v11 (copy), u16 (ref), u17 (ref), onScrollingFrameChanged (copy), t1 (copy)
		if v11 and (not u16 or not u16.current) then
			u17()
		end

		onScrollingFrameChanged(p4)

		if t1.onCanvasSizeChanged then
			t1.onCanvasSizeChanged(p4)
		end
	end
	local function onAbsoluteWindowSizeChanged(p5) -- line: 112
		-- upvalues: onScrollingFrameChanged (copy), t1 (copy)
		onScrollingFrameChanged(p5)

		if t1.onAbsoluteWindowSizeChanged then
			t1.onAbsoluteWindowSizeChanged(p5)
		end
	end

	local v22 = p1

	if FFlagAXScrollingFramesShouldAnimateOnFocus then
		local v23 = React.useRef(nil)

		if not v22 then
			v22 = v23
		end

		useAXAnimateScrollFrame(v22)
	end

	local v24 = Cryo.Dictionary.join(t1, {
		onCanvasPositionChangedCallback = onCanvasPositionChanged,
		onCanvasSizeChangedCallback = onCanvasSizeChanged,
		onAbsoluteWindowSizeChangedCallback = onAbsoluteWindowSizeChanged,
		onThresholdReached = Cryo.None,
		showLoadingBar = Cryo.None,
		onCanvasPositionChanged = Cryo.None,
		onCanvasSizeChanged = Cryo.None,
		onAbsoluteWindowSizeChanged = Cryo.None,
		Selectable = if not FFlagAXFixGamepadNavigationOnOutfitManagement then nil else t1.Selectable,
		ref = if not FFlagAXScrollingFramesShouldAnimateOnFocus then p1 else v22
	})

	return React.createElement(RefreshScrollingFrame, v24)
end)
