local parent = script.Parent.Parent

local CarouselIndexSelected = require(parent.Actions.CarouselIndexSelected)
local Constants = require(parent.Constants)

return function(value: number)
	return function(object)
		object:dispatch(CarouselIndexSelected((math.clamp(value, 1, #object:getState()[Constants.RoduxKey].Captures))))
	end
end
