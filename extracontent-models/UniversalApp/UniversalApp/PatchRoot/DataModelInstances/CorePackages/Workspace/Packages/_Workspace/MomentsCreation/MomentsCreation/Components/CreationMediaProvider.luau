local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local React = require(MomentsCreationParent.React)

require(MomentsCreationParent.Signals)

local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local enableAudioPlaybackInApp = require(MomentsCreationParent.MediaPlayback).enableAudioPlaybackInApp
local feedPlaybackSuspension = MomentsCommon.Media.feedPlaybackSuspension

require(MomentsCreation.Types.CreationFlowTypes)

local function CreationMediaProvider(t1: {[any]: any}) -- line: 45
	-- upvalues: React (copy), enableAudioPlaybackInApp (copy), feedPlaybackSuspension (copy)
	React.useEffect(function() -- line: 46
		-- upvalues: enableAudioPlaybackInApp (copy)
		enableAudioPlaybackInApp()
	end, {})
	React.useEffect(function() -- line: 51
		-- upvalues: feedPlaybackSuspension (copy)
		feedPlaybackSuspension.setSuspended(true)

		return function() -- line: 53
			-- upvalues: feedPlaybackSuspension (copy)
			feedPlaybackSuspension.setSuspended(false)
		end
	end, {})

	return React.createElement(React.Fragment, nil, t1.children)
end

return CreationMediaProvider
