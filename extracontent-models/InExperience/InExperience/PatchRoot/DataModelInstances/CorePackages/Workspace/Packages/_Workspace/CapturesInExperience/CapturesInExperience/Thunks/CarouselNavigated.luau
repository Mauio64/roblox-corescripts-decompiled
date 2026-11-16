local parent = script.Parent.Parent

local CarouselIndexSelected = require(parent.Actions.CarouselIndexSelected)
local Constants = require(parent.Constants)

return function(p)
	return function(object)
		local captures = object:getState()[Constants.RoduxKey].Captures
		object:dispatch(CarouselIndexSelected((math.clamp(
			object:getState()[Constants.RoduxKey].Carousel.SelectedCaptureIndex + (p == Constants.CarouselDirection.Left and -1 or 1),
			1,
			#captures
		))))
	end
end
