local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpStore = require(CorePackages.Workspace.Packages.HttpStore)
local StatusCodes = require(CorePackages.Workspace.Packages.Http).StatusCodes
local Modules = CoreGui.RobloxGui.Modules
local LogoutUserOnUnauthorized = require(Modules.LuaApp.Thunks.LogoutUserOnUnauthorized)
local UserModerationCheck = require(Modules.LuaApp.Thunks.Moderation.UserModerationCheck)
local Instance = HttpStore.Instance

function createAppHttpStoreWrapper(p1, p2, p3) -- line: 18
	-- upvalues: Instance (copy), StatusCodes (copy), UserModerationCheck (copy), LogoutUserOnUnauthorized (copy)
	return Instance._create({
		[StatusCodes.UNAUTHORIZED] = function(p4) -- line: 20
			-- upvalues: p1 (copy), UserModerationCheck (copy), p2 (copy)
			p1:dispatch(UserModerationCheck(p2, p4))
		end,
		[StatusCodes.FORBIDDEN] = function(p5) -- line: 23
			-- upvalues: p1 (copy), LogoutUserOnUnauthorized (copy), p2 (copy), p3 (copy)
			p1:dispatch(LogoutUserOnUnauthorized(p2, p3, p5.config.Url))
		end
	})
end

return createAppHttpStoreWrapper
