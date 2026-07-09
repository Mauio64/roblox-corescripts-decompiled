local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UrlBuilder = require(CorePackages.Packages.UrlBuilder).UrlBuilder
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local NavigateToUserInfo = require(Modules.LuaApp.Thunks.NavigateToUserInfo)
local wrapComponent = require(Modules.LuaApp.Common.wrapComponent)
local getRbxthumbWithTypeSizeAndOptions = require(CorePackages.Workspace.Packages.UserLib).Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = require(CorePackages.Workspace.Packages.UserLib).Utils.Constants
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v15 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local NameBadge = require(script.NameBadge)
local v17 = RoactRodux.connect(function(p1) -- line: 25
	-- upvalues: getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), FFlagEnableBlackbirdCheck (copy)
	local v19 = p1.Users[p1.LocalUserId]

	if v19 then
		local v20 = getRbxthumbWithTypeSizeAndOptions(p1.LocalUserId, Constants.RbxthumbTypes.AvatarHeadShot, 150)

		return {
			displayName = v19.displayName or v19.name,
			thumbnail = v20,
			isPremium = v19.membership == Enum.MembershipType.Premium,
			isVerified = v19.hasVerifiedBadge,
			isRobloxSubscriber = not not FFlagEnableBlackbirdCheck and (v19.hasRobloxSubscription == true or false),
			localUserId = p1.LocalUserId
		}
	end

	return {}
end, function(p2) -- line: 42
	-- upvalues: AppPage (copy), UrlBuilder (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), NavigateDown (copy), NavigateToUserInfo (copy)
	return {
		openProfile = function() -- line: 44
			-- upvalues: AppPage (copy), UrlBuilder (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), p2 (copy), NavigateDown (copy)
			local t1 = {
				name = AppPage.ViewProfile,
				detail = UrlBuilder.static.profile()
			}

			if FFlagSignalsNavP3Dispatch then
				v15.down(v15.fromLegacyPage(t1))

				return
			end

			p2(NavigateDown(t1))
		end,
		openLuaProfile = function(p3, p4) -- line: 55
			-- upvalues: p2 (copy), NavigateToUserInfo (copy)
			p2(NavigateToUserInfo(p3, p4))
		end
	}
end)(NameBadge)

return (wrapComponent(function(p5, p6) -- line: 61
	-- upvalues: Roact (copy)
	if p6.isSearching then
		return nil
	end

	return Roact.createElement(p5, p6)
end)(v17))
