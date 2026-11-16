local module = require("@luauforge/bundled/fwF")
local sduiApiStorePostConfigContentType = module.SduiApiStorePostConfigContentType
local sduiCapabilities = module.SduiCapabilities
local sduiResponseType = module.SduiResponseType
local getSduiApiStore = module.getSduiApiStore
local getSduiTemplateStore = module.getSduiTemplateStore

local module2 = require("@luauforge/bundled/fwM")

local module3 = require("@luauforge/bundled/fwJ")

local user_library_page = module2.apppageplatform.userlibrary.user_library_page

local v5 = {
	library = user_library_page.LibraryPageRequest,
	collection = user_library_page.CollectionPageRequest
}

local function readNextCursor(p2)
	local v6 = p2 and p2.page_entries[1]
	local kind = v6 and v6.input_data and v6.input_data.kind

	if kind == nil or kind.type ~= "user_library_list" then
		return nil
	end

	local next_cursor = kind.value.next_cursor

	if next_cursor == "" then
		return nil
	end

	return next_cursor
end

local function fetchPage(p2, p3, p4, p5)
	local page = module3.getPage(p2)

	if page == nil then
		warn(`UserLibrary: no page for scope kind {p2.kind}`)
		return nil
	end

	local v6 = v5[p2.kind]

	local v7 = module3.ApiBaseUrl .. page.path
	local configKey = module3.getConfigKey(page, p2, p3)

	local function buildBody(p6)
		return v6.new({
			collection_id = page.getLibraryCollectionId(p2),
			view = p3,
			cursor = p6,
			page_size = module3.PageSize,
			config_key = configKey,
			surface_key = page.surfaceKey,
			cached_roblox_component_to_template_id = getSduiTemplateStore().getCachedRobloxComponentToTemplateId(page.surfaceKey),
			client_capabilities = sduiCapabilities.buildClientCapabilities()
		})
	end

	local v8 = p3 ~= "VIEW_ALL"
	return getSduiApiStore().fetchIfNeeded({
		responseType = sduiResponseType.Protobuf,
		url = v7,
		surfaceKey = page.surfaceKey,
		configKey = configKey,
		loadTimer = p4,
		apiProto = user_library_page.PageResponse,
		postConfig = {
			contentType = sduiApiStorePostConfigContentType.Proto,
			protoMessage = v6,
			body = buildBody(nil)
		},
		enableTemplateCache = true,
		buildNextPageUrl = v8 and function(p6)
			local v9 = p6 and p6.page_entries[1]
			local kind = v9 and v9.input_data and v9.input_data.kind
			local next_cursor

			if not (kind == nil or kind.type ~= "user_library_list") then
				next_cursor = kind.value.next_cursor

				if next_cursor == "" then
					next_cursor = nil
				end
			end

			if next_cursor then
				return v7
			end

			return nil
		end or nil,
		buildNextPagePostBody = v8 and function(p6)
			local v9 = p6 and p6.page_entries[1]
			local kind = v9 and v9.input_data and v9.input_data.kind
			local next_cursor

			if not (kind == nil or kind.type ~= "user_library_list") then
				next_cursor = kind.value.next_cursor

				if next_cursor == "" then
					next_cursor = nil
				end
			end

			if next_cursor then
				return (buildBody(next_cursor))
			end

			return nil
		end or nil,
		buildRefreshPostBody = function()
			return buildBody(nil)
		end
	}, p5)
end

return fetchPage
