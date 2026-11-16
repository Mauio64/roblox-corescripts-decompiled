local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")

local getGameMediaStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration").Game.getGameMediaStore

local function useGameMediaForUniverse(p2)
	local state, setState = React.useState(getGameMediaStore().getAndFetchGameMedia((tostring(p2))).data)

	React.useEffect(function()
		local effect = Signals.createEffect(function(p3)
			setState(getGameMediaStore(p3).getAndFetchGameMedia((tostring(p2))).data(p3))
		end)
		return function()
			effect()
		end
	end, { p2 })

	return {
		icon = React.useMemo(function()
			return string.format("rbxthumb://type=GameIcon&id=%d&w=512&h=512", p2)
		end, { p2 }),
		thumbnails = React.useMemo(function()
			if not state then
				return {}
			end

			local result = {}

			for k, v5 in state do
				local v6 = "image"

				local videoId = tostring(v5.videoId or v5.imageId)
				local v7

				if v5.videoId then
					v7 = "rbxassetid://" .. tostring(v5.videoId)
					v6 = "video"
				elseif v5.imageId then
					v7 = "rbxassetid://" .. tostring(v5.imageId)
				else
					continue
				end

				local v9 = if v5.imageId then `assets/{v5.imageId}` else nil
				table.insert(result, {
					id = videoId,
					mediaType = v6,
					assetSource = v7,
					assetResourceName = v9
				})
			end

			return result
		end, { state })
	}
end

return useGameMediaForUniverse
