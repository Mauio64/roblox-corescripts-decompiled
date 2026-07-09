local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local FullView = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.FullView
local mutedError = require(Modules.LuaApp.mutedError)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local SetFullView = require(Modules.AvatarExperience.Common.Actions.SetFullView)

local function getAnalyticsContext(p1) -- line: 15
	-- upvalues: Constants (copy), mutedError (copy)
	local v10 = Constants.AnalyticsContext[p1]

	if v10 == nil then
		if _G.__TESTEZ_RUNNING_TEST__ and p1 == "DummyRoute" then
			return "DummyRoute"
		end

		mutedError(string.format("opaquePage: %s missing an entry in AXConstants.AnalyticsContext", (tostring(p1))))
		v10 = ""
	end

	return v10
end
local function getAnalyticsFunction(p2, p3, p4) -- line: 29
	-- upvalues: FullView (copy)
	if p4 == FullView.SceneFullView then
		return p2.open3DFullView
	end

	if p4 == FullView.UIFullView then
		return p2.openUIFullView
	end

	if p3 == FullView.SceneFullView then
		return p2.close3DFullView
	end

	if p3 == FullView.UIFullView then
		return p2.closeUIFullView
	end
end

return function(p5, p6, p7) -- line: 45
	-- upvalues: SetFullView (copy), Constants (copy), mutedError (copy), FullView (copy)
	return function(p8) -- line: 46
		-- upvalues: p6 (copy), SetFullView (copy), p7 (copy), Constants (copy), mutedError (copy), p5 (copy), FullView (copy)
		local v18 = p8:getState().AvatarExperience.Common.FullView[p6]

		p8:dispatch(SetFullView(p6, p7))

		local v19 = p6
		local v20 = Constants.AnalyticsContext[v19]
		local g21 = nil

		repeat
			if g21 or v20 == nil then
				if g21 or _G.__TESTEZ_RUNNING_TEST__ and v19 == "DummyRoute" then
					if not g21 then
						v20 = "DummyRoute"
					end

					g21 = false

					local v22 = p5
					local v23 = p7
					local v24 = if v23 ~= FullView.SceneFullView then if v23 ~= FullView.UIFullView then if v18 ~= FullView.SceneFullView then if v18 ~= FullView.UIFullView then nil else v22.closeUIFullView else v22.close3DFullView else v22.openUIFullView else v22.open3DFullView

					if v24 then
						v24(v20)
					end

					return
				end

				mutedError(string.format("opaquePage: %s missing an entry in AXConstants.AnalyticsContext", (tostring(v19))))
				v20 = ""
			end

			g21 = true
		until not g21
	end
end
