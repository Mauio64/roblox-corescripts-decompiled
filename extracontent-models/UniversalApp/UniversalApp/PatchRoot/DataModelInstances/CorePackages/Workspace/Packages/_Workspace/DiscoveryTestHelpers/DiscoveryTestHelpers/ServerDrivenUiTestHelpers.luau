local DiscoveryTestHelpers = script:FindFirstAncestor("DiscoveryTestHelpers")
local DiscoveryTestHelpersParent = DiscoveryTestHelpers.Parent
local Signals = require(DiscoveryTestHelpersParent.Signals)
local Cryo = require(DiscoveryTestHelpersParent.Cryo)
local Promise = require(DiscoveryTestHelpersParent.Promise)
local tutils = require(DiscoveryTestHelpersParent.tutils)
local Rhodium = require(DiscoveryTestHelpersParent.Rhodium)
local VirtualInput = Rhodium.VirtualInput
local ReactRoblox = require(DiscoveryTestHelpersParent.ReactRoblox)
local Localization = require(DiscoveryTestHelpersParent.RobloxAppLocales).Localization
local MockTokens = require(script.Parent.MockTokens)

local function deepJoin(p1, p2) -- line: 23
	-- upvalues: tutils (copy), deepJoin (copy)
	if not p1 then
		return p2
	end

	local v24 = p2 or {}
	local v25 = tutils.deepCopy(p1)

	for v26, v27 in v24 do
		if typeof(v27) == "table" then
			v25[v26] = deepJoin(v25[v26], v27)
		else
			v25[v26] = v27
		end
	end

	return v25
end
local function mockComponentDefinitions() -- line: 42
	-- upvalues: DiscoveryTestHelpersParent (copy)
	local jest = require(DiscoveryTestHelpersParent.Dev.JestGlobals).jest
	local t1 = {}

	return {
		getComponentDefinition = jest.fn(function(_, p4) -- line: 48
			-- upvalues: t1 (copy)
			return t1[p4]
		end),
		getComponent = jest.fn(function(_, p6) -- line: 51
			-- upvalues: t1 (copy)
			return t1[p6] and t1[p6].component
		end),
		getPropParsers = jest.fn(function(_, p8) -- line: 54
			-- upvalues: t1 (copy)
			return t1[p8] and t1[p8].propParsers
		end),
		getPropInterface = jest.fn(function(_, p10) -- line: 57
			-- upvalues: t1 (copy)
			return t1[p10] and t1[p10].propInterface
		end),
		doesParserRequireRenderContext = jest.fn(function(_, p12) -- line: 60
			-- upvalues: t1 (copy)
			return t1[p12] and t1[p12].doesParserRequireRenderContext
		end),
		registerComponent = jest.fn(function(_, p14, p15) -- line: 63
			-- upvalues: t1 (copy)
			t1[p14] = p15
		end)
	}
end
local function mockDataStore(t2: {[any]: any}?) -- line: 69
	-- upvalues: Signals (copy), deepJoin (copy)
	local t3 = {
		social = {
			getInGameFriendsByGame = Signals.createSignal({})
		}
	}

	return (deepJoin(t3, t2))
end
local function mockSduiDependencies(t4: {[any]: any}?) -- line: 78
	-- upvalues: DiscoveryTestHelpersParent (copy), Cryo (copy), Promise (copy), Localization (copy), MockTokens (copy)
	local jest = require(DiscoveryTestHelpersParent.Dev.JestGlobals).jest
	local t5 = {
		navigate = jest.fn()
	}

	return Cryo.Dictionary.join({
		dispatch = jest.fn(),
		getNavigation = jest.fn(function() -- line: 90
			-- upvalues: t5 (copy)
			return t5
		end),
		gameAnalytics = {
			sendEventDeferred = jest.fn()
		},
		eventIngest = {
			sendEventDeferred = jest.fn()
		},
		logger = {
			reportError = jest.fn(),
			reportCounter = jest.fn(),
			reportTimers = jest.fn()
		},
		linkingProtocol = {
			detectURL = jest.fn(),
			isURLRegistered = jest.fn(function(_, p17) -- line: 106
				-- upvalues: Promise (copy)
				local v107 = p17 == "roblox://registered-with-mock/"

				return Promise.resolve(v107)
			end),
			openURL = jest.fn(function(_, _) -- line: 110
				-- upvalues: Promise (copy)
				return Promise.resolve()
			end)
		},
		instrumentation = {
			startTimerFlow = jest.fn(function() -- line: 115
			end),
			stopTimerFlow = jest.fn(function() -- line: 116
			end),
			reportTimers = jest.fn()
		},
		localization = Localization.new("en-us"),
		tokens = MockTokens(1),
		cursors = {
			tileCursor = nil
		}
	}, t4 or {})
