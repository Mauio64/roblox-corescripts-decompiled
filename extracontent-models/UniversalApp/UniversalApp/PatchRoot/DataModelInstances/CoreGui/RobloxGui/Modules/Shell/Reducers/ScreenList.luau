local Actions = game:GetService("CoreGui").RobloxGui.Modules.Shell.Actions
local InsertScreen = require(Actions.InsertScreen)
local RemoveScreen = require(Actions.RemoveScreen)
local CorePackages = game:GetService("CorePackages")
local Immutable = require(CorePackages.Workspace.Packages.AppCommonLib).Immutable

return function(t1: {[any]: any}?, p1) -- line: 19
	-- upvalues: InsertScreen (copy), Immutable (copy), RemoveScreen (copy)
	local v8 = t1 or {}

	assert(v8, "")

	if p1.type == InsertScreen.name then
		local v9 = Immutable.Append(v8, p1.item)

		table.sort(v9, function(p2, p3) -- line: 26
			if p2.priority == p3.priority then
				return p2.createdAt > p3.createdAt
			end

			return p2.priority > p3.priority
		end)

		return v9
	end

	if p1.type == RemoveScreen.name then
		return Immutable.RemoveValueFromList(v8, p1.item)
	end

	return v8
end
