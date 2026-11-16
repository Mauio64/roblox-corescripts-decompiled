local parent = script.Parent.Parent
require(parent.Enums.ColorMode)
local Device = require(parent.Enums.Device)
local ThemeName = require(parent.Enums.ThemeName)
require(parent.Providers.Style.Tokens)
require(script.Parent.Rules.Types)

local Flags = require(parent.Utility.Flags)
local devAssert = require(parent.Utility.devAssert)
local getGeneratedRules = require(parent.Utility.getGeneratedRules)
local getMainGui = require(parent.Utility.getMainGui)
local getOverrideAttributes = require(script.Parent.getOverrideAttributes)
local scaleValue = require(parent.Utility.scaleValue)

local HttpService = game:GetService("HttpService")
local folder = Instance.new("Folder")
folder.Name = "FoundationStyleSheets" .. HttpService:GenerateGUID(false)

local mainGui = getMainGui()
devAssert(mainGui ~= nil, "MainGui not found")
folder.Parent = mainGui

local v = {}

local v2 = {}
local flag = false

local function createStyleSheet(colorMode, p, value: number?, tokenOverrides, p2)
	local device = p or Device.Desktop
	local scale = value or 1
	local themeName = p2 or ThemeName.Default
	local styleSheet = Instance.new("StyleSheet")
	local formatted = `{themeName}-`
	local name

	if tokenOverrides == nil then
		name = `{formatted}{colorMode}-{device}-{scale}`
	else
		name = `{formatted}{colorMode}-{device}-{scale}-{tostring(tokenOverrides)}`
	end

	styleSheet.Name = name

	styleSheet.Parent = folder
	return {
		themeName = themeName,
		colorMode = colorMode,
		device = device,
		scale = scale,
		tokenOverrides = tokenOverrides,
		overrideAttributes = getOverrideAttributes(themeName, colorMode, device, tokenOverrides),
		instance = styleSheet,
		tags = {},
		rules = getGeneratedRules(themeName, colorMode, device),
		attributes = {},
		refCount = 0
	}
end

local function createStyleRule(data, p: string)
	local v3 = "." .. p
	local v4 = data.modifier == nil and "" or ":" .. data.modifier
	local v5 = v3 .. v4 .. (data.pseudo == nil and "" or " ::" .. data.pseudo)

	if data.pseudoName ~= nil then
		v5 ..= " #" .. data.pseudoName
	end

	if data.pseudo ~= nil and data.pseudoName == nil then
		v5 ..= ", " .. v3 .. v4 .. " > " .. data.pseudo
	end

	local styleRule = Instance.new("StyleRule")
	styleRule.Name = v5
	styleRule.Priority = data.priority or 1
	styleRule.Selector = v5
	styleRule:SetProperties(data.properties)
	return styleRule
end

local function applyAttributes(data, attributes)
	if not attributes then
		return
	end

	for _, item in attributes do
		if data.attributes[item.name] then
			continue
		end

		local v3 = data.overrideAttributes[item.name]

		if v3 == nil then
			v3 = item.value
		end

		if not Flags.FoundationDisableTokenScaling then
			v3 = scaleValue(v3, data.scale)
		end

		data.attributes[item.name] = true
		data.instance:SetAttribute(item.name, v3)
	end
end

local function addRegisteredStyleSheetTags(data, items)
	for _, item in items do
		if data.tags[item] then
			continue
		end

		local rule = data.rules[item]

		if not rule then
			continue
		end

		local styleRule = createStyleRule(rule, item)
		styleRule.Parent = data.instance
		applyAttributes(data, rule.attributes)

		if rule.children then
			for _, child in rule.children do
				local styleRule_2 = createStyleRule(child, child.tag)
				styleRule_2.Parent = data.instance
				applyAttributes(data, child.attributes)
			end
		end

		data.tags[item] = true
	end
end

local function resolveStyleSheet(colorMode, p, value: number?, tokenOverrides, p2)
	local v3 = p or Device.Desktop

	local v4 = p2 or ThemeName.Default
	local v5 = value or 1

	for k, v6 in v do
		if
			v6.themeName == v4
			and v6.colorMode == colorMode
			and v6.device == v3
			and v6.scale == v5
			and v6.tokenOverrides == tokenOverrides
		then
			v2[k] = nil
			return k
		end
	end

	local styleSheet = createStyleSheet(colorMode, v3, v5, tokenOverrides, v4)
	v[styleSheet.instance] = styleSheet
	return styleSheet.instance
end

local function destroyStyleSheet(instance)
	local v3 = v[instance]

	if v3 == nil or v3.refCount > 0 then
		return
	end

	v[instance] = nil
	instance:Destroy()
end

local function flushPendingCleanup()
	flag = false

	for k in v2 do
		v2[k] = nil
		local v3 = v[k]

		if v3 == nil or v3.refCount > 0 then
			continue
		end

		v[k] = nil
		k:Destroy()
	end
end

local function scheduleCleanup(p) -- 1 equivalent call inferred from this helper
	v2[p] = true

	if flag then
		return
	end

	flag = true
	task.delay(5, flushPendingCleanup)
end

local function acquireStyleSheet(styleSheet) -- 1 equivalent call inferred from this helper
	local v3 = v[styleSheet]

	if v3 == nil then
		return
	end

	v3.refCount += 1

	v2[styleSheet] = nil
end

local StyleSheetRegistry = {}
StyleSheetRegistry.resolveStyleSheet = resolveStyleSheet

function StyleSheetRegistry.getStyleSheet(colorMode, p, p2: number?, tokenOverrides, p3)
	local styleSheet = resolveStyleSheet(colorMode, p, p2, tokenOverrides, p3)
	acquireStyleSheet(styleSheet) -- inferred equivalent call
	return styleSheet
end

function StyleSheetRegistry.addStyleTags(p, p2)
	local v3 = v[p]

	if not v3 then
		error("StyleSheet not found in registry")
	end

	addRegisteredStyleSheetTags(v3, p2)
end

StyleSheetRegistry.acquireStyleSheet = acquireStyleSheet

function StyleSheetRegistry.releaseStyleSheet(p)
	local v3 = v[p]

	if v3 == nil or v3.refCount == 0 then
		return
	end

	v3.refCount -= 1

	if v3.refCount == 0 then
		scheduleCleanup(p) -- inferred equivalent call
	end
end

StyleSheetRegistry.flushPendingCleanup = flushPendingCleanup
return StyleSheetRegistry
