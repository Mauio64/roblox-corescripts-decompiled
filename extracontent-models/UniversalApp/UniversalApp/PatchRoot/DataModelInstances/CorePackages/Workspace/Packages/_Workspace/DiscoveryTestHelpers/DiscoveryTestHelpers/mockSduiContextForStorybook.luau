local Parent = script:FindFirstAncestor("DiscoveryTestHelpers").Parent
local Signals = require(Parent.Signals)
local Localization = require(Parent.RobloxAppLocales).Localization

require(Parent.SduiCoreSystem)

local function mockSduiContextForStorybook(p1: ((...any) -> ...any)?) -- line: 26
	-- upvalues: Localization (copy), Signals (copy)
	local t1 = {}

	if p1 then
		p1(t1)
	end

	local t2 = {
		reportCounter = function(_, _, _, _) -- line: 34
		end,
		reportError = function(_, _, _, _) -- line: 35
		end,
		clearSeenErrors = function() -- line: 36
		end,
		reportTimers = function(_, _, _) -- line: 37
		end,
		reportOmniFeedStats = function(_, _, _, _, _) -- line: 38
		end
	}
	local t3 = {
		startTimerFlow = function(_, _) -- line: 42
		end,
		stopTimerFlow = function(_, _, _, _) -- line: 43
		end,
		scheduleFlush = function(_, _) -- line: 44
		end,
		reportTimers = function(_, _) -- line: 45
		end
	}
	local t4 = {
		appAnalytics = nil,
		gameAnalytics = nil,
		eventIngest = nil,
		sessionService = nil,
		networking = nil,
		dispatch = function(_) -- line: 49
		end,
		getNavigation = function() -- line: 50
			return {
				navigate = function() -- line: 51
				end
			}
		end,
		linkingProtocol = {
			detectURL = function() -- line: 58
			end,
			isURLRegistered = function(_, p30) -- line: 59
				return p30 == "roblox://registered-with-mock/"
			end
		},
		logger = t2,
		cursors = {
			tileCursor = nil
		},
		instrumentation = t3,
		localization = Localization.new("en-us")
	}
	local t5 = {
		_registeredComponents = t1,
		doesComponentManageChildren = function(_, _) -- line: 72
			return false
		end,
		registerComponent = function(_, p34, p35) -- line: 75
			-- upvalues: t1 (copy)
			t1[p34] = p35
		end,
		getComponent = function(_, p37) -- line: 78
			-- upvalues: t1 (copy)
			local v50 = t1[p37]

			if v50 then
				return v50.component
			end

			return nil
		end,
		getPropParsers = function(_, p39) -- line: 82
			-- upvalues: t1 (copy)
			local v53 = t1[p39]

			if v53 then
				return v53.propParsers
			end

			return nil
		end,
		getPropInterface = function(_, p41) -- line: 86
			-- upvalues: t1 (copy)
			local v56 = t1[p41]

			if v56 then
				return v56.propInterface
			end

			return nil
		end,
		doesParserRequireRenderContext = function(_, _) -- line: 90
			return false
		end
	}
	local t6 = {
		new = function(_) -- line: 96
			return nil
		end,
		getTemplate = function(_, _) -- line: 99
			return nil
		end,
		resolveTemplateForConfig = function(_, _, _) -- line: 102
			return nil
		end,
		shouldResolveTemplate = function(_, _) -- line: 105
			return false
		end,
		_registeredTemplates = {}
	}
	local t7 = {
		social = {
			getInGameFriendsByGame = Signals.createSignal({})
		}
	}
	local v13 = Signals.createSignal({
		numColumns = 3,
		fractionalItemAmount = 0,
		columnGap = 24,
		sideMargin = 24,
		verticalPadding = 16,
		itemWidth = 0
	})

	return {
		appPage = "Home",
		dataUpdatedTimestamp = os.clock(),
		dependencies = t4,
		componentDefinitions = t5,
		templateRegistry = t6,
		dataStore = t7,
		getPageLayoutConfig = function(_) -- line: 133
			-- upvalues: Signals (copy), v13 (copy)
			return Signals.createComputed(function(p53) -- line: 134
				-- upvalues: v13 (copy)
				return v13(p53)
			end)
		end
	}
end

return mockSduiContextForStorybook
