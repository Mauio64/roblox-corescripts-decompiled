local AppComposition = script:FindFirstAncestor("AppComposition")
local parent = AppComposition.Parent

require(parent.Foundation)
local Signals = require(parent.Signals)

local CompositionConfig = require(AppComposition.CompositionConfig)
local AppCompositionEnums = require(AppComposition.AppCompositionEnums)
local CompositionTags = require(AppComposition.CompositionTags)
local getGlobalViewportBreakpoint = require(AppComposition.getGlobalViewportBreakpoint)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local Display = require(parent.Display)

local defineFastFlag = game:DefineFastFlag("LuaAppScaleDetailWidth", false)

local defineFastFlag2 = game:DefineFastFlag("LuaAppScaleDiscoveryWidth", false)

local Header = CompositionTags.ContentRegion.Header
local Body = CompositionTags.ContentRegion.Body
local Detail = CompositionTags.Layout.Detail
local ClipAtMaxWidth = CompositionTags.Utility.ClipAtMaxWidth
local root

if FFlagEnableSplitPane then
	root = CompositionTags.SupportRegion.Root
end

local collapsed

if FFlagEnableSplitPane then
	collapsed = CompositionTags.SupportRegion.Collapsed
end

local v = FFlagEnableSplitPane and "CompositionSupportMinSize" or nil
local v2 = FFlagEnableSplitPane and "CompositionSupportMaxSize" or nil
local v3

if FFlagEnableSplitPane then
	v3 = CompositionConfig.getRegionOverrides(AppCompositionEnums.RegionName.SupportRegion)
end

local v4 = {
	[`.{Header}`] = { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromScale(0.5, 0) },
	[`.{Header}::UIPadding`] = {
		PaddingLeft = "$CompositionMargin",
		PaddingRight = "$CompositionMargin"
	},
	[`.{Header}::UISizeConstraint`] = { MaxSize = "$CompositionMaxWidthDiscovery" },
	[`.{Body}`] = { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromScale(0.5, 0) },
	[`.{Body}::UIPadding`] = {
		PaddingLeft = "$CompositionMargin",
		PaddingRight = "$CompositionMargin"
	},
	[`.{Body}::UISizeConstraint`] = { MaxSize = "$CompositionMaxWidthDiscovery" },
	[`.{Detail} >> .{Header}::UISizeConstraint`] = { MaxSize = "$CompositionMaxWidthDetail" },
	[`.{Detail} >> .{Body}::UISizeConstraint`] = { MaxSize = "$CompositionMaxWidthDetail" },
	[`.{Body}::StyleQuery #CompositionAtMaxWidthDiscovery`] = {
		MinSize = "$CompositionClipThresholdDiscovery"
	},
	[`.{Body}::StyleQuery #CompositionNotAtMaxWidthDiscovery`] = {
		MaxSize = "$CompositionMaxWidthDiscovery"
	},
	[`@CompositionAtMaxWidthDiscovery >> .{ClipAtMaxWidth}`] = { ClipsDescendants = true },
	[`.{Detail} >> .{Body}::StyleQuery #CompositionAtMaxWidthDetail`] = {
		MinSize = "$CompositionClipThresholdDetail"
	},
	[`.{Detail} >> .{Body}::StyleQuery #CompositionNotAtMaxWidthDetail`] = {
		MaxSize = "$CompositionMaxWidthDetail"
	},
	[`@CompositionAtMaxWidthDetail >> .{ClipAtMaxWidth}`] = { ClipsDescendants = true },
	[`.{root}`] = FFlagEnableSplitPane and v3 and v3.widthScale and {
		Size = UDim2.new(v3.widthScale, 0, 1, 0)
	} or nil,
	[`.{root}::UISizeConstraint`] = FFlagEnableSplitPane and {
		MinSize = "$" .. v,
		MaxSize = "$" .. v2
	} or nil,
	[`.{collapsed}`] = FFlagEnableSplitPane and { Size = UDim2.new(0, 0, 1, 0) } or nil
}

local function applyRules(parent2, list)
	for k, v5 in v4 do
		local styleRule = Instance.new("StyleRule")
		styleRule.Selector = k
		styleRule.Name = k
		styleRule:SetProperties(v5)
		styleRule.Parent = parent2
		table.insert(list, styleRule)
	end
end

local function setupReactiveAttributes(instance, p)
	local computed = Signals.createComputed(function(p2)
		local globalViewportBreakpoint = getGlobalViewportBreakpoint(p2)
		return CompositionConfig.getBaseConfig(globalViewportBreakpoint, p).margin
	end)
	local v5

	if FFlagEnableSplitPane then
		v5 = Signals.createComputed(function(p2)
			local globalViewportBreakpoint = getGlobalViewportBreakpoint(p2)
			return CompositionConfig.getRegionLayout(
				AppCompositionEnums.RegionName.SupportRegion,
				globalViewportBreakpoint,
				p
			)
		end)
	else
		v5 = nil
	end

	return Signals.createEffect(function(p2)
		local v6 = computed(p2)
		local v7 = v6 * 2

		instance:SetAttribute("CompositionMargin", UDim.new(0, v6))
		local v8

		if defineFastFlag2 or defineFastFlag then
			local displayStore = Display.GetDisplayStore(p2)
			local v9 = not displayStore.getPlatformScale and 1 or displayStore.getPlatformScale(p2)
			v8 = not (v9 and v9 > 0) and 1 or v9
		end

		instance:SetAttribute(
			"CompositionMaxWidthDiscovery",
			Vector2.new((not defineFastFlag2 and 1920 or v8 * 1920) + v7, 1e999)
		)

		instance:SetAttribute(
			"CompositionClipThresholdDiscovery",
			Vector2.new((not defineFastFlag2 and 1920 or v8 * 1920) + v7, 0)
		)

		instance:SetAttribute(
			"CompositionMaxWidthDetail",
			Vector2.new((not defineFastFlag and 848 or v8 * 848) + v7, 1e999)
		)

		instance:SetAttribute(
			"CompositionClipThresholdDetail",
			Vector2.new((not defineFastFlag and 848 or v8 * 848) + v7, 0)
		)

		if FFlagEnableSplitPane then
			local v9 = v5(p2)
			local displayStore = Display.GetDisplayStore(p2)
			local v10 = not displayStore.getPlatformScale and 1 or displayStore.getPlatformScale(p2)
			local v11 = (not v10 or v10 == 0) and 1 or v10
			instance:SetAttribute(v, Vector2.new((v9.minWidth or 0) * v11, 0))
			instance:SetAttribute(v2, Vector2.new((v9.maxWidth or 1e999) * v11, 1e999))
		end
	end)
end

local function setupCompositionStyleRules(parent2, p)
	local v5 = {}

	applyRules(parent2, v5)

	local v6 = setupReactiveAttributes(parent2, p)

	return function()
		v6()

		for _, v7 in v5 do
			v7:Destroy()
		end
	end
end

return setupCompositionStyleRules
