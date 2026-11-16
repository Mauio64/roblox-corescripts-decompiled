local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local React = require(parent.React)
require(parent.Signals)
local MomentsCommon = require(parent.MomentsCommon)

local MediaPlayback = require(parent.MediaPlayback)
local enableAudioPlaybackInApp = MediaPlayback.enableAudioPlaybackInApp

local feedPlaybackSuspension = MomentsCommon.Media.feedPlaybackSuspension

require(MomentsCreation.Types.CreationFlowTypes)

local function CreationMediaProvider(p)
	React.useEffect(function()
		enableAudioPlaybackInApp()
	end, {})

	React.useEffect(function()
		feedPlaybackSuspension.setSuspended(true)
		return function()
			feedPlaybackSuspension.setSuspended(false)
		end
	end, {})

	return React.createElement(React.Fragment, nil, p.children)
end

return CreationMediaProvider
