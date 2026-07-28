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
local v16 = if not FFlagEnableSplitPane then nil else CompositionTags.SupportRegion.Collapsed
local v17 = if not FFlagEnableSplitPane then nil else "CompositionSupportMinSize"
local v18 = if not FFlagEnableSplitPane then nil else "CompositionSupportMaxSize"
local v19 = if not FFlagEnableSplitPane then nil else "CompositionSupportCollapsedSize"
local v20 = if not FFlagEnableSplitPane then nil else CompositionConfig.getRegionOverrides(AppCompositionEnums.RegionName.SupportRegion)
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
	[`.{ v15 }`] = if not FFlagEnableSplitPane or (not v20 or not v20.widthScale) then nil else {
		Size = UDim2.new(v20.widthScale, 0, 1, 0)
	},
	[`.{ v15 }::UISizeConstraint`] = if not FFlagEnableSplitPane then nil else {
		MinSize = "$" .. v17,
		MaxSize = "$" .. v18
	},
	[`.{ v16 }`] = if not FFlagEnableSplitPane then nil else {
		Size = "$" .. v19
	}
}

local function applyRules(p1, t2: {[any]: any}) -- line: 141
	-- upvalues: t1 (copy)
	for v27, v28 in t1 do
		local StyleRule = Instance.new("StyleRule")

		StyleRule.Selector = v27
		StyleRule.Name = v27
		StyleRule:SetProperties(v28)
		StyleRule.Parent = p1
		table.insert(t2, StyleRule)
	end
end
local function setupReactiveAttributes(p2, p3) -- line: 155
	-- upvalues: Signals (copy), getGlobalViewportBreakpoint (copy), CompositionConfig (copy), FFlagEnableSplitPane (copy), AppCompositionEnums (copy), Display (copy), v17 (copy), v18 (copy), v19 (copy)
	local v32 = Signals.createComputed(function(p4) -- line: 156
		-- upvalues: getGlobalViewportBreakpoint (copy), CompositionConfig (copy), p3 (copy)
		local v39 = getGlobalViewportBreakpoint(p4)

		return CompositionConfig.getBaseConfig(v39, p3).margin
	end)
	local v33 = if not FFlagEnableSplitPane then nil else Signals.createComputed(function(p5) -- line: 162
		-- upvalues: getGlobalViewportBreakpoint (copy), CompositionConfig (copy), AppCompositionEnums (copy), p3 (copy)
		local v41 = getGlobalViewportBreakpoint(p5)

		return CompositionConfig.getRegionLayout(AppCompositionEnums.RegionName.SupportRegion, v41, p3)
	end)

	return Signals.createEffect(function(p6) -- line: 168
		-- upvalues: v32 (copy), p2 (copy), FFlagEnableSplitPane (copy), v33 (copy), Display (copy), v17 (copy), v18 (copy), v19 (copy)
		local v43 = v32(p6)
		local v44 = v43 * 2

		p2:SetAttribute("CompositionMargin", UDim.new(0, v43))
		p2:SetAttribute("CompositionMaxWidthDiscovery", Vector2.new(1920 + v44, 1e999))
		p2:SetAttribute("CompositionClipThresholdDiscovery", Vector2.new(1920 + v44, 0))
		p2:SetAttribute("CompositionMaxWidthDetail", Vector2.new(848 + v44, 1e999))
		p2:SetAttribute("CompositionClipThresholdDetail", Vector2.new(848 + v44, 0))

		if FFlagEnableSplitPane then
			local v45 = v33(p6)
			local v46 = Display.GetDisplayStore(p6)
			local v47 = not v46.getPlatformScale and 1 or v46.getPlatformScale(p6)

			if not v47 or v47 == 0 then
				v47 = 1
			end

			p2:SetAttribute(v17, Vector2.new((v45.minWidth or 0) * v47, 0))
			p2:SetAttribute(v18, Vector2.new((v45.maxWidth or 1e999) * v47, 1e999))
			p2:SetAttribute(v19, UDim2.new(0, v43, 1, 0))
		end
	end)
end
local function setupCompositionStyleRules(p7, p8) -- line: 196
	-- upvalues: applyRules (copy), setupReactiveAttributes (copy)
	local t3 = {}

	applyRules(p7, t3)

	local v37 = setupReactiveAttributes(p7, p8)

	return function() -- line: 203
		-- upvalues: v37 (copy), t3 (copy)
		v37()

		for _, v49 in t3 do
			v49:Destroy()
		end
	end
end

return setupCompositionStyleRules
