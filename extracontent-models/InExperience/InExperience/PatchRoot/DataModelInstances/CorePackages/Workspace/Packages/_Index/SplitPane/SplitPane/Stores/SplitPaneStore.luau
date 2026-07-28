local Parent = script:FindFirstAncestor("SplitPane").Parent
local Signals = require(Parent.Signals)
local Foundation = require(Parent.Foundation)
local AppComposition = require(Parent.AppComposition)
local AppSplitView = require(Parent.AppSplitView)
local Display = require(Parent.Display)
local Breakpoint = Foundation.Enums.Breakpoint
local getRegionOverrides = AppComposition.getRegionOverrides
local RegionName = AppComposition.RegionName
local resolveBreakpoint = AppComposition.resolveBreakpoint
local SupportPaneMode = AppSplitView.Enums.SupportPaneMode
local XLarge = Breakpoint.XLarge
local t1 = {
	[Breakpoint.XSmall] = 1,
	[Breakpoint.Small] = 2,
	[Breakpoint.Medium] = 3,
	[Breakpoint.Large] = 4,
	[Breakpoint.XLarge] = 5,
	[Breakpoint.XXLarge] = 6
}

local function isBreakpointAtLeast(p1, p2) -- line: 32
	-- upvalues: t1 (copy)
	return (t1[p1] or 0) >= (t1[p2] or 0)
end
local function getSupportRegionMinMax() -- line: 36
	-- upvalues: getRegionOverrides (copy), RegionName (copy)
	local v21 = if not getRegionOverrides or not RegionName then nil else getRegionOverrides(RegionName.SupportRegion)
	local v22 = (not v21 or not v21.minWidth) and 0 or v21.minWidth

	if v21 and v21.maxWidth then
		return v22, v21.maxWidth
	end

	return v22, 1e999
end
local function evaluateBreakpointEnabled(p3) -- line: 43
	-- upvalues: Display (copy), resolveBreakpoint (copy), XLarge (copy), t1 (copy)
	local v24 = Display.GetDisplayStore(p3).getDesignSpaceViewportWidth(p3)
	local v25 = resolveBreakpoint(v24)
	local v26 = XLarge

	return (t1[v25] or 0) >= (t1[v26] or 0)
end
local function createSplitPaneStore() -- line: 65
	-- upvalues: getRegionOverrides (copy), RegionName (copy), Signals (copy), SupportPaneMode (copy), Display (copy), resolveBreakpoint (copy), XLarge (copy), t1 (copy), evaluateBreakpointEnabled (copy)
	local v27 = if not getRegionOverrides or not RegionName then nil else getRegionOverrides(RegionName.SupportRegion)
	local v28 = (not v27 or not v27.minWidth) and 0 or v27.minWidth
	local v29 = (not v27 or not v27.maxWidth) and 1e999 or v27.maxWidth
	local v30, v31 = Signals.createSignal(nil)
	local v32, v33 = Signals.createSignal(SupportPaneMode.Normal)
	local v34, v35 = Signals.createSignal(false)

	local function evaluateSplitEnabled(p4) -- line: 75
		-- upvalues: Display (copy), resolveBreakpoint (copy), XLarge (copy), t1 (copy), v34 (copy)
		local v43 = Display.GetDisplayStore(p4).getDesignSpaceViewportWidth(p4)
		local v44 = resolveBreakpoint(v43)
		local v45 = XLarge

		return (t1[v44] or 0) >= (t1[v45] or 0) and v34(p4)
	end

	return {
		getSupportWidth = v30,
		setSupportWidth = function(n1: number) -- line: 71
			-- upvalues: v31 (copy), v28 (copy), v29 (copy)
			v31((math.clamp(n1, v28, v29)))
		end,
		getMinSupportWidth = function() -- line: 82
			-- upvalues: v28 (copy)
			return v28
		end,
		getMaxSupportWidth = function() -- line: 85
			-- upvalues: v29 (copy)
			return v29
		end,
		getIsBreakpointEnabled = Signals.createComputed(evaluateBreakpointEnabled),
		getIsSplitEnabled = Signals.createComputed(evaluateSplitEnabled),
		getIsSplitEligible = v34,
		setIsSplitEligible = v35,
		getSupportPaneMode = v32,
		setSupportPaneMode = v33,
		toggleSupportPaneMode = function(p5) -- line: 96
			-- upvalues: v33 (copy), v32 (copy), SupportPaneMode (copy)
			v33(if p5 ~= v32(false) then p5 else SupportPaneMode.Normal)
		end
	}
end

local u18 = nil

return {
	getStore = function() -- line: 103
		-- upvalues: u18 (ref), createSplitPaneStore (copy)
		if u18 == nil then
			u18 = createSplitPaneStore()
		end

		return u18
	end,
	isSplitEnabledNow = function() -- line: 112
		-- upvalues: Display (copy), resolveBreakpoint (copy), XLarge (copy), t1 (copy), u18 (ref), createSplitPaneStore (copy)
		local v37 = Display.GetDisplayStore(false).getDesignSpaceViewportWidth(false)
		local v38 = resolveBreakpoint(v37)
		local v39 = XLarge
		local v40 = (t1[v38] or 0) >= (t1[v39] or 0)

		if v40 then
			if u18 == nil then
				u18 = createSplitPaneStore()
			end

			v40 = u18.getIsSplitEligible(false)
		end

		return v40
	end
}
