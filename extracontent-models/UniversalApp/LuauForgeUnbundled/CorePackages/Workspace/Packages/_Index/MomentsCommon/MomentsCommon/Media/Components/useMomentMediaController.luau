local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/SignalsReact")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/MediaTypes")
local MediaPreloadProvider = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Components/MediaPreloadProvider")

local useSignalState = SignalsReact.useSignalState

local function useMomentMediaController(p2)
	local v5 = MediaPreloadProvider.useMediaControllerProvider()

	return useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p3)
			if v5 == nil then
				return nil
			end

			return v5.getControllerMap(p3)[p2]
		end)
	end, { v5, p2 })))
end

return useMomentMediaController
