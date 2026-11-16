local fullView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Enums.FullView
local setFullView = require("@luauforge/bundled/dHL").Actions.SetFullView

local module = require("@luauforge/bundled/dCn")
local module2 = require("@luauforge/bundled/dMx")

local function getAnalyticsContext(p2)
	local v5 = module2.AnalyticsContext[p2]

	if v5 ~= nil then
		return v5
	end

	if _G.__TESTEZ_RUNNING_TEST__ and p2 == "DummyRoute" then
		return "DummyRoute"
	end

	module(string.format("opaquePage: %s missing an entry in AXConstants.AnalyticsContext", (tostring(p2))))
	v5 = ""
	return v5
end

local function getAnalyticsFunction(data, p2, p3)
	if p3 == fullView.SceneFullView then
		return data.open3DFullView
	end

	if p3 == fullView.UIFullView then
		return data.openUIFullView
	end

	if p2 == fullView.SceneFullView then
		return data.close3DFullView
	end

	if p2 == fullView.UIFullView then
		return data.closeUIFullView
	end
end

return function(p2, p3, p4)
	return function(object)
		local v5 = object:getState().AvatarExperience.Common.FullView[p3]
		object:dispatch(setFullView(p3, p4))

		local v6 = p3
		local v7 = module2.AnalyticsContext[v6]

		if v7 == nil then
			if _G.__TESTEZ_RUNNING_TEST__ and v6 == "DummyRoute" then
				v7 = "DummyRoute"
			else
				module(string.format(
					"opaquePage: %s missing an entry in AXConstants.AnalyticsContext",
					(tostring(v6))
				))
				v7 = ""
			end
		end

		local v8 = p2
		local v9 = p4
		local v10

		if v9 == fullView.SceneFullView then
			v10 = v8.open3DFullView
		elseif v9 == fullView.UIFullView then
			v10 = v8.openUIFullView
		elseif v5 == fullView.SceneFullView then
			v10 = v8.close3DFullView
		elseif v5 == fullView.UIFullView then
			v10 = v8.closeUIFullView
		end

		if v10 then
			v10(v7)
		end
	end
end
