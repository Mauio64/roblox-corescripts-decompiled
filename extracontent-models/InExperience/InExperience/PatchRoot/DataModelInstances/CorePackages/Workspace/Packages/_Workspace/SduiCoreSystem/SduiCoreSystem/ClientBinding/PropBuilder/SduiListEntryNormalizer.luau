local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SharedFlags = require(SduiCoreSystem.Parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths

require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)

local function tryResolveTemplatePair(roblox_component: string?, inline_component, p)
	if inline_component ~= nil then
		return inline_component, true, nil
	end

	local v = roblox_component and roblox_component ~= "" and p.getTemplateForRobloxComponent(roblox_component)

	if not v then
		return nil, false, nil
	end

	local v2 = false

	if FFlagSduiErrorPaths then
		return v, false, roblox_component
	end

	return v, v2, nil
end

local function resolveItemOverrides(items, p)
	if items == nil or next(items) == nil then
		return nil
	end

	local result = {}

	for k, item in items do
		local roblox_component = item.roblox_component
		local template = item.inline_component
		local isInline

		if template == nil then
			if roblox_component and roblox_component ~= "" then
				template = p.getTemplateForRobloxComponent(roblox_component)

				if template then
					isInline = false

					if not FFlagSduiErrorPaths then
						roblox_component = nil
					end
				else
					template = nil
					isInline = false
					roblox_component = nil
				end
			else
				template = nil
				isInline = false
				roblox_component = nil
			end
		else
			isInline = true
			roblox_component = nil
		end

		if not FFlagSduiErrorPaths then
			roblox_component = nil
		end

		result[k] = {
			template = template,
			isInline = isInline,
			robloxComponent = roblox_component,
			inputs = item.inputs,
			sortRankProp = item.sort_rank
		}
	end

	return result
end

local function pickTemplate(p, data, p2, flag: boolean, p3: string?, p4)
	local roblox_component

	if typeof(p) == "table" then
		roblox_component = p.roblox_component
	end

	local v

	if typeof(p) == "table" then
		v = p.inline_component
	end

	local v2

	if v == nil then
		if roblox_component then
			v = roblox_component ~= "" and p4.getTemplateForRobloxComponent(roblox_component)

			if v then
				v2 = false

				if not FFlagSduiErrorPaths then
					roblox_component = nil
				end
			else
				v = nil
				v2 = false
				roblox_component = nil
			end
		else
			v = nil
			v2 = false
			roblox_component = nil
		end
	else
		v2 = true
		roblox_component = nil
	end

	if v then
		if FFlagSduiErrorPaths then
			return v, v2, roblox_component
		end

		return v, v2, nil
	elseif data and data.template then
		local template = data.template
		local isInline = data.isInline

		if FFlagSduiErrorPaths then
			return template, isInline, data.robloxComponent
		end

		return template, isInline, nil
	elseif FFlagSduiErrorPaths then
		return p2, flag, p3
	else
		return p2, flag, nil
	end
end

local function resolveDefaultTemplate(p, p2)
	if p == nil then
		return nil, false, nil
	end

	return tryResolveTemplatePair(p.roblox_component, p.inline_component, p2)
end

local function buildBoundEntry(item, identifier: string?, p, flag: boolean, p2: string?, inputs, sort_rank, itemOverrides, p3)
	local v

	if itemOverrides and identifier then
		v = itemOverrides[identifier]
	end

	if not FFlagSduiErrorPaths then
		p2 = nil
	end

	local template, isInline, robloxComponent = pickTemplate(item, v, p, flag, p2, p3)
	local sort_rank2

	if typeof(item) == "table" then
		sort_rank2 = item.sort_rank
	end

	inputs = v and v.inputs or inputs

	if not FFlagSduiErrorPaths then
		robloxComponent = nil
	end

	if sort_rank2 then
		sort_rank = sort_rank2
	else
		sort_rank = v and v.sortRankProp or sort_rank
	end

	return {
		item = item,
		identifier = identifier,
		sourceMode = "data",
		inputs = inputs,
		template = template,
		isInline = isInline,
		robloxComponent = robloxComponent,
		sortRankProp = sort_rank
	}
end

local SduiListEntryNormalizer = {}

