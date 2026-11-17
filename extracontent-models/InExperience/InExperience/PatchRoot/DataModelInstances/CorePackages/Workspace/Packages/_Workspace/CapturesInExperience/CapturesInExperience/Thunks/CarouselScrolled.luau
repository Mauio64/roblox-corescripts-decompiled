local parent = script.Parent.Parent

local CarouselIndexSelected = require(parent.Actions.CarouselIndexSelected)
local Constants = require(parent.Constants)

return function(value: number)
	return function(object)
		local captures = object:getState()[Constants.RoduxKey].Captures

		object:dispatch(CarouselIndexSelected((math.clamp(value, 1, #captures))))
	end
end
