local CorePackages = game:GetService("CorePackages")
local Modules = script:FindFirstAncestor("Modules")
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local AppPage = require(Modules.LuaApp.AppPage)
local Dash = require(CorePackages.Packages.Dash)
local SocialStopwatch = require(CorePackages.Workspace.Packages.SocialStopwatch)
local SocialLuaAnalytics = require(CorePackages.Workspace.Packages.SocialLuaAnalytics)
local Constants = require(CorePackages.Workspace.Packages.ContactImporter).Constants
local initializeProfileAnalytics = require(CorePackages.Workspace.Packages.ProfilePlatform.initializeProfileAnalytics)
local EventNames = require(CorePackages.Workspace.Packages.ProfilePlatform.EventNames)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v12 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local v13 = initializeProfileAnalytics()

return function(s1: string, p1) -- line: 70
	-- upvalues: SocialStopwatch (copy), v13 (copy), EventNames (copy), SocialLuaAnalytics (copy), Constants (copy), AppPage (copy), Dash (copy), FFlagSignalsNavP3Dispatch (copy), v12 (copy), NavigateDown (copy)
	return function(p2) -- line: 71
		-- upvalues: SocialStopwatch (copy), p1 (copy), v13 (copy), EventNames (copy), SocialLuaAnalytics (copy), Constants (copy), AppPage (copy), Dash (copy), FFlagSignalsNavP3Dispatch (copy), v12 (copy), NavigateDown (copy), s1 (copy)
		SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.ProfileOpened);
		((if not p1 or not p1.mockProfileAnalytics_dev then v13 else p1.mockProfileAnalytics_dev)).fireAnalyticsEvent(EventNames.ProfileLoadingStage, {
			status = SocialLuaAnalytics.Analytics.Enums.LoadingStages.Started
		})

		if p1 and (p1.profileType == Constants.CONTACTS_PROFILE_TYPE and p1.contactProps) then
			local t1 = {
				name = AppPage.ProfilePlatform,
				detail = p1.contactProps.contactId,
				extraProps = Dash.join(p1, {
					profileType = Constants.CONTACT
				})
			}

			if FFlagSignalsNavP3Dispatch then
				v12.down(v12.fromLegacyPage(t1))

				return
			end

			p2:dispatch(NavigateDown(t1))

			return
		end

		local t2 = {
			name = AppPage.ProfilePlatform,
			detail = s1,
			extraProps = p1
		}

		if FFlagSignalsNavP3Dispatch then
			v12.down(v12.fromLegacyPage(t2))

			return
		end

		p2:dispatch(NavigateDown(t2))
	end
end
