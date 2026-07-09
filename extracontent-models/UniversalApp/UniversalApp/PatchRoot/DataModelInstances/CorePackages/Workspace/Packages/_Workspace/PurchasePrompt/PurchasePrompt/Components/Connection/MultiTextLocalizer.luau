local Parent = script:FindFirstAncestor("PurchasePrompt").Parent
local PurchasePromptDeps = require(Parent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact
local t = PurchasePromptDeps.t
local LocalizationContextConsumer = require(script.Parent.LocalizationContextConsumer)
local v6 = t.strictInterface({
	locKeys = t.table,
	render = t.callback
})
local v7 = t.strictInterface({
	key = t.string,
	params = t.optional(t.table)
})

local function MultiTextLocalizer(p1) -- line: 20
	-- upvalues: v6 (copy), v7 (copy), Roact (copy), LocalizationContextConsumer (copy)
	assert(v6(p1))

	for _, v in pairs(p1.locKeys) do
		assert(v7(v))
	end

	local render = p1.render

	return Roact.createElement(LocalizationContextConsumer, {
		render = function(p2) -- line: 29
			-- upvalues: p1 (copy), render (copy)
			local t1 = {}

			for k, v in pairs(p1.locKeys) do
				t1[k] = p2:Format(v.key, v.params)
			end

			return render(t1)
		end
	})
end

return MultiTextLocalizer
