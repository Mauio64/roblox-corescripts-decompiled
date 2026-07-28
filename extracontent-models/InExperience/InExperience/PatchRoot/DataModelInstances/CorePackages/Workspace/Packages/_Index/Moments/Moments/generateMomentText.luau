local Parent = script:FindFirstAncestor("Moments").Parent
local Promise = require(Parent.Promise)
local isStudio = require(Parent.MomentsCommon.isStudio)
local t1 = {}

local function log(s1: string, ...) -- line: 48
	print(`[moments-gen] { string.format(s1, ...) }`)
end
local function mockResult() -- line: 52
	return {
		summary = "insane save",
		description = "no way i pulled this off — clutch save on the last second, everyone was screaming lol",
		error = nil
	}
end
local function captureKey(p1) -- line: 60
	local LocalId = nil

	pcall(function() -- line: 62
		-- upvalues: LocalId (ref), p1 (copy)
		LocalId = p1.LocalId
	end)

	if LocalId ~= nil then
		return `local:{ LocalId }`
	end

	if typeof(p1) == "table" and p1.assetId ~= nil then
		return `asset:{ p1.assetId }`
	end

	return `capture:{ tostring(p1) }`
end
local function resultName(p2) -- line: 77
	if p2 == nil then
		return nil
	end

	local ok, result = pcall(function() -- line: 81
		-- upvalues: p2 (copy)
		return p2.Name
	end)

	if ok and typeof(result) == "string" then
		return result
	end

	return nil
end
local function runGeneration(p3, s2: string, t2: {[any]: any}) -- line: 90
	-- upvalues: Promise (copy), log (copy), isStudio (copy)
	local v20 = t2.captureService or game:GetService("CaptureService")
	local v21 = t2.pollIntervalSeconds or 1
	local v22 = t2.maxPollAttempts or 30

	return Promise.new(function(resolve) -- line: 95
		-- upvalues: v20 (copy), p3 (copy), log (copy), s2 (copy), isStudio (copy), v22 (copy), v21 (copy)
		task.spawn(function() -- line: 96
			-- upvalues: v20 (copy), p3 (copy), log (copy), s2 (copy), isStudio (copy), resolve (copy), v22 (copy), v21 (copy)
			local ok, result, v36 = pcall(function() -- line: 97
				-- upvalues: v20 (copy), p3 (copy)
				return v20:GenerateMomentTextAsync(p3)
			end)

			if ok then
				local v37

				if result == nil then
					v37 = nil
				else
					local ok2, result2 = pcall(function() -- line: 81
						-- upvalues: result (copy)
						return result.Name
					end)

					v37 = if not ok2 or typeof(result2) ~= "string" then nil else result2
				end

				if v37 == "Success" and typeof(v36) == "string" and #v36 ~= 0 then
					log("generation started for %s → token=%s, polling", s2, v36)

					for _ = 1, v22 do
						task.wait(v21)

						local ok3, result3, v43, v44 = pcall(function() -- line: 118
							-- upvalues: v20 (copy), v36 (copy)
							return v20:CheckMomentTextStatusAsync(v36)
						end)

						if not ok3 then
							continue
						end

						local v45

						if result3 == nil then
							v45 = nil
						else
							local ok4, result4 = pcall(function() -- line: 81
								-- upvalues: result3 (copy)
								return result3.Name
							end)

							v45 = if not ok4 or typeof(result4) ~= "string" then nil else result4
						end

						if v45 == "Success" then
							log("generation complete for %s", s2)
							resolve({
								summary = v43,
								description = v44
							})

							return
						end

						if v45 == "Failed" then
							log("generation failed for %s", s2)
							resolve({
								error = "GENERATION_FAILED"
							})

							return
						end
					end

					log("generation timed out for %s", s2)
					resolve({
						error = "TIMEOUT"
					})

					return
				end
			end

			log("generation start failed for %s", s2)

			if isStudio() then
				log("resolving with mock result (Studio, backend unreachable)")
				resolve({
					summary = "insane save",
					description = "no way i pulled this off — clutch save on the last second, everyone was screaming lol",
					error = nil
				})

				return
			end

			resolve({
				error = "REQUEST_FAILED"
			})
		end)
	end)
