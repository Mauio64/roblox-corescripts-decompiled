local CorePackages = game:GetService("CorePackages")

local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local Dash = require(CorePackages.Packages.Dash)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module2 = require("@luauforge/bundled/dwM")
local Promise = require(CorePackages.Packages.Promise)
require(CorePackages.Packages.LuauPolyfill)

local module3 = require("@luauforge/bundled/dCn")
require("@luauforge/bundled/dMc")
local module4 = require("@luauforge/bundled/dNQ")
local module5 = require("@luauforge/bundled/fwg")
local module6 = require("@luauforge/bundled/fuD")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
local module7 = require("@luauforge/bundled/dMx")
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXCounterV2

local module8 = require("@luauforge/bundled/dNG")
local module9 = require("@luauforge/bundled/dSS")

local module10 = require("@luauforge/bundled/dMP")

local mySharedAvatars = widgetConstants.ContextWidgets.MySharedAvatars
local function makeGetMySharedAvatarsApiCall(p2, userId, value, list, p3, p4)
	return module5.GetMySharedAvatars(p2, userId, value or ""):andThen(function(p5)
		local responseBody = p5.responseBody

		if responseBody and responseBody.data and type(responseBody.data) == "table" then
			local data = responseBody.data

			if #data < 1 then
				return Promise.resolve(list, p3)
			end

			for k, v5 in data do
				table.insert(list, {
					id = v5.lookId,
					type = widgetConstants.ContentType.Look
				})

				p3[v5.lookId] = {
					assets = v5.assets,
					bundles = v5.bundles,
					id = v5.lookId,
					owned = true,
					lookType = v5.lookType,
					moderationStatus = v5.moderationStatus,
					displayProperties = v5.displayProperties,
					type = widgetConstants.ContentType.Look
				}
			end

			if not responseBody.nextCursor then
				return Promise.resolve(list, p3)
			end

			sendAXCounterV2(module7.Counter.MySharedAvatars.FetchMySharedAvatarsNewPage, {
				pageNum = tostring(p4)
			})

			return makeGetMySharedAvatarsApiCall(p2, userId, responseBody.nextCursor, list, p3, p4 + 1)
		elseif #Dash.keys(list) > 0 or #Dash.keys(p3) > 0 then
			sendAXCounterV2(module7.Counter.MySharedAvatars.FetchMySharedAvatarsError, {
				StatusCode = "-206"
			})

			return Promise.resolve(list, p3)
		else
			sendAXCounterV2(module7.Counter.MySharedAvatars.FetchMySharedAvatarsError, {
				StatusCode = "-204"
			})

			return Promise.reject("No data returned from GetMySharedAvatars")
		end
	end, function(p5)
		logging.warn("WebApi failure in FetchMySharedAvatars: " .. tostring(p5))

		if p5 then
			sendAXCounterV2(module7.Counter.MySharedAvatars.FetchMySharedAvatarsError, {
				StatusCode = tostring(p5.StatusCode or -1)
			})
		end

		if #Dash.keys(list) > 0 or #Dash.keys(p3) > 0 then
			sendAXCounterV2(module7.Counter.MySharedAvatars.FetchMySharedAvatarsError, {
				StatusCode = "-207"
			})

			return Promise.resolve(list, p3)
		end

		return Promise.reject(p5)
	end)
end

local function FetchMySharedAvatars(p2)
	module2.isType(p2, "function", "FetchMySharedAvatars thunk expects networkImpl to be a function")

	return performFetch.Single(module4.GetMySharedAvatarsKey, function(object)
		local state = object:getState()
		local userId = module6.getUserId(state)

		if not userId then
			sendAXCounterV2(module7.Counter.MySharedAvatars.FetchMySharedAvatarsError, {
				StatusCode = "-403"
			})

			return Promise.reject("No userId found")
		end

		local v5 = { title = mySharedAvatars.Title, tooltip = mySharedAvatars.Tooltip }

		object:dispatch(module9(mySharedAvatars.RequestId, mySharedAvatars.WidgetId, v5))

		return makeGetMySharedAvatarsApiCall(p2, userId, nil, {}, {}, 1):andThen(function(p3, p4)
			object:dispatch(module8({
				[mySharedAvatars.Context] = {
					content = p3,
					template = {
						title = mySharedAvatars.Title,
						type = widgetConstants.Templates.ItemGroup
					},
					id = mySharedAvatars.WidgetId,
					requestId = mySharedAvatars.RequestId,
					type = widgetConstants.Types.MySharedAvatarsWidget
				}
			}, mySharedAvatars.RequestId, nil, mySharedAvatars.Context))

			object:dispatch(module10({ [widgetConstants.ContentType.Look] = p4 }))
		end):catch(function(p3)
			module3(string.format(
				"[AvatarExperience] Failed to fetch MySharedAvatars for user %s with error: %s",
				tostring(userId),
				(tostring(p3))
			))

			sendAXCounterV2(module7.Counter.MySharedAvatars.FetchMySharedAvatarsError, {
				StatusCode = "-500"
			})
		end)
	end)
end

return FetchMySharedAvatars
