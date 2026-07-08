local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiStreamingResponseUtils = require(SduiSharedUtilities.SduiStreamingResponseUtils)

local function createSduiStreamingResponseHandler(t1: {[any]: any}) -- line: 20
	-- upvalues: SduiStreamingResponseUtils (copy)
	local n1 = 0
	local u6 = nil
	local u7 = nil
	local s1 = ""

	local function processExtractedFrames(t2: {[any]: any}) -- line: 28
		-- upvalues: t1 (copy), n1 (ref), u6 (ref), u7 (ref)
		for _, v13 in t2 do
			local v14, v15 = t1.processFrame(v13)

			if not v14 then
				u7 = v15

				return
			end

			n1 += 1
			u6 = v15
		end
	end
	local function extractAndProcessFrames(s2: string) -- line: 41
		-- upvalues: SduiStreamingResponseUtils (copy), u7 (ref), s1 (ref), processExtractedFrames (copy)
		local ok, result, v19 = pcall(SduiStreamingResponseUtils.extractFrames, s2)

		if not ok then
			u7 = result

			return
		end

		s1 = v19
		processExtractedFrames(result)
	end

	return {
		handleChunk = function(s3: string) -- line: 52
			-- upvalues: t1 (copy), u7 (ref), s1 (ref), SduiStreamingResponseUtils (copy), processExtractedFrames (copy)
			t1.loadTimer.logUiStreamChunkReceived()

			if #s3 == 0 or u7 ~= nil then
				return
			end

			s1 ..= s3

			local v21 = s1
			local ok, result, v24 = pcall(SduiStreamingResponseUtils.extractFrames, v21)

			if not ok then
				u7 = result

				return
			end

			s1 = v24
			processExtractedFrames(result)
		end,
		finalize = function(p1) -- line: 63
			-- upvalues: n1 (ref), SduiStreamingResponseUtils (copy), s1 (ref), u7 (ref), processExtractedFrames (copy), t1 (copy), u6 (ref)
			if n1 == 0 and not SduiStreamingResponseUtils.isEmptyResponseBody(p1) then
				local v26 = if typeof(p1) ~= "buffer" then p1 else buffer.tostring(p1)

				if typeof(v26) == "string" and #v26 > 0 then
					s1 = v26

					local v27 = s1
					local ok, result, v30 = pcall(SduiStreamingResponseUtils.extractFrames, v27)

					if not ok then
						u7 = result
					else
						s1 = v30
						processExtractedFrames(result)
					end
				end
			end

			if u7 ~= nil then
				return {
					ok = false,
					value = u7
				}
			end

			if #s1 > 0 then
				return {
					ok = false,
					value = `Streaming response for { t1.configKey } ended with { #s1 } undecoded bytes remaining`
				}
			end

			if n1 > 0 then
				return {
					ok = true,
					value = u6
				}
			end

			return {
				ok = false,
				value = `Streaming request for { t1.configKey } completed without receiving data`
			}
		end
	}
end

return createSduiStreamingResponseHandler
