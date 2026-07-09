local Parent = script:FindFirstAncestor("RobloxAppNavigationCore").Parent
local React = require(Parent.React)
local AppCard = require(script.Parent.AppCard)

local function AppStackCard(p1) -- line: 13
	-- upvalues: React (copy), AppCard (copy)
	React.useEffect(function() -- line: 14
		-- upvalues: p1 (copy)
		p1.onAnimationComplete()
	end, { p1.onAnimationComplete })

	return React.createElement(AppCard, {
		isActive = p1.isActive,
		descriptor = p1.descriptor,
		screenProps = p1.screenProps,
		isVisible = p1.isVisible,
		ZIndex = p1.ZIndex
	})
end

return AppStackCard
