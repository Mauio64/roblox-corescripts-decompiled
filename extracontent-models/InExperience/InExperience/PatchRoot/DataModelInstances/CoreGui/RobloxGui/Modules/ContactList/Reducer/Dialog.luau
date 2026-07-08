local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local OpenOrUpdateDialog = require(script.Parent.Parent.Actions.OpenOrUpdateDialog)
local CloseDialog = require(script.Parent.Parent.Actions.CloseDialog)

return Rodux.createReducer({
	isOpen = false,
	title = "",
	bodyText = "",
	dismissCallback = nil
}, {
	[OpenOrUpdateDialog.name] = function(p1, p2) -- line: 14
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			isOpen = true,
			title = p2.title,
			bodyText = p2.bodyText,
			dismissCallback = p2.dismissCallback
		})
	end,
	[CloseDialog.name] = function(p3, _) -- line: 22
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			isOpen = false,
			title = "",
			bodyText = "",
			dismissCallback = Cryo.None
		})
	end
})
