local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)

local RobloxGui = CoreGui.RobloxGui
local GetFIntCanHideGuiGroupId = require(RobloxGui.Modules.Flags.GetFIntCanHideGuiGroupId)

return function(_, object, _)
	return Promise.new(function(callback, callback2)
		if not game:GetEngineFeature("GuiHidingApiSupport") then
			callback(false)
			return
		end

		if not object then
			callback2("Invalid local player")
			return
		end

		local v = false
		local success, result = pcall(function()
			v = object:IsInGroupAsync((GetFIntCanHideGuiGroupId()))
		end)

		if success then
			callback(v)
		else
			callback2(result)
		end
	end)
end
