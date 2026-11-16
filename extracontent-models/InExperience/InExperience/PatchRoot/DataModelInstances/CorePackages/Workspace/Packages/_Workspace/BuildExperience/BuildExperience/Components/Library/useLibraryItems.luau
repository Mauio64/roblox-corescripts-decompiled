local BuildExperience = script:FindFirstAncestor("BuildExperience")
local React = require(BuildExperience.Parent.React)
require(BuildExperience.Stores.BuildLibrary.createBuildLibraryStore)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)

local function useLibraryItems(p, items, value, value2: string, count2: number, p2: string?, p3: string?)
	local v = React.useMemo(function()
		return {}
	end, {
		p,
		value or false,
		value2,
		p2 or false,
		p3 or false
	})
	local state, setState = React.useState({ key = v, count = count2 })
	local count3

	if state.key == v then
		count3 = state.count
	else
		count3 = count2
	end

	local result = {}
	local count = 0
	local v2 = string.lower(value2)
	local folderIdsById = {}

	if v2 ~= "" and p3 ~= nil then
		for _, item in items do
			if item.className == "Folder" and item.folderId ~= nil then
				folderIdsById[item.id] = item.folderId
			end
		end
	end

	for _, item in items do
		local v3 = item.folderId == p3

		if v2 ~= "" then
			local v4 = item.folderId

			while p3 ~= nil and v4 ~= nil and v4 ~= p3 do
				v4 = folderIdsById[v4]
			end

			if item.className == "Folder" then
				v3 = false
			else
				v3 = p3 == nil or v4 == p3
			end
		end

		if not ((value == nil or item.kind == value) and v3) then
			continue
		end

		if not (v2 == "" or string.find(string.lower(item.displayName), v2, 1, true) ~= nil) then
			continue
		end

		count += 1

		if count <= count3 then
			table.insert(result, item)
		end
	end

	local selected = count3 < count
	local ref = React.useRef({ key = v, count = count3 })
	React.useEffect(function()
		local current = ref.current

		if current.key == v and count3 > current.count then
			local v3 = math.min(count3, count) - math.min(current.count, count)

			if v3 > 0 then
				sendBuildExperienceEvent("LIBRARY_LOAD_MORE", {
					universeId = game.GameId,
					placeId = game.PlaceId
				}, {
					surface = p2 == nil and "Browser" or "Category",
					kind = value or "All",
					scope = p3 == nil and "Root" or "Folder",
					addedCount = tostring(v3),
					visibleCount = tostring((math.min(count3, count)))
				})
			end
		end

		ref.current = { key = v, count = count3 }
	end, {
		v,
		count3,
		count,
		value or false,
		p2 or false,
		p3 or false
	})
	return result, selected, (React.useCallback(function()
		if selected then
			setState({
				key = v,
				count = count3 + count2
			})
		end
	end, { v, count3, count2, selected }))
end

return useLibraryItems
