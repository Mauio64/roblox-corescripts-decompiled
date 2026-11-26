local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiErrorPaths

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes")

local function tryResolveTemplatePair(roblox_component, inline_component, p2)
	if inline_component ~= nil then
		return inline_component, true, nil
	end

	local v5 = roblox_component
		and roblox_component ~= ""
		and p2.getTemplateForRobloxComponent(roblox_component)

	if not v5 then
		return nil, false, nil
	end

	local v6 = false

	if fFlagSduiErrorPaths then
		return v5, false, roblox_component
	end

	return v5, v6, nil
end

local function resolveItemOverrides(items, p2)
	if items == nil or next(items) == nil then
		return nil
	end

	local result = {}

	for k, item in items do
		local roblox_component = item.roblox_component
		local v5 = item.inline_component
		local v6

		if v5 == nil then
			if roblox_component and roblox_component ~= "" then
				v5 = p2.getTemplateForRobloxComponent(roblox_component)

				if v5 then
					v6 = false

					if not fFlagSduiErrorPaths then
						roblox_component = nil
					end
				else
					v5 = nil
					v6 = false
					roblox_component = nil
				end
			else
				v5 = nil
				v6 = false
				roblox_component = nil
			end
		else
			v6 = true
			roblox_component = nil
		end

		if not fFlagSduiErrorPaths then
			roblox_component = nil
		end

		result[k] = {
			template = v5,
			isInline = v6,
			robloxComponent = roblox_component,
			inputs = item.inputs,
			sortRankProp = item.sort_rank
		}
	end

	return result
end

local function pickTemplate(p2, data, p3, p4, p5, p6)
	local roblox_component = if typeof(p2) == "table" then p2.roblox_component else nil
	local v5 = if typeof(p2) == "table" then p2.inline_component else nil
	local v6

	if v5 == nil then
		if roblox_component then
			v5 = roblox_component ~= "" and p6.getTemplateForRobloxComponent(roblox_component)

			if v5 then
				v6 = false

				if not fFlagSduiErrorPaths then
					roblox_component = nil
				end
			else
				v5 = nil
				v6 = false
				roblox_component = nil
			end
		else
			v5 = nil
			v6 = false
			roblox_component = nil
		end
	else
		v6 = true
		roblox_component = nil
	end

	if v5 then
		if fFlagSduiErrorPaths then
			return v5, v6, roblox_component
		end

		return v5, v6, nil
	elseif data and data.template then
		local template = data.template
		local isInline = data.isInline

		if fFlagSduiErrorPaths then
			return template, isInline, data.robloxComponent
		end

		return template, isInline, nil
	elseif fFlagSduiErrorPaths then
		return p3, p4, p5
	else
		return p3, p4, nil
	end
end

local function resolveDefaultTemplate(p2, p3)
	if p2 == nil then
		return nil, false, nil
	end

	return tryResolveTemplatePair(p2.roblox_component, p2.inline_component, p3)
end

local function buildBoundEntry(p2, p3, p4, p5, p6, inputs, sortRankProp, p7, p8)
	local v5 = if p7 and p3 then p7[p3] else nil

	if not fFlagSduiErrorPaths then
		p6 = nil
	end

	local v7, v8, v9 = pickTemplate(p2, v5, p4, p5, p6, p8)

	local sort_rank = if typeof(p2) == "table" then p2.sort_rank else nil

	inputs = v5 and v5.inputs or inputs

	if not fFlagSduiErrorPaths then
		v9 = nil
	end

	sortRankProp = if sort_rank then sort_rank else v5 and v5.sortRankProp or sortRankProp
	return {
		item = p2,
		identifier = p3,
		sourceMode = "data",
		inputs = inputs,
		template = v7,
		isInline = v8,
		robloxComponent = v9,
		sortRankProp = sortRankProp
	}
end

