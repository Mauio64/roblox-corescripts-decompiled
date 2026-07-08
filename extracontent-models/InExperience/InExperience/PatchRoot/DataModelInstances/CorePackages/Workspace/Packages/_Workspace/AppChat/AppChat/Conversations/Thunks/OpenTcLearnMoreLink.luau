local Parent = script:FindFirstAncestor("AppChat").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v5 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local v6 = game:DefineFastString("AppChatTcLearnMoreUrl", "https://en.help.roblox.com/")

return function() -- line: 13
	-- upvalues: AppPage (copy), v6 (copy), FFlagSignalsNavP3Dispatch (copy), v5 (copy), NavigateDown (copy)
	return function(p1) -- line: 14
		-- upvalues: AppPage (copy), v6 (copy), FFlagSignalsNavP3Dispatch (copy), v5 (copy), NavigateDown (copy)
		local t1 = {
			name = AppPage.GenericWebPage,
			detail = v6,
			extraProps = {
				title = ""
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v5.down(v5.fromLegacyPage(t1))

			return
		end

		p1:dispatch(NavigateDown(t1, nil))
	end
end
