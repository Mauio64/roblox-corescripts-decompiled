local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization

local SearchTopBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/SearchTopBar")

local v5 = {
	paddingTop = 0,
	paddingBottom = 6,
	paddingLeft = 12,
	paddingRight = 12,
	layoutOrder = -1
}

local function fn() end

return function(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local v6 = useLocalization({
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
			cancelText = v6.cancelText,
			searchPlaceholderText = v6.searchPlaceholderText,
			shouldShowCancel = false,
			cancelCallback = fn,
			captureFocusOnMount = false,
			filterBoxPaddingTop = union.paddingTop,
			filterBoxPaddingBottom = union.paddingBottom,
			filterBoxPaddingLeft = union.paddingLeft,
			filterBoxPaddingRight = union.paddingRight,
			textChangedCallback = union.onFilter
		}),
		heightFlexOverride = React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.None
		})
	})
end
