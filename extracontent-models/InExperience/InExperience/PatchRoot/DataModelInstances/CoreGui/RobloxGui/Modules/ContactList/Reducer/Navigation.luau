local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)

require(script.Parent.Parent.Enums.Pages)

local SetCurrentPage = require(script.Parent.Parent.Actions.SetCurrentPage)
local SetCurrentTag = require(script.Parent.Parent.Actions.SetCurrentTag)

return Rodux.createReducer({
	currentPage = nil,
	currentTag = ""
}, {
	[SetCurrentPage.name] = function(p1, p2) -- line: 16
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			currentPage = if p2.page ~= nil then p2.page else Cryo.None
		})
	end,
	[SetCurrentTag.name] = function(p3, p4) -- line: 21
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			currentTag = p4.tag
		})
	end
})
