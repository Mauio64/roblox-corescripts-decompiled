local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Promise")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local isStudio = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsCommon/isStudio")
local getFFlagEnableMomentTextGeneration = MomentsCommon.Flags.GetFFlagEnableMomentTextGeneration
local GetFFlagMomentTextGenerationDisableCache = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/GetFFlagMomentTextGenerationDisableCache")
local fFlagMomentTextGenerationFilteredSignal = MomentsCommon.Flags.FFlagMomentTextGenerationFilteredSignal

local v5 = {}

local function log(formatString, ...)
	if _G.__MOMENTS_DISABLE_GEN_TEXT_LOG__ then
		return
	end

	print(`[moments-gen] {string.format(formatString, ...)}`)
end

local function mockResult()
	return {
		summary = "insane save",
		description = "no way i pulled this off — clutch save on the last second, everyone was screaming lol",
		error = nil
	}
end

local function captureKey(p2)
	local localId = nil
	pcall(function()
		localId = p2.LocalId
	end)

	if localId ~= nil then
		return `local:{localId}`
	end

	if typeof(p2) == "table" and p2.assetId ~= nil then
		return `asset:{p2.assetId}`
	end

	return `capture:{tostring(p2)}`
end

local function resultName(p2)
	if p2 == nil then
		return nil
	end

	local success, result = pcall(function()
		return p2.Name
	end)

	if success and typeof(result) == "string" then
		return result
	end

	return nil
end

local function runGeneration(p2, p3, p4, data)
	local captureService = data.captureService or game:GetService("CaptureService")
	local pollIntervalSeconds = data.pollIntervalSeconds or 1
	local maxPollAttempts = data.maxPollAttempts or 30

	return Promise.new(function(callback, p5, callback2)
		local thread = task.spawn(function()
			local success, result, v6 = pcall(function()
				if p4 == nil then
					return captureService:GenerateMomentTextAsync(p2)
				end

				return captureService:GenerateMomentTextAsync(p2, p4)
			end)

			if success then
				local result2

				if result ~= nil then
					local success2
					success2, result2 = pcall(function()
						return result.Name
					end)

					if not success2 or typeof(result2) ~= "string" then
						result2 = nil
					end
				end

				if result2 == "Success" and typeof(v6) == "string" and #v6 ~= 0 then
					log("generation started for %s", p3)

					for i = 1, maxPollAttempts do
						task.wait(pollIntervalSeconds)

						local success2, result3, v7, v8 = pcall(function()
							return captureService:CheckMomentTextStatusAsync(v6)
						end)

						if not success2 then
							continue
						end

						local result4

						if result3 ~= nil then
							local success3
							success3, result4 = pcall(function()
								return result3.Name
							end)

							if not success3 or typeof(result4) ~= "string" then
								result4 = nil
							end
						end

						if result4 == "Success" then
							log("generation succeeded for %s", p3)
							callback({
								summary = v7,
								description = v8,
								generationToken = v6
							})

							return
						end

						if fFlagMomentTextGenerationFilteredSignal and result4 == "Filtered" then
							callback({ error = "CONTENT_FILTERED" })
							return
						end

						if result4 == "Failed" then
							callback({ error = "GENERATION_FAILED" })
							return
						end
					end

					callback({ error = "TIMEOUT" })
					return
				end
			end

			if not success then
				log("generation start failed for %s", p3)
			end

			if isStudio() then
				callback({
					summary = "insane save",
					description = "no way i pulled this off — clutch save on the last second, everyone was screaming lol",
					error = nil
				})
			else
				callback({ error = "REQUEST_FAILED" })
			end
		end)

		if getFFlagEnableMomentTextGeneration() then
			callback2(function()
				log("generation cancelled for %s", p3)
				task.cancel(thread)
			end)
		end
	end)
end

local function generateMomentText(p2, p3, options)
	local v6 = options or {}

	if (v6.isEngineEnabled or function()
		return game:GetEngineFeature("CaptureServiceGenerateMomentText")
	end)() then
		local v7 = captureKey(p2)

		if p3 ~= nil and p3 ~= "" then
			v7 = `{v7}|tone:{p3}`
		end

		if GetFFlagMomentTextGenerationDisableCache() then
			return runGeneration(p2, v7, p3, v6)
		end

		if v5[v7] ~= nil then
			return v5[v7]
		end

		local v8 = v7
		local captureService = v6.captureService or game:GetService("CaptureService")
		local pollIntervalSeconds = v6.pollIntervalSeconds or 1
		local maxPollAttempts = v6.maxPollAttempts or 30

		local v9 = Promise.new(function(callback, p4, callback2)
			local thread = task.spawn(function()
				local success, result, v10 = pcall(function()
					if p3 == nil then
						return captureService:GenerateMomentTextAsync(p2)
					end

					return captureService:GenerateMomentTextAsync(p2, p3)
				end)

				if success then
					local result2

					if result ~= nil then
						local success2
						success2, result2 = pcall(function()
							return result.Name
						end)

						if not success2 or typeof(result2) ~= "string" then
							result2 = nil
						end
					end

					if result2 == "Success" and typeof(v10) == "string" and #v10 ~= 0 then
						log("generation started for %s", v8)

						for i = 1, maxPollAttempts do
							task.wait(pollIntervalSeconds)

							local success2, result3, v11, v12 = pcall(function()
								return captureService:CheckMomentTextStatusAsync(v10)
							end)

							if not success2 then
								continue
							end

							local result4

							if result3 ~= nil then
								local success3
								success3, result4 = pcall(function()
									return result3.Name
								end)

								if not success3 or typeof(result4) ~= "string" then
									result4 = nil
								end
							end

							if result4 == "Success" then
								log("generation succeeded for %s", v8)
								callback({
									summary = v11,
									description = v12,
									generationToken = v10
								})

								return
							end

							if fFlagMomentTextGenerationFilteredSignal and result4 == "Filtered" then
								callback({ error = "CONTENT_FILTERED" })
								return
							end

							if result4 == "Failed" then
								callback({ error = "GENERATION_FAILED" })
								return
							end
						end

						callback({ error = "TIMEOUT" })
						return
					end
				end

				if not success then
					log("generation start failed for %s", v8)
				end

				if isStudio() then
					callback({
						summary = "insane save",
						description = "no way i pulled this off — clutch save on the last second, everyone was screaming lol",
						error = nil
					})
				else
					callback({ error = "REQUEST_FAILED" })
				end
			end)

			if getFFlagEnableMomentTextGeneration() then
				callback2(function()
					log("generation cancelled for %s", v8)
					task.cancel(thread)
				end)
			end
		end)

		v5[v7] = v9

		v9:andThen(function(p4)
			if p4 == nil or p4.error ~= nil then
				v5[v7] = nil
			end
		end, function()
			v5[v7] = nil
		end)

		if getFFlagEnableMomentTextGeneration() then
			v9:finally(function(p4)
				if p4 == Promise.Status.Cancelled then
					v5[v7] = nil
				end
			end)
		end

		return v9
	elseif isStudio() then
		return Promise.resolve({
			summary = "insane save",
			description = "no way i pulled this off — clutch save on the last second, everyone was screaming lol",
			error = nil
		})
	else
		return Promise.resolve({ error = "ENGINE_UNSUPPORTED" })
	end
end

return generateMomentText
