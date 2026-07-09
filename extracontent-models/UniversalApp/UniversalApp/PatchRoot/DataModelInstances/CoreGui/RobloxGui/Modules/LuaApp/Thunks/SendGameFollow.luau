local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Promise = require(Modules.LuaApp.Promise)
local FollowingsPostFollow = require(Modules.LuaApp.Http.Requests.FollowingsPostFollow)
local FollowingsDeleteFollow = require(Modules.LuaApp.Http.Requests.FollowingsDeleteFollow)
local SetGameFollow = require(Modules.LuaApp.Actions.SetGameFollow)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local Localization = require(CorePackages.Workspace.Packages.RobloxAppLocales).Localization
local LocalizationService = game:GetService("LocalizationService")
local SetExperienceNotificationsEnabledCount = require(Modules.LuaApp.Actions.Games.SetExperienceNotificationsEnabledCount)
local GameInfosReducer = require(CorePackages.Workspace.Packages.GameInfosRodux).GameInfosReducer

local function translateString(s1: string, t1: {[any]: any}?) -- line: 17
	-- upvalues: LocalizationService (copy), Localization (copy)
	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local v20 = Localization.new(RobloxLocaleId)

	v20:SetLocale(RobloxLocaleId)

	return v20:Format(s1, t1)
end
local function SendGameFollow(p1, p2, p3, p4, n1: number?, n2: number?) -- line: 25
	-- upvalues: PerformFetch (copy), SetCurrentToastMessage (copy), ToastType (copy), Promise (copy), SetExperienceNotificationsEnabledCount (copy), SetGameFollow (copy), FollowingsPostFollow (copy), GameInfosReducer (copy), LocalizationService (copy), Localization (copy), SendGameFollow (copy), SetNetworkingErrorToast (copy), FollowingsDeleteFollow (copy)
	if type(p2) ~= "string" then
		error("SendGameFollow thunk expects universeId to be a string")
	end

	if type(p3) ~= "boolean" then
		error("SendGameFollow thunk expects isFollowed to be a boolean")
	end

	return PerformFetch.Single("SendGameFollow" .. p2, function(p5) -- line: 40
		-- upvalues: p4 (copy), n2 (copy), n1 (copy), p3 (copy), SetCurrentToastMessage (copy), ToastType (copy), Promise (copy), SetExperienceNotificationsEnabledCount (copy), SetGameFollow (copy), p2 (copy), FollowingsPostFollow (copy), p1 (copy), GameInfosReducer (copy), LocalizationService (copy), Localization (copy), SendGameFollow (copy), SetNetworkingErrorToast (copy), FollowingsDeleteFollow (copy)
		local LocalUserId = p5:getState().LocalUserId

		if p4 then
			local v29 = n2 or 0
			local v30 = n1 or 0

			if p3 then
				if v29 <= v30 then
					p5:dispatch(SetCurrentToastMessage({
						toastMessage = "Feature.GameFollows.TooltipNotificationsLimitReached",
						toastType = ToastType.GameFollowError
					}))

					return Promise.resolve()
				end

				p5:dispatch(SetExperienceNotificationsEnabledCount(v30 + 1))
			else
				p5:dispatch(SetExperienceNotificationsEnabledCount(v30 - 1))
			end

			p5:dispatch(SetGameFollow(p2, p3))
		end

		if p3 then
			return FollowingsPostFollow(p1, LocalUserId, p2):andThen(function(p6) -- line: 65
				-- upvalues: p5 (copy), p2 (copy), p4 (copy), GameInfosReducer (copy), SetCurrentToastMessage (copy), ToastType (copy), LocalizationService (copy), Localization (copy), Promise (copy), SendGameFollow (copy), p1 (copy), n1 (copy), n2 (copy)
				if p5:getState().GameFollowings[p2].isFollowed then
					if p4 then
						local v32 = p5:getState().Personalization[GameInfosReducer.key][p2]
						local v33 = v32 and v32.name or ""
						local v34 = p5
						local v35 = SetCurrentToastMessage
						local t2 = {
							isLocalized = true,
							toastType = ToastType.NotificationsTurnedOn
						}
						local t3 = {
							experienceName = v33
						}
						local RobloxLocaleId = LocalizationService.RobloxLocaleId
						local v39 = Localization.new(RobloxLocaleId)

						v39:SetLocale(RobloxLocaleId)
						t2.toastMessage = v39:Format("Feature.GameFollows.TooltipTurnedOnNotifications", t3)
						v34:dispatch(v35(t2))
					end

					return Promise.resolve(p6)
				end

				return SendGameFollow(p1, p2, false, p4, n1, n2)
			end, function(p7) -- line: 91
				-- upvalues: p5 (copy), SetGameFollow (copy), p2 (copy), n1 (copy), SetExperienceNotificationsEnabledCount (copy), SetCurrentToastMessage (copy), ToastType (copy), p4 (copy), SetNetworkingErrorToast (copy), Promise (copy)
				p5:dispatch(SetGameFollow(p2, false))

				local v41 = n1 or 0

				p5:dispatch(SetExperienceNotificationsEnabledCount(v41))

				if p7.StatusCode == 400 then
					p5:dispatch(SetCurrentToastMessage({
						toastType = ToastType.GameFollowError,
						toastMessage = not p4 and "Feature.GameFollows.TooltipFollowLimitReached" or "Feature.GameFollows.TooltipNotificationsLimitReached"
					}))
				else
					p5:dispatch(SetNetworkingErrorToast(p7))
				end

				return Promise.reject(p7)
			end)
		end

		return FollowingsDeleteFollow(p1, LocalUserId, p2):andThen(function(p8) -- line: 110
			-- upvalues: p5 (copy), p2 (copy), p4 (copy), GameInfosReducer (copy), SetCurrentToastMessage (copy), ToastType (copy), LocalizationService (copy), Localization (copy), Promise (copy), SendGameFollow (copy), p1 (copy), n1 (copy), n2 (copy)
			if not p5:getState().GameFollowings[p2].isFollowed then
				if p4 then
					local v43 = p5:getState().Personalization[GameInfosReducer.key][p2]
					local v44 = v43 and v43.name or ""
					local v45 = p5
					local v46 = SetCurrentToastMessage
					local t4 = {
						isLocalized = true,
						toastType = ToastType.NotificationsTurnedOff
					}
					local t5 = {
						experienceName = v44
					}
					local RobloxLocaleId = LocalizationService.RobloxLocaleId
					local v50 = Localization.new(RobloxLocaleId)

					v50:SetLocale(RobloxLocaleId)
					t4.toastMessage = v50:Format("Feature.GameFollows.TooltipTurnedOffNotifications", t5)
					v45:dispatch(v46(t4))
				end

				return Promise.resolve(p8)
			end

			return SendGameFollow(p1, p2, true, p4, n1, n2)
		end, function(p9) -- line: 136
			-- upvalues: p5 (copy), SetGameFollow (copy), p2 (copy), n1 (copy), SetExperienceNotificationsEnabledCount (copy), SetNetworkingErrorToast (copy), Promise (copy)
			p5:dispatch(SetGameFollow(p2, true))

			local v52 = n1 or 0

			p5:dispatch(SetExperienceNotificationsEnabledCount(v52))
			p5:dispatch(SetNetworkingErrorToast(p9))

			return Promise.reject(p9)
		end)
	end)
end

return SendGameFollow
