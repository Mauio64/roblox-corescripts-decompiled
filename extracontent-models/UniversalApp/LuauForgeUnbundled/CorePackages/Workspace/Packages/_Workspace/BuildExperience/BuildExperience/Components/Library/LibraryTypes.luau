require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/BuildLibrary/createBuildLibraryStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local clientDataModelCollector = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/clientDataModelCollector")

return {
	toResourceUri = function(p2)
		return "rbx-dm:" .. p2
	end,
	toResourceAttachment = function(p2)
		return {
			type = "resource_link",
			name = p2.displayName,
			uri = "rbx-dm:" .. p2.path,
			mimeType = "datamodel.instance/v1"
		}
	end,
	toChatResource = function(data)
		local v5 = if data.instance == nil then data.path else clientDataModelCollector.getInstancePath(data.instance)
		return { path = v5, displayName = data.displayName, className = data.className }
	end
}
