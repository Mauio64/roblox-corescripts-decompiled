local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local ReactTestingLibrary = require(ParentParentParent.Dev.ReactTestingLibrary)
local render = ReactTestingLibrary.render
local screen = ReactTestingLibrary.screen
local mockProviders = require(ParentParent.TestUtils.mockProviders)

return {
	createTestController = function(p1, p2) -- line: 13
		-- upvalues: mockProviders (copy), React (copy), render (copy), screen (copy)
		return function(p3) -- line: 14
			-- upvalues: p2 (copy), mockProviders (copy), React (copy), p1 (copy), render (copy), screen (copy)
			local t1 = {}
			local v16 = table.clone(p2 or {})

			if p3 then
				for k, v in pairs(p3) do
					v16[k] = v
				end
			end

			local v19 = mockProviders(React.createElement(p1, v16))

			t1.rendered = render(v19)

			function t1.findByTestId(p4) -- line: 31
				-- upvalues: screen (copy)
				return (screen.queryByTestId(p4))
			end

			return t1
		end
	end,
	createPeopleReactViewController = function() -- line: 41
		-- upvalues: ParentParent (copy), mockProviders (copy), React (copy), render (copy), screen (copy)
		local PeopleReactView = require(ParentParent.PeopleReactView)
		local t2 = {
			chromeEnabled = true,
			blockingFlags = {}
		}

		local function v12(p5) -- line: 14
			-- upvalues: t2 (copy), mockProviders (copy), React (copy), PeopleReactView (copy), render (copy), screen (copy)
			local t3 = {}
			local v22 = table.clone(t2 or {})

			if p5 then
				for k, v in pairs(p5) do
					v22[k] = v
				end
			end

			local v25 = mockProviders(React.createElement(PeopleReactView, v22))

			t3.rendered = render(v25)

			function t3.findByTestId(p6) -- line: 31
				-- upvalues: screen (copy)
				return (screen.queryByTestId(p6))
			end

			return t3
		end
		local function getController() -- line: 52
			-- upvalues: v12 (copy)
			local v26 = v12({})
			local t4 = {
				rendered = v26.rendered,
				findByTestId = v26.findByTestId
			}

			function t4.theMainView() -- line: 62
				-- upvalues: t4 (copy)
				return t4.findByTestId("mainView")
			end
			function t4.thePeopleCards() -- line: 66
				-- upvalues: t4 (copy)
				return t4.findByTestId("peopleCards")
			end
			function t4.thePeopleList() -- line: 70
				-- upvalues: t4 (copy)
				return t4.findByTestId("peopleList")
			end
			function t4.theCoreButtonRow() -- line: 74
				-- upvalues: t4 (copy)
				return t4.findByTestId("coreButtonRow")
			end
			function t4.theMenuButtonsWrapper() -- line: 78
				-- upvalues: t4 (copy)
				return t4.findByTestId("menuButtonsWrapper")
			end
			function t4.theBlockingModalManager() -- line: 82
				-- upvalues: t4 (copy)
				return t4.findByTestId("blockingModalManager")
			end
			function t4.hasAllChildComponents() -- line: 87
				-- upvalues: t4 (copy)
				t4.thePeopleList()
				t4.theCoreButtonRow()
				t4.theMenuButtonsWrapper()
				t4.theBlockingModalManager()

				return true
			end

			return t4
		end

		return getController
	end
}
