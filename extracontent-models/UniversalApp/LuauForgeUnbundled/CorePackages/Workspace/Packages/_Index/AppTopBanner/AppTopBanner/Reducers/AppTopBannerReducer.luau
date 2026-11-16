local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppTopBanner/Cryo")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppTopBanner/Rodux")

local AppTopBannerType = require("@game/CorePackages/Workspace/Packages/_Index/AppTopBanner/AppTopBanner/Enums/AppTopBannerType")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AppTopBanner/AppTopBanner/Constants")
local SetAppTopBanner = require("@game/CorePackages/Workspace/Packages/_Index/AppTopBanner/AppTopBanner/Actions/SetAppTopBanner")
local DisableAppTopBanner = require("@game/CorePackages/Workspace/Packages/_Index/AppTopBanner/AppTopBanner/Actions/DisableAppTopBanner")

local v5 = {
	isDisabled = true,
	expanded = false,
	appTopBannerType = AppTopBannerType.None,
	appTopBannerContentProps = nil,
	appTopBannerContentHeight = 0,
	onAppTopBannerClick = function() end
}

return Rodux.createReducer(v5, {
	[SetAppTopBanner.name] = function(p2, data)
		local isDisabled = p2.isDisabled

		if data.expanded then
			return (Cryo.Dictionary.join(p2, {
				expanded = data.expanded,
				appTopBannerType = data.appTopBannerType,
				appTopBannerContentProps = data.appTopBannerContentProps,
				onAppTopBannerClick = data.onAppTopBannerClick,
				appTopBannerContentHeight = data.appTopBannerContentHeight or Constants.CONTENT_HEIGHT,
				isDisabled = isDisabled
			}))
		end

		if p2.expanded ~= data.expanded then
			p2 = Cryo.Dictionary.join(v5, { isDisabled = isDisabled })
		end

		return p2
	end,
	[DisableAppTopBanner.name] = function(p2, p3)
		if p2.isDisabled == p3.isDisabled then
			return p2
		end

		return (Cryo.Dictionary.join(p2, {
			isDisabled = not p2.isDisabled
		}))
	end
})
