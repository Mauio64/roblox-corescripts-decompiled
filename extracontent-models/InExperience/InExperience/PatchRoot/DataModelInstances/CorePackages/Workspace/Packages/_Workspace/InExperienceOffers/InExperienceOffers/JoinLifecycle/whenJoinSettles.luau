local Players = game:GetService("Players")

local InExperienceOffers = script:FindFirstAncestor("InExperienceOffers")
local FIntOffersPrefetchOnGameJoinFallbackDelayMs = require(InExperienceOffers.Flags.FIntOffersPrefetchOnGameJoinFallbackDelayMs)
local scheduleFallback = require(script.Parent.scheduleFallback)
local OffersDebugLogger = require(InExperienceOffers.Internal.OffersDebugLogger)

local v = FIntOffersPrefetchOnGameJoinFallbackDelayMs / 1000

local function whenJoinSettles(callback)
	local flag = false
	local function fire(p: string)
		if flag then
			return
		end

		flag = true
		OffersDebugLogger.logLazy(function()
			return "whenJoinSettles: settled path=" .. p
		end)

		callback(p)
	end

	task.spawn(function()
		xpcall(function()
			while not Players.LocalPlayer do
				Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

				if flag then
					return
				end
			end

			local localPlayer = Players.LocalPlayer
			assert(localPlayer ~= nil, "LocalPlayer must be non-nil after the wait loop")

			if localPlayer.Character and localPlayer:HasAppearanceLoaded() then
				if flag then
					return
				end

				flag = true
				local v2
				v2 = "primary"
				OffersDebugLogger.logLazy(function()
					return "whenJoinSettles: settled path=" .. v2
				end)

				callback("primary")
			else
				if flag then
					return
				end

				localPlayer.CharacterAppearanceLoaded:Once(function()
					if flag then
						return
					end

					flag = true
					local v2
					v2 = "primary"
					OffersDebugLogger.logLazy(function()
						return "whenJoinSettles: settled path=" .. v2
					end)

					callback("primary")
				end)
			end
		end, function(p)
			warn("[InExperienceOffers] whenJoinSettles path 1 errored: " .. tostring(p))
		end)
	end)

	OffersDebugLogger.logLazy(function()
		return "whenJoinSettles: scheduled fallback delaySeconds=" .. v
	end)

	scheduleFallback(v, function()
		if flag then
			return
		end

		flag = true
		local v2
		v2 = "fallback"
		OffersDebugLogger.logLazy(function()
			return "whenJoinSettles: settled path=" .. v2
		end)

		callback("fallback")
	end)
end

return whenJoinSettles
