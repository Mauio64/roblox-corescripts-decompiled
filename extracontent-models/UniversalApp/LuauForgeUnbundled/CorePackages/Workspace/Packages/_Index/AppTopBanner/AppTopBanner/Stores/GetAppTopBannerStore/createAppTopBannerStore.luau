local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppTopBanner/Signals")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/AppTopBanner/SignalsExperimental")
local SignalsUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppTopBanner/SignalsUtils")

local AppTopBannerType = require("@game/CorePackages/Workspace/Packages/_Index/AppTopBanner/AppTopBanner/Enums/AppTopBannerType")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AppTopBanner/AppTopBanner/Constants")

local function defaultOnAppTopBannerClick() end

return function()
	local sessionScopedSignal, v5 = SignalsUtils.createSessionScopedSignal(true)

	local sessionScopedSignal2, v6 = SignalsUtils.createSessionScopedSignal(false)

	local sessionScopedSignal3, v7 = SignalsUtils.createSessionScopedSignal(AppTopBannerType.None)

	local sessionScopedSignal4, v8 = SignalsUtils.createSessionScopedSignal(nil)

	local sessionScopedSignal5, v9 = SignalsUtils.createSessionScopedSignal(0)

	local sessionScopedSignal6, v10 = SignalsUtils.createSessionScopedSignal(
		{ callback = defaultOnAppTopBannerClick },
		function(p2, p3): boolean
			return p2.callback == p3.callback
		end
	)

	local function collapseToDefaults()
		SignalsExperimental.batch(function()
			v6(false)
			v7(AppTopBannerType.None)
			v8(nil)
			v9(0)
			v10({ callback = defaultOnAppTopBannerClick })
		end)
	end

	return {
		getIsDisabled = sessionScopedSignal,
		getExpanded = sessionScopedSignal2,
		getAppTopBannerType = sessionScopedSignal3,
		getAppTopBannerContentProps = sessionScopedSignal4,
		getAppTopBannerContentHeight = sessionScopedSignal5,
		getOnAppTopBannerClick = sessionScopedSignal6,
		getIsVisible = Signals.createComputed(function(p2)
			return sessionScopedSignal2(p2) and not sessionScopedSignal(p2)
		end),
		setAppTopBanner = function(p2, p3, p4, p5, p6)
			if p2 then
				SignalsExperimental.batch(function()
					v6(p2)

					if p3 ~= nil then
						v7(p3)
					end

					if p4 ~= nil then
						v8(p4)
					end

					if p5 ~= nil then
						v10({ callback = p5 })
					end

					v9(p6 or Constants.CONTENT_HEIGHT)
				end)
			elseif sessionScopedSignal2(false) ~= p2 then
				SignalsExperimental.batch(function()
					v6(false)
					v7(AppTopBannerType.None)
					v8(nil)
					v9(0)
					v10({ callback = defaultOnAppTopBannerClick })
				end)
			end
		end,
		disableAppTopBanner = function(p2)
			if sessionScopedSignal(false) ~= p2 then
				v5(p2)
			end
		end,
		reset = function()
			SignalsExperimental.batch(function()
				v5(true)
				SignalsExperimental.batch(function()
					v6(false)
					v7(AppTopBannerType.None)
					v8(nil)
					v9(0)
					v10({ callback = defaultOnAppTopBannerClick })
				end)
			end)
		end
	}
end
