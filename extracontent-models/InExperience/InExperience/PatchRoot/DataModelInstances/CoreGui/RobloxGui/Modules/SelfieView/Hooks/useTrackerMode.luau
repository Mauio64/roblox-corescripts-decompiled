local Packages = game:GetService("CorePackages").Packages
local React = require(Packages.React)
local VideoCaptureService = game:GetService("VideoCaptureService")
local FaceAnimatorService = game:GetService("FaceAnimatorService")
local FaceChatUtils = require(script.Parent.Parent.Utils.FaceChatUtils)
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local v7 = require(RobloxGui.Modules.SelfView.Analytics).new()
local TrackerMode = Enum.TrackerMode
local v9 = FaceChatUtils.getTrackerMode()
local u10 = v9 == TrackerMode.Video or v9 == TrackerMode.AudioVideo
local u11 = v9 == TrackerMode.Audio or v9 == TrackerMode.AudioVideo

return function() -- line: 23
	-- upvalues: React (copy), TrackerMode (copy), FaceChatUtils (copy), u10 (ref), v7 (copy), u11 (ref), VideoCaptureService (copy), FaceAnimatorService (copy)
	local v12, v13 = React.useState(TrackerMode.None)
	local v14 = React.useCallback(function() -- line: 26
		-- upvalues: FaceChatUtils (copy), TrackerMode (copy), u10 (ref), v7 (copy), u11 (ref), v13 (copy)
		local v15 = FaceChatUtils.getTrackerMode()
		local v16 = v15 == TrackerMode.Video or v15 == TrackerMode.AudioVideo

		if v16 ~= u10 then
			v7:reportCamState(v16)
			u10 = v16
		end

		local v17 = v15 == TrackerMode.Audio or v15 == TrackerMode.AudioVideo

		if v17 ~= u11 then
			v7:reportMicState(v17)
			u11 = v17
		end

		v13(v15)
	end)

	React.useEffect(function() -- line: 45
		-- upvalues: VideoCaptureService (copy), v14 (copy), FaceAnimatorService (copy)
		if VideoCaptureService then
			v14()

			local connection = VideoCaptureService.Started:Connect(v14)
			local connection2 = VideoCaptureService.Stopped:Connect(v14)
			local connection3 = VideoCaptureService.DevicesChanged:Connect(v14)
			local connection4 = FaceAnimatorService:GetPropertyChangedSignal("VideoAnimationEnabled"):Connect(v14)
			local connection5 = FaceAnimatorService:GetPropertyChangedSignal("AudioAnimationEnabled"):Connect(v14)

			return function() -- line: 55
				-- upvalues: connection (copy), connection2 (copy), connection3 (copy), connection4 (copy), connection5 (copy)
				connection:Disconnect()
				connection2:Disconnect()
				connection3:Disconnect()
				connection4:Disconnect()
				connection5:Disconnect()
			end
		end

		return function() -- line: 63
		end
	end, {})

	return v12
end
