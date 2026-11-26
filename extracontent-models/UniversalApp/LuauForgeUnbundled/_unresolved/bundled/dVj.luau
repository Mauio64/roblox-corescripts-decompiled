require("@luauforge/bundled/dUK")
local module = require("@luauforge/bundled/dUL")
local mutedError = require("@luauforge/bundled/dUM").mutedError
local module2 = require("@luauforge/bundled/dTq")
require("@luauforge/bundled/dVa")

local sduiErrorType = module2.SduiErrors.SduiErrorType

local set = {}

for k, v5 in module.Enums.IconName do
	set[k] = true

	if typeof(v5) == "string" then
		set[v5] = true
	end
end

local function wrapRequiredZeroArgAction(callback)
	return function()
		if typeof(callback) == "function" then
			callback(nil, nil, nil)
		else
			mutedError(`Expected function, got {typeof(callback)}`)
		end
	end
end

return {
	mapButtons = function(items, p2, p3)
		if not items then
			return nil
		end

		local clones = {}

		for k, item in items do
			if set[item.icon] then
				local clone = table.clone(item)
				local onActivated = item.onActivated

				function clone.onActivated()
					if typeof(onActivated) == "function" then
						onActivated(nil, nil, nil)
					else
						mutedError(`Expected function, got {typeof(onActivated)}`)
					end
				end
				table.insert(clones, clone)
			else
				p2.dependencies.logger.reportError(
					sduiErrorType.InvalidProps,
					{
						name = p3,
						message = `Skipping button "{item.id}": unknown icon "{item.icon}"`
					},
					p2.appPage
				)
			end
		end

		return clones
	end,
	mapTooltips = function(items)
		if not items then
			return nil
		end

		local clones = {}

		for k, item in items do
			local clone = table.clone(item)

			if clone.actions then
				local clones2 = {}

				for k2, action in clone.actions do
					local clone2 = table.clone(action)
					local onActivated = clone2.onActivated

					function clone2.onActivated()
						if typeof(onActivated) == "function" then
							onActivated(nil, nil, nil)
						else
							mutedError(`Expected function, got {typeof(onActivated)}`)
						end
					end
					clones2[k2] = clone2
				end

				clone.actions = clones2
			end

			if clone.onClose then
				local onClose = clone.onClose

				function clone.onClose()
					if typeof(onClose) == "function" then
						onClose(nil, nil, nil)
					else
						mutedError(`Expected function, got {typeof(onClose)}`)
					end
				end
			end

			clones[k] = clone
		end

		return clones
	end
}
