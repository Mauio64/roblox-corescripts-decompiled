local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)

require(Parent.SduiCompat)

local SduiText = require(script.Parent.SduiText)
local useShimmerText = require(script.Parent.useShimmerText)

local function SduiShimmerText(p1) -- line: 19
	-- upvalues: useShimmerText (copy), React (copy), Cryo (copy), SduiText (copy)
	local v8 = useShimmerText({
		animationSpeed = p1.animationSpeed,
		children = p1.children,
		gradientOffset = p1.gradientOffset,
		isShimmerEnabled = p1.isShimmerEnabled,
		textStyle = p1.textStyle
	})
	local v9 = React.useMemo(function() -- line: 28
		-- upvalues: Cryo (copy), p1 (copy), v8 (copy)
		return Cryo.Dictionary.join(p1, {
			animationSpeed = Cryo.None,
			children = Cryo.None,
			gradientOffset = Cryo.None,
			isShimmerEnabled = Cryo.None,
			textStyle = v8.textStyle
		})
	end, {
		p1,
		v8.textStyle
	})

	return React.createElement(SduiText, v9, v8.children)
end

return SduiShimmerText
