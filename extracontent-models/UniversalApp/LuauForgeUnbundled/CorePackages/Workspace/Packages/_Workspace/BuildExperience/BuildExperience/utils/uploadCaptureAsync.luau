local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Promise")

local Debug = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat").debug

local CaptureService = game:GetService("CaptureService")

local v5 = {}

local function uploadCaptureAsync(p2)
	local success, result = pcall(function()
		return game:GetEngineFeature("CaptureServiceStartUploadCoreScriptBypass")
	end)

	if not success or result ~= true then
		return Promise.reject("Capture upload is not supported on this platform")
	end

	local v6 = v5[p2]

	if v6 then
		return Promise.resolve({ assetId = v6 })
	end

	Debug.log("info", "capture_upload starting")

	return Promise.new(function(callback, callback2)
		local success2, result2, v7 = pcall(function()
			return CaptureService:StartUploadCaptureAsync(p2)
		end)

		if success2 then
			if result2 == Enum.UploadCaptureResult.Success then
				for i = 1, 30 do
					task.wait(2)

					local success3, result3, v8 = pcall(function()
						return CaptureService:CheckUploadCaptureStatusAsync(v7)
					end)

					if success3 then
						if result3 == Enum.UploadCaptureResult.Success then
							Debug.log("info", "capture_upload succeeded", {
								assetId = v8
							})
							v5[p2] = v8
							callback({ assetId = v8 })
							return
						elseif result3 ~= Enum.UploadCaptureResult.UploadPending then
							Debug.log("warn", "capture_upload failed", {
								status = tostring(result3)
							})
							callback2(`Upload failed: {tostring(result3)}`)
							return
						end
					else
						Debug.log("warn", "capture_upload poll error", {
							error = tostring(result3)
						})
						callback2(`Upload poll error: {result3}`)
						return
					end
				end

				callback2("Upload timed out")
			else
				Debug.log("warn", "capture_upload rejected", {
					status = tostring(result2)
				})
				callback2(`Upload rejected: {tostring(result2)}`)
			end
		else
			Debug.log("warn", "capture_upload start failed", {
				error = tostring(result2)
			})
			callback2(`Failed to start capture upload: {result2}`)
		end
	end)
end

return uploadCaptureAsync
