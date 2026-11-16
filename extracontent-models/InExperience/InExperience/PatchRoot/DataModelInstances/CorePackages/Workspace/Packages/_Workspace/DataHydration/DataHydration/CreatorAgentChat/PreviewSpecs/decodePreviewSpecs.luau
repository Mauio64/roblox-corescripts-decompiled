local PreviewSpecsTypes = require(script.Parent.PreviewSpecsTypes)

local function optionalString(value) -- 6 equivalent calls inferred from this helper
	return if typeof(value) == "string" then value else nil
end

local function decodePinned(pinned) -- 1 equivalent call inferred from this helper
	if pinned == PreviewSpecsTypes.PreviewSpecPinned.Pr or pinned == PreviewSpecsTypes.PreviewSpecPinned.Hash then
		return pinned
	end

	return nil
end

local function decodeItem(item)
	if typeof(item) ~= "table" then
		return nil
	end

	local pr_number = item.pr_number
	local override = item.override

	if typeof(pr_number) ~= "number" or typeof(override) ~= "string" or override == "" then
		return nil
	end

	return {
		prNumber = pr_number,
		title = optionalString(item.title) or "", -- inferred equivalent call
		draft = item.draft == true,
		override = override,
		publishedAt = optionalString(item.published_at), -- inferred equivalent call
		status = optionalString(item.status) or PreviewSpecsTypes.PreviewSpecStatus.Unverified, -- inferred equivalent call
		pinned = decodePinned(item.pinned) -- inferred equivalent call
	}
end

local function decodePreviewSpecs(data)
	if typeof(data) ~= "table" then
		error("preview-specs: response is not an object")
	end

	if data.schema_version ~= 1 then
		error(`preview-specs: unsupported schema_version {tostring(data.schema_version)}`)
	end

	if typeof(data.items) ~= "table" then
		error("preview-specs: items is not an array")
	end

	local items = {}

	for _, item in ipairs(data.items) do
		local v = decodeItem(item)

		if v ~= nil then
			table.insert(items, v)
		end
	end

	return {
		environment = optionalString(data.environment), -- inferred equivalent call
		agent = optionalString(data.agent), -- inferred equivalent call
		refreshedAt = optionalString(data.refreshed_at), -- inferred equivalent call
		items = items
	}
end

return decodePreviewSpecs
