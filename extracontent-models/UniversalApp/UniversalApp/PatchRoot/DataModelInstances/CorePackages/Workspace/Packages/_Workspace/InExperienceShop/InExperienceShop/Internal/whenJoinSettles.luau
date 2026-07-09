local Players = game:GetService("Players")
local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local FIntShopFetchOnGameJoinFallbackDelayMs = require(InExperienceShop.Flags.FIntShopFetchOnGameJoinFallbackDelayMs)
local scheduleFallback = require(script.Parent.scheduleFallback)
local ShopDebugLogger = require(script.Parent.ShopDebugLogger)
local v6 = FIntShopFetchOnGameJoinFallbackDelayMs / 1000

local function whenJoinSettles(p1: ((...any) -> ...any)) -- line: 20
	-- upvalues: ShopDebugLogger (copy), Players (copy), v6 (copy), scheduleFallback (copy)
	local u9 = false

	local function fire(s1: string) -- line: 22
		-- upvalues: u9 (ref), ShopDebugLogger (copy), p1 (copy)
		if u9 then
			return
		end

		u9 = true
		ShopDebugLogger.logLazy(function() -- line: 27
			-- upvalues: s1 (copy)
			return "whenJoinSettles: settled path=" .. s1
		end)
		p1(s1)
	end

	task.spawn(function() -- line: 33
		-- upvalues: Players (copy), u9 (ref), ShopDebugLogger (copy), p1 (copy)
		xpcall(function() -- line: 36
			-- upvalues: Players (copy), u9 (ref), ShopDebugLogger (copy), p1 (copy)
			repeat
				if Players.LocalPlayer then
					local LocalPlayer = Players.LocalPlayer

					assert(LocalPlayer ~= nil, "LocalPlayer must be non-nil after the wait loop")

					if LocalPlayer.Character and LocalPlayer:HasAppearanceLoaded() then
						if u9 then
							return
						end

						u9 = true

						local s2 = "primary"

						ShopDebugLogger.logLazy(function() -- line: 27
							-- upvalues: s2 (copy)
							return "whenJoinSettles: settled path=" .. s2
						end)
						p1("primary")

						return
					end

					if u9 then
						return
					end

					LocalPlayer.CharacterAppearanceLoaded:Once(function() -- line: 60
						-- upvalues: u9 (ref), ShopDebugLogger (copy), p1 (copy)
						if u9 then
							return
						end

						u9 = true

						local s3 = "primary"

						ShopDebugLogger.logLazy(function() -- line: 27
							-- upvalues: s3 (copy)
							return "whenJoinSettles: settled path=" .. s3
						end)
						p1("primary")
					end)

					return
				end

				Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
			until u9
		end, function(err) -- line: 63
			warn("[InExperienceShop] whenJoinSettles path 1 errored: " .. tostring(err))
		end)
	end)
	ShopDebugLogger.logLazy(function() -- line: 70
		-- upvalues: v6 (copy)
		return "whenJoinSettles: scheduled fallback delaySeconds=" .. v6
	end)
	scheduleFallback(v6, function() -- line: 73
		-- upvalues: u9 (ref), ShopDebugLogger (copy), p1 (copy)
		if u9 then
			return
		end

		u9 = true

		local s4 = "fallback"

		ShopDebugLogger.logLazy(function() -- line: 27
			-- upvalues: s4 (copy)
			return "whenJoinSettles: settled path=" .. s4
		end)
		p1("fallback")
	end)
end

return whenJoinSettles
