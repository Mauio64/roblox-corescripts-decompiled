local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local RobloxGui = CoreGui.RobloxGui
local GetFIntCanHideGuiGroupId = require(RobloxGui.Modules.Flags.GetFIntCanHideGuiGroupId)

return function(_, p2, _) -- line: 11
	-- upvalues: Promise (copy), GetFIntCanHideGuiGroupId (copy)
	return Promise.new(function(resolve, reject) -- line: 12
		-- upvalues: p2 (copy), GetFIntCanHideGuiGroupId (copy)
		if not game:GetEngineFeature("GuiHidingApiSupport") then
			resolve(false)

			return
		end

		if not p2 then
			reject("Invalid local player")

			return
		end

		local u11 = false
		local ok, result = pcall(function() -- line: 24
			-- upvalues: GetFIntCanHideGuiGroupId (copy), u11 (ref), p2 (copy)
			local v14 = GetFIntCanHideGuiGroupId()

			if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
				u11 = p2:IsInGroupAsync(v14)

				return
			end

			u11 = p2:IsInGroup(v14)
		end)

		if ok then
			resolve(u11)
		else
			reject(result)
		end
	end)
end
