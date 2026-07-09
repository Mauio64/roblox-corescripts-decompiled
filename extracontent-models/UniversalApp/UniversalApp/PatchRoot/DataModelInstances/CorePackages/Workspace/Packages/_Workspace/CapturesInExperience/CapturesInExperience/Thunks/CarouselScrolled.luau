local ParentParent = script.Parent.Parent
local CarouselIndexSelected = require(ParentParent.Actions.CarouselIndexSelected)
local Constants = require(ParentParent.Constants)

return function(n1: number) -- line: 6
	-- upvalues: Constants (copy), CarouselIndexSelected (copy)
	return function(p1) -- line: 7
		-- upvalues: Constants (copy), n1 (copy), CarouselIndexSelected (copy)
		local Captures = p1:getState()[Constants.RoduxKey].Captures
		local v7 = math.clamp(n1, 1, #Captures)

		p1:dispatch(CarouselIndexSelected(v7))
	end
end
