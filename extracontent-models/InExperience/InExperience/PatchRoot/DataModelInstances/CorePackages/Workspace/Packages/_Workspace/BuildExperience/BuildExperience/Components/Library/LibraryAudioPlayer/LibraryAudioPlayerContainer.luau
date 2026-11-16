local BuildExperience = script:FindFirstAncestor("BuildExperience")
local React = require(BuildExperience.Parent.React)
local LibraryAudioPlayerView = require(script.Parent.LibraryAudioPlayerView)
local useLibraryAudioPlayerViewModel = require(script.Parent.useLibraryAudioPlayerViewModel)

local function LibraryAudioPlayerContainer(p)
	local v = useLibraryAudioPlayerViewModel(p)
	return React.createElement(LibraryAudioPlayerView, v)
end

return LibraryAudioPlayerContainer
