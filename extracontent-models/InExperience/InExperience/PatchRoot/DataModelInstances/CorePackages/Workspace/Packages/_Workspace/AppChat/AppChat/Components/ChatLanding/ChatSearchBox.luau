local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local SearchTopBar = require(AppChat.Components.ChatLanding.SearchTopBar)

local v = {
	paddingTop = 0,
	paddingBottom = 6,
	paddingLeft = 12,
	paddingRight = 12,
	layoutOrder = -1
}

local function fn() end

return function(p)
	local union = Cryo.Dictionary.union(v, p)
	local v2 = useLocalization({
		searchPlaceholderText = "Feature.Chat.Label.SearchWord",
		cancelText = "Feature.Chat.Action.Cancel"
	})

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, union.height - union.paddingBottom - union.paddingTop),
		LayoutOrder = union.layoutOrder,
		BackgroundTransparency = 1
	}, {
		filterBox = React.createElement(SearchTopBar, {
			initialInputText = union.initialText or "",
			cancelText = v2.cancelText,
			searchPlaceholderText = v2.searchPlaceholderText,
			shouldShowCancel = false,
			cancelCallback = fn,
			captureFocusOnMount = false,
			filterBoxPaddingTop = union.paddingTop,
			filterBoxPaddingBottom = union.paddingBottom,
			filterBoxPaddingLeft = union.paddingLeft,
			filterBoxPaddingRight = union.paddingRight,
			textChangedCallback = union.onFilter
		}),
		heightFlexOverride = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.None })
	})
end
