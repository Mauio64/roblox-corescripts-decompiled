local SduiStreamingResponseUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiStreamingResponseUtils")

local function createSduiStreamingResponseHandler(data)
	local count = 0
	local v5 = nil
	local v6 = nil
	local v7 = ""

	local function processExtractedFrames(result)
		for k, item in result do
			local v8, v9 = data.processFrame(item)

			if v8 then
				count += 1
				v5 = v9
			else
				v6 = v9
				break
			end
		end
	end

	local function extractAndProcessFrames(p2)
		local success, result, v8 = pcall(SduiStreamingResponseUtils.extractFrames, p2)

		if not success then
			v6 = result
			return
		end

		v7 = v8
		processExtractedFrames(result)
	end

	return {
		handleChunk = function(list)
			data.loadTimer.logUiStreamChunkReceived()

			if #list == 0 or v6 ~= nil then
				return
			end

			v7 ..= list
			local v8 = v7
			local success, result, v9 = pcall(SduiStreamingResponseUtils.extractFrames, v8)

			if not success then
				v6 = result
				return
			end

			v7 = v9
			processExtractedFrames(result)
		end,
		finalize = function(value)
			if count == 0 and not SduiStreamingResponseUtils.isEmptyResponseBody(value) then
				if typeof(value) == "buffer" then
					value = buffer.tostring(value)
				end

				if typeof(value) == "string" and #value > 0 then
					v7 = value
					local v8 = v7
					local success, result, v9 = pcall(SduiStreamingResponseUtils.extractFrames, v8)

					if success then
						v7 = v9
						processExtractedFrames(result)
					else
						v6 = result
					end
				end
			end

			if v6 ~= nil then
				return { ok = false, value = v6 }
			end

			if #v7 > 0 then
				return {
					ok = false,
					value = `Streaming response for {data.configKey} ended with {#v7} undecoded bytes remaining`
				}
			end

			if count > 0 then
				return { ok = true, value = v5 }
			end

			return {
				ok = false,
				value = `Streaming request for {data.configKey} completed without receiving data`
			}
		end
	}
end

return createSduiStreamingResponseHandler
