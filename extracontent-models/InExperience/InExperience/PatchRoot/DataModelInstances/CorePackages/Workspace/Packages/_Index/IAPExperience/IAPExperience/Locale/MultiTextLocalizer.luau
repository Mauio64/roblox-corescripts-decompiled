local parent = script.Parent.Parent.Parent
local Roact = require(parent.Roact)
local t = require(parent.t)

local LocaleRoactContext = require(script.Parent.LocaleRoactContext)

local strictInterface = t.strictInterface({ keys = t.table, render = t.callback })

local strictInterface2 = t.strictInterface({ key = t.string, params = t.optional(t.table) })

local function MultiTextLocalizer(p)
	assert(strictInterface(p))

	for _, key in pairs(p.keys) do
		assert(strictInterface2(key))
	end

	local render = p.render

	return Roact.createElement(LocaleRoactContext.Consumer, {
		render = function(object)
			local v = {}

			for k, key in pairs(p.keys) do
				v[k] = object:Format(key.key, key.params)
			end

			return render(v)
		end
	})
end

return MultiTextLocalizer
