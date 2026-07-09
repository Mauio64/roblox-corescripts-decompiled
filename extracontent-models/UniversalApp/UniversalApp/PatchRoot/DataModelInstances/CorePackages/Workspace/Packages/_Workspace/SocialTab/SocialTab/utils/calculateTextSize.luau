local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local t = dependencies.t
local dependenciesText = dependencies.Text
local memoize = dependencies.memoize
local v6 = t.interface({
	text = t.string,
	font = t.interface({
		Font = t.Font,
		RelativeSize = t.number
	}),
	baseSize = t.number
})

return function() -- line: 19
	-- upvalues: memoize (copy), v6 (copy), dependenciesText (copy)
	return memoize(function(p1, p2, p3) -- line: 20
		-- upvalues: v6 (copy), dependenciesText (copy)
		assert(v6({
			text = p1,
			font = p2,
			baseSize = p3
		}))

		local v10 = p2.RelativeSize * p3

		return dependenciesText.GetTextBounds(p1, p2.Font, v10, Vector2.new(10000, 10000))
	end)
end
