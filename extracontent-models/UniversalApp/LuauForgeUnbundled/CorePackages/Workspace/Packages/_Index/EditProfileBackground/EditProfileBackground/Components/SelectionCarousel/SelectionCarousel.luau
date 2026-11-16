local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/React")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/Foundation").View
local ProfileBackgroundButton = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Components/ProfileBackgroundButton")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Common/Constants")

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

	local v5 = React.useCallback(function(p2)
		setState(p2)

		task.delay(0.1, function()
			if props.onBackgroundSelected then
				props.onBackgroundSelected(p2)
			end
		end)
	end, { props.onBackgroundSelected })

	local function renderRow(i, total, buttonsPerRow2)
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
			local v6 = BACKGROUND_ASSET_IDS[j]
			local v7 = state == v6
			table.insert(children, React.createElement(ProfileBackgroundButton, {
				LayoutOrder = j,
				profileBackgroundId = v6,
				selected = v7,
				onActivated = v5,
				buttonSize = buttonSize
			}))
		end

		return React.createElement(
			view,
			{
				LayoutOrder = i,
				Size = UDim2.new(1, -32, 0, buttonSize)
			},
			children
		)
	end

	local v6 = React.useMemo(function()
		local result = {}

		table.insert(result, React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 16)
		}))

		table.insert(result, React.createElement(view, {
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

	return React.createElement(view, {
		tag = "bg-surface-0",
		Size = UDim2.new(1, 0, 0, props.height)
	}, v6)
end

return SelectionCarousel
