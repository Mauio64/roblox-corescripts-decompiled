local EditProfileBackground = script:FindFirstAncestor("EditProfileBackground")
local EditProfileBackgroundParent = EditProfileBackground.Parent
local React = require(EditProfileBackgroundParent.React)
local View = require(EditProfileBackgroundParent.Foundation).View
local ProfileBackgroundButton = require(EditProfileBackground.Components.ProfileBackgroundButton)
local Constants = require(EditProfileBackground.Common.Constants)

local function SelectionCarousel(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), Constants (copy), ProfileBackgroundButton (copy), View (copy)
	local v9, v10 = React.useState(t1.currentBackgroundId or Constants.BACKGROUND_ASSET_IDS[1])

	React.useEffect(function() -- line: 23
		-- upvalues: t1 (copy), v10 (copy)
		if t1.currentBackgroundId then
			v10(t1.currentBackgroundId)
		end
	end, { t1.currentBackgroundId })

	local BACKGROUND_ASSET_IDS = Constants.BACKGROUND_ASSET_IDS
	local buttonsPerRow = t1.buttonsPerRow
	local numRows = t1.numRows
	local buttonSize = t1.buttonSize
	local v15 = React.useCallback(function(n1: number) -- line: 38
		-- upvalues: v10 (copy), t1 (copy)
		v10(n1)
		task.delay(0.1, function() -- line: 42
			-- upvalues: t1 (copy), n1 (copy)
			if t1.onBackgroundSelected then
				t1.onBackgroundSelected(n1)
			end
		end)
	end, { t1.onBackgroundSelected })

	local function renderRow(n2: number, n3: number, n4: number) -- line: 49
		-- upvalues: React (copy), BACKGROUND_ASSET_IDS (copy), v9 (copy), ProfileBackgroundButton (copy), v15 (copy), buttonSize (copy), View (copy), buttonSize (copy)
		local t2 = {}

		table.insert(t2, React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 16)
		}))
		table.insert(t2, React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 0),
			PaddingRight = UDim.new(0, 0)
		}))

		for i = n3, n3 + n4 - 1 do
			local v24 = BACKGROUND_ASSET_IDS[i]
			local v25 = v24 == v9

			table.insert(t2, React.createElement(ProfileBackgroundButton, {
				LayoutOrder = i,
				profileBackgroundId = v24,
				selected = v25,
				onActivated = v15,
				buttonSize = buttonSize
			}))
		end

		return React.createElement(View, {
			LayoutOrder = n2,
			Size = UDim2.new(1, -32, 0, buttonSize)
		}, t2)
	end

	local v17 = React.useMemo(function() -- line: 93
		-- upvalues: React (copy), View (copy), numRows (copy), renderRow (copy), buttonsPerRow (copy)
		local t3 = {}

		table.insert(t3, React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 16)
		}))
		table.insert(t3, React.createElement(View, {
			LayoutOrder = 0,
			Size = UDim2.new(1, 0, 0, 0)
		}))

		local n5 = 1

		for i = 1, numRows do
			table.insert(t3, renderRow(i, n5, buttonsPerRow))
			n5 += buttonsPerRow
		end

		return t3
	end, { v9 })

	return React.createElement(View, {
		tag = "bg-surface-0",
		Size = UDim2.new(1, 0, 0, t1.height)
	}, v17)
end

return SelectionCarousel
