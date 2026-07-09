local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local SocialTabParent = SocialTab.Parent
local UiModeStyleProvider = dependencies.UiModeStyleProvider
local mockLocale = require(script.Parent.mockLocale)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local RadioButtonList = UIBlox.App.InputButton.RadioButtonList
local RoactRodux = dependencies.RoactRodux
local Rodux = dependencies.Rodux
local ApolloClient = require(SocialTabParent.ApolloClient)
local mockApolloClient = require(SocialTabParent.GraphQLServer).ApolloClientTestUtils.mockApolloClient

local function v13(p1) -- line: 22
	-- upvalues: Roact (copy), RadioButtonList (copy), UIBlox (copy)
	local t1 = {
		"Dark",
		"Light"
	}
	local t2 = {
		radioButtonList = Roact.createElement(RadioButtonList, {
			radioButtons = t1,
			onActivated = function(p2) -- line: 30
				-- upvalues: p1 (copy), t1 (copy)
				p1.updateStyle(t1[p2])
			end,
			initialValue = table.find(t1, p1.styleName) or 1,
			elementSize = UDim2.new(1, 0, 0, 40)
		})
	}

	return UIBlox.Style.withStyle(function(p3) -- line: 37
		-- upvalues: Roact (copy), p1 (copy), t2 (copy)
		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal
			}),
			sideBar = Roact.createElement("Frame", {
				LayoutOrder = 1,
				Size = UDim2.new(0, p1.width, 1, 0),
				BackgroundColor3 = p3.Theme.BackgroundDefault.Color
			}, t2),
			viewPort = Roact.createElement("Frame", {
				LayoutOrder = 2,
				Size = UDim2.new(1, -p1.width, 1, 0),
				BackgroundColor3 = Color3.fromRGB(222, 255, 255)
			}, p1[Roact.Children])
		})
	end)
end
local function v14() -- line: 59
	-- upvalues: Rodux (copy)
	local t3 = {
		style = "Light"
	}

	return (Rodux.Store.new(function(p4, p5) -- line: 64
		if p5.type == "receivedStyle" then
			return {
				style = p5.style
			}
		end

		return p4
	end, t3, { Rodux.thunkMiddleware }))
end

local u15 = RoactRodux.connect(function(p6) -- line: 94
	return {
		styleName = p6.style
	}
end, function(p7) -- line: 98
	return {
		updateStyle = function(p8) -- line: 100
			-- upvalues: p7 (copy)
			return p7({
				type = "receivedStyle",
				style = p8
			})
		end
	}
end)(function(p9) -- line: 78
	-- upvalues: Roact (copy), UiModeStyleProvider (copy), v13 (copy)
	return Roact.createElement(UiModeStyleProvider, {
		style = {
			themeName = p9.styleName
		}
	}, {
		viewportWithSidebar = Roact.createElement(v13, {
			width = p9.sideBarWidth,
			updateStyle = p9.updateStyle,
			styleName = p9.styleName
		}, {
			Story = Roact.createElement(p9.story)
		})
	})
end)

return function() -- line: 109
	-- upvalues: mockApolloClient (copy), Roact (copy), RoactRodux (copy), v14 (copy), ApolloClient (copy), u15 (ref), mockLocale (copy)
	return function(p10, p11) -- line: 110
		-- upvalues: mockApolloClient (copy), Roact (copy), RoactRodux (copy), v14 (copy), ApolloClient (copy), u15 (ref), mockLocale (copy)
		local v30 = mockApolloClient({})
		local v31 = Roact.createElement(RoactRodux.StoreProvider, {
			store = v14()
		}, { Roact.createElement(ApolloClient.ApolloProvider, {
			client = v30
		}, {
			container = Roact.createElement(u15, {
				sideBarWidth = 100,
				story = p10
			})
		}) })
		local v32 = Roact.mount(mockLocale(v31), p11, "StoryRoot")

		return function() -- line: 128
			-- upvalues: Roact (copy), v32 (copy)
			Roact.unmount(v32)
		end
	end
end
