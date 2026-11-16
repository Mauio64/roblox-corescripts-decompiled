local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local iconButton = Foundation.IconButton
local list = Foundation.List
local sheet = Foundation.Sheet
local text = Foundation.Text

local dialogSize = Foundation.Enums.DialogSize
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize

local v5 = { 0.5 }

local function SelectFolderMenuView(props)
	local v6

	if props.isLoading then
		v6 = React.createElement(text, {
			Text = props.loadingText,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left",
			testId = "select-folder-status"
		})
	elseif #props.folders == 0 then
		v6 = React.createElement(text, {
			Text = props.emptyText,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left",
			testId = "select-folder-status"
		})
	else
		local children = {}

		for k, folder in props.folders do
			local createElement = React.createElement
			local v8 = {
				size = inputSize.Small,
				isCircular = true,
				icon = 0,
				isDisabled = 0,
				onActivated = 0,
				Selectable = true,
				testId = 0
			}

			local v9 = if folder.isDisabled then iconName.StackableCheck else iconName.CirclePlus
			v8.icon = v9
			v8.isDisabled = folder.isDisabled
			v8.onActivated = folder.onAdd

			v8.testId = "select-folder-add--" .. folder.id
			local element = createElement(iconButton, v8)

			children[folder.id] = React.createElement(list.Item, {
				title = folder.name,
				description = folder.itemCountText,
				LayoutOrder = k,
				testId = "select-folder-row--" .. folder.id,
				trailing = element
			})
		end

		v6 = React.createElement(list.Root, { tag = "size-full-0 auto-y" }, children)
	end

	return React.createElement(sheet.Root, {
		size = dialogSize.Medium,
		snapPoints = v5,
		preferCenterSheet = true,
		centerSheetHeight = 1,
		onClose = props.onClose,
		testId = "select-folder-sheet"
	}, {
		Header = React.createElement(sheet.Header, nil, {
			Title = React.createElement(text, {
				Text = props.titleText,
				tag = "auto-xy text-heading-small text-truncate-split content-emphasis",
				LayoutOrder = 1
			})
		}),
		Content = React.createElement(sheet.Content, nil, { Content = v6 })
	})
end

return SelectFolderMenuView
