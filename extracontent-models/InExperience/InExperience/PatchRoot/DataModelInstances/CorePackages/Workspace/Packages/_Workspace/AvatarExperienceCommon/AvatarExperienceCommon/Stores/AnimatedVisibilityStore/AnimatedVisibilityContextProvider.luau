local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local createAnimatedVisibilityStore = require(script.Parent.createAnimatedVisibilityStore)
local AnimatedVisibilityContext = require(script.Parent.AnimatedVisibilityContext)

local function AnimatedVisibilityProvider(t1: {[any]: any}) -- line: 14
	-- upvalues: React (copy), createAnimatedVisibilityStore (copy), AnimatedVisibilityContext (copy)
	local v7 = React.useMemo(function() -- line: 15
		-- upvalues: createAnimatedVisibilityStore (copy), t1 (copy)
		return createAnimatedVisibilityStore(t1.initialRatio)
	end, {})

	React.useEffect(function() -- line: 19
		-- upvalues: v7 (copy)
		return function() -- line: 20
			-- upvalues: v7 (copy)
			v7.destroy()
		end
	end, { v7 })

	return React.createElement(AnimatedVisibilityContext.Provider, {
		value = {
			animatedMenusStore = v7
		}
	}, t1.children)
end

return AnimatedVisibilityProvider
