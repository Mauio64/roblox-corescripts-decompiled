local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Foundation")

local GiftSheetLayoutView = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftSheetLayout/GiftSheetLayoutView")
local GiftStateView = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftState/GiftStateView")
local RecipientRowView = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/RecipientPicker/RecipientRowView")

local inputSize = Foundation.Enums.InputSize
local searchInputShape = Foundation.Enums.SearchInputShape

local v5 = { 0.93 }

local function RecipientPickerView(props)
	local v6 = React.useMemo(function()
		local children = {}

		for k, row in props.rows do
			children[`Recipient_{row.userId}`] = React.createElement(RecipientRowView, {
				userId = row.userId,
				displayName = row.displayName,
				username = row.username,
				isAvailable = row.isAvailable,
				unavailableLabel = props.unavailableLabel,
				avatarBackgroundStyle = props.avatarBackgroundStyle,
				onActivated = function()
					props.onRecipientSelected(row.userId)
				end,
				LayoutOrder = k
			})
		end

		return children
	end, {
		props.rows,
		props.avatarBackgroundStyle,
		props.onRecipientSelected,
		props.unavailableLabel
	})

	local createElement = React.createElement
	local view = Foundation.View

	local v9 = if props.isSearchVisible then React.createElement(Foundation.SearchInput, {
		text = props.searchText,
		placeholder = props.searchPlaceholder,
		onChanged = props.onSearchChanged,
		size = inputSize.Medium,
		shape = searchInputShape.Pill,
		width = UDim.new(1, 0),
		testId = "recipient-picker-search",
		LayoutOrder = 1
	}) else nil

	local v10 = if not props.state then React.createElement(Foundation.Text, {
		tag = "size-full-0 auto-y text-title-medium text-align-x-left content-emphasis",
		Text = props.sectionTitle,
		testId = "recipient-picker-section-title",
		LayoutOrder = 2
	}) else nil

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v13 = if props.state then React.createElement(GiftStateView, props.state) else nil
	local v14 = if not props.state then React.createElement(
		Foundation.View,
		{ tag = "col size-full-0 auto-y", LayoutOrder = 1 },
		v6
	) else nil
	local element = createElement(view, { tag = "col gap-medium size-full-0 auto-y" }, {
		Search = v9,
		SectionTitle = v10,
		Body = createElement2(view2, { tag = "col size-full-0 auto-y", LayoutOrder = 3 }, {
			State = v13,
			RecipientList = v14
		})
	})

	return React.createElement(GiftSheetLayoutView, {
		isOpen = props.isOpen,
		titleText = props.titleText,
		content = element,
		snapPoints = v5,
		centerSheetHeight = 1,
		onClose = props.onClose
	})
end

return React.memo(RecipientPickerView)
