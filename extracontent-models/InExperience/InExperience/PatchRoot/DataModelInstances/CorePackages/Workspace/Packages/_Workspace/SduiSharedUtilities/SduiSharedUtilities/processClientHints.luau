local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")

local SduiGameIconPrewarm = require(SduiSharedUtilities.SduiGameIconPrewarm)
require(SduiSharedUtilities.SduiIntegrationTypes)

local _ = { PrewarmIcon = "prewarm_icon", PrewarmLargeIcon = "prewarm_large_icon" }

local v = {
	["prewarm_icon"] = SduiGameIconPrewarm.prewarmSmallIcons,
	prewarm_large_icon = SduiGameIconPrewarm.prewarmLargeIcons
}
local function collectHintsInTemplateTree(items, callback, p, p2)
	if type(items) ~= "table" then
		return
	end

	for k, item in items do
		if k == "client_hints" and type(item) == "table" then
			for _, item2 in item do
				if type(item2) == "string" then
					p[item2] = true
				end
			end
		elseif k == "roblox_component" and type(item) == "string" and item ~= "" then
			if not p2[item] then
				p2[item] = true
				local v2 = callback(item)

				if v2 ~= nil then
					collectHintsInTemplateTree(v2, callback, p, p2)
				end
			end
		elseif type(item) == "table" then
			collectHintsInTemplateTree(item, callback, p, p2)
		end
	end
end

local object = setmetatable({}, { __mode = "k" })

local function getHintsDeclaredBy(p, callback)
	if p == nil then
		return {}
	end

	local v2 = object[p]

	if v2 ~= nil then
		return v2
	end

	local v3 = {}
	collectHintsInTemplateTree(p, callback, v3, {})
	object[p] = v3
	return v3
end

local function declaresHintWithHandler(p, callback): boolean -- 1 equivalent call inferred from this helper
	for k in getHintsDeclaredBy(p, callback) do
		if v[k] then
			return true
		end
	end

	return false
end

local function anyTemplateDeclaresHintWithHandler(p, getTemplateForRobloxComponent): boolean -- 1 equivalent call inferred from this helper
	for _, v2 in p.getKnownTemplates() do
		if declaresHintWithHandler(v2, getTemplateForRobloxComponent) then -- inferred equivalent call
			return true
		end
	end

	return false
end

local function attributeHintTo(p, k: string, p2) -- 2 equivalent calls inferred from this helper
	local v2 = p[k]

	if v2 == nil then
		v2 = {}
		p[k] = v2
	end

	table.insert(v2, p2)
end

local function attributeHintsInInputData(componentInputData, getTemplateForRobloxComponent, set, p)
	if type(componentInputData) ~= "table" then
		return
	end

	local roblox_component = componentInputData.roblox_component
	local v2

	if type(roblox_component) == "string" and roblox_component ~= "" then
		v2 = getTemplateForRobloxComponent(roblox_component)
	end

	local v3

	if v2 == nil then
		v3 = set
	else
		v3 = set

		for k in getHintsDeclaredBy(v2, getTemplateForRobloxComponent) do
			if not v[k] or v3[k] then
				continue
			end

			if v3 == set then
				v3 = table.clone(set)
			end

			v3[k] = true
			attributeHintTo(p, k, componentInputData) -- inferred equivalent call
		end
	end

	for _, v4 in componentInputData do
		if type(v4) == "table" then
			attributeHintsInInputData(v4, getTemplateForRobloxComponent, v3, p)
		end
	end
end

local function processClientHints(p)
	local getTemplateForRobloxComponent = p.getTemplateForRobloxComponent

	if not (getTemplateForRobloxComponent ~= nil and anyTemplateDeclaresHintWithHandler( -- inferred equivalent call
		p,
		getTemplateForRobloxComponent
	)) then
		return
	end

	local v2 = {}

	for _, pageEntry in p.pageEntries do
		local robloxComponentType = pageEntry.robloxComponentType
		local componentInputData = pageEntry.componentInputData

		if not (robloxComponentType and componentInputData) then
			continue
		end

		local set = {}
		local templateForRobloxComponent = getTemplateForRobloxComponent(robloxComponentType)

		if templateForRobloxComponent ~= nil then
			for k in getHintsDeclaredBy(templateForRobloxComponent, getTemplateForRobloxComponent) do
				if not v[k] then
					continue
				end

				set[k] = true
				attributeHintTo(v2, k, componentInputData) -- inferred equivalent call
			end
		end

		attributeHintsInInputData(componentInputData, getTemplateForRobloxComponent, set, v2)
	end

	for k, v3 in v2 do
		v[k](v3)
	end
end

return processClientHints
