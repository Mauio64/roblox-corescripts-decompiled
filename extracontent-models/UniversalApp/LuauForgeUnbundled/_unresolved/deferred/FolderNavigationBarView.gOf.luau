local module = require("@luauforge/deferred/gNV")
local module2 = require("@luauforge/deferred/gOg")

require("@luauforge/deferred/gND")
local LoadingState = require("@game/CorePackages/Packages/_Index/MomentsCommon/MomentsCommon/Enums/LoadingState")

local chip = module2.Chip
local chipSize = module2.Enums.ChipSize
local iconName = module2.Enums.IconName
local scrollBarVisibility = module2.Enums.ScrollBarVisibility
local useTokens = module2.Hooks.useTokens

local function FolderNavigationBarView(props)
	local v5 = useTokens()

	local folders = props.folders
	local selectedFolderId = props.selectedFolderId
	local allLabel = props.allLabel
	local clearSelection = props.clearSelection
	local onSelectFolder = props.onSelectFolder
	local onCreatePressed = props.onCreatePressed
	local createLabel = props.createLabel

	local v6 = module.useMemo(function()
		local children = {
			AllPill = module.createElement(chip, {
				text = allLabel,
				isChecked = selectedFolderId == nil,
				size = chipSize.Medium,
				LayoutOrder = 0,
				onActivated = clearSelection,
				testId = "avatar-folders-pill--all"
			})
		}

		if onCreatePressed ~= nil then
			children.CreatePill = module.createElement(chip, {
				leading = iconName.PlusLarge,
				text = createLabel,
				isChecked = false,
				size = chipSize.Medium,
				LayoutOrder = 1,
				onActivated = onCreatePressed,
				testId = "avatar-folders-pill--create"
			})
		end

		for k, folder in folders do
			children["Folder_" .. folder.id] = module.createElement(chip, {
				text = folder.name,
				isChecked = selectedFolderId == folder.id,
				size = chipSize.Medium,
				LayoutOrder = k + 1,
				onActivated = function()
					onSelectFolder(folder.id)
				end
			})
		end

		return children
	end, {
		folders,
		selectedFolderId,
		allLabel,
		clearSelection,
		onSelectFolder,
		onCreatePressed,
		createLabel
	})

	if props.status == LoadingState.Failed then
		return nil
	end

	return module.createElement(
		module2.View,
		{
			LayoutOrder = props.LayoutOrder,
			testId = "avatar-folders-chip-bar",
			tag = "size-full-1200 padding-bottom-xsmall padding-left-medium padding-right-small padding-top-medium"
		},
		{
			Scroll = module.createElement(module2.ScrollView, {
				layout = {
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, v5.Gap.Small),
					SortOrder = Enum.SortOrder.LayoutOrder
				},
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.XY,
					CanvasSize = UDim2.fromOffset(0, 0),
					ScrollingDirection = Enum.ScrollingDirection.X,
					scrollBarVisibility = scrollBarVisibility.None
				},
				tag = "size-full"
			}, v6)
		}
	)
end

return FolderNavigationBarView
