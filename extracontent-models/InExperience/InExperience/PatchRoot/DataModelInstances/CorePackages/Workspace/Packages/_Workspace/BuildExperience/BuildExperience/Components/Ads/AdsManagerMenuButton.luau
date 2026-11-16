local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local AdsManagerMenuButtonView = require(script.Parent.AdsManagerMenuButtonView)
local useAdsManagerMenuButtonViewModel = require(script.Parent.useAdsManagerMenuButtonViewModel)

local function AdsManagerMenuButton(p)
	local v = useAdsManagerMenuButtonViewModel(p)
	return React.createElement(AdsManagerMenuButtonView, v)
end

return AdsManagerMenuButton
