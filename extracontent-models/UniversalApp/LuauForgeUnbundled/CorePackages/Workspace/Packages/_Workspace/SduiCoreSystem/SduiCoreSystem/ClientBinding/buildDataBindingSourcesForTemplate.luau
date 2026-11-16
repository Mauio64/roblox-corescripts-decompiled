require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/ServiceContractsProto")

local tryGetPathFromData = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/tryGetPathFromData")
local splitDottedPath = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/splitDottedPath")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiDataBindingContentType")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes")
local ProtoVariableMapper = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/ProtoVariableMapper")
local defaultHydrationIdPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/defaultHydrationIdPaths")

local function buildDataBindingSourcesForTemplate(p2, items)
	local dataBindingSourcesForTemplate = {}

	for k, item in items do
		local mapHydrationContentTypeToLua = ProtoVariableMapper.mapHydrationContentTypeToLua(item.content_type)

		if not mapHydrationContentTypeToLua then
			error(`Unsupported contentType {item.content_type}`)
		end

		local kind = item.id_binding and item.id_binding.kind and item.id_binding.kind.type
		local value = item.id_binding and item.id_binding.kind and item.id_binding.kind.value
		local v5 = nil

		if kind == "literal" and value then
			v5 = value
		elseif kind == "input_path" and value then
			local v7, v8 = tryGetPathFromData(p2, (splitDottedPath(value)))

			if v7 and v8 ~= nil then
				v5 = v8
			else
				error(`Unable to resolve path from inputPath: {value} in data`)
			end
		else
			local v6 = defaultHydrationIdPaths[mapHydrationContentTypeToLua]

			if v6 then
				local v7, v8 = tryGetPathFromData(p2, v6)

				if v7 and v8 ~= nil then
					v5 = v8
				else
					local joined = table.concat(v6, ",")
					error(`Unable to resolve default path: {joined} in data for contentType {mapHydrationContentTypeToLua}`)
				end
			else
				error(`Unable to find default for unknown contentType: {mapHydrationContentTypeToLua}`)
			end
		end

		local v6 = if item.alias and item.alias ~= "" then item.alias else mapHydrationContentTypeToLua
		dataBindingSourcesForTemplate[v6] = {
			contentType = mapHydrationContentTypeToLua,
			id = v5,
			fetchIfMissing = item.client_fetch
		}
	end

	return dataBindingSourcesForTemplate
end

return buildDataBindingSourcesForTemplate
