local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local MockProviders = require(AppChat.Components.MockProviders)
local mockAnalytics = require(AppChat.LegacyAnalytics.Mock.mockAnalytics)
local ReactTestingLibrary = require(AppChatParent.Dev.ReactTestingLibrary)

local function createTreeWithProviders(p1, t1: {[any]: any}) -- line: 9
	-- upvalues: React (copy), MockProviders (copy), mockAnalytics (copy)
	local v11 = React.createElement(MockProviders, {
		withUiModeSupport = t1.withUiModeSupport,
		withLayerCollector = t1.withLayerCollector,
		children = p1,
		rodux = {
			store = t1.store,
			state = t1.state
		}
	})

	if t1.mockAnalytics then
		v11 = mockAnalytics(v11)
	end

	return v11
end
local function renderWithProviders(p2, t2: {[any]: any}?) -- line: 58
	-- upvalues: createTreeWithProviders (copy), ReactTestingLibrary (copy)
	local v14 = createTreeWithProviders(p2, t2 or {})
	local u15 = nil

	ReactTestingLibrary.act(function() -- line: 71
		-- upvalues: u15 (ref), ReactTestingLibrary (copy), v14 (copy)
		u15 = ReactTestingLibrary.render(v14)
	end)

	return u15.container, function() -- line: 74
		-- upvalues: ReactTestingLibrary (copy)
		ReactTestingLibrary.cleanup()
	end, u15
end

return renderWithProviders
