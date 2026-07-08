local AppComposition = script:FindFirstAncestor("AppComposition")
local AppCompositionParent = AppComposition.Parent

require(AppCompositionParent.Foundation)

local Signals = require(AppCompositionParent.Signals)
local CompositionConfig = require(AppComposition.CompositionConfig)
local AppCompositionEnums = require(AppComposition.AppCompositionEnums)
local CompositionTags = require(AppComposition.CompositionTags)
local getGlobalViewportBreakpoint = require(AppComposition.getGlobalViewportBreakpoint)
local FFlagEnableSplitPane = require(AppCompositionParent.SharedFlags).FFlagEnableSplitPane
local Display = require(AppCompositionParent.Display)
local v10 = game:DefineFastFlag("LuaAppCompositionFixDetailClip", false)
local Header = CompositionTags.ContentRegion.Header
local Body = CompositionTags.ContentRegion.Body
local Detail = CompositionTags.Layout.Detail
local ClipAtMaxWidth = CompositionTags.Utility.ClipAtMaxWidth
local v15 = if not FFlagEnableSplitPane then nil else CompositionTags.SupportRegion.Root
local v16 = if not FFlagEnableSplitPane then nil else "CompositionSupportMinSize"
local v17 = if not FFlagEnableSplitPane then nil else "CompositionSupportMaxSize"
local t1 = {
	[`.{ Header }`] = {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.fromScale(0.5, 0)
	},
	[`.{ Header }::UIPadding`] = {
		PaddingLeft = "$CompositionMargin",
		PaddingRight = "$CompositionMargin"
	},
	[`.{ Header }::UISizeConstraint`] = {
		MaxSize = "$CompositionMaxWidthDiscovery"
	},
	[`.{ Body }`] = {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.fromScale(0.5, 0)
	},
	[`.{ Body }::UIPadding`] = {
		PaddingLeft = "$CompositionMargin",
		PaddingRight = "$CompositionMargin"
	},
	[`.{ Body }::UISizeConstraint`] = {
		MaxSize = "$CompositionMaxWidthDiscovery"
	},
	[`.{ Detail } >> .{ Header }::UISizeConstraint`] = {
		MaxSize = "$CompositionMaxWidthDetail"
	},
	[`.{ Detail } >> .{ Body }::UISizeConstraint`] = {
		MaxSize = "$CompositionMaxWidthDetail"
	},
	[`.{ Body }::StyleQuery #CompositionAtMaxWidthDiscovery`] = {
		MinSize = "$CompositionClipThresholdDiscovery"
	},
	[`.{ Body }::StyleQuery #CompositionNotAtMaxWidthDiscovery`] = {
		MaxSize = "$CompositionMaxWidthDiscovery"
	},
	[`@CompositionAtMaxWidthDiscovery >> .{ ClipAtMaxWidth }`] = {
		ClipsDescendants = true
	},
	[`@CompositionNotAtMaxWidthDiscovery >> .{ ClipAtMaxWidth }`] = if v10 then nil else {
		ClipsDescendants = false
	},
	[`.{ Detail } >> .{ Body }::StyleQuery #CompositionAtMaxWidthDetail`] = {
		MinSize = "$CompositionClipThresholdDetail"
	},
	[`.{ Detail } >> .{ Body }::StyleQuery #CompositionNotAtMaxWidthDetail`] = {
		MaxSize = "$CompositionMaxWidthDetail"
	},
	[`@CompositionAtMaxWidthDetail >> .{ ClipAtMaxWidth }`] = {
		ClipsDescendants = true
	},
	[`@CompositionNotAtMaxWidthDetail >> .{ ClipAtMaxWidth }`] = if v10 then nil else {
		ClipsDescendants = false
	},
	[`.{ v15 }::UISizeConstraint`] = if not FFlagEnableSplitPane then nil else {
		MinSize = "$" .. v16,
		MaxSize = "$" .. v17
	}
}

local function applyRules(p1, t2: {[any]: any}) -- line: 121
	-- upvalues: t1 (copy)
	for v24, v25 in t1 do
		local StyleRule = Instance.new("StyleRule")

		StyleRule.Selector = v24
		StyleRule.Name = v24
		StyleRule:SetProperties(v25)
		StyleRule.Parent = p1
		table.insert(t2, StyleRule)
	end
end
local function setupReactiveAttributes(p2, p3) -- line: 135
	-- upvalues: Signals (copy), getGlobalViewportBreakpoint (copy), CompositionConfig (copy), FFlagEnableSplitPane (copy), AppCompositionEnums (copy), Display (copy), v16 (copy), v17 (copy)
	local v29 = Signals.createComputed(function(p4) -- line: 136
		-- upvalues: getGlobalViewportBreakpoint (copy), CompositionConfig (copy), p3 (copy)
		local v36 = getGlobalViewportBreakpoint(p4)

		return CompositionConfig.getBaseConfig(v36, p3).margin
	end)
	local v30 = if not FFlagEnableSplitPane then nil else Signals.createComputed(function(p5) -- line: 142
		-- upvalues: getGlobalViewportBreakpoint (copy), CompositionConfig (copy), AppCompositionEnums (copy), p3 (copy)
		local v38 = getGlobalViewportBreakpoint(p5)

		return CompositionConfig.getRegionLayout(AppCompositionEnums.RegionName.SupportRegion, v38, p3)
	end)

	return Signals.createEffect(function(p6) -- line: 148
		-- upvalues: v29 (copy), p2 (copy), FFlagEnableSplitPane (copy), v30 (copy), Display (copy), v16 (copy), v17 (copy)
		local v40 = v29(p6)
		local v41 = v40 * 2

		p2:SetAttribute("CompositionMargin", UDim.new(0, v40))
		p2:SetAttribute("CompositionMaxWidthDiscovery", Vector2.new(1920 + v41, 1e999))
		p2:SetAttribute("CompositionClipThresholdDiscovery", Vector2.new(1920 + v41, 0))
		p2:SetAttribute("CompositionMaxWidthDetail", Vector2.new(848 + v41, 1e999))
		p2:SetAttribute("CompositionClipThresholdDetail", Vector2.new(848 + v41, 0))

		if FFlagEnableSplitPane then
			local v42 = v30(p6)
			local v43 = Display.GetDisplayStore(p6)
			local v44 = not v43.getPlatformScale and 1 or v43.getPlatformScale(p6)

			if not v44 or v44 == 0 then
				v44 = 1
			end

			p2:SetAttribute(v16, Vector2.new((v42.minWidth or 0) * v44, 0))
			p2:SetAttribute(v17, Vector2.new((v42.maxWidth or 1e999) * v44, 1e999))
		end
	end)
end
local function setupCompositionStyleRules(p7, p8) -- line: 175
	-- upvalues: applyRules (copy), setupReactiveAttributes (copy)
	local t3 = {}

	applyRules(p7, t3)

	local v34 = setupReactiveAttributes(p7, p8)

	return function() -- line: 182
		-- upvalues: v34 (copy), t3 (copy)
		v34()

		for _, v46 in t3 do
			v46:Destroy()
		end
	end
end

return setupCompositionStyleRules