end
local function mockSduiContext(t6: {[any]: any}?, t7: {[any]: any}?) -- line: 127
	-- upvalues: DiscoveryTestHelpersParent (copy), Signals (copy), Cryo (copy), mockSduiDependencies (copy), mockComponentDefinitions (copy), mockDataStore (copy)
	local jest = require(DiscoveryTestHelpersParent.Dev.JestGlobals).jest
	local v38 = Signals.createSignal({
		numColumns = 3,
		fractionalItemAmount = 0,
		columnGap = 24,
		sideMargin = 24,
		verticalPadding = 16
	})

	return Cryo.Dictionary.join({
		appPage = "Home",
		dataUpdatedTimestamp = os.clock(),
		dependencies = mockSduiDependencies(t7),
		buildSduiComponent = function() -- line: 145
			return nil
		end,
		componentDefinitions = mockComponentDefinitions(),
		templateRegistry = {
			shouldResolveTemplate = jest.fn(),
			resolveTemplateForConfig = jest.fn()
		},
		dataStore = mockDataStore(),
		getPageLayoutConfig = function(_) -- line: 154
			-- upvalues: Signals (copy), v38 (copy)
			return Signals.createComputed(function(p21) -- line: 155
				-- upvalues: v38 (copy)
				return v38(p21)
			end)
		end
	}, t6 or {})
end
local function debugDumpInstanceTreeRecursive(p22, s1: string) -- line: 352
	-- upvalues: debugDumpInstanceTreeRecursive (copy)
	if not p22 then
		return
	end

	assert(p22, "node must exist")

	local v85 = s1 .. " "

	for _, child in p22:GetChildren() do
		local s2 = ""

		for _, tag in (child:GetTags()) do
			if string.find(tag, "data") ~= nil then
				s2 = tag
			end
		end

		print(`{ v85 }{ child } - testId: { s2 } - { child:GetFullName() }`)
		debugDumpInstanceTreeRecursive(child, v85)
	end
end

