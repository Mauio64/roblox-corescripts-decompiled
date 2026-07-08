local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local OpenOrUpdateCFM = require(script.Parent.Parent.Actions.OpenOrUpdateCFM)
local CloseCFM = require(script.Parent.Parent.Actions.CloseCFM)

return Rodux.createReducer({
	isOpen = false,
	friend = {
		userId = nil,
		combinedName = "",
		userName = ""
	}
}, {
	[OpenOrUpdateCFM.name] = function(p1, p2) -- line: 16
		-- upvalues: Cryo (copy)
		if p2.friend and p2.friend.combinedName then
			return Cryo.Dictionary.join(p1, {
				isOpen = true,
				friend = p2.friend
			})
		end

		return {
			isOpen = false,
			friend = {
				userId = nil,
				combinedName = "",
				userName = ""
			}
		}
	end,
	[CloseCFM.name] = function(_, _) -- line: 34
		return {
			isOpen = false,
			friend = {
				userId = nil,
				combinedName = "",
				userName = ""
			}
		}
	end
})
