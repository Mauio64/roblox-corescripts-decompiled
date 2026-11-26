local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")

local enableAudioPlaybackInApp = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MediaPlayback").enableAudioPlaybackInApp

local feedPlaybackSuspension = MomentsCommon.Media.feedPlaybackSuspension

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local function CreationMediaProvider(p2)
	React.useEffect(function()
		enableAudioPlaybackInApp()
	end, {})

	React.useEffect(function()
		feedPlaybackSuspension.setSuspended(true)
		return function()
			feedPlaybackSuspension.setSuspended(false)
		end
	end, {})

	return React.createElement(React.Fragment, nil, p2.children)
end

return CreationMediaProvider
