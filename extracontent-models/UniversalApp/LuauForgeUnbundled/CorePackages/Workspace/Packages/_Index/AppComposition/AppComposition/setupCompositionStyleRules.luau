require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/Foundation")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/Signals")

local CompositionConfig = require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/CompositionConfig")
local AppCompositionEnums = require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/AppCompositionEnums")
local CompositionTags = require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/CompositionTags")
local getGlobalViewportBreakpoint = require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/getGlobalViewportBreakpoint")
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/SharedFlags").FFlagEnableSplitPane
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/Display")

local defineFastFlag = game:DefineFastFlag("LuaAppScaleDetailWidth", false)

local defineFastFlag2 = game:DefineFastFlag("LuaAppScaleDiscoveryWidth", false)

local header = CompositionTags.ContentRegion.Header
local body = CompositionTags.ContentRegion.Body
local detail = CompositionTags.Layout.Detail
local clipAtMaxWidth = CompositionTags.Utility.ClipAtMaxWidth
local root = if fFlagEnableSplitPane then CompositionTags.SupportRegion.Root else nil
local collapsed = if fFlagEnableSplitPane then CompositionTags.SupportRegion.Collapsed else nil
local v5 = fFlagEnableSplitPane and "CompositionSupportMinSize" or nil
local v6 = fFlagEnableSplitPane and "CompositionSupportMaxSize" or nil
local v7

if fFlagEnableSplitPane then
	v7 = CompositionConfig.getRegionOverrides(AppCompositionEnums.RegionName.SupportRegion)
end

local v8 = {
	[`.{header}`] = {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.fromScale(0.5, 0)
	},
	[`.{header}::UIPadding`] = {
		PaddingLeft = "$CompositionMargin",
		PaddingRight = "$CompositionMargin"
	},
	[`.{header}::UISizeConstraint`] = { MaxSize = "$CompositionMaxWidthDiscovery" },
	[`.{body}`] = {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.fromScale(0.5, 0)
	},
	[`.{body}::UIPadding`] = {
		PaddingLeft = "$CompositionMargin",
		PaddingRight = "$CompositionMargin"
	},
	[`.{body}::UISizeConstraint`] = { MaxSize = "$CompositionMaxWidthDiscovery" },
	[`.{detail} >> .{header}::UISizeConstraint`] = {
		MaxSize = "$CompositionMaxWidthDetail"
	},
	[`.{detail} >> .{body}::UISizeConstraint`] = {
		MaxSize = "$CompositionMaxWidthDetail"
	},
	[`.{body}::StyleQuery #CompositionAtMaxWidthDiscovery`] = {
		MinSize = "$CompositionClipThresholdDiscovery"
	},
	[`.{body}::StyleQuery #CompositionNotAtMaxWidthDiscovery`] = {
		MaxSize = "$CompositionMaxWidthDiscovery"
	},
	[`@CompositionAtMaxWidthDiscovery >> .{clipAtMaxWidth}`] = {
		ClipsDescendants = true
	},
	[`.{detail} >> .{body}::StyleQuery #CompositionAtMaxWidthDetail`] = {
		MinSize = "$CompositionClipThresholdDetail"
	},
	[`.{detail} >> .{body}::StyleQuery #CompositionNotAtMaxWidthDetail`] = {
		MaxSize = "$CompositionMaxWidthDetail"
	},
	[`@CompositionAtMaxWidthDetail >> .{clipAtMaxWidth}`] = { ClipsDescendants = true },
	[`.{root}`] = fFlagEnableSplitPane and v7 and v7.widthScale and {
		Size = UDim2.new(v7.widthScale, 0, 1, 0)
	} or nil,
	[`.{root}::UISizeConstraint`] = fFlagEnableSplitPane and {
		MinSize = "$" .. v5,
		MaxSize = "$" .. v6
	} or nil,
	[`.{collapsed}`] = fFlagEnableSplitPane and { Size = UDim2.new(0, 0, 1, 0) } or nil
}

local function applyRules(parent, list)
	for k, v9 in v8 do
		local styleRule = Instance.new("StyleRule")
		styleRule.Selector = k
		styleRule.Name = k
		styleRule:SetProperties(v9)
		styleRule.Parent = parent
		table.insert(list, styleRule)
	end
end

local function setupReactiveAttributes(instance, p2)
	local computed = Signals.createComputed(function(p3)
		local v9 = getGlobalViewportBreakpoint(p3)
		return CompositionConfig.getBaseConfig(v9, p2).margin
	end)
	local v9

	if fFlagEnableSplitPane then
		v9 = Signals.createComputed(function(p3)
			local v10 = getGlobalViewportBreakpoint(p3)
			return CompositionConfig.getRegionLayout(AppCompositionEnums.RegionName.SupportRegion, v10, p2)
		end)
	else
		v9 = nil
	end

	return Signals.createEffect(function(p3)
		local v10 = computed(p3)
		local v11 = v10 * 2

		instance:SetAttribute("CompositionMargin", UDim.new(0, v10))
		local v12

		if defineFastFlag2 or defineFastFlag then
			local displayStore = Display.GetDisplayStore(p3)
			local v13 = not displayStore.getPlatformScale and 1 or displayStore.getPlatformScale(p3)
			v12 = not (v13 and v13 > 0) and 1 or v13
		end

		instance:SetAttribute(
			"CompositionMaxWidthDiscovery",
			Vector2.new((not defineFastFlag2 and 1920 or 1920 * v12) + v11, 1e999)
		)

		instance:SetAttribute(
			"CompositionClipThresholdDiscovery",
			Vector2.new((not defineFastFlag2 and 1920 or 1920 * v12) + v11, 0)
		)

		instance:SetAttribute(
			"CompositionMaxWidthDetail",
			Vector2.new((not defineFastFlag and 848 or 848 * v12) + v11, 1e999)
		)

		instance:SetAttribute(
			"CompositionClipThresholdDetail",
			Vector2.new((not defineFastFlag and 848 or 848 * v12) + v11, 0)
		)

		if fFlagEnableSplitPane then
			local v13 = v9(p3)
			local displayStore = Display.GetDisplayStore(p3)
			local v14 = not displayStore.getPlatformScale and 1 or displayStore.getPlatformScale(p3)
			local v15 = (not v14 or v14 == 0) and 1 or v14
			instance:SetAttribute(v5, Vector2.new((v13.minWidth or 0) * v15, 0))
			instance:SetAttribute(v6, Vector2.new((v13.maxWidth or 1e999) * v15, 1e999))
		end
	end)
end

local function setupCompositionStyleRules(p2, p3)
	local v9 = {}

	applyRules(p2, v9)

	local v10 = setupReactiveAttributes(p2, p3)

	return function()
		v10()

		for k, v11 in v9 do
			v11:Destroy()
		end
	end
end

return setupCompositionStyleRules
