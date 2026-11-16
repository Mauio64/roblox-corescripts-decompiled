local Players = game:GetService("Players")

local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local FIntShopFetchOnGameJoinFallbackDelayMs = require(InExperienceShop.Flags.FIntShopFetchOnGameJoinFallbackDelayMs)
local scheduleFallback = require(script.Parent.scheduleFallback)
local ShopDebugLogger = require(script.Parent.ShopDebugLogger)

local v = FIntShopFetchOnGameJoinFallbackDelayMs / 1000

local function whenJoinSettles(callback)
	local flag = false
	local function fire(p: string)
		if flag then
			return
		end

		flag = true
		ShopDebugLogger.logLazy(function()
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
				ShopDebugLogger.logLazy(function()
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
					ShopDebugLogger.logLazy(function()
						return "whenJoinSettles: settled path=" .. v2
					end)

					callback("primary")
				end)
			end
		end, function(p)
			warn("[InExperienceShop] whenJoinSettles path 1 errored: " .. tostring(p))
		end)
	end)

	ShopDebugLogger.logLazy(function()
		return "whenJoinSettles: scheduled fallback delaySeconds=" .. v
	end)

	scheduleFallback(v, function()
		if flag then
			return
		end

		flag = true
		local v2
		v2 = "fallback"
		ShopDebugLogger.logLazy(function()
			return "whenJoinSettles: settled path=" .. v2
		end)

		callback("fallback")
	end)
end

return whenJoinSettles
