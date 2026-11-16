local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local react = dependencies.React

local getTextBoundsAsync = dependencies.Foundation.Utility.getTextBoundsAsync

return function(p: string, p2, p3: number, p4: number?)
	local state, setState = react.useState(nil)

	react.useEffect(function()
		local v = false
		task.spawn(function()
			local textBoundsAsync = getTextBoundsAsync(p, p2, p3, p4)

			if textBoundsAsync and not v then
				setState(textBoundsAsync)
			end
		end)

		return function()
			v = true
		end
	end, { p, p2, p3, p4 })

	return state
end
