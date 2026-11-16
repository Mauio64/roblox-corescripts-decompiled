local BuildExperience = script:FindFirstAncestor("BuildExperience")
require(BuildExperience.Stores.BuildLibrary.createBuildLibraryStore)
require(script.Parent.LibraryTypes)

return {
	fromItems = function(items, data)
		local result = {}

		for _, v in { "Model", "Image", "Sound" } do
			for _, item in items do
				if item.kind == v then
					local v2 = v == "Model" and "Models" or v == "Image" and "Images" or "Sounds"
					local title

					if v == "Model" then
						title = data.model
					elseif v == "Image" then
						title = data.image
					else
						title = data.sound
					end

					table.insert(result, { key = v2, title = title, itemKind = item.kind })
					break
				end
			end
		end

		return result
	end
}
