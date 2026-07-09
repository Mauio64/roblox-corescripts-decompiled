local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local ArgCheck = require(AppChatParent.ArgCheck)
local AppCommonLib = require(AppChatParent.AppCommonLib)
local Cryo = require(AppChatParent.Cryo)
local Localization = require(AppChatParent.Localization)
local Roact = require(AppChatParent.Roact)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local TopBarContext = require(AppChat.TopBarContext)
local FFlagAppChatTopBarSignalsStore = require(AppChat.Flags.FFlagAppChatTopBarSignalsStore)
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local UniversalAppPolicy = require(AppChatParent.UniversalAppPolicy)
local SocialPolicies = require(AppChatParent.SocialPolicies)
local v14 = Roact.Component:extend("MockTopBarProvider")

function v14.init(p1) -- line: 19
	-- upvalues: FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), ArgCheck (copy), Cryo (copy)
	if FFlagAppChatTopBarSignalsStore then
		GetTopBarStore(false).resetStore()
	end

	p1.state = {
		topBar = {}
	}

	function p1.getScreenTopBar(p2) -- line: 28
		-- upvalues: ArgCheck (copy), p1 (copy)
		ArgCheck.isType(p2, "string", "screen")

		return p1.state.topBar[p2] or {}
	end
	function p1.setScreenTopBar(p3, p4) -- line: 34
		-- upvalues: ArgCheck (copy), FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), p1 (copy), Cryo (copy)
		ArgCheck.isType(p3, "string", "screen")
		ArgCheck.isType(p4, "table", "state")

		if FFlagAppChatTopBarSignalsStore then
			GetTopBarStore(false).setScreenTopBar(p3, p4)
		end

		p1:setState(function(p5) -- line: 42
			-- upvalues: Cryo (copy), p3 (copy), p4 (copy)
			local v26 = Cryo.Dictionary.join(p5.topBar[p3] or {}, p4)

			return {
				topBar = Cryo.Dictionary.join(p5.topBar, {
					[p3] = v26
				})
			}
		end)
	end
end
function v14.render(p6) -- line: 54
	-- upvalues: Roact (copy), TopBarContext (copy), Cryo (copy)
	return Roact.createElement(TopBarContext.Provider, {
		value = Cryo.Dictionary.join(p6.state.topBar, {
			getScreenTopBar = p6.getScreenTopBar,
			setScreenTopBar = p6.setScreenTopBar
		})
	}, {
		Element = p6.props[Roact.Children]
	})
end

return function(p7) -- line: 65
	-- upvalues: Roact (copy), v14 (copy), FFlagAppChatTopBarConfigDriven (copy), Localization (copy), AppCommonLib (copy), UniversalAppPolicy (copy), SocialPolicies (copy)
	local v18 = Roact.createElement(v14, {}, p7)

	if FFlagAppChatTopBarConfigDriven() then
		local v19 = Roact.createElement(Localization.LocalizationProvider, {
			localization = {
				Format = function(_, s1: string) -- line: 70
					return s1
				end,
				changed = AppCommonLib.Signal.new()
			}
		}, { v18 })

		v18 = Roact.createElement(UniversalAppPolicy.RoactAppPolicy.Provider, {
			policy = {
				UniversalAppPolicy.AppFeaturePolicies,
				SocialPolicies.ChatPolicies
			},
			policyData = {
				ChatHeaderSearch = true,
				ChatHeaderCreateChatGroup = true,
				ChatHeaderNotifications = true,
				EnableWebViewSupport = true
			}
		}, { v19 })
	end

	return v18
end
