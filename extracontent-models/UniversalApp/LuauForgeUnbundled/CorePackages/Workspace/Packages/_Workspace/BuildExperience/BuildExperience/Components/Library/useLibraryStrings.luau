local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryTypes")

local v5 = {
	title = LocalizationStrings.LIBRARY_TITLE,
	empty = LocalizationStrings.LIBRARY_EMPTY,
	image = LocalizationStrings.LIBRARY_IMAGES_2D,
	sound = LocalizationStrings.LIBRARY_SOUNDS,
	modelUnavailable = LocalizationStrings.LIBRARY_MODEL_UNAVAILABLE,
	searchPlaceholder = LocalizationStrings.LIBRARY_SEARCH_PLACEHOLDER
}

local v6 = {
	model = { LocalizationStrings.LIBRARY_OBJECTS_3D, "3D Objects" },
	object = { LocalizationStrings.LIBRARY_OBJECT, "Object" },
	world = { LocalizationStrings.LIBRARY_WORLD, "World" },
	searchEmpty = { LocalizationStrings.LIBRARY_SEARCH_EMPTY, "No search results found" }
}

local function useLibraryStrings()
	local v7 = Localization.Hooks.useLocalization(v5)
	local v8 = React.useContext(Localization.LocalizationRoactContext)
	local clone = table.clone(v7)

	for k, v9 in v6 do
		local v10 = v9[1]
		local v11 = v9[2]
		local success, result = pcall(function()
			assert(v8 ~= nil, "Library localization context is unavailable")
			return v8:Format(v10)
		end)

		if success and type(result) == "string" and result ~= "" and result ~= v10 then
			v11 = result
		end

		clone[k] = v11
	end

	local ref = React.useRef(clone)

	for k, v9 in clone do
		if ref.current[k] ~= v9 then
			ref.current = clone
			break
		end
	end

	return ref.current
end

return useLibraryStrings
