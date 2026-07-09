local TransitionAnimation = require(script.Parent.Enum.TransitionAnimation)
local t1 = {
	[TransitionAnimation.SlideInFromRight] = "slideInFromRight",
	[TransitionAnimation.SlideInFromBottom] = "slideInFromBottom"
}

return function(s1: string?) -- line: 8
	-- upvalues: t1 (copy)
	if s1 then
		return t1[s1]
	end

	return nil
end
