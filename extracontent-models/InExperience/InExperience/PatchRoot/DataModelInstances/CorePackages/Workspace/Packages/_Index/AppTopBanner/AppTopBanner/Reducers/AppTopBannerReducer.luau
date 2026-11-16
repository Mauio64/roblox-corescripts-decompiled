local AppTopBanner = script:FindFirstAncestor("AppTopBanner")
local parent = AppTopBanner.Parent

local Cryo = require(parent.Cryo)
local Rodux = require(parent.Rodux)

local AppTopBannerType = require(AppTopBanner.Enums.AppTopBannerType)
local Constants = require(AppTopBanner.Constants)
local SetAppTopBanner = require(AppTopBanner.Actions.SetAppTopBanner)
local DisableAppTopBanner = require(AppTopBanner.Actions.DisableAppTopBanner)

local v = {
	isDisabled = true,
	expanded = false,
	appTopBannerType = AppTopBannerType.None,
	appTopBannerContentProps = nil,
	appTopBannerContentHeight = 0,
	onAppTopBannerClick = function() end
}

return Rodux.createReducer(v, {
	[SetAppTopBanner.name] = function(p, data)
		local isDisabled = p.isDisabled

		if data.expanded then
			return (Cryo.Dictionary.join(p, {
				expanded = data.expanded,
				appTopBannerType = data.appTopBannerType,
				appTopBannerContentProps = data.appTopBannerContentProps,
				onAppTopBannerClick = data.onAppTopBannerClick,
				appTopBannerContentHeight = data.appTopBannerContentHeight or Constants.CONTENT_HEIGHT,
				isDisabled = isDisabled
			}))
		end

		if p.expanded ~= data.expanded then
			p = Cryo.Dictionary.join(v, { isDisabled = isDisabled })
		end

		return p
	end,
	[DisableAppTopBanner.name] = function(p, p2)
		if p.isDisabled == p2.isDisabled then
			return p
		end

		return (Cryo.Dictionary.join(p, {
			isDisabled = not p.isDisabled
		}))
	end
})
