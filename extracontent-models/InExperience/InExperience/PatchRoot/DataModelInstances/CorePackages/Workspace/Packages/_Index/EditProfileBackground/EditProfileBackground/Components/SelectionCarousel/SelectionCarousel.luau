local EditProfileBackground = script:FindFirstAncestor("EditProfileBackground")
local parent = EditProfileBackground.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local ProfileBackgroundButton = require(EditProfileBackground.Components.ProfileBackgroundButton)
local Constants = require(EditProfileBackground.Common.Constants)

local function SelectionCarousel(props)
	local state, setState = React.useState(props.currentBackgroundId or Constants.BACKGROUND_ASSET_IDS[1])

	React.useEffect(function()
		if props.currentBackgroundId then
			setState(props.currentBackgroundId)
		end
	end, { props.currentBackgroundId })

	local BACKGROUND_ASSET_IDS = Constants.BACKGROUND_ASSET_IDS
	local buttonsPerRow = props.buttonsPerRow
	local numRows = props.numRows
	local buttonSize = props.buttonSize

	local onActivated = React.useCallback(function(p: number)
		setState(p)

		task.delay(0.1, function()
			if props.onBackgroundSelected then
				props.onBackgroundSelected(p)
			end
		end)
	end, { props.onBackgroundSelected })

	local function renderRow(i: number, total: number, buttonsPerRow2: number)
		local children = {}

		table.insert(
			children,
			React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 16)
			})
		)

		table.insert(
			children,
			React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 0),
				PaddingRight = UDim.new(0, 0)
			})
		)

		for j = total, total + buttonsPerRow2 - 1 do
			local profileBackgroundId = BACKGROUND_ASSET_IDS[j]
			local selected = state == profileBackgroundId
			table.insert(children, React.createElement(ProfileBackgroundButton, {
				LayoutOrder = j,
				profileBackgroundId = profileBackgroundId,
				selected = selected,
				onActivated = onActivated,
				buttonSize = buttonSize
			}))
		end

		return React.createElement(View, {
			LayoutOrder = i,
			Size = UDim2.new(1, -32, 0, buttonSize)
		}, children)
	end

	local v = React.useMemo(function()
		local result = {}

		table.insert(result, React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 16)
		}))

		table.insert(result, React.createElement(View, {
			LayoutOrder = 0,
			Size = UDim2.new(1, 0, 0, 0)
		}))
		local total = 1

		for i = 1, numRows do
			table.insert(result, renderRow(i, total, buttonsPerRow))
			total += buttonsPerRow
		end

		return result
	end, { state })

	return React.createElement(View, {
		tag = "bg-surface-0",
		Size = UDim2.new(1, 0, 0, props.height)
	}, v)
end

return SelectionCarousel
