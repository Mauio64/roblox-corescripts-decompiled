local Groups = script:FindFirstAncestor("Groups")
local GroupsParent = Groups.Parent
local React = require(GroupsParent.React)
local Foundation = require(GroupsParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Enums = Foundation.Enums
local mockProviders = require(GroupsParent.Dev.UnitTestHelpers).mockProviders
local ServiceOverrideContext = require(Groups.Components.CoreUI.ServiceOverrideContext)
local GroupsWrapperContext = require(Groups.Contexts.GroupsWrapperContext)
local GroupsAnalyticsContext = require(Groups.Analytics.GroupsAnalyticsContext)
local LocalizationProvider = require(GroupsParent.Localization).LocalizationProvider
local Signal = require(GroupsParent.AppCommonLib).Signal
local jest = require(GroupsParent.Dev.JestGlobals).jest

local function withMockProviders(t1: {[any]: any}, t2: {[any]: any}?) -- line: 43
	-- upvalues: jest (copy), React (copy), mockProviders (copy), LocalizationProvider (copy), Signal (copy), FoundationProvider (copy), Enums (copy), GroupsWrapperContext (copy), GroupsAnalyticsContext (copy), ServiceOverrideContext (copy)
	local v17 = if not t2 then nil else t2.navigation
	local v18 = if not t2 then nil else t2.groupsContext
	local v19 = if not v18 then nil else v18.navigateTo
	local t3 = {
		SendNotification = jest.fn(function(_) -- line: 49
		end)
	}
	local t4 = {
		ShowJoinPrompt = Instance.new("BindableEvent"),
		PromptJoinCompleted = jest.fn(function(_, _, _, _) -- line: 54
		end)
	}
	local t5 = {
		goBack = if not v17 or not v17.goBack then jest.fn() else v17.goBack,
		navigate = if not v17 or not v17.navigate then jest.fn() else v17.navigate,
		pop = if not v17 or not v17.pop then jest.fn() else v17.pop,
		state = {},
		getScreenProps = function() -- line: 63
			return nil
		end
	}
	local t6 = {
		navigateTo = {
			webView = if not v19 or not v19.webView then jest.fn() else v19.webView,
			groupDetails = if not v19 or not v19.groupDetails then jest.fn() else v19.groupDetails,
			seeAllGroups = if not v19 or not v19.seeAllGroups then jest.fn() else v19.seeAllGroups,
			createGroup = if not v19 or not v19.createGroup then jest.fn() else v19.createGroup
		},
		userId = (not v18 or not v18.userId) and "12345" or v18.userId
	}
	local v24 = React.createElement(React.Fragment, nil, t1)
	local v25 = mockProviders(v24, {
		mockFoundation = false
	})
	local v26 = React.createElement(LocalizationProvider, {
		localization = {
			Format = function(_, s1: string, _) -- line: 97
				return s1
			end,
			GetLocale = function() -- line: 100
				return "en-us"
			end,
			changed = Signal.new()
		}
	}, {
		Element = v25
	})
	local v27 = React.createElement(FoundationProvider, {
		device = Enums.Device.Desktop,
		theme = Enums.Theme.Dark
	}, {
		Element = v26
	})
	local v28 = React.createElement(GroupsWrapperContext.Provider, {
		value = t6
	}, {
		Element = v27
	})
	local t7 = {
		fireAnalyticsEvent = jest.fn()
	}
	local v30 = React.createElement(GroupsAnalyticsContext.Provider, {
		value = t7
	}, {
		Element = v28
	})

	return React.createElement(ServiceOverrideContext.Provider, {
		value = {
			groupService = t4,
			guiService = t3
		}
	}, {
		Element = v30
	}), t5, t6, t7
end

return withMockProviders
