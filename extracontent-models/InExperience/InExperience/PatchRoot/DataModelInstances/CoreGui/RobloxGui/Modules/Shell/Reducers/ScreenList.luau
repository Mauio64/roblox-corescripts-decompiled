local CoreGui = game:GetService("CoreGui")
local Actions = CoreGui.RobloxGui.Modules.Shell.Actions

local InsertScreen = require(Actions.InsertScreen)
local RemoveScreen = require(Actions.RemoveScreen)

local CorePackages = game:GetService("CorePackages")
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Immutable = AppCommonLib.Immutable

return function(options, p)
	local selected = options or {}
	assert(selected, "")

	if p.type == InsertScreen.name then
		local v = Immutable.Append(selected, p.item)

		table.sort(v, function(a, b): boolean
			if a.priority == b.priority then
				return a.createdAt > b.createdAt
			end

			return a.priority > b.priority
		end)

		return v
	elseif p.type == RemoveScreen.name then
		return Immutable.RemoveValueFromList(selected, p.item)
	else
		return selected
	end
end
