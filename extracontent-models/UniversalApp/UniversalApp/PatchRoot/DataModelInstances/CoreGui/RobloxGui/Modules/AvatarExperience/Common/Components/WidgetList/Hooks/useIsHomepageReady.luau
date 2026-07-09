local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local default = require(CorePackages.Workspace.Packages.AppStartup).AppStartupSequence.default
local v4 = game:DefineFastInt("HomepageReadyFailsafeTimeoutSeconds", 20)
local AXPrefetchMarketplaceIXP = require(CorePackages.Workspace.Packages.AvatarExperienceExperiments).AXPrefetchMarketplaceIXP
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local v7 = game:DefineFastFlag("AXEnablePrefetchMarketplaceFailsafe", false)

local function useIsHomepageReady() -- line: 39
	-- upvalues: React (copy), default (copy), AXPrefetchMarketplaceIXP (copy), IxpUtils (copy), v7 (copy), v4 (copy)
	local v9, v10 = React.useState(default.isInteractive)
	local v11, v12 = React.useState(false)
	local v13 = if not AXPrefetchMarketplaceIXP.isEnabled() then nil else IxpUtils.readTestVariable(AXPrefetchMarketplaceIXP.EnabledForUser)

	React.useEffect(function() -- line: 47
		-- upvalues: v13 (copy), v10 (copy), default (copy), v9 (copy)
		if not v13 then
			return
		end

		v10(default.isInteractive)

		if not v9 then
			local v15 = default.changed:connect(function() -- line: 56
				-- upvalues: v10 (copy), default (copy)
				v10(default.isInteractive)
			end)

			return function() -- line: 59
				-- upvalues: v15 (copy)
				v15:disconnect()
			end
		end

		return function() -- line: 63
		end
	end, {
		v9,
		v13
	})

	if v7 then
		React.useEffect(function() -- line: 68
			-- upvalues: v13 (copy), v9 (copy), v4 (copy), v12 (copy)
			if not v13 then
				return
			end

			if v9 then
				return function() -- line: 75
				end
			end

			local thread = task.delay(v4, function() -- line: 78
				-- upvalues: v12 (copy)
				v12(true)
			end)

			return function() -- line: 82
				-- upvalues: thread (copy)
				task.cancel(thread)
			end
		end, {
			v9,
			v13
		})
	end

	local v14 = v9

	if not v14 then
		if v7 then
			return v11
		end

		v14 = false
	end

	return v14
end

return useIsHomepageReady
