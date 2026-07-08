local Parent = script:FindFirstAncestor("CoreScriptsRoactCommon").Parent
local Foundation = require(Parent.Foundation)
local Impressions = require(Parent.Impressions)
local Localization = require(Parent.Localization)
local React = require(Parent.React)
local View = Foundation.View
local FoundationText = Foundation.Text
local FoundationImage = Foundation.Image
local ImpressionsTagUtility = Impressions.ImpressionsTagUtility
local useLocalization = Localization.Hooks.useLocalization
local FFlagTraversalExpCardFontSizeFix = require(script.Parent.Flags).FFlagTraversalExpCardFontSizeFix

local function TraversalExperienceCard(t1: {[any]: any}, p1) -- line: 27
	-- upvalues: Foundation (copy), useLocalization (copy), React (copy), ImpressionsTagUtility (copy), View (copy), FoundationImage (copy), FoundationText (copy), FFlagTraversalExpCardFontSizeFix (copy)
	local v15 = Foundation.Hooks.useTokens()
	local Foreground = v15.Color.ActionStandard.Foreground
	local Size_2500 = v15.Size.Size_2500
	local v18 = if typeof(t1.width) ~= "table" then UDim2.fromOffset(t1.width or Size_2500, 0) else t1.width:map(function(n1: number?) -- line: 33
		-- upvalues: Size_2500 (copy)
		return UDim2.fromOffset(n1 or Size_2500, 0)
	end)
	local v19 = if not t1.rating then nil else useLocalization({
		ratingText = {
			"Feature.GameDetails.RatingPercentOnly",
			percentRating = t1.rating
		}
	})
	local v20 = React.useRef(nil)
	local v21 = React.useCallback(function(p2) -- line: 48
		-- upvalues: v20 (copy), p1 (copy)
		v20.current = p2

		if typeof(p1) == "function" then
			p1(p2)

			return
		end

		if typeof(p1) == "table" then
			p1.current = p2
		end
	end, {})

	React.useEffect(function() -- line: 57
		-- upvalues: v20 (copy), t1 (copy), ImpressionsTagUtility (copy)
		if not v20.current or (not t1.impressionTag or not t1.impressionIndex) then
			return
		end

		ImpressionsTagUtility.AddTag(v20, t1.impressionTag, t1.impressionIndex)

		return function() -- line: 63
			-- upvalues: ImpressionsTagUtility (copy), v20 (copy), t1 (copy)
			ImpressionsTagUtility.RemoveTag(v20, t1.impressionTag, t1.impressionIndex)
		end
	end, {
		t1.impressionTag,
		t1.impressionIndex
	})

	return React.createElement(View, {
		tag = "auto-y align-x-center align-y-top col radius-medium",
		Size = v18,
		onActivated = t1.onActivated,
		ref = v21
	}, {
		PlaceIcon = if not t1.image then nil else React.createElement(FoundationImage, {
			tag = "size-full-full radius-medium aspect-1-1",
			Image = t1.image,
			style = Foreground
		}),
		Text = React.createElement(View, {
			tag = "size-full-0 auto-y col gap-xsmall padding-y-medium",
			textStyle = Foreground
		}, {
			Name = React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-truncate-split text-title-medium text-align-x-left",
				Text = t1.name
			}),
			Rating = t1.rating and React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-truncate-end text-align-x-left " .. (not FFlagTraversalExpCardFontSizeFix and "text-body-small " or "text-body-medium "),
				Text = v19.ratingText
			})
		})
	})
end

return React.memo(React.forwardRef(TraversalExperienceCard))
