local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Foundation")
local Impressions = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Impressions")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/React")

local view = Foundation.View
local text = Foundation.Text
local image = Foundation.Image
local impressionsTagUtility = Impressions.ImpressionsTagUtility
local useLocalization = Localization.Hooks.useLocalization

local function TraversalExperienceCard(props, callback)
	local v5 = Foundation.Hooks.useTokens()

	local foreground = v5.Color.ActionStandard.Foreground
	local size_2500 = v5.Size.Size_2500
	local v6

	if typeof(props.width) == "table" then
		v6 = props.width:map(function(p2)
			return UDim2.fromOffset(p2 or size_2500, 0)
		end)
	else
		v6 = UDim2.fromOffset(props.width or size_2500, 0)
	end

	local v7

	if props.rating then
		v7 = useLocalization({
			ratingText = {
				"Feature.GameDetails.RatingPercentOnly",
				percentRating = props.rating
			}
		})
	end

	local ref = React.useRef(nil)
	local v8 = React.useCallback(function(current)
		ref.current = current

		if typeof(callback) == "function" then
			callback(current)
		elseif typeof(callback) == "table" then
			callback.current = current
		end
	end, {})

	React.useEffect(function()
		if ref.current and props.impressionTag and props.impressionIndex then
			impressionsTagUtility.AddTag(ref, props.impressionTag, props.impressionIndex)
			return function()
				impressionsTagUtility.RemoveTag(ref, props.impressionTag, props.impressionIndex)
			end
		end
	end, { props.impressionTag, props.impressionIndex })

	local createElement = React.createElement
	local v10 = {
		tag = "auto-y align-x-center align-y-top col radius-medium",
		Size = v6,
		onActivated = props.onActivated,
		ref = v8
	}

	local v12 = if props.image then React.createElement(image, {
		Image = props.image,
		tag = "size-full-full radius-medium aspect-1-1",
		style = foreground
	}) else nil
	return createElement(view, v10, {
		PlaceIcon = v12,
		Text = React.createElement(
			view,
			{
				tag = "size-full-0 auto-y col gap-xsmall padding-y-medium",
				textStyle = foreground
			},
			{
				Name = React.createElement(text, {
					tag = "size-full-0 auto-y text-truncate-split text-title-medium text-align-x-left",
					Text = props.name
				}),
				Rating = props.rating and React.createElement(text, {
					tag = "size-full-0 auto-y text-truncate-end text-align-x-left text-body-medium ",
					Text = v7.ratingText
				})
			}
		)
	})
end

return React.memo(React.forwardRef(TraversalExperienceCard))