return {
	normalizeLiteralItems = function(items, data, p2)
		local inputs = if data then data.inputs else nil
		local sort_rank = if data then data.sort_rank else nil
		local roblox_component, v5, v6

		if data == nil then
			v6 = false
		else
			roblox_component = data.roblox_component
			v5 = data.inline_component

			if v5 == nil then
				if roblox_component and roblox_component ~= "" then
					v5 = p2.getTemplateForRobloxComponent(roblox_component)

					if v5 then
						v6 = false

						if not fFlagSduiErrorPaths then
							roblox_component = nil
						end
					else
						roblox_component = nil
						v5 = nil
						v6 = false
					end
				else
					roblox_component = nil
					v5 = nil
					v6 = false
				end
			else
				roblox_component = nil
				v6 = true
			end
		end

		local literalItems = {}

		for k, item in items do
			local identifier = item.identifier

			if identifier == "" then
				identifier = nil
			end

			local v7 = if fFlagSduiErrorPaths then roblox_component else nil
			local v8 = if typeof(item) == "table" then item.roblox_component else nil
			local v9 = if typeof(item) == "table" then item.inline_component else nil
			local v10

			if v9 == nil then
				if v8 and v8 ~= "" then
					v9 = p2.getTemplateForRobloxComponent(v8)

					if v9 then
						v10 = false

						if not fFlagSduiErrorPaths then
							v8 = nil
						end
					else
						v9 = nil
						v10 = false
						v8 = nil
					end
				else
					v9 = nil
					v10 = false
					v8 = nil
				end
			else
				v10 = true
				v8 = nil
			end

			if v9 then
				if not fFlagSduiErrorPaths then
					v8 = nil
				end
			elseif fFlagSduiErrorPaths then
				v8 = v7
				v10 = v6
				v9 = v5
			else
				v10 = v6
				v9 = v5
				v8 = nil
			end

			local v11 = {
				item = item,
				identifier = identifier,
				sourceMode = "literal",
				inputs = item.inputs or inputs,
				template = v9,
				isInline = v10,
				robloxComponent = 0,
				sortRankProp = 0
			}

			if not fFlagSduiErrorPaths then
				v8 = nil
			end

			v11.robloxComponent = v8
			v11.sortRankProp = item.sort_rank or sort_rank
			table.insert(literalItems, v11)
		end

		return literalItems
	end,
	normalizeBoundData = function(list, data, p2, p3)
		if typeof(list) ~= "table" then
			return {}
		end

		local inputs = if data then data.inputs else nil
		local sort_rank = if data then data.sort_rank else nil
		local v5, v6, roblox_component

		if data == nil then
			v6 = false
		else
			roblox_component = data.roblox_component
			v5 = data.inline_component

			if v5 == nil then
				if roblox_component and roblox_component ~= "" then
					v5 = p3.getTemplateForRobloxComponent(roblox_component)

					if v5 then
						v6 = false

						if not fFlagSduiErrorPaths then
							roblox_component = nil
						end
					else
						v5 = nil
						v6 = false
						roblox_component = nil
					end
				else
					v5 = nil
					v6 = false
					roblox_component = nil
				end
			else
				v6 = true
				roblox_component = nil
			end
		end

		local itemOverrides = resolveItemOverrides(p2, p3)
		local result = {}

		if list[1] ~= nil or next(list) == nil then
			for k, item in list do
				local identifier = if typeof(item) == "table" then item.identifier else nil

				if identifier == "" then
					identifier = nil
				end

				local v8 = if fFlagSduiErrorPaths then roblox_component else nil
				table.insert(
					result,
					buildBoundEntry(item, identifier, v5, v6, v8, inputs, sort_rank, itemOverrides, p3)
				)
			end
		else
			for k, item in list do
				local v8 = tostring(k)
				local v9 = if fFlagSduiErrorPaths then roblox_component else nil
				table.insert(
					result,
					buildBoundEntry(item, v8, v5, v6, v9, inputs, sort_rank, itemOverrides, p3)
				)
			end
		end

		return result
	end
}
