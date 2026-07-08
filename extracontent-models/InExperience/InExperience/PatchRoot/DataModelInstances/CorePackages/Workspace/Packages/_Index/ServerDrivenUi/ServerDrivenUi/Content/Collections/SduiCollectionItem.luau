local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local ImpressionsTagUtility = require(Parent.Impressions).ImpressionsTagUtility
local FFlagSduiPoolBackedFeed = require(Parent.SharedFlags).FFlagSduiPoolBackedFeed

local function SduiCollectionItem(t1: {[any]: any}) -- line: 34
	-- upvalues: FFlagSduiPoolBackedFeed (copy), React (copy), ImpressionsTagUtility (copy), Cryo (copy)
	local layoutOrder = t1.layoutOrder
	local size = t1.size
	local position = t1.position
	local anchorPoint = t1.anchorPoint
	local zIndex = t1.zIndex
	local automaticSize = t1.automaticSize
	local v14 = if not FFlagSduiPoolBackedFeed then nil else t1.innerWrapperSize
	local v15 = React.useRef(nil)

	React.useEffect(function() -- line: 44
		-- upvalues: ImpressionsTagUtility (copy), v15 (copy), t1 (copy)
		ImpressionsTagUtility.AddTag(v15, t1.impressionsTag, t1.index)

		return function() -- line: 46
			-- upvalues: ImpressionsTagUtility (copy), v15 (copy), t1 (copy)
			ImpressionsTagUtility.RemoveTag(v15, t1.impressionsTag, t1.index)
		end
	end, {
		v15,
		t1.impressionsTag,
		t1.index
	})

	local v16 = React.useCallback(function(p1) -- line: 51
		-- upvalues: v15 (copy), ImpressionsTagUtility (copy), t1 (copy)
		v15.current = p1

		if p1 then
			ImpressionsTagUtility.AddTag(v15, t1.impressionsTag, t1.index)
		end
	end, {
		t1.impressionsTag,
		t1.index
	})
	local v17 = React.useCallback(function(p2) -- line: 58
		-- upvalues: t1 (copy)
		if t1.onItemSizeChanged then
			t1.onItemSizeChanged(t1.index, p2)
		end
	end, {
		t1.onItemSizeChanged,
		t1.index
	})
	local v18 = if not FFlagSduiPoolBackedFeed or v14 == nil then t1.children else {
		InnerWrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ref = v16,
			Size = v14,
			Position = UDim2.fromScale(0, 0)
		}, t1.children)
	}

	if t1.minHeightBinding then
		v18 = Cryo.Dictionary.join(v18 or {}, {
			SizeConstraint = React.createElement("UISizeConstraint", {
				MinSize = t1.minHeightBinding:map(function(n1: number?) -- line: 85
					return Vector2.new(0, (not n1 or not (n1 > 0)) and 0 or n1)
				end)
			})
		})
	end

	return React.createElement("Frame", {
		ref = if not FFlagSduiPoolBackedFeed or v14 == nil then v16 else nil,
		AnchorPoint = anchorPoint,
		Position = position,
		Size = size,
		LayoutOrder = layoutOrder or t1.index,
		ZIndex = zIndex,
		BackgroundTransparency = 1,
		AutomaticSize = automaticSize,
		[React.Change.AbsoluteSize] = if not t1.onItemSizeChanged then nil else v17,
		[React.Tag] = if not t1.testId then nil else `data-testid={ t1.testId }`
	}, v18)
end

return React.memo(SduiCollectionItem)
