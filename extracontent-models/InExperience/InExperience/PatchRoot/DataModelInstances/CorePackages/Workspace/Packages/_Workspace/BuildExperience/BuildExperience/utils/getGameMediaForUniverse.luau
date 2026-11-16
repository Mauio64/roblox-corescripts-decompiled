local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

local DataHydration = require(parent.DataHydration)
local getGameMediaStore = DataHydration.Game.getGameMediaStore

local function useGameMediaForUniverse(p: number)
	local state, setState = React.useState(getGameMediaStore().getAndFetchGameMedia((tostring(p))).data)

	React.useEffect(function()
		local effect = Signals.createEffect(function(p2)
			setState(getGameMediaStore(p2).getAndFetchGameMedia((tostring(p))).data(p2))
		end)
		return function()
			effect()
		end
	end, { p })

	return {
		icon = React.useMemo(function()
			return string.format("rbxthumb://type=GameIcon&id=%d&w=512&h=512", p)
		end, { p }),
		thumbnails = React.useMemo(function()
			if not state then
				return {}
			end

			local result = {}

			for _, v in state do
				local mediaType = "image"

				local videoId = tostring(v.videoId or v.imageId)
				local assetSource

				if v.videoId then
					assetSource = "rbxassetid://" .. tostring(v.videoId)
					mediaType = "video"
				elseif v.imageId then
					assetSource = "rbxassetid://" .. tostring(v.imageId)
				else
					continue
				end

				local assetResourceName

				if v.imageId then
					assetResourceName = `assets/{v.imageId}`
				end

				table.insert(result, {
					id = videoId,
					mediaType = mediaType,
					assetSource = assetSource,
					assetResourceName = assetResourceName
				})
			end

			return result
		end, { state })
	}
end

return useGameMediaForUniverse
