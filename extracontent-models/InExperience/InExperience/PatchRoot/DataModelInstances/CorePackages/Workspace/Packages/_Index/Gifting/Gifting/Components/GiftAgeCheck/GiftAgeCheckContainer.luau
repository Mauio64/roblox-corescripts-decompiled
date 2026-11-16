local parent = script:FindFirstAncestor("Gifting").Parent
local React = require(parent.React)

local GiftAgeCheckView = require(script.Parent.GiftAgeCheckView)
local useGiftAgeCheckViewModel = require(script.Parent.useGiftAgeCheckViewModel)

local function GiftAgeCheckContainer(p)
	local v = useGiftAgeCheckViewModel(p)
	return React.createElement(GiftAgeCheckView, v)
end

return GiftAgeCheckContainer
