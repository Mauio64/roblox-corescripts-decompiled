local module = require("@luauforge/deferred/fUU")

local module2 = require("@luauforge/deferred/fUV")
local buttonSize = module2.Enums.ButtonSize
local buttonVariant = module2.Enums.ButtonVariant
local iconButton = module2.IconButton
local iconName = module2.Enums.IconName

local usePageNavigation = require("@luauforge/deferred/fVa").usePageNavigation

local function BackButton()
	local v5 = usePageNavigation()

	return module.createElement(iconButton, {
		icon = iconName.ChevronLargeLeft,
		variant = buttonVariant.Utility,
		onActivated = v5.goToPreviousPage,
		size = buttonSize.Medium,
		testId = "back-button"
	})
end

return module.memo(BackButton)
