local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local SearchTopBar = require(AppChat.Components.ChatLanding.SearchTopBar)
local t1 = {
	paddingTop = 0,
	paddingBottom = 6,
	paddingLeft = 12,
	paddingRight = 12,
	layoutOrder = -1
}

local function v8() -- line: 32
end

return function(t2: {[any]: any}) -- line: 34
	-- upvalues: Cryo (copy), t1 (copy), useLocalization (copy), React (copy), SearchTopBar (copy), v8 (copy)
	local v10 = Cryo.Dictionary.union(t1, t2)
	local v11 = useLocalization({
		searchPlaceholderText = "Feature.Chat.Label.SearchWord",
		cancelText = "Feature.Chat.Action.Cancel"
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v10.height - v10.paddingBottom - v10.paddingTop),
		LayoutOrder = v10.layoutOrder
	}, {
		filterBox = React.createElement(SearchTopBar, {
			shouldShowCancel = false,
			captureFocusOnMount = false,
			initialInputText = v10.initialText or "",
			cancelText = v11.cancelText,
			searchPlaceholderText = v11.searchPlaceholderText,
			cancelCallback = v8,
			filterBoxPaddingTop = v10.paddingTop,
			filterBoxPaddingBottom = v10.paddingBottom,
			filterBoxPaddingLeft = v10.paddingLeft,
			filterBoxPaddingRight = v10.paddingRight,
			textChangedCallback = v10.onFilter
		}),
		heightFlexOverride = React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.None
		})
	})
end
