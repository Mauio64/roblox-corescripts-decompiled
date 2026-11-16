local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)

local createAnimatedVisibilityStore = require(script.Parent.createAnimatedVisibilityStore)
local AnimatedVisibilityContext = require(script.Parent.AnimatedVisibilityContext)

local function AnimatedVisibilityProvider(p)
	local animatedMenusStore = React.useMemo(function()
		return createAnimatedVisibilityStore(p.initialRatio)
	end, {})

	React.useEffect(function()
		return function()
			animatedMenusStore.destroy()
		end
	end, { animatedMenusStore })

	return React.createElement(AnimatedVisibilityContext.Provider, {
		value = { animatedMenusStore = animatedMenusStore }
	}, p.children)
end

return AnimatedVisibilityProvider
