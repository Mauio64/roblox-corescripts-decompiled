local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local getGameMediaStore = require(Parent.DataHydration).Game.getGameMediaStore

local function useGameMediaForUniverse(n1: number) -- line: 21
	-- upvalues: React (copy), getGameMediaStore (copy), Signals (copy)
	local v7, v8 = React.useState(getGameMediaStore().getAndFetchGameMedia((tostring(n1))).data)

	React.useEffect(function() -- line: 25
		-- upvalues: Signals (copy), getGameMediaStore (copy), n1 (copy), v8 (copy)
		local v11 = Signals.createEffect(function(p1) -- line: 26
			-- upvalues: getGameMediaStore (copy), n1 (copy), v8 (copy)
			local v18 = getGameMediaStore(p1).getAndFetchGameMedia((tostring(n1)))

			v8(v18.data(p1))
		end)

		return function() -- line: 30
			-- upvalues: v11 (copy)
			v11()
		end
	end, { n1 })

	local v9 = React.useMemo(function() -- line: 35
		-- upvalues: n1 (copy)
		return string.format("rbxthumb://type=GameIcon&id=%d&w=512&h=512", n1)
	end, { n1 })
	local v10 = React.useMemo(function() -- line: 39
		-- upvalues: v7 (copy)
		if not v7 then
			return {}
		end

		local t1 = {}

		for v13, v14 in v7 do
			local s1 = "image"
			local v16 = nil

			if v14.videoId then
				s1 = "video"
				v16 = "rbxassetid://" .. tostring(v14.videoId)
			elseif v14.imageId then
				v16 = "rbxassetid://" .. tostring(v14.imageId)
			end

			table.insert(t1, {
				id = `thumbnail_{ v13 }`,
				mediaType = s1,
				assetSource = v16
			})
		end

		return t1
	end, { v7 })

	return {
		icon = v9,
		thumbnails = v10
	}
end

return useGameMediaForUniverse
