local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local React = require(NotApprovedPageParent.React)
local Foundation = require(NotApprovedPageParent.Foundation)
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local usePageNavigation = require(NotApprovedPage.Contexts.PageNavigationContext).usePageNavigation

local function BackButton() -- line: 17
	-- upvalues: usePageNavigation (copy), React (copy), IconButton (copy), IconName (copy), ButtonVariant (copy), ButtonSize (copy)
	local v11 = usePageNavigation()

	return React.createElement(IconButton, {
		testId = "back-button",
		icon = IconName.ChevronLargeLeft,
		variant = ButtonVariant.Utility,
		onActivated = v11.goToPreviousPage,
		size = ButtonSize.Medium
	})
end

return React.memo(BackButton)
