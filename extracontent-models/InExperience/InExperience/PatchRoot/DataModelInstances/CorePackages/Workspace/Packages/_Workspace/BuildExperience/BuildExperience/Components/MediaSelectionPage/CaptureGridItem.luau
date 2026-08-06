local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Checkbox = Foundation.Checkbox
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function CaptureGridItem(t1: {[any]: any}) -- line: 18
	-- upvalues: useTokens (copy), React (copy), View (copy), Foundation (copy), Checkbox (copy)
	local v9 = useTokens()
	local v10 = React.useCallback(function() -- line: 21
		-- upvalues: t1 (copy)
		t1.onActivated(t1.capture)
	end, {
		t1.capture,
		t1.onActivated
	})

	return React.createElement(View, {
		tag = "size-full",
		onActivated = v10,
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		stroke = if not t1.isSelected then nil else {
			Color = v9.Color.Content.Emphasis.Color3,
			Thickness = v9.Stroke.Thick,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		}
	}, {
		CaptureThumbnail = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 1,
			ImageContent = if typeof(t1.capture) ~= "Object" then Content.none else Content.fromObject(t1.capture),
			ScaleType = Enum.ScaleType.Crop,
			Size = UDim2.fromScale(1, 1)
		}),
		SelectionOverlay = if not t1.isSelected then nil else React.createElement(View, {
			tag = "size-full padding-small",
			ZIndex = 3
		}, {
			SelectedIndicator = React.createElement(Checkbox, {
				isChecked = true,
				label = "",
				AnchorPoint = Vector2.new(1, 0),
				onActivated = function() -- line: 57
					-- upvalues: v10 (copy)
					v10()
				end,
				Position = UDim2.fromScale(1, 0),
				size = Foundation.Enums.InputSize.Small
			})
		})
	})
end

return CaptureGridItem
