local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

local parent = SduiCoreSystem.Parent
require(parent.ServiceContractsProto)

local tryGetPathFromData = require(SduiCoreSystem.ClientBinding.tryGetPathFromData)
local splitDottedPath = require(SduiCoreSystem.ClientBinding.splitDottedPath)
require(SduiCoreSystem.ClientBinding.SduiDataBindingContentType)
require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local ProtoVariableMapper = require(SduiCoreSystem.ClientBinding.ProtoVariableMapper)
local defaultHydrationIdPaths = require(SduiCoreSystem.ClientBinding.defaultHydrationIdPaths)

local function buildDataBindingSourcesForTemplate(p, items)
	local dataBindingSourcesForTemplate = {}

	for _, item in items do
		local mapHydrationContentTypeToLua = ProtoVariableMapper.mapHydrationContentTypeToLua(item.content_type)

		if not mapHydrationContentTypeToLua then
			error(`Unsupported contentType {item.content_type}`)
		end

		local kind = item.id_binding and item.id_binding.kind and item.id_binding.kind.type
		local value = item.id_binding and item.id_binding.kind and item.id_binding.kind.value
		local id = nil

		if kind == "literal" and value then
			id = value
		elseif kind == "input_path" and value then
			local v, v2 = tryGetPathFromData(p, (splitDottedPath(value)))

			if v and v2 ~= nil then
				id = v2
			else
				error(`Unable to resolve path from inputPath: {value} in data`)
			end
		else
			local defaultHydrationIdPath = defaultHydrationIdPaths[mapHydrationContentTypeToLua]

			if defaultHydrationIdPath then
				local v, v2 = tryGetPathFromData(p, defaultHydrationIdPath)

				if v and v2 ~= nil then
					id = v2
				else
					local joined = table.concat(defaultHydrationIdPath, ",")
					error(`Unable to resolve default path: {joined} in data for contentType {mapHydrationContentTypeToLua}`)
				end
			else
				error(`Unable to find default for unknown contentType: {mapHydrationContentTypeToLua}`)
			end
		end

		local v

		if item.alias and item.alias ~= "" then
			v = item.alias
		else
			v = mapHydrationContentTypeToLua
		end

		dataBindingSourcesForTemplate[v] = {
			contentType = mapHydrationContentTypeToLua,
			id = id,
			fetchIfMissing = item.client_fetch
		}
	end

	return dataBindingSourcesForTemplate
end

return buildDataBindingSourcesForTemplate
