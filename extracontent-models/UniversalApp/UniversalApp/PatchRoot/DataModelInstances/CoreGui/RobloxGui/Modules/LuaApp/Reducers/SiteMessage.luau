local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ProcessSiteAlertInfoPayload = require(Modules.LuaApp.Actions.ProcessSiteAlertInfoPayload)
local RefreshSiteAlertInfo = require(Modules.LuaApp.Actions.RefreshSiteAlertInfo)
local ApplySetNavigationLocked = require(Modules.LuaApp.Actions.ApplySetNavigationLocked)
local ApplyRoactNavigationHistory = require(Modules.LuaApp.Actions.ApplyRoactNavigationHistory)

return function(p1, p2) -- line: 12
	-- upvalues: ProcessSiteAlertInfoPayload (copy), RefreshSiteAlertInfo (copy), Cryo (copy), ApplySetNavigationLocked (copy), ApplyRoactNavigationHistory (copy)
	local v10 = p1 or {}

	if p2.type == ProcessSiteAlertInfoPayload.name then
		return {
			updateRequested = false,
			Text = p2.visible and p2.text or nil,
			Link = p2.visible and p2.link or nil,
			timestamp = p2.timestamp or nil
		}
	end

	if p2.type == RefreshSiteAlertInfo.name then
		return Cryo.Dictionary.join(v10, {
			updateRequested = p2.updateRequested
		})
	end

	for _, v in ipairs({
		ApplySetNavigationLocked,
		ApplyRoactNavigationHistory
	}) do
		if p2.type == v.name then
			return Cryo.Dictionary.join(v10, {
				updateRequested = true
			})
		end
	end

	return v10
end