function SduiListEntryNormalizer.normalizeLiteralItems(items, data, p)
	local inputs

	if data then
		inputs = data.inputs
	end

	local sort_rank

	if data then
		sort_rank = data.sort_rank
	end

	local roblox_component, v, v2

	if data == nil then
		v2 = false
	else
		roblox_component = data.roblox_component
		v = data.inline_component

		if v == nil then
			if roblox_component and roblox_component ~= "" then
				v = p.getTemplateForRobloxComponent(roblox_component)

				if v then
					v2 = false

					if not FFlagSduiErrorPaths then
						roblox_component = nil
					end
				else
					roblox_component = nil
					v = nil
					v2 = false
				end
			else
				roblox_component = nil
				v = nil
				v2 = false
			end
		else
			roblox_component = nil
			v2 = true
		end
	end

	local literalItems = {}

	for _, item in items do
		local identifier = item.identifier

		if identifier == "" then
			identifier = nil
		end

		local v3

		if FFlagSduiErrorPaths then
			v3 = roblox_component
		end

		local robloxComponent

		if typeof(item) == "table" then
			robloxComponent = item.roblox_component
		end

		local template

		if typeof(item) == "table" then
			template = item.inline_component
		end

		local isInline

		if template == nil then
			if robloxComponent and robloxComponent ~= "" then
				template = p.getTemplateForRobloxComponent(robloxComponent)

				if template then
					isInline = false

					if not FFlagSduiErrorPaths then
						robloxComponent = nil
					end
				else
					template = nil
					isInline = false
					robloxComponent = nil
				end
			else
				template = nil
				isInline = false
				robloxComponent = nil
			end
		else
			isInline = true
			robloxComponent = nil
		end

		if template then
			if not FFlagSduiErrorPaths then
				robloxComponent = nil
			end
		elseif FFlagSduiErrorPaths then
			robloxComponent = v3
			isInline = v2
			template = v
		else
			isInline = v2
			template = v
			robloxComponent = nil
		end

		local v4 = {
			item = item,
			identifier = identifier,
			sourceMode = "literal",
			inputs = item.inputs or inputs,
			template = template,
			isInline = isInline,
			robloxComponent = 0,
			sortRankProp = 0
		}

		if not FFlagSduiErrorPaths then
			robloxComponent = nil
		end

		v4.robloxComponent = robloxComponent
		v4.sortRankProp = item.sort_rank or sort_rank
		table.insert(literalItems, v4)
	end

	return literalItems
end

function SduiListEntryNormalizer.normalizeBoundData(list, data, p, p2)
	if typeof(list) ~= "table" then
		return {}
	end

	local inputs

	if data then
		inputs = data.inputs
	end

	local sort_rank

	if data then
		sort_rank = data.sort_rank
	end

	local v, v2, roblox_component

	if data == nil then
		v2 = false
	else
		roblox_component = data.roblox_component
		v = data.inline_component

		if v == nil then
			if roblox_component and roblox_component ~= "" then
				v = p2.getTemplateForRobloxComponent(roblox_component)

				if v then
					v2 = false

					if not FFlagSduiErrorPaths then
						roblox_component = nil
					end
				else
					v = nil
					v2 = false
					roblox_component = nil
				end
			else
				v = nil
				v2 = false
				roblox_component = nil
			end
		else
			v2 = true
			roblox_component = nil
		end
	end

	local itemOverrides = resolveItemOverrides(p, p2)
	local result = {}

	if list[1] ~= nil or next(list) == nil then
		for _, item in list do
			local identifier

			if typeof(item) == "table" then
				identifier = item.identifier
			end

			if identifier == "" then
				identifier = nil
			end

			local v3

			if FFlagSduiErrorPaths then
				v3 = roblox_component
			end

			table.insert(result, buildBoundEntry(item, identifier, v, v2, v3, inputs, sort_rank, itemOverrides, p2))
		end
	else
		for k, item in list do
			local identifier = tostring(k)
			local v3

			if FFlagSduiErrorPaths then
				v3 = roblox_component
			end

			table.insert(result, buildBoundEntry(item, identifier, v, v2, v3, inputs, sort_rank, itemOverrides, p2))
		end
	end

	return result
end

return SduiListEntryNormalizer
