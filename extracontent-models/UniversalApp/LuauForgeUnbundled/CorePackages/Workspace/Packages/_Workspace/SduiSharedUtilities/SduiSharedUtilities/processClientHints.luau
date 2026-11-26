local SduiGameIconPrewarm = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiGameIconPrewarm")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes")

local v5 = { PrewarmIcon = "prewarm_icon", PrewarmLargeIcon = "prewarm_large_icon" }

local v6 = {
	["prewarm_icon"] = SduiGameIconPrewarm.prewarmSmallIcons,
	prewarm_large_icon = SduiGameIconPrewarm.prewarmLargeIcons
}
local function collectHintsInTemplateTree(items, callback, p2, p3)
	if type(items) ~= "table" then
		return
	end

	for k, item in items do
		if k == "client_hints" and type(item) == "table" then
			for k2, item2 in item do
				if type(item2) == "string" then
					p2[item2] = true
				end
			end
		elseif k == "roblox_component" and type(item) == "string" and item ~= "" then
			if not p3[item] then
				p3[item] = true
				local v7 = callback(item)

				if v7 ~= nil then
					collectHintsInTemplateTree(v7, callback, p2, p3)
				end
			end
		elseif type(item) == "table" then
			collectHintsInTemplateTree(item, callback, p2, p3)
		end
	end
end

local object = setmetatable({}, { __mode = "k" })

local function getHintsDeclaredBy(p2, p3)
	if p2 == nil then
		return {}
	end

	local v7 = object[p2]

	if v7 ~= nil then
		return v7
	end

	local v8 = {}
	collectHintsInTemplateTree(p2, p3, v8, {})
	object[p2] = v8
	return v8
end

local function declaresHintWithHandler(p2, p3): boolean
	for k in getHintsDeclaredBy(p2, p3) do
		if v6[k] then
			return true
		end
	end

	return false
end

local function anyTemplateDeclaresHintWithHandler(p2, p3): boolean
	for k, v7 in p2.getKnownTemplates() do
		local flag = true
		local flag2

		for k2 in getHintsDeclaredBy(v7, p3) do
			if v6[k2] then
				flag2 = true
				flag = false
				break
			end
		end

		if flag then
			flag2 = false
		end

		if flag2 then
			return true
		end
	end

	return false
end

local function attributeHintTo(p2, p3, p4)
	local v7 = p2[p3]

	if v7 == nil then
		v7 = {}
		p2[p3] = v7
	end

	table.insert(v7, p4)
end

local function attributeHintsInInputData(componentInputData, getTemplateForRobloxComponent, set, p2)
	if type(componentInputData) ~= "table" then
		return
	end

	local roblox_component = componentInputData.roblox_component
	local v7

	if type(roblox_component) == "string" and roblox_component ~= "" then
		v7 = getTemplateForRobloxComponent(roblox_component)
	end

	local v8

	if v7 == nil then
		v8 = set
	else
		v8 = set

		for k in getHintsDeclaredBy(v7, getTemplateForRobloxComponent) do
			if not v6[k] or v8[k] then
				continue
			end

			if v8 == set then
				v8 = table.clone(set)
			end

			v8[k] = true
			local v9 = p2[k]

			if v9 == nil then
				v9 = {}
				p2[k] = v9
			end

			table.insert(v9, componentInputData)
		end
	end

	for k, v9 in componentInputData do
		if type(v9) == "table" then
			attributeHintsInInputData(v9, getTemplateForRobloxComponent, v8, p2)
		end
	end
end

local function processClientHints(data)
	local getTemplateForRobloxComponent = data.getTemplateForRobloxComponent

	if getTemplateForRobloxComponent == nil then
		return
	end

	local flag = true
	local v7

	for k, v8 in data.getKnownTemplates() do
		local flag2 = true
		local flag3

		for k2 in getHintsDeclaredBy(v8, getTemplateForRobloxComponent) do
			if v6[k2] then
				flag3 = true
				flag2 = false
				break
			end
		end

		if flag2 then
			flag3 = false
		end

		if flag3 then
			v7 = true
			flag = false
			break
		end
	end

	if flag then
		v7 = false
	end

	if not v7 then
		return
	end

	local v8 = {}

	for k, pageEntry in data.pageEntries do
		local robloxComponentType = pageEntry.robloxComponentType
		local componentInputData = pageEntry.componentInputData

		if not (robloxComponentType and componentInputData) then
			continue
		end

		local set = {}
		local templateForRobloxComponent = getTemplateForRobloxComponent(robloxComponentType)

		if templateForRobloxComponent ~= nil then
			for k2 in getHintsDeclaredBy(templateForRobloxComponent, getTemplateForRobloxComponent) do
				if not v6[k2] then
					continue
				end

				set[k2] = true
				local componentInputDatas = v8[k2]

				if componentInputDatas == nil then
					componentInputDatas = {}
					v8[k2] = componentInputDatas
				end

				table.insert(componentInputDatas, componentInputData)
			end
		end

		attributeHintsInInputData(componentInputData, getTemplateForRobloxComponent, set, v8)
	end

	for k, v9 in v8 do
		v6[k](v9)
	end
end

return processClientHints
