local parent = script:FindFirstAncestor("GameJoinCard").Parent

local Foundation = require(parent.Foundation)
require(parent.DataHydration)
local ButtonVariant = Foundation.Enums.ButtonVariant

require(script.Parent.Types)
local actionFactories = require(script.Parent.actionFactories)

local function resolveJoinCardActions(p, p2)
	local joinCardActions = {}

	if p == nil or p.actions == nil then
		return joinCardActions
	end

	local flag = false

	for _, action in p.actions do
		local actionFactory = actionFactories[action.type]

		if actionFactory == nil then
			continue
		end

		local v = actionFactory(p2)

		if v == nil then
			continue
		end

		if v.render == nil then
			if flag then
				if v.variant ~= ButtonVariant.Utility then
					v.variant = ButtonVariant.Standard
				end
			else
				v.variant = v.variant or ButtonVariant.Emphasis
			end

			flag = true
		end

		table.insert(joinCardActions, v)
	end

	return joinCardActions
end

return resolveJoinCardActions
