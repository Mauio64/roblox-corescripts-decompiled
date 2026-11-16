local parent = script:FindFirstAncestor("Gifting").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local GiftSheetLayoutView = require(script.Parent.Parent.GiftSheetLayout.GiftSheetLayoutView)
local GiftStateView = require(script.Parent.Parent.GiftState.GiftStateView)
local RecipientRowView = require(script.Parent.RecipientRowView)

local InputSize = Foundation.Enums.InputSize
local SearchInputShape = Foundation.Enums.SearchInputShape

local snapPoints = { 0.93 }

local function RecipientPickerView(props)
	local v = React.useMemo(function()
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
	local search

	if props.isSearchVisible then
		search = React.createElement(Foundation.SearchInput, {
			text = props.searchText,
			placeholder = props.searchPlaceholder,
			onChanged = props.onSearchChanged,
			size = InputSize.Medium,
			shape = SearchInputShape.Pill,
			width = UDim.new(1, 0),
			testId = "recipient-picker-search",
			LayoutOrder = 1
		})
	end

	local sectionTitle

	if not props.state then
		sectionTitle = React.createElement(Foundation.Text, {
			tag = "size-full-0 auto-y text-title-medium text-align-x-left content-emphasis",
			Text = props.sectionTitle,
			testId = "recipient-picker-section-title",
			LayoutOrder = 2
		})
	end

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local state

	if props.state then
		state = React.createElement(GiftStateView, props.state)
	end

	local recipientList

	if not props.state then
		recipientList = React.createElement(Foundation.View, {
			tag = "col size-full-0 auto-y",
			LayoutOrder = 1
		}, v)
	end

	local element = createElement(view, { tag = "col gap-medium size-full-0 auto-y" }, {
		Search = search,
		SectionTitle = sectionTitle,
		Body = createElement2(view2, { tag = "col size-full-0 auto-y", LayoutOrder = 3 }, {
			State = state,
			RecipientList = recipientList
		})
	})

	return React.createElement(GiftSheetLayoutView, {
		isOpen = props.isOpen,
		titleText = props.titleText,
		content = element,
		snapPoints = snapPoints,
		centerSheetHeight = 1,
		onClose = props.onClose
	})
end

return React.memo(RecipientPickerView)
