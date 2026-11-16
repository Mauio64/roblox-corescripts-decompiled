local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")

local SduiStreamingResponseUtils = require(SduiSharedUtilities.SduiStreamingResponseUtils)

local function createSduiStreamingResponseHandler(data)
	local count = 0
	local v = nil
	local v2 = nil
	local v3 = ""

	local function processExtractedFrames(result)
		for _, item in result do
			local v4, v5 = data.processFrame(item)

			if v4 then
				count += 1
				v = v5
			else
				v2 = v5
				break
			end
		end
	end

	local function extractAndProcessFrames(p: string) -- 2 equivalent calls inferred from this helper
		local success, result, v4 = pcall(SduiStreamingResponseUtils.extractFrames, p)

		if not success then
			v2 = result
			return
		end

		v3 = v4
		processExtractedFrames(result)
	end

	return {
		handleChunk = function(list: string)
			data.loadTimer.logUiStreamChunkReceived()

			if #list == 0 or v2 ~= nil then
				return
			end

			v3 ..= list
			extractAndProcessFrames(v3) -- inferred equivalent call
		end,
		finalize = function(value)
			if count == 0 and not SduiStreamingResponseUtils.isEmptyResponseBody(value) then
				if typeof(value) == "buffer" then
					value = buffer.tostring(value)
				end

				if typeof(value) == "string" and #value > 0 then
					v3 = value
					extractAndProcessFrames(v3) -- inferred equivalent call
				end
			end

			if v2 ~= nil then
				return { ok = false, value = v2 }
			end

			if #v3 > 0 then
				return {
					ok = false,
					value = `Streaming response for {data.configKey} ended with {#v3} undecoded bytes remaining`
				}
			end

			if count > 0 then
				return { ok = true, value = v }
			end

			return {
				ok = false,
				value = `Streaming request for {data.configKey} completed without receiving data`
			}
		end
	}
end

return createSduiStreamingResponseHandler
