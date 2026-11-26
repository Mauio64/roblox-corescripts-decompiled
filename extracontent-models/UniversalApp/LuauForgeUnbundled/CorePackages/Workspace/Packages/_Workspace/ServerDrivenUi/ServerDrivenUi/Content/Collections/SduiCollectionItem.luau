local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Cryo")

local impressionsTagUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Impressions").ImpressionsTagUtility
local combineReactTags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RoactUtils").combineReactTags

local fFlagSduiOptionSelectorAnchorTag = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiOptionSelectorAnchorTag

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
		impressionsTagUtility.AddTag(ref, props.impressionsTag, props.index)
		return function()
			impressionsTagUtility.RemoveTag(ref, props.impressionsTag, props.index)
		end
	end, { ref, props.impressionsTag, props.index })

	local v5 = React.useCallback(function(current)
		ref.current = current

		if current then
			impressionsTagUtility.AddTag(ref, props.impressionsTag, props.index)
		end
	end, { props.impressionsTag, props.index })

	local v6 = React.useCallback(function(p2)
		if props.onItemSizeChanged then
			props.onItemSizeChanged(props.index, p2)
		end
	end, { props.onItemSizeChanged, props.index })
	local v7

	if innerWrapperSize == nil then
		v7 = props.children
	else
		v7 = {
			InnerWrapper = React.createElement(
				"Frame",
				{
					ref = v5,
					Size = innerWrapperSize,
					Position = UDim2.fromScale(0, 0),
					BackgroundTransparency = 1
				},
				props.children
			)
		}
	end

	if props.minHeightBinding then
		v7 = Cryo.Dictionary.join(v7 or {}, {
			SizeConstraint = React.createElement("UISizeConstraint", {
				MinSize = props.minHeightBinding:map(function(p2)
					return Vector2.new(0, not (p2 and p2 > 0) and 0 or p2)
				end)
			})
		})
	end

	local createElement = React.createElement

	if innerWrapperSize ~= nil then
		v5 = nil
	end

	local v9 = {
		["ref"] = nil,
		ref = v5,
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
		v6 = nil
	end

	v9[absoluteSize] = v6
	local tag = React.Tag
	local v10

	if fFlagSduiOptionSelectorAnchorTag then
		local tag2 = props.tag
		local v12 = if props.testId then `data-testid={props.testId}` else nil
		v10 = combineReactTags(tag2, v12)
	elseif props.testId then
		v10 = `data-testid={props.testId}`
	end

	v9[tag] = v10
	return createElement("Frame", v9, v7)
end

return React.memo(SduiCollectionItem)
