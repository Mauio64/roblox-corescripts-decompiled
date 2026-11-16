local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Promise = require(parent.Promise)
local MomentsCommon = require(parent.MomentsCommon)
local isStudio = require(parent.MomentsCommon.isStudio)
local GetFFlagEnableMomentTextGeneration = MomentsCommon.Flags.GetFFlagEnableMomentTextGeneration
local GetFFlagMomentTextGenerationDisableCache = require(Moments.Flags.GetFFlagMomentTextGenerationDisableCache)
local FFlagMomentTextGenerationFilteredSignal = MomentsCommon.Flags.FFlagMomentTextGenerationFilteredSignal

local v = {}

local function log(formatString: string, ...)
	if _G.__MOMENTS_DISABLE_GEN_TEXT_LOG__ then
		return
	end

	print(`[moments-gen] {string.format(formatString, ...)}`)
end

local function mockResult() -- 2 equivalent calls inferred from this helper
	return {
		summary = "insane save",
		description = "no way i pulled this off — clutch save on the last second, everyone was screaming lol",
		error = nil
	}
end

local function captureKey(p)
	local localId = nil
	pcall(function()
		localId = p.LocalId
	end)

	if localId ~= nil then
		return `local:{localId}`
	end

	if typeof(p) == "table" and p.assetId ~= nil then
		return `asset:{p.assetId}`
	end

	return `capture:{tostring(p)}`
end

local function resultName(p)
	if p == nil then
		return nil
	end

	local success, result = pcall(function()
		return p.Name
	end)

	if success and typeof(result) == "string" then
		return result
	end

	return nil
end

local function runGeneration(p, p2: string, p3: string?, data) -- 1 equivalent call inferred from this helper
	local captureService = data.captureService or game:GetService("CaptureService")
	local pollIntervalSeconds = data.pollIntervalSeconds or 1
	local maxPollAttempts = data.maxPollAttempts or 30

	return Promise.new(function(callback, _, callback2)
		local thread = task.spawn(function()
			local success, result, generationToken = pcall(function()
				if p3 == nil then
					return captureService:GenerateMomentTextAsync(p)
				end

				return captureService:GenerateMomentTextAsync(p, p3)
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

				if result2 == "Success" and typeof(generationToken) == "string" and #generationToken ~= 0 then
					log("generation started for %s", p2)

					for _ = 1, maxPollAttempts do
						task.wait(pollIntervalSeconds)

						local success2, result3, summary, description = pcall(function()
							return captureService:CheckMomentTextStatusAsync(generationToken)
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
							log("generation succeeded for %s", p2)
							callback({
								summary = summary,
								description = description,
								generationToken = generationToken
							})

							return
						end

						if FFlagMomentTextGenerationFilteredSignal and result4 == "Filtered" then
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
				log("generation start failed for %s", p2)
			end

			if isStudio() then
				callback(mockResult()) -- inferred equivalent call
			else
				callback({ error = "REQUEST_FAILED" })
			end
		end)

		if GetFFlagEnableMomentTextGeneration() then
			callback2(function()
				log("generation cancelled for %s", p2)
				task.cancel(thread)
			end)
		end
	end)
end

local function generateMomentText(p, p2: string?, options)
	local v2 = options or {}

	if (v2.isEngineEnabled or function()
		return game:GetEngineFeature("CaptureServiceGenerateMomentText")
	end)() then
		local v3 = captureKey(p)

		if p2 ~= nil and p2 ~= "" then
			v3 = `{v3}|tone:{p2}`
		end

		if GetFFlagMomentTextGenerationDisableCache() then
			return runGeneration(p, v3, p2, v2)
		end

		if v[v3] ~= nil then
			return v[v3]
		end

		local v4 = runGeneration(p, v3, p2, v2) -- inferred equivalent call
		v[v3] = v4

		v4:andThen(function(p3)
			if p3 == nil or p3.error ~= nil then
				v[v3] = nil
			end
		end, function()
			v[v3] = nil
		end)

		if GetFFlagEnableMomentTextGeneration() then
			v4:finally(function(p3)
				if p3 == Promise.Status.Cancelled then
					v[v3] = nil
				end
			end)
		end

		return v4
	elseif isStudio() then
		return Promise.resolve(mockResult()) -- inferred equivalent call
	else
		return Promise.resolve({ error = "ENGINE_UNSUPPORTED" })
	end
end

return generateMomentText
