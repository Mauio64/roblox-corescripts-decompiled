local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryTypes")
local ModelViewport = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/ModelViewport")

local image = Foundation.Image
local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize

local function LibraryTile(props)
	local v5 = Foundation.Hooks.useTokens()
	local v6 = Foundation.Hooks.useScaledValue(136)
	local v7 = Foundation.Hooks.useScaledValue(168)
	local v8 = props.onActivated ~= nil
	local tileKey = props.tileKey or props.itemId or props.displayName
	local v9 = props.isFolder and props.folderPreview == nil
	local model = if props.folderPreview == nil then props.model else props.folderPreview.model
	local v10 = if props.folderPreview == nil then props.thumbnail else props.folderPreview.image
	local v11

	if v9 then
		v11 = iconName.Folder
	elseif props.itemKind == "Sound" then
		v11 = iconName.Speaker
	else
		v11 = if props.itemKind == "Image" then iconName.Image else iconName.TwoStackedSquares
	end

	local v12

	if props.itemKind == "Image" and v10 ~= nil then
		v12 = React.createElement(image, {
			Image = v10,
			ScaleType = Enum.ScaleType.Fit,
			tag = "size-full",
			testId = `Library.Tile.{tileKey}.Image`
		})
	elseif model == nil then
		local createElement = React.createElement

		local v15 = if v9 or props.itemKind == "Sound" then v5.Size.Size_900 else iconSize.Large
		v12 = createElement(icon, {
			name = v11,
			size = v15,
			style = v5.Color.Content.Default,
			testId = `Library.Tile.{tileKey}.Icon`
		})
	else
		v12 = React.createElement(ModelViewport, {
			model = model,
			unavailableText = props.unavailableText,
			backgroundTransparency = 1,
			size = UDim2.fromScale(1, 1),
			isInteractive = false,
			testId = `Library.Tile.{tileKey}.Model`
		})
	end

	local element = React.createElement(view, {
		LayoutOrder = 1,
		Size = props.mediaSize or UDim2.fromScale(1, 0),
		aspectRatio = props.mediaSize == nil and 1 or nil,
		tag = "align-x-center align-y-center radius-medium clip bg-shift-200",
		testId = `Library.Tile.{tileKey}.MediaFrame`
	}, { Media = v12 })

	local createElement = React.createElement
	local v14 = {
		LayoutOrder = props.LayoutOrder,
		onActivated = props.onActivated,
		selection = { Selectable = v8 },
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		Size = 0,
		tag = 0,
		testId = 0
	}
	local v15 = props.Size

	if not v15 then
		if props.compact then
			v15 = UDim2.fromOffset(v5.Size.Size_2400, v6)
		else
			v15 = UDim2.fromOffset(v5.Size.Size_3000, v7)
		end
	end

	v14.Size = v15

	v14.tag = {
		["radius-medium"] = true,
		["col gap-small"] = not props.compact
	}

	v14.testId = `Library.Tile.{tileKey}`

	local createElement2 = React.createElement
	local v18 = {
		LayoutOrder = 2,
		tag = {
			["col position-bottom-left anchor-bottom-left size-full-800"] = props.compact,
			["col size-full-0 auto-y"] = not props.compact
		},
		testId = `Library.Tile.{tileKey}.Content`
	}

	local createElement3 = React.createElement
	local v21 = {
		LayoutOrder = 1,
		Text = props.displayName,
		TextYAlignment = Enum.TextYAlignment.Top,
		Size = 0,
		tag = "text-title-medium text-align-x-left text-truncate-end content-emphasis"
	}
	local newUDim2 = UDim2.new
	local v25 = if props.compact then v5.Size.Size_600 else v5.Size.Size_1000
	v21.Size = newUDim2(1, 0, 0, v25)
	return createElement(view, v14, {
		Thumbnail = element,
		Content = createElement2(view, v18, { Title = createElement3(text, v21) })
	})
end

return React.memo(LibraryTile)
