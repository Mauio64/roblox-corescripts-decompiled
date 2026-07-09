local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local tutils = require(CorePackages.Packages.tutils)
local SetScreenGuiBlur = require(Modules.LuaApp.Actions.SetScreenGuiBlur)

return Rodux.createReducer({
	hasBlur = false,
	blurDisplayOrder = 0,
	details = {}
}, {
	[SetScreenGuiBlur.name] = function(p1, p2) -- line: 14
		-- upvalues: Cryo (copy), tutils (copy)
		local v9 = if p2.blur ~= true then Cryo.Dictionary.join(p1.details, {
			[p2.source] = Cryo.None
		}) else Cryo.Dictionary.join(p1.details, {
			[p2.source] = p2.displayOrder
		})
		local v10 = tutils.fieldCount(v9) > 0
		local n1 = 0

		for _, v in pairs(v9) do
			n1 = math.max(n1, v)
		end

		return {
			hasBlur = v10,
			blurDisplayOrder = n1,
			details = v9
		}
	end
})