end
local function generateMomentText(p4, t3: {[any]: any}?) -- line: 144
	-- upvalues: log (copy), isStudio (copy), Promise (copy), captureKey (copy), t1 (copy)
	local v25 = t3 or {}

	if not (v25.isEngineEnabled or function() -- line: 147
		return game:GetEngineFeature("CaptureServiceGenerateMomentText")
	end)() then
		log("engine feature %s unavailable", "CaptureServiceGenerateMomentText")

		if isStudio() then
			return Promise.resolve({
				summary = "insane save",
				description = "no way i pulled this off — clutch save on the last second, everyone was screaming lol",
				error = nil
			})
		end

		return Promise.resolve({
			error = "ENGINE_UNSUPPORTED"
		})
	end

	local v26 = captureKey(p4)

	if t1[v26] ~= nil then
		log("reusing cached generation for %s (no re-send)", v26)

		return t1[v26]
	end

	local v27 = v25.captureService or game:GetService("CaptureService")
	local v28 = v25.pollIntervalSeconds or 1
	local v29 = v25.maxPollAttempts or 30
	local v30 = Promise.new(function(resolve) -- line: 95
		-- upvalues: v27 (copy), p4 (copy), log (copy), v26 (copy), isStudio (copy), v29 (copy), v28 (copy)
		task.spawn(function() -- line: 96
			-- upvalues: v27 (copy), p4 (copy), log (copy), v26 (copy), isStudio (copy), resolve (copy), v29 (copy), v28 (copy)
			local ok, result, v50 = pcall(function() -- line: 97
				-- upvalues: v27 (copy), p4 (copy)
				return v27:GenerateMomentTextAsync(p4)
			end)

			if ok then
				local v51

				if result == nil then
					v51 = nil
				else
					local ok5, result5 = pcall(function() -- line: 81
						-- upvalues: result (copy)
						return result.Name
					end)

					v51 = if not ok5 or typeof(result5) ~= "string" then nil else result5
				end

				if v51 == "Success" and typeof(v50) == "string" and #v50 ~= 0 then
					log("generation started for %s → token=%s, polling", v26, v50)

					for _ = 1, v29 do
						task.wait(v28)

						local ok6, result6, v57, v58 = pcall(function() -- line: 118
							-- upvalues: v27 (copy), v50 (copy)
							return v27:CheckMomentTextStatusAsync(v50)
						end)

						if not ok6 then
							continue
						end

						local v59

						if result6 == nil then
							v59 = nil
						else
							local ok7, result7 = pcall(function() -- line: 81
								-- upvalues: result6 (copy)
								return result6.Name
							end)

							v59 = if not ok7 or typeof(result7) ~= "string" then nil else result7
						end

						if v59 == "Success" then
							log("generation complete for %s", v26)
							resolve({
								summary = v57,
								description = v58
							})

							return
						end

						if v59 == "Failed" then
							log("generation failed for %s", v26)
							resolve({
								error = "GENERATION_FAILED"
							})

							return
						end
					end

					log("generation timed out for %s", v26)
					resolve({
						error = "TIMEOUT"
					})

					return
				end
			end

			log("generation start failed for %s", v26)

			if isStudio() then
				log("resolving with mock result (Studio, backend unreachable)")
				resolve({
					summary = "insane save",
					description = "no way i pulled this off — clutch save on the last second, everyone was screaming lol",
					error = nil
				})

				return
			end

			resolve({
				error = "REQUEST_FAILED"
			})
		end)
	end)

	t1[v26] = v30
	v30:andThen(function(t4: {[any]: any}) -- line: 171
		-- upvalues: t1 (copy), v26 (copy)
		if t4 == nil or t4.error ~= nil then
			t1[v26] = nil
		end
	end, function() -- line: 175
		-- upvalues: t1 (copy), v26 (copy)
		t1[v26] = nil
	end)

	return v30
end

return generateMomentText
