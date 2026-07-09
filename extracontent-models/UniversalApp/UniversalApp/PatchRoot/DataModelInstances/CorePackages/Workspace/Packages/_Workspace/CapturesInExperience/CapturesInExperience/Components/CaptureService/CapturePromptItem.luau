local ParentParent = script.Parent.Parent.Parent.Parent
local CapturesCommon = require(ParentParent.CapturesCommon)
local Foundation = require(ParentParent.Foundation)
local React = require(ParentParent.React)
local Checkbox = Foundation.Checkbox
local View = Foundation.View
local getCropSize = CapturesCommon.Utils.getCropSize

return function(t1: {[any]: any}) -- line: 20
	-- upvalues: React (copy), View (copy), Foundation (copy), Checkbox (copy), getCropSize (copy)
	local v9, v10 = React.useState(Vector2.new(0, 0))
	local v11 = React.useRef(nil)
	local v12, v13 = React.useState(Vector2.new(0, 0))
	local v14 = React.useCallback(function() -- line: 25
		-- upvalues: t1 (copy)
		t1.updateSelected(not t1.isSelected)
	end, {
		t1.isSelected,
		t1.updateSelected
	})
	local v15 = React.useCallback(function(p1) -- line: 29
		-- upvalues: v10 (copy)
		v10(p1.AbsoluteSize)
	end, {})
	local v16 = React.useCallback(function(p2) -- line: 33
		-- upvalues: v11 (copy), v13 (copy)
		v11.current = p2
		v13(p2.Resolution)
	end, {})

	React.useEffect(function() -- line: 38
		-- upvalues: v11 (copy)
		return function() -- line: 39
			-- upvalues: v11 (copy)
			if v11.current then
				v11.current.Video = ""
			end
		end
	end, {})

	local v17 = typeof(t1.content) == "Content" and (t1.content.Object ~= nil and t1.content.Object:IsA("VideoCapture"))

	return React.createElement(View, {
		tag = "clip size-full",
		onAbsoluteSizeChanged = v15
	}, {
		CheckboxOverlay = if not t1.showCheckbox then nil else React.createElement(View, {
			tag = "size-full padding-small",
			ZIndex = 2,
			onActivated = v14,
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.None
			}
		}, {
			Checkbox = React.createElement(Checkbox, {
				label = "",
				AnchorPoint = Vector2.new(1, 0),
				isChecked = t1.isSelected,
				onActivated = v14,
				Position = UDim2.fromScale(1, 0)
			})
		}),
		Image = if v17 then nil else React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageContent = t1.content,
			Position = UDim2.fromScale(0.5, 0.5),
			ScaleType = Enum.ScaleType.Crop,
			Size = UDim2.fromScale(1, 1)
		}),
		Video = if not v17 then nil else React.createElement("VideoFrame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Looped = true,
			Playing = true,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = getCropSize(v9, v12),
			VideoContent = t1.content,
			Volume = 0,
			[React.Event.Loaded] = v16
		})
	})
end
