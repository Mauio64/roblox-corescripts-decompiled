local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Foundation")

require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftAgeCheck/GiftAgeCheckView")

local function useGiftAgeCheckViewModel(data)
	local v5 = Foundation.Hooks.useScaledValue(363)
	local v6 = Foundation.Hooks.useScaledValue(320)
	local v7 = Foundation.Hooks.useScaledValue(180)
	local v8 = React.useMemo(function()
		return UDim2.fromOffset(v6, v7)
	end, { v6, v7 })

	return {
		isOpen = data.isOpen,
		titleText = data.copy.titleText,
		descriptionText = data.copy.descriptionText,
		continueLabel = data.copy.continueLabel,
		mobileSnapPoint = v5,
		pictogramSize = v8,
		onContinue = data.onContinue,
		onClose = data.onClose
	}
end

return useGiftAgeCheckViewModel