return {
	mockSduiDependencies = mockSduiDependencies,
	mockSduiContext = mockSduiContext,
	mockSduiContextAndLogErrors = function(t8: {[any]: any}?) -- line: 162
		-- upvalues: mockSduiDependencies (copy), Cryo (copy), mockSduiContext (copy)
		local v40 = t8 or {}

		assert(v40, "overrides must exist")

		local t9 = {}
		local t10 = {}
		local t11 = {}
		local t12 = {
			reportError = function(p23, p24) -- line: 170
				-- upvalues: t9 (copy)
				table.insert(t9, {
					errorType = p23,
					errorDimensions = p24
				})
			end,
			reportCounter = function(p25, p26) -- line: 176
				-- upvalues: t10 (copy)
				table.insert(t10, {
					counterName = p25,
					errorDimensions = p26
				})
			end,
			reportTimers = function(p27) -- line: 182
				-- upvalues: t11 (copy)
				table.insert(t11, table.clone(p27))
			end
		}
		local v45 = if not v40.dependencies then mockSduiDependencies({
			logger = t12
		}) else mockSduiDependencies(Cryo.Dictionary.join({
			logger = t12
		}, v40.dependencies))

		return {
			sduiContext = mockSduiContext(Cryo.Dictionary.join(v40, {
				dependencies = v45
			})),
			getErrors = function() -- line: 202
				-- upvalues: t9 (copy)
				return t9
			end,
			getLastError = function() -- line: 205
				-- upvalues: t9 (copy)
				return t9[#t9]
			end,
			hasError = function(p28) -- line: 208
				-- upvalues: t9 (copy)
				for _, v118 in t9 do
					if p28 == v118.errorType then
						return true
					end
				end

				return false
			end,
			getCounters = function() -- line: 216
				-- upvalues: t10 (copy)
				return t10
			end,
			getLastCounter = function() -- line: 219
				-- upvalues: t10 (copy)
				return t10[#t10]
			end,
			hasCounter = function(p29) -- line: 222
				-- upvalues: t10 (copy)
				for _, v121 in t10 do
					if p29 == v121.counterName then
						return true
					end
				end

				return false
			end,
			getTimerReports = function() -- line: 230
				-- upvalues: t11 (copy)
				return t11
			end,
			getLastTimerReport = function() -- line: 233
				-- upvalues: t11 (copy)
				return t11[#t11]
			end,
			hasTimer = function(p30) -- line: 236
				-- upvalues: t11 (copy)
				for _, v124 in t11 do
					for v125, _ in v124 do
						if v125 == p30 then
							return true
						end
					end
				end

				return false
			end,
			getTimer = function(p31) -- line: 246
				-- upvalues: t11 (copy)
				for _, v129 in t11 do
					for v130, v131 in v129 do
						if v130 == p31 then
							return v131
						end
					end
				end

				return nil
			end
		}
	end,
	mockDataStore = mockDataStore,
	mockComponentDefinitions = mockComponentDefinitions,
	findInstanceWithTag = function(p32, s3: string) -- line: 14
		for _, descendant in p32:GetDescendants() do
			if descendant:HasTag(s3) then
				return descendant
			end
		end

		return nil
	end,
	findAndClickInstanceWithTag = function(p33, s4: string) -- line: 293
		-- upvalues: Rhodium (copy), ReactRoblox (copy), VirtualInput (copy)
		local g59 = nil
		local v58 = nil

		for _, descendant in p33:GetDescendants() do
			if descendant:HasTag(s4) then
				v58 = descendant
				g59 = true
			end

			if g59 then
				break
			end
		end

		if not g59 then
			v58 = nil
		end

		g59 = false
		assert(v58, "instance should be rendered")

		local v60 = Rhodium.Element.new(v58)

		ReactRoblox.act(function() -- line: 299
			-- upvalues: v60 (copy), VirtualInput (copy)
			v60:click()
			VirtualInput.waitForInputEventsProcessed()
		end)
	end,
	findAndSelectInstanceWithTag = function(p34, s5: string) -- line: 305
		-- upvalues: ReactRoblox (copy), VirtualInput (copy)
		local g66 = nil
		local v65 = nil

		for _, descendant in p34:GetDescendants() do
			if descendant:HasTag(s5) then
				v65 = descendant
				g66 = true
			end

			if g66 then
				break
			end
		end

		if not g66 then
			v65 = nil
		end

		g66 = false

		local v67 = v65

		assert(v67, "instance should be rendered")
		ReactRoblox.act(function() -- line: 309
			-- upvalues: v67 (copy), VirtualInput (copy)
			game:GetService("GuiService").SelectedCoreObject = v67
			VirtualInput.waitForInputEventsProcessed()
		end)
	end,
	findAndMouseOverInstanceWithTag = function(p35, s6: string) -- line: 315
		-- upvalues: Rhodium (copy), ReactRoblox (copy), VirtualInput (copy)
		local g73 = nil
		local v72 = nil

		for _, descendant in p35:GetDescendants() do
			if descendant:HasTag(s6) then
				v72 = descendant
				g73 = true
			end

			if g73 then
				break
			end
		end

		if not g73 then
			v72 = nil
		end

		g73 = false
		assert(v72, "instance should be rendered")

		local v74 = Rhodium.Element.new(v72)

		ReactRoblox.act(function() -- line: 321
			-- upvalues: VirtualInput (copy), v74 (copy)
			VirtualInput.waitForInputEventsProcessed()
			VirtualInput.Mouse.mouseMove(v74:getAnchor())
			VirtualInput.waitForInputEventsProcessed()
		end)
	end,
	findDescendantWithImage = function(p36, s7: string) -- line: 340
		for _, descendant in (p36:GetDescendants()) do
			if (descendant:IsA("ImageLabel") or descendant:IsA("ImageButton")) and s7 == descendant.Image then
				return descendant
			end
		end

		return nil
	end,
	findDescendantWithText = function(p37, s8: string) -- line: 328
		for _, descendant in (p37:GetDescendants()) do
			if (descendant:IsA("TextLabel") or descendant:IsA("TextButton")) and s8 == descendant.Text then
				return descendant
			end
		end

		return nil
	end,
	mountSduiComponent = function(p38, s9: string) -- line: 260
		-- upvalues: DiscoveryTestHelpers (copy), DiscoveryTestHelpersParent (copy)
		local wrapWithAppProviders = require(DiscoveryTestHelpers.wrapWithAppProviders)
		local mountInScreenGui = require(DiscoveryTestHelpers.mountInScreenGui)
		local ReactRoblox2 = require(DiscoveryTestHelpersParent.ReactRoblox)
		local VirtualInput2 = require(DiscoveryTestHelpersParent.Rhodium).VirtualInput
		local v52 = mountInScreenGui({
			TestWrapper = wrapWithAppProviders({
				TestComponent = p38
			})
		}, s9)

		ReactRoblox2.act(function() -- line: 281
			-- upvalues: VirtualInput2 (copy)
			VirtualInput2.waitForInputEventsProcessed()
		end)

		local s9_2 = game:GetService("CoreGui"):FindFirstChild(s9)

		assert(s9_2, `ScreenGui { s9 } should be mounted`)

		return s9_2, v52
	end,
	debugDumpInstanceTree = function(p39) -- line: 371
		-- upvalues: debugDumpInstanceTreeRecursive (copy)
		print("\n\t----------- DEBUG DUMP TREE -------------")
		debugDumpInstanceTreeRecursive(p39, "")
		print("\t-----------------------------------------\n\n\t")
	end
}
