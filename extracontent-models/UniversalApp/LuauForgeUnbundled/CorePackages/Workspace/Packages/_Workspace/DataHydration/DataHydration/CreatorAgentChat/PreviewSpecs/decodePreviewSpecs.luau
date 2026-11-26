local PreviewSpecsTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/PreviewSpecs/PreviewSpecsTypes")

local function optionalString(value)
	if typeof(value) == "string" then
		return value
	end

	return nil
end

local function decodePinned(p2)
	if p2 == PreviewSpecsTypes.PreviewSpecPinned.Pr or p2 == PreviewSpecsTypes.PreviewSpecPinned.Hash then
		return p2
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

	local title = item.title

	if typeof(title) ~= "string" then
		title = nil
	end

	local v5 = {
		prNumber = pr_number,
		title = title or "",
		draft = item.draft == true,
		override = override,
		publishedAt = 0,
		status = 0,
		pinned = 0
	}

	local published_at = item.published_at

	if typeof(published_at) ~= "string" then
		published_at = nil
	end

	v5.publishedAt = published_at
	local status = item.status

	if typeof(status) ~= "string" then
		status = nil
	end

	v5.status = status or PreviewSpecsTypes.PreviewSpecStatus.Unverified
	local pinned = item.pinned

	if pinned ~= PreviewSpecsTypes.PreviewSpecPinned.Pr and pinned ~= PreviewSpecsTypes.PreviewSpecPinned.Hash then
		pinned = nil
	end

	v5.pinned = pinned
	return v5
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

	local v5 = {}

	for i, item in ipairs(data.items) do
		local v6 = decodeItem(item)

		if v6 ~= nil then
			table.insert(v5, v6)
		end
	end

	local environment = data.environment

	if typeof(environment) ~= "string" then
		environment = nil
	end

	local agent = data.agent

	if typeof(agent) ~= "string" then
		agent = nil
	end

	local refreshed_at = data.refreshed_at

	if typeof(refreshed_at) ~= "string" then
		refreshed_at = nil
	end

	return {
		environment = environment,
		agent = agent,
		refreshedAt = refreshed_at,
		items = v5
	}
end

return decodePreviewSpecs
