local module = require("@luauforge/bundled/ecV")
local module2 = require("@luauforge/deferred/fYf")
local module3 = require("@luauforge/deferred/fYg")
local module4 = require("@luauforge/bundled/dyn")
local module5 = require("@luauforge/bundled/ecW")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module6 = require("@luauforge/bundled/dCh")
local module7 = require("@luauforge/bundled/dwB")
local localization = require("@game/CorePackages/Workspace/Packages/RobloxAppLocales").Localization
local LocalizationService = game:GetService("LocalizationService")

local module8 = require("@luauforge/bundled/dyp")
local gameInfosReducer = require("@luauforge/bundled/dzK").GameInfosReducer
local module9 = require("@luauforge/bundled/dPI")
local fFlagMigrateGameInfoToStore = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagMigrateGameInfoToStore

local function translateString(p2, p3)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v5 = localization.new(robloxLocaleId)
	v5:SetLocale(robloxLocaleId)

	return v5:Format(p2, p3)
end

local function SendGameFollow(p2, value, p3, p4, value2, value3)
	if type(value) ~= "string" then
		error("SendGameFollow thunk expects universeId to be a string")
	end

	if (type)(p3) ~= "boolean" then
		error("SendGameFollow thunk expects isFollowed to be a boolean")
	end

	return performFetch.Single("SendGameFollow" .. value, function(object)
		local localUserId = object:getState().LocalUserId

		if p4 then
			local v5 = value3 or 0
			local v6 = value2 or 0

			if p3 then
				if v5 <= v6 then
					object:dispatch(module6({
						toastType = module7.GameFollowError,
						toastMessage = "Feature.GameFollows.TooltipNotificationsLimitReached"
					}))

					return module.resolve()
				end

				object:dispatch(module8(v6 + 1))
			else
				object:dispatch(module8(v6 - 1))
			end

			object:dispatch(module4(value, p3))
		end

		if p3 then
			return module2(p2, localUserId, value):andThen(function(p5)
				if not object:getState().GameFollowings[value].isFollowed then
					return SendGameFollow(p2, value, false, p4, value2, value3)
				end

				if p4 then
					local v5

					if fFlagMigrateGameInfoToStore then
						v5 = module9.Game.getGameInfoStore(false).getGameInfo(value).data(false)
					else
						v5 = object:getState().Personalization[gameInfosReducer.key][value]
					end

					local name = v5 and v5.name or ""

					local v8 = {
						toastType = module7.NotificationsTurnedOn,
						toastMessage = 0,
						isLocalized = true
					}
					local robloxLocaleId = LocalizationService.RobloxLocaleId
					local v9 = localization.new(robloxLocaleId)
					v9:SetLocale(robloxLocaleId)

					v8.toastMessage = v9:Format("Feature.GameFollows.TooltipTurnedOnNotifications", {
						experienceName = name
					})
					object:dispatch(module6(v8))
				end

				return module.resolve(p5)
			end, function(p5)
				object:dispatch(module4(value, false))

				object:dispatch(module8(value2 or 0))

				if p5.StatusCode == 400 then
					object:dispatch(module6({
						toastType = module7.GameFollowError,
						toastMessage = p4 and "Feature.GameFollows.TooltipNotificationsLimitReached" or "Feature.GameFollows.TooltipFollowLimitReached"
					}))
				else
					object:dispatch(module5(p5))
				end

				return module.reject(p5)
			end)
		end

		return module3(p2, localUserId, value):andThen(function(p5)
			if object:getState().GameFollowings[value].isFollowed then
				return SendGameFollow(p2, value, true, p4, value2, value3)
			end

			if p4 then
				local v5

				if fFlagMigrateGameInfoToStore then
					v5 = module9.Game.getGameInfoStore(false).getGameInfo(value).data(false)
				else
					v5 = object:getState().Personalization[gameInfosReducer.key][value]
				end

				local name = v5 and v5.name or ""

				local v8 = {
					toastType = module7.NotificationsTurnedOff,
					toastMessage = 0,
					isLocalized = true
				}
				local robloxLocaleId = LocalizationService.RobloxLocaleId
				local v9 = localization.new(robloxLocaleId)
				v9:SetLocale(robloxLocaleId)

				v8.toastMessage = v9:Format("Feature.GameFollows.TooltipTurnedOffNotifications", {
					experienceName = name
				})
				object:dispatch(module6(v8))
			end

			return module.resolve(p5)
		end, function(p5)
			object:dispatch(module4(value, true))

			object:dispatch(module8(value2 or 0))
			object:dispatch(module5(p5))
			return module.reject(p5)
		end)
	end)
end

return SendGameFollow
