local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
require(script.Parent.LibraryTypes)

local v = {
	title = LocalizationStrings.LIBRARY_TITLE,
	empty = LocalizationStrings.LIBRARY_EMPTY,
	image = LocalizationStrings.LIBRARY_IMAGES_2D,
	sound = LocalizationStrings.LIBRARY_SOUNDS,
	modelUnavailable = LocalizationStrings.LIBRARY_MODEL_UNAVAILABLE,
	searchPlaceholder = LocalizationStrings.LIBRARY_SEARCH_PLACEHOLDER
}

local v2 = {
	model = { LocalizationStrings.LIBRARY_OBJECTS_3D, "3D Objects" },
	object = { LocalizationStrings.LIBRARY_OBJECT, "Object" },
	world = { LocalizationStrings.LIBRARY_WORLD, "World" },
	searchEmpty = { LocalizationStrings.LIBRARY_SEARCH_EMPTY, "No search results found" },
	selectAll = { LocalizationStrings.LIBRARY_SELECT_ALL, "Select all" },
	selectFirst = { LocalizationStrings.LIBRARY_SELECT_FIRST, "Select first {count}" }
}

local function useLibraryStrings()
	local v3 = Localization.Hooks.useLocalization(v)
	local v4 = React.useContext(Localization.LocalizationRoactContext)
	local clone = table.clone(v3)

	for k, v5 in v2 do
		local v6 = v5[1]
		local v7 = v5[2]
		local success, result = pcall(function()
			assert(v4 ~= nil, "Library localization context is unavailable")
			return v4:Format(v6)
		end)

		if success and type(result) == "string" and result ~= "" and result ~= v6 then
			v7 = result
		end

		clone[k] = v7
	end

	local ref = React.useRef(clone)

	for k, v5 in clone do
		if ref.current[k] ~= v5 then
			ref.current = clone
			break
		end
	end

	return ref.current
end

return useLibraryStrings
