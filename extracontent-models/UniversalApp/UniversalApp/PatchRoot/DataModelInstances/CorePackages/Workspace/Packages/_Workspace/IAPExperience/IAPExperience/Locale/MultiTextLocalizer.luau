local ParentParent = script.Parent.Parent.Parent
local Roact = require(ParentParent.Roact)
local t = require(ParentParent.t)
local LocaleRoactContext = require(script.Parent.LocaleRoactContext)
local v5 = t.strictInterface({
	keys = t.table,
	render = t.callback
})
local v6 = t.strictInterface({
	key = t.string,
	params = t.optional(t.table)
})

local function MultiTextLocalizer(p1) -- line: 19
	-- upvalues: v5 (copy), v6 (copy), Roact (copy), LocaleRoactContext (copy)
	assert(v5(p1))

	for _, v in pairs(p1.keys) do
		assert(v6(v))
	end

	local render = p1.render

	return Roact.createElement(LocaleRoactContext.Consumer, {
		render = function(p2) -- line: 28
			-- upvalues: p1 (copy), render (copy)
			local t1 = {}

			for k, v in pairs(p1.keys) do
				t1[k] = p2:Format(v.key, v.params)
			end

			return render(t1)
		end
	})
end

return MultiTextLocalizer
