local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

require(script.Parent.LibraryTypes)
local ModelViewport = require(BuildExperience.Components.Library.ModelViewport)

local Image = Foundation.Image
local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View

local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize

local function LibraryTile(props)
	local v = Foundation.Hooks.useTokens()
	local v2 = Foundation.Hooks.useScaledValue(136)
	local v3 = Foundation.Hooks.useScaledValue(168)
	local selectable = props.onActivated ~= nil
	local tileKey = props.tileKey or props.itemId or props.displayName
	local v4 = props.isFolder and props.folderPreview == nil
	local model

	if props.folderPreview == nil then
		model = props.model
	else
		model = props.folderPreview.model
	end

	local image

	if props.folderPreview == nil then
		image = props.thumbnail
	else
		image = props.folderPreview.image
	end

	local name

	if v4 then
		name = IconName.Folder
	elseif props.itemKind == "Sound" then
		name = IconName.Speaker
	elseif props.itemKind == "Image" then
		name = IconName.Image
	else
		name = IconName.TwoStackedSquares
	end

	local media

	if props.itemKind == "Image" and image ~= nil then
		media = React.createElement(Image, {
			Image = image,
			ScaleType = Enum.ScaleType.Fit,
			tag = "size-full",
			testId = `Library.Tile.{tileKey}.Image`
		})
	elseif model == nil then
		local createElement = React.createElement
		local size

		if v4 or props.itemKind == "Sound" then
			size = v.Size.Size_900
		else
			size = IconSize.Large
		end

		media = createElement(Icon, {
			name = name,
			size = size,
			style = v.Color.Content.Default,
			testId = `Library.Tile.{tileKey}.Icon`
		})
	else
		media = React.createElement(ModelViewport, {
			model = model,
			unavailableText = props.unavailableText,
			backgroundTransparency = 1,
			size = UDim2.fromScale(1, 1),
			isInteractive = false,
			testId = `Library.Tile.{tileKey}.Model`
		})
	end

	local element = React.createElement(View, {
		LayoutOrder = 1,
		Size = props.mediaSize or UDim2.fromScale(1, 0),
		aspectRatio = props.mediaSize == nil and 1 or nil,
		tag = "align-x-center align-y-center radius-medium clip bg-shift-200",
		testId = `Library.Tile.{tileKey}.MediaFrame`
	}, { Media = media })

	local createElement = React.createElement
	local v5 = {
		LayoutOrder = props.LayoutOrder,
		onActivated = props.onActivated,
		selection = { Selectable = selectable },
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		Size = 0,
		tag = 0,
		testId = 0
	}
	local size = props.Size

	if not size then
		if props.compact then
			size = UDim2.fromOffset(v.Size.Size_2400, v2)
		else
			size = UDim2.fromOffset(v.Size.Size_3000, v3)
		end
	end

	v5.Size = size

	v5.tag = {
		["radius-medium"] = true,
		["col gap-small"] = not props.compact
	}

	v5.testId = `Library.Tile.{tileKey}`

	local createElement2 = React.createElement
	local v6 = {
		LayoutOrder = 2,
		tag = {
			["col position-bottom-left anchor-bottom-left size-full-800"] = props.compact,
			["col size-full-0 auto-y"] = not props.compact
		},
		testId = `Library.Tile.{tileKey}.Content`
	}

	local createElement3 = React.createElement
	local v7 = {
		LayoutOrder = 1,
		Text = props.displayName,
		TextYAlignment = Enum.TextYAlignment.Top,
		Size = 0,
		tag = "text-title-medium text-align-x-left text-truncate-end content-emphasis"
	}
	local v8

	if props.compact then
		v8 = v.Size.Size_600
	else
		v8 = v.Size.Size_1000
	end

	v7.Size = UDim2.new(1, 0, 0, v8)
	return createElement(View, v5, {
		Thumbnail = element,
		Content = createElement2(View, v6, { Title = createElement3(Text, v7) })
	})
end

return React.memo(LibraryTile)
