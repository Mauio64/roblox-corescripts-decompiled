local BuildExperience = script:FindFirstAncestor("BuildExperience")
local React = require(BuildExperience.Parent.React)
require(BuildExperience.Stores.BuildLibrary.createBuildLibraryStore)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local getLibraryMatches = require(script.Parent.getLibraryMatches)

local function useLibraryItems(p, p2, value, p3: string, count2: number, p4: string?, p5: string?)
	local v = React.useMemo(function()
		return {}
	end, {
		p,
		value or false,
		p3,
		p4 or false,
		p5 or false
	})
	local state, setState = React.useState({ key = v, count = count2 })
	local count3

	if state.key == v then
		count3 = state.count
	else
		count3 = count2
	end

	local libraryMatches = getLibraryMatches(p2, value, p3, p5, p3 ~= "")
	local count = #libraryMatches
	local v2 = table.move(libraryMatches, 1, math.min(count3, count), 1, {})
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
					surface = p4 == nil and "Browser" or "Category",
					kind = value or "All",
					scope = p5 == nil and "Root" or "Folder",
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
		p4 or false,
		p5 or false
	})
	return v2, selected, (React.useCallback(function()
		if selected then
			setState({
				key = v,
				count = count3 + count2
			})
		end
	end, { v, count3, count2, selected }))
end

return useLibraryItems
