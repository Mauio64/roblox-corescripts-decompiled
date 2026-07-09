local AppMusicPlayer = script:FindFirstAncestor("AppMusicPlayer")
local Cryo = require(AppMusicPlayer.Parent.Cryo)
local React = require(AppMusicPlayer.Parent.React)
local RoactUtils = require(AppMusicPlayer.Parent.RoactUtils)
local TopicContentsRodux = require(AppMusicPlayer.Parent.TopicContentsRodux)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local TopicContentsReducer = TopicContentsRodux.TopicContentsReducer
local useMemo = React.useMemo

local function useMusicTop100Playlist() -- line: 13
	-- upvalues: useSelector (copy), TopicContentsReducer (copy), useMemo (copy), Cryo (copy)
	local v10 = useSelector(function(p1) -- line: 14
		-- upvalues: TopicContentsReducer (copy)
		local Personalization = p1.Personalization
		local v13 = if not Personalization then nil else Personalization[TopicContentsReducer.key]
		local v14 = if not v13 then nil else v13["music-top-100"]

		if v14 then
			return v14.entries
		end

		return nil
	end)

	return (useMemo(function() -- line: 21
		-- upvalues: v10 (copy), Cryo (copy)
		if v10 then
			return Cryo.List.map(v10, function(p2) -- line: 23
				return (tostring(p2.contentId))
			end)
		end

		return {}
	end, { v10 }))
end

return useMusicTop100Playlist
