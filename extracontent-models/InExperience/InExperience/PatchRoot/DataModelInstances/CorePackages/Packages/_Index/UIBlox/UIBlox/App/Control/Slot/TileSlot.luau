local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local core = parent2.Core

local React = require(parent3.React)
local Foundation = require(parent3.Foundation)

local ControlState = require(core.Control.Enum.ControlState)
local getContentStyle = require(core.Button.getContentStyle)

local Interactable = require(core.Control.Interactable)

local useStyle = require(core.Style.useStyle)
local ImageSetComponent = require(core.ImageSet.ImageSetComponent)
local Skeleton = Foundation.Skeleton
local GenericTextLabel = require(core.Text.GenericTextLabel.GenericTextLabel)
local Images = require(parent.ImageSet.Images)
local IconSize = require(parent.ImageSet.Enum.IconSize)
local getIconSize = require(parent.ImageSet.getIconSize)

local component_assetscircle_9 = Images["component_assets/circle_9"]
local component_assetscircle_9_stroke_1 = Images["component_assets/circle_9_stroke_1"]

local v = { [ControlState.Default] = "SecondaryDefault", [ControlState.Hover] = "SecondaryOnHover" }

local v2 = {
	[ControlState.Default] = "SecondaryDefault",
	[ControlState.Hover] = "SecondaryDefault"
}

local v3 = { [ControlState.Default] = "TextDefault", [ControlState.Hover] = "TextEmphasis" }

local v4 = { [ControlState.Default] = "TextEmphasis", [ControlState.Hover] = "TextEmphasis" }

local v5 = { [ControlState.Default] = "BackgroundMuted" }

local v6 = { [ControlState.Default] = "PlaceHolder" }

local v7 = { [ControlState.Default] = "PlaceHolder" }

local v8 = { [ControlState.Default] = "TextEmphasis" }

local function TileSlot(props)
	local state, setState = React.useState(ControlState.Initialize)
	local state2, setState2 = React.useState(false)

	local v9 = React.useCallback(function()
		props.onActivated(props.index)
	end, { props.onActivated, props.index })

	local onStateChanged = React.useCallback(function(p, p2)
		setState(p2)

		if p2 == ControlState.Hover then
			setState2(true)
		else
			setState2(false)
		end

		if props.onStateChanged then
			props.onStateChanged(p, p2)
		end
	end, { props.onStateChanged })

	local v10 = useStyle()

	local isDisabled = props.isDisabled
	local isLoading = props.isLoading
	state = isDisabled and ControlState.Disabled or state
	local isSelected = props.isSelected

	local v11 = isSelected and getContentStyle(v2, state, v10) or getContentStyle(v, state, v10)
	local colorStyle = isSelected and getContentStyle(v4, state, v10) or getContentStyle(v3, state, v10)
	local contentStyle = getContentStyle(v8, state, v10)

	local v12 = isSelected and getContentStyle(v6, state, v10) or getContentStyle(v5, state, v10)
	local contentStyle2 = getContentStyle(v7, state, v10)
	local subHeader1 = v10.Font.SubHeader1
	local thumbnail = props.thumbnail

	local v13 = props.thumbnail ~= nil
	local v14 = props.displayText ~= nil
	local v15 = isDisabled or isLoading
	local v16

	if v15 then
		v16 = false
	else
		v16 = state2 or isSelected
	end

	local createElement = React.createElement
	local v17 = {
		["Size"] = nil,
		Size = UDim2.fromOffset(48, 48),
		Position = props.position or UDim2.fromScale(0, 0),
		BackgroundTransparency = 1,
		onStateChanged = onStateChanged
	}

	local activated = React.Event.Activated

	if v15 or not v9 then
		v9 = nil
	end

	v17[activated] = v9

	local createElement2 = React.createElement
	local v18 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }

	local v19 = {
		Background = React.createElement(ImageSetComponent.Label, {
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0, 0),
			BackgroundTransparency = 1,
			Image = component_assetscircle_9,
			ImageColor3 = v14 and v12.Color or contentStyle2.Color,
			ImageTransparency = v14 and v12.Transparency or contentStyle2.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(4, 4, 5, 5),
			ZIndex = 1
		}),
		Border = 0,
		ButtonContentLayer = 0
	}
	local border

	if v16 then
		border = React.createElement(ImageSetComponent.Label, {
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0, 0),
			BackgroundTransparency = 1,
			Image = component_assetscircle_9_stroke_1,
			ImageColor3 = v11.Color,
			ImageTransparency = v11.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(4, 4, 5, 5),
			ZIndex = 2
		})
	end

	v19.Border = border

	local createElement3 = React.createElement
	local v20 = {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0, 0),
		BackgroundTransparency = 1,
		ZIndex = 3
	}
	local thumbnail2

	if not (isLoading or not v13) then
		thumbnail2 = React.createElement(ImageSetComponent.Label, {
			Size = UDim2.fromOffset(getIconSize(IconSize.Medium), getIconSize(IconSize.Medium)),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Image = thumbnail,
			ImageColor3 = contentStyle.Color,
			ImageTransparency = contentStyle.Transparency,
			ZIndex = 3
		})
	end

	local text

	if not (isLoading or not v14) then
		text = React.createElement(GenericTextLabel, {
			Size = UDim2.new(1, -24, 1, -24),
			BackgroundTransparency = 1,
			Text = props.displayText,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			fontStyle = subHeader1,
			colorStyle = colorStyle,
			ZIndex = 3
		})
	end

	local loadingShimmer

	if isLoading then
		loadingShimmer = React.createElement(Skeleton, { Size = UDim2.fromScale(1, 1) })
	end

	v19.ButtonContentLayer = createElement3("Frame", v20, {
		Thumbnail = thumbnail2,
		Text = text,
		LoadingShimmer = loadingShimmer
	})
	return createElement(Interactable, v17, {
		Button = createElement2("Frame", v18, v19)
	})
end

return TileSlot
