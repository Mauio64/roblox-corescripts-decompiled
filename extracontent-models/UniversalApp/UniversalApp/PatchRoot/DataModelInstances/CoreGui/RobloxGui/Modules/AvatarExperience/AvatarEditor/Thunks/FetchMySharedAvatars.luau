local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Dash = require(CorePackages.Packages.Dash)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Promise = require(CorePackages.Packages.Promise)

require(CorePackages.Packages.LuauPolyfill)

local mutedError = require(Modules.LuaApp.mutedError)

require(Modules.AvatarExperience.Common.Types)

local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local WebApi = require(Modules.AvatarExperience.AvatarEditor.Http.WebApi)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2
local SetWidgetInfo = require(Modules.AvatarExperience.Catalog.Actions.SetWidgetInfo)
local SetResultsListFocusedWidget = require(Modules.AvatarExperience.Catalog.Actions.SetResultsListFocusedWidget)
local SetHydratedWidgetData = require(Modules.AvatarExperience.Catalog.Actions.SetHydratedWidgetData)
local MySharedAvatars = WidgetConstants.ContextWidgets.MySharedAvatars

local function makeGetMySharedAvatarsApiCall(p1, s1: string, s2: string?, t1: {[any]: any}, t2: {[any]: any}, n1: number) -- line: 40
	-- upvalues: WebApi (copy), Dash (copy), sendAXCounterV2 (copy), Constants2 (copy), Promise (copy), WidgetConstants (copy), makeGetMySharedAvatarsApiCall (copy), Logging (copy)
	return WebApi.GetMySharedAvatars(p1, s1, s2 or ""):andThen(function(p2) -- line: 48
		-- upvalues: Dash (copy), t1 (copy), t2 (copy), sendAXCounterV2 (copy), Constants2 (copy), Promise (copy), WidgetConstants (copy), n1 (copy), makeGetMySharedAvatarsApiCall (copy), p1 (copy), s1 (copy)
		local responseBody = p2.responseBody

		if not responseBody or (not responseBody.data or type(responseBody.data) ~= "table") then
			if #Dash.keys(t1) > 0 or #Dash.keys(t2) > 0 then
				sendAXCounterV2(Constants2.Counter.MySharedAvatars.FetchMySharedAvatarsError, {
					StatusCode = "-206"
				})

				return Promise.resolve(t1, t2)
			end

			sendAXCounterV2(Constants2.Counter.MySharedAvatars.FetchMySharedAvatarsError, {
				StatusCode = "-204"
			})

			return Promise.reject("No data returned from GetMySharedAvatars")
		end

		local data = responseBody.data

		if #data < 1 then
			return Promise.resolve(t1, t2)
		end

		for _, v34 in data do
			table.insert(t1, {
				id = v34.lookId,
				type = WidgetConstants.ContentType.Look
			})
			t2[v34.lookId] = {
				owned = true,
				assets = v34.assets,
				bundles = v34.bundles,
				id = v34.lookId,
				lookType = v34.lookType,
				moderationStatus = v34.moderationStatus,
				displayProperties = v34.displayProperties,
				type = WidgetConstants.ContentType.Look
			}
		end

		if responseBody.nextCursor then
			sendAXCounterV2(Constants2.Counter.MySharedAvatars.FetchMySharedAvatarsNewPage, {
				pageNum = tostring(n1)
			})

			return (makeGetMySharedAvatarsApiCall(p1, s1, responseBody.nextCursor, t1, t2, n1 + 1))
		end

		return Promise.resolve(t1, t2)
	end, function(p3) -- line: 101
		-- upvalues: Logging (copy), sendAXCounterV2 (copy), Constants2 (copy), Dash (copy), t1 (copy), t2 (copy), Promise (copy)
		Logging.warn("WebApi failure in FetchMySharedAvatars: " .. tostring(p3))

		if p3 then
			sendAXCounterV2(Constants2.Counter.MySharedAvatars.FetchMySharedAvatarsError, {
				StatusCode = tostring(p3.StatusCode or -1)
			})
		end

		if #Dash.keys(t1) > 0 or #Dash.keys(t2) > 0 then
			sendAXCounterV2(Constants2.Counter.MySharedAvatars.FetchMySharedAvatarsError, {
				StatusCode = "-207"
			})

			return Promise.resolve(t1, t2)
		end

		return Promise.reject(p3)
	end)
end
local function FetchMySharedAvatars(p4) -- line: 121
	-- upvalues: ArgCheck (copy), PerformFetch (copy), Constants (copy), Utils (copy), sendAXCounterV2 (copy), Constants2 (copy), Promise (copy), MySharedAvatars (copy), SetResultsListFocusedWidget (copy), makeGetMySharedAvatarsApiCall (copy), WidgetConstants (copy), SetWidgetInfo (copy), SetHydratedWidgetData (copy), mutedError (copy)
	ArgCheck.isType(p4, "function", "FetchMySharedAvatars thunk expects networkImpl to be a function")

	return PerformFetch.Single(Constants.GetMySharedAvatarsKey, function(p5) -- line: 124
		-- upvalues: Utils (copy), sendAXCounterV2 (copy), Constants2 (copy), Promise (copy), MySharedAvatars (copy), SetResultsListFocusedWidget (copy), makeGetMySharedAvatarsApiCall (copy), p4 (copy), WidgetConstants (copy), SetWidgetInfo (copy), SetHydratedWidgetData (copy), mutedError (copy)
		local v37 = p5:getState()
		local v38 = Utils.getUserId(v37)

		if not v38 then
			sendAXCounterV2(Constants2.Counter.MySharedAvatars.FetchMySharedAvatarsError, {
				StatusCode = "-403"
			})

			return Promise.reject("No userId found")
		end

		local t3 = {
			title = MySharedAvatars.Title,
			tooltip = MySharedAvatars.Tooltip
		}

		p5:dispatch(SetResultsListFocusedWidget(MySharedAvatars.RequestId, MySharedAvatars.WidgetId, t3))

		return makeGetMySharedAvatarsApiCall(p4, v38, nil, {}, {}, 1):andThen(function(p6, p7) -- line: 151
			-- upvalues: MySharedAvatars (copy), WidgetConstants (copy), p5 (copy), SetWidgetInfo (copy), SetHydratedWidgetData (copy)
			local t4 = {
				[MySharedAvatars.Context] = {
					content = p6,
					template = {
						title = MySharedAvatars.Title,
						type = WidgetConstants.Templates.ItemGroup
					},
					id = MySharedAvatars.WidgetId,
					requestId = MySharedAvatars.RequestId,
					type = WidgetConstants.Types.MySharedAvatarsWidget
				}
			}

			p5:dispatch(SetWidgetInfo(t4, MySharedAvatars.RequestId, nil, MySharedAvatars.Context))
			p5:dispatch(SetHydratedWidgetData({
				[WidgetConstants.ContentType.Look] = p7
			}))
		end):catch(function(p8) -- line: 180
			-- upvalues: mutedError (copy), v38 (copy), sendAXCounterV2 (copy), Constants2 (copy)
			mutedError(string.format("[AvatarExperience] Failed to fetch MySharedAvatars for user %s with error: %s", tostring(v38), (tostring(p8))))
			sendAXCounterV2(Constants2.Counter.MySharedAvatars.FetchMySharedAvatarsError, {
				StatusCode = "-500"
			})
		end)
	end)
end

return FetchMySharedAvatars
