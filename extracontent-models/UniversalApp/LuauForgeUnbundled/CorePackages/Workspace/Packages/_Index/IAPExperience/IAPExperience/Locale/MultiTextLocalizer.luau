local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/t")

local LocaleRoactContext = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Locale/LocaleRoactContext")

local strictInterface = t.strictInterface({
	keys = t.table,
	render = t.callback
})

local strictInterface2 = t.strictInterface({
	key = t.string,
	params = t.optional(t.table)
})

local function MultiTextLocalizer(p2)
	assert(strictInterface(p2))

	for k, key in pairs(p2.keys) do
		assert(strictInterface2(key))
	end

	local render = p2.render

	return Roact.createElement(LocaleRoactContext.Consumer, {
		render = function(object)
			local v5 = {}

			for k, key in pairs(p2.keys) do
				v5[k] = object:Format(key.key, key.params)
			end

			return render(v5)
		end
	})
end

return MultiTextLocalizer
