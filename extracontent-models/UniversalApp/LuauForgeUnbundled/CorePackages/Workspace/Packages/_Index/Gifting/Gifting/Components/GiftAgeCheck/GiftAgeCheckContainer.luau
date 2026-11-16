local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/React")

local GiftAgeCheckView = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftAgeCheck/GiftAgeCheckView")
local useGiftAgeCheckViewModel = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftAgeCheck/useGiftAgeCheckViewModel")

local function GiftAgeCheckContainer(p2)
	local v5 = useGiftAgeCheckViewModel(p2)
	return React.createElement(GiftAgeCheckView, v5)
end

return GiftAgeCheckContainer
