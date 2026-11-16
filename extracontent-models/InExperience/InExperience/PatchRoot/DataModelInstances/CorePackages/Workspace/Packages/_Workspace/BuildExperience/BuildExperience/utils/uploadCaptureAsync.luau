local parent = script:FindFirstAncestor("BuildExperience").Parent

local Promise = require(parent.Promise)

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local Debug = CreatorAgentChat.debug

local CaptureService = game:GetService("CaptureService")

local v = {}

local function uploadCaptureAsync(p)
	local success, result = pcall(function()
		return game:GetEngineFeature("CaptureServiceStartUploadCoreScriptBypass")
	end)

	if not success or result ~= true then
		return Promise.reject("Capture upload is not supported on this platform")
	end

	local assetId = v[p]

	if assetId then
		return Promise.resolve({ assetId = assetId })
	end

	Debug.log("info", "capture_upload starting")

	return Promise.new(function(callback, callback2)
		local success2, result2, v2 = pcall(function()
			return CaptureService:StartUploadCaptureAsync(p)
		end)

		if success2 then
			if result2 == Enum.UploadCaptureResult.Success then
				for _ = 1, 30 do
					task.wait(2)

					local success3, result3, assetId2 = pcall(function()
						return CaptureService:CheckUploadCaptureStatusAsync(v2)
					end)

					if success3 then
						if result3 == Enum.UploadCaptureResult.Success then
							Debug.log("info", "capture_upload succeeded", { assetId = assetId2 })
							v[p] = assetId2
							callback({ assetId = assetId2 })
							return
						elseif result3 ~= Enum.UploadCaptureResult.UploadPending then
							Debug.log("warn", "capture_upload failed", {
								status = tostring(result3)
							})
							callback2(`Upload failed: {tostring(result3)}`)
							return
						end
					else
						Debug.log("warn", "capture_upload poll error", { error = tostring(result3) })
						callback2(`Upload poll error: {result3}`)
						return
					end
				end

				callback2("Upload timed out")
			else
				Debug.log("warn", "capture_upload rejected", { status = tostring(result2) })
				callback2(`Upload rejected: {tostring(result2)}`)
			end
		else
			Debug.log("warn", "capture_upload start failed", { error = tostring(result2) })
			callback2(`Failed to start capture upload: {result2}`)
		end
	end)
end

return uploadCaptureAsync
