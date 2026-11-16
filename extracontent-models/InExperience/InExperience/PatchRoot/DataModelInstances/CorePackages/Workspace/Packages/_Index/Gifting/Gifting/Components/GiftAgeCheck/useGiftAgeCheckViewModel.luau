local parent = script:FindFirstAncestor("Gifting").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

require(script.Parent.GiftAgeCheckView)

local function useGiftAgeCheckViewModel(data)
	local mobileSnapPoint = Foundation.Hooks.useScaledValue(363)
	local v = Foundation.Hooks.useScaledValue(320)
	local v2 = Foundation.Hooks.useScaledValue(180)
	local pictogramSize = React.useMemo(function()
		return UDim2.fromOffset(v, v2)
	end, { v, v2 })

	return {
		isOpen = data.isOpen,
		titleText = data.copy.titleText,
		descriptionText = data.copy.descriptionText,
		continueLabel = data.copy.continueLabel,
		mobileSnapPoint = mobileSnapPoint,
		pictogramSize = pictogramSize,
		onContinue = data.onContinue,
		onClose = data.onClose
	}
end

return useGiftAgeCheckViewModel
