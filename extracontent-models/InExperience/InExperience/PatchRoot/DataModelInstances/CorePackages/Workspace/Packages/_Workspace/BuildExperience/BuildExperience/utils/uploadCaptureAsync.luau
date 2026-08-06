local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Promise = require(Parent.Promise)
local debug = require(Parent.DataHydration.CreatorAgentChat).debug
local CaptureService = game:GetService("CaptureService")
local t1 = {}

local function uploadCaptureAsync(p1) -- line: 20
	-- upvalues: Promise (copy), t1 (copy), debug (copy), CaptureService (copy)
	local ok, result = pcall(function() -- line: 21
		return game:GetEngineFeature("CaptureServiceStartUploadCoreScriptBypass")
	end)

	if not ok or result ~= true then
		return Promise.reject("Capture upload is not supported on this platform")
	end

	local v10 = t1[p1]

	if v10 then
		return Promise.resolve({
			assetId = v10
		})
	end

	debug.log("info", "capture_upload starting")

	return Promise.new(function(resolve, reject) -- line: 35
		-- upvalues: CaptureService (copy), p1 (copy), debug (copy), t1 (copy)
		local ok2, result2, v15 = pcall(function() -- line: 36
			-- upvalues: CaptureService (copy), p1 (copy)
			return CaptureService:StartUploadCaptureAsync(p1)
		end)

		if not ok2 then
			debug.log("warn", "capture_upload start failed", {
				error = tostring(result2)
			})
			reject(`Failed to start capture upload: { result2 }`)

			return
		end

		if result2 ~= Enum.UploadCaptureResult.Success then
			debug.log("warn", "capture_upload rejected", {
				status = tostring(result2)
			})
			reject(`Upload rejected: { tostring(result2) }`)

			return
		end

		for _ = 1, 30 do
			task.wait(2)

			local ok3, result3, v19 = pcall(function() -- line: 55
				-- upvalues: CaptureService (copy), v15 (copy)
				return CaptureService:CheckUploadCaptureStatusAsync(v15)
			end)

			if not ok3 then
				debug.log("warn", "capture_upload poll error", {
					error = tostring(result3)
				})
				reject(`Upload poll error: { result3 }`)

				return
			end

			if result3 == Enum.UploadCaptureResult.Success then
				debug.log("info", "capture_upload succeeded", {
					assetId = v19
				})
				t1[p1] = v19
				resolve({
					assetId = v19
				})

				return
			end

			if result3 ~= Enum.UploadCaptureResult.UploadPending then
				debug.log("warn", "capture_upload failed", {
					status = tostring(result3)
				})
				reject(`Upload failed: { tostring(result3) }`)

				return
			end
		end

		reject("Upload timed out")
	end)
end

return uploadCaptureAsync
