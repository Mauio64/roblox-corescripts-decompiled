local parent = script:FindFirstAncestor("CoreScriptsRoactCommon").Parent

local Foundation = require(parent.Foundation)
local Impressions = require(parent.Impressions)
local Localization = require(parent.Localization)
local React = require(parent.React)

local View = Foundation.View
local Text = Foundation.Text
local Image = Foundation.Image
local ImpressionsTagUtility = Impressions.ImpressionsTagUtility
local useLocalization = Localization.Hooks.useLocalization

local function TraversalExperienceCard(props, callback)
	local v = Foundation.Hooks.useTokens()

	local foreground = v.Color.ActionStandard.Foreground
	local size_2500 = v.Size.Size_2500
	local size

	if typeof(props.width) == "table" then
		size = props.width:map(function(p: number?)
			return UDim2.fromOffset(p or size_2500, 0)
		end)
	else
		size = UDim2.fromOffset(props.width or size_2500, 0)
	end

	local v2

	if props.rating then
		v2 = useLocalization({
			ratingText = {
				"Feature.GameDetails.RatingPercentOnly",
				percentRating = props.rating
			}
		})
	end

	local ref = React.useRef(nil)
	local ref2 = React.useCallback(function(current)
		ref.current = current

		if typeof(callback) == "function" then
			callback(current)
		elseif typeof(callback) == "table" then
			callback.current = current
		end
	end, {})

	React.useEffect(function()
		if ref.current and props.impressionTag and props.impressionIndex then
			ImpressionsTagUtility.AddTag(ref, props.impressionTag, props.impressionIndex)
			return function()
				ImpressionsTagUtility.RemoveTag(ref, props.impressionTag, props.impressionIndex)
			end
		end
	end, { props.impressionTag, props.impressionIndex })

	local createElement = React.createElement
	local v3 = {
		tag = "auto-y align-x-center align-y-top col radius-medium",
		Size = size,
		onActivated = props.onActivated,
		ref = ref2
	}
	local placeIcon

	if props.image then
		placeIcon = React.createElement(Image, {
			Image = props.image,
			tag = "size-full-full radius-medium aspect-1-1",
			style = foreground
		})
	end

	return createElement(View, v3, {
		PlaceIcon = placeIcon,
		Text = React.createElement(
			View,
			{ tag = "size-full-0 auto-y col gap-xsmall padding-y-medium", textStyle = foreground },
			{
				Name = React.createElement(Text, {
					tag = "size-full-0 auto-y text-truncate-split text-title-medium text-align-x-left",
					Text = props.name
				}),
				Rating = props.rating and React.createElement(Text, {
					tag = "size-full-0 auto-y text-truncate-end text-align-x-left text-body-medium ",
					Text = v2.ratingText
				})
			}
		)
	})
end

return React.memo(React.forwardRef(TraversalExperienceCard))
