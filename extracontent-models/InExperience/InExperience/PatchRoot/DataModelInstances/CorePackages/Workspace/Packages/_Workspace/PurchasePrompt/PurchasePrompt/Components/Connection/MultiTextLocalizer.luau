local parent = script:FindFirstAncestor("PurchasePrompt").Parent

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact
local t = PurchasePromptDeps.t

local LocalizationContextConsumer = require(script.Parent.LocalizationContextConsumer)

local strictInterface = t.strictInterface({ locKeys = t.table, render = t.callback })

local strictInterface2 = t.strictInterface({ key = t.string, params = t.optional(t.table) })

local function MultiTextLocalizer(p)
	assert(strictInterface(p))

	for _, locKey in pairs(p.locKeys) do
		assert(strictInterface2(locKey))
	end

	local render = p.render

	return Roact.createElement(LocalizationContextConsumer, {
		render = function(object)
			local v = {}

			for k, locKey in pairs(p.locKeys) do
				v[k] = object:Format(locKey.key, locKey.params)
			end

			return render(v)
		end
	})
end

return MultiTextLocalizer
