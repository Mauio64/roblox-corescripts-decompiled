local CorePackages = game:GetService("CorePackages")
local Packages = CorePackages.Packages
local React = require(Packages.React)
local VideoCaptureService = game:GetService("VideoCaptureService")
local FaceAnimatorService = game:GetService("FaceAnimatorService")
local FaceChatUtils = require(script.Parent.Parent.Utils.FaceChatUtils)

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Analytics = require(RobloxGui.Modules.SelfView.Analytics)
local v = Analytics.new()

local TrackerMode = Enum.TrackerMode

local trackerMode = FaceChatUtils.getTrackerMode()
local v2 = trackerMode == TrackerMode.Video or trackerMode == TrackerMode.AudioVideo
local v3 = trackerMode == TrackerMode.Audio or trackerMode == TrackerMode.AudioVideo

return function()
	local state, setState = React.useState(TrackerMode.None)

	local v4 = React.useCallback(function()
		local trackerMode2 = FaceChatUtils.getTrackerMode()

		local v4 = trackerMode2 == TrackerMode.Video or trackerMode2 == TrackerMode.AudioVideo

		if v4 ~= v2 then
			v:reportCamState(v4)
			v2 = v4
		end

		local v5 = trackerMode2 == TrackerMode.Audio or trackerMode2 == TrackerMode.AudioVideo

		if v5 ~= v3 then
			v:reportMicState(v5)
			v3 = v5
		end

		setState(trackerMode2)
	end)

	React.useEffect(function()
		if not VideoCaptureService then
			return function() end
		end

		v4()
		local startedConnection = VideoCaptureService.Started:Connect(v4)
		local stoppedConnection = VideoCaptureService.Stopped:Connect(v4)
		local devicesChangedConnection = VideoCaptureService.DevicesChanged:Connect(v4)

		local videoAnimationEnabledChangedConnection = FaceAnimatorService:GetPropertyChangedSignal("VideoAnimationEnabled"):Connect(v4)

		local audioAnimationEnabledChangedConnection = FaceAnimatorService:GetPropertyChangedSignal("AudioAnimationEnabled"):Connect(v4)
		return function()
			startedConnection:Disconnect()
			stoppedConnection:Disconnect()
			devicesChangedConnection:Disconnect()
			videoAnimationEnabledChangedConnection:Disconnect()
			audioAnimationEnabledChangedConnection:Disconnect()
		end
	end, {})

	return state
end
