local BuildExperience = script:FindFirstAncestor("BuildExperience")
require(BuildExperience.Stores.BuildLibrary.createBuildLibraryStore)
require(BuildExperience.Chat.chatTypes)
local clientDataModelCollector = require(BuildExperience.Chat.clientDataModelCollector)

local function toResourceUri(path: string) -- 1 equivalent call inferred from this helper
	return "rbx-dm:" .. path
end

local LibraryTypes = {}
LibraryTypes.toResourceUri = toResourceUri

function LibraryTypes.toResourceAttachment(p)
	return {
		type = "resource_link",
		name = p.displayName,
		uri = toResourceUri(p.path), -- inferred equivalent call
		mimeType = "datamodel.instance/v1"
	}
end

function LibraryTypes.toChatResource(data)
	local path

	if data.instance == nil then
		path = data.path
	else
		path = clientDataModelCollector.getInstancePath(data.instance)
	end

	return { path = path, displayName = data.displayName, className = data.className }
end

return LibraryTypes
