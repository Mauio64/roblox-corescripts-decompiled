local AppTopBanner = script:FindFirstAncestor("AppTopBanner")
local parent = AppTopBanner.Parent

local Signals = require(parent.Signals)
local SignalsExperimental = require(parent.SignalsExperimental)
local SignalsUtils = require(parent.SignalsUtils)

local AppTopBannerType = require(AppTopBanner.Enums.AppTopBannerType)
local Constants = require(AppTopBanner.Constants)

local function defaultOnAppTopBannerClick() end

return function()
	local sessionScopedSignal, v = SignalsUtils.createSessionScopedSignal(true)

	local sessionScopedSignal2, v2 = SignalsUtils.createSessionScopedSignal(false)

	local sessionScopedSignal3, v3 = SignalsUtils.createSessionScopedSignal(AppTopBannerType.None)

	local sessionScopedSignal4, v4 = SignalsUtils.createSessionScopedSignal(nil)

	local sessionScopedSignal5, v5 = SignalsUtils.createSessionScopedSignal(0)

	local sessionScopedSignal6, v6 = SignalsUtils.createSessionScopedSignal(
		{ callback = defaultOnAppTopBannerClick },
		function(p, p2): boolean
			return p.callback == p2.callback
		end
	)

	local function collapseToDefaults() -- 2 equivalent calls inferred from this helper
		SignalsExperimental.batch(function()
			v2(false)
			v3(AppTopBannerType.None)
			v4(nil)
			v5(0)
			v6({ callback = defaultOnAppTopBannerClick })
		end)
	end

	return {
		getIsDisabled = sessionScopedSignal,
		getExpanded = sessionScopedSignal2,
		getAppTopBannerType = sessionScopedSignal3,
		getAppTopBannerContentProps = sessionScopedSignal4,
		getAppTopBannerContentHeight = sessionScopedSignal5,
		getOnAppTopBannerClick = sessionScopedSignal6,
		getIsVisible = Signals.createComputed(function(p)
			return sessionScopedSignal2(p) and not sessionScopedSignal(p)
		end),
		setAppTopBanner = function(flag: boolean?, p, p2, callback, p3: number?)
			if flag then
				SignalsExperimental.batch(function()
					v2(flag)

					if p ~= nil then
						v3(p)
					end

					if p2 ~= nil then
						v4(p2)
					end

					if callback ~= nil then
						v6({ callback = callback })
					end

					v5(p3 or Constants.CONTENT_HEIGHT)
				end)
			elseif sessionScopedSignal2(false) ~= flag then
				collapseToDefaults() -- inferred equivalent call
			end
		end,
		disableAppTopBanner = function(flag: boolean)
			if sessionScopedSignal(false) ~= flag then
				v(flag)
			end
		end,
		reset = function()
			SignalsExperimental.batch(function()
				v(true)
				collapseToDefaults() -- inferred equivalent call
			end)
		end
	}
end
