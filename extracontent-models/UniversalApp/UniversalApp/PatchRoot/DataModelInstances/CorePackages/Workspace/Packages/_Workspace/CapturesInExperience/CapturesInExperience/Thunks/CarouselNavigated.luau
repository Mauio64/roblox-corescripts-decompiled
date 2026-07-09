local ParentParent = script.Parent.Parent
local CarouselIndexSelected = require(ParentParent.Actions.CarouselIndexSelected)
local Constants = require(ParentParent.Constants)

return function(p1) -- line: 6
	-- upvalues: Constants (copy), CarouselIndexSelected (copy)
	return function(p2) -- line: 7
		-- upvalues: Constants (copy), p1 (copy), CarouselIndexSelected (copy)
		local Captures = p2:getState()[Constants.RoduxKey].Captures
		local v7 = math.clamp(p2:getState()[Constants.RoduxKey].Carousel.SelectedCaptureIndex + (p1 ~= Constants.CarouselDirection.Left and 1 or -1), 1, #Captures)

		p2:dispatch(CarouselIndexSelected(v7))
	end
end
