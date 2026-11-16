local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(parent.React)
local Cryo = require(parent.Cryo)

local Impressions = require(parent.Impressions)
local ImpressionsTagUtility = Impressions.ImpressionsTagUtility
local RoactUtils = require(parent.RoactUtils)
local combineReactTags = RoactUtils.combineReactTags

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiOptionSelectorAnchorTag = SharedFlags.FFlagSduiOptionSelectorAnchorTag

local function SduiCollectionItem(props)
	local layoutOrder = props.layoutOrder
	local size = props.size
	local position = props.position
	local anchorPoint = props.anchorPoint
	local zIndex = props.zIndex
	local automaticSize = props.automaticSize
	local innerWrapperSize = props.innerWrapperSize
	local ref = React.useRef(nil)
	React.useEffect(function()
		ImpressionsTagUtility.AddTag(ref, props.impressionsTag, props.index)
		return function()
			ImpressionsTagUtility.RemoveTag(ref, props.impressionsTag, props.index)
		end
	end, { ref, props.impressionsTag, props.index })

	local ref2 = React.useCallback(function(current)
		ref.current = current

		if current then
			ImpressionsTagUtility.AddTag(ref, props.impressionsTag, props.index)
		end
	end, { props.impressionsTag, props.index })

	local v = React.useCallback(function(p)
		if props.onItemSizeChanged then
			props.onItemSizeChanged(props.index, p)
		end
	end, { props.onItemSizeChanged, props.index })
	local v2

	if innerWrapperSize == nil then
		v2 = props.children
	else
		v2 = {
			InnerWrapper = React.createElement(
				"Frame",
				{
					ref = ref2,
					Size = innerWrapperSize,
					Position = UDim2.fromScale(0, 0),
					BackgroundTransparency = 1
				},
				props.children
			)
		}
	end

	if props.minHeightBinding then
		v2 = Cryo.Dictionary.join(v2 or {}, {
			SizeConstraint = React.createElement("UISizeConstraint", {
				MinSize = props.minHeightBinding:map(function(p: number?)
					return Vector2.new(0, not (p and p > 0) and 0 or p)
				end)
			})
		})
	end

	local createElement = React.createElement

	if innerWrapperSize ~= nil then
		ref2 = nil
	end

	local v3 = {
		["ref"] = nil,
		ref = ref2,
		AnchorPoint = anchorPoint,
		Position = position,
		Size = size,
		LayoutOrder = layoutOrder or props.index,
		ZIndex = zIndex,
		BackgroundTransparency = 1,
		AutomaticSize = automaticSize
	}

	local absoluteSize = React.Change.AbsoluteSize

	if not props.onItemSizeChanged then
		v = nil
	end

	v3[absoluteSize] = v
	local tag = React.Tag
	local v4

	if FFlagSduiOptionSelectorAnchorTag then
		local tag2 = props.tag
		local v5

		if props.testId then
			v5 = `data-testid={props.testId}`
		end

		v4 = combineReactTags(tag2, v5)
	elseif props.testId then
		v4 = `data-testid={props.testId}`
	end

	v3[tag] = v4
	return createElement("Frame", v3, v2)
end

return React.memo(SduiCollectionItem)
